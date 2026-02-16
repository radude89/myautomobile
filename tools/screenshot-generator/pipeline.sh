#!/bin/bash

# CarChum Screenshot Generation Pipeline
# End-to-end orchestrator for generating App Store screenshots
#
# Usage:
#   ./pipeline.sh [OPTIONS]
#
# Options:
#   --skip-extract              Skip raw screenshot extraction (use existing raw/ files)
#   --skip-cleanup              Leave YUZU Docker container running after completion
#   --xcresult-path <path>      Path to .xcresult bundle (required unless --skip-extract)
#   --help                      Show this help message
#
# Pipeline Steps:
#   1. Pre-flight checks (Docker, Node.js, Playwright)
#   2. Start YUZU Docker container
#   3. Extract raw screenshots from .xcresult
#   4. Generate framed screenshots with YUZU
#   5. Organize output to fastlane/screenshots/
#   6. Stop YUZU Docker container
#   7. Print summary report

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

CONFIG_FILE="$SCRIPT_DIR/config.json"
DOCKER_RUNNING=false
START_TIME=$(date +%s)

SKIP_EXTRACT=false
SKIP_CLEANUP=false
XCRESULT_PATH=""

# ============================================================================
# Helper Functions
# ============================================================================

print_error() {
    echo -e "${RED}✗ Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_step() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

cleanup() {
    local exit_code=$?
    
    if [[ "$DOCKER_RUNNING" == true ]] && [[ "$SKIP_CLEANUP" == false ]]; then
        print_info "Cleaning up Docker containers..."
        cd "$SCRIPT_DIR"
        if docker compose down 2>/dev/null; then
            print_success "Docker containers stopped"
        else
            print_error "Failed to stop Docker containers"
        fi
    fi
    
    if [[ $exit_code -ne 0 ]]; then
        print_error "Pipeline failed with exit code $exit_code"
    fi
}

trap cleanup EXIT ERR

print_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  --skip-extract              Skip raw screenshot extraction (use existing raw/ files)
  --skip-cleanup              Leave YUZU Docker container running after completion
  --xcresult-path <path>      Path to .xcresult bundle (required unless --skip-extract)
  --help                      Show this help message

Description:
  Orchestrates the complete screenshot generation workflow:
  1. Pre-flight checks (Docker, Node.js, Playwright)
  2. Start YUZU Docker container
  3. Extract raw screenshots from .xcresult (unless --skip-extract)
  4. Generate framed screenshots with YUZU
  5. Organize output to fastlane/screenshots/
  6. Stop YUZU Docker container (unless --skip-cleanup)
  7. Print summary report

Examples:
  # Full pipeline with extraction
  $(basename "$0") --xcresult-path ~/Library/Developer/Xcode/DerivedData/.../Test.xcresult

  # Skip extraction (use existing raw/ screenshots)
  $(basename "$0") --skip-extract

  # Skip cleanup (leave YUZU running for debugging)
  $(basename "$0") --skip-extract --skip-cleanup

EOF
}

# ============================================================================
# Pipeline Steps
# ============================================================================

check_prereqs() {
    print_step "Step 1: Pre-flight Checks"
    
    local missing_tools=()
    
    if ! command -v docker &> /dev/null; then
        missing_tools+=("docker")
    else
        print_success "Docker found: $(docker --version | head -n1)"
    fi
    
    if ! docker compose version &> /dev/null; then
        missing_tools+=("docker-compose")
    else
        print_success "Docker Compose found: $(docker compose version | head -n1)"
    fi
    
    if ! command -v node &> /dev/null; then
        missing_tools+=("node")
    else
        local node_version=$(node --version | sed 's/v//')
        local node_major=$(echo "$node_version" | cut -d. -f1)
        if [[ $node_major -lt 18 ]]; then
            print_error "Node.js version 18+ required (found: v$node_version)"
            missing_tools+=("node (version 18+)")
        else
            print_success "Node.js found: v$node_version"
        fi
    fi
    
    if ! npx playwright --version &> /dev/null; then
        missing_tools+=("playwright")
    else
        print_success "Playwright found: $(npx playwright --version)"
    fi
    
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_error "Configuration file not found: $CONFIG_FILE"
        exit 1
    else
        print_success "Configuration file found: $CONFIG_FILE"
    fi
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        echo ""
        echo "Please install the missing tools and try again."
        exit 1
    fi
    
    print_success "All prerequisites satisfied"
}

start_yuzu() {
    print_step "Step 2: Start YUZU Docker Container"
    
    cd "$SCRIPT_DIR"
    
    print_info "Starting YUZU container..."
    if docker compose up -d; then
        DOCKER_RUNNING=true
        print_success "YUZU container started"
    else
        print_error "Failed to start YUZU container"
        exit 1
    fi
    
    print_info "Waiting for YUZU to be ready..."
    local max_attempts=30
    local attempt=0
    local healthy=false
    
    while [[ $attempt -lt $max_attempts ]]; do
        if curl -sf http://localhost:8080/health > /dev/null 2>&1; then
            healthy=true
            break
        fi
        ((attempt++))
        sleep 1
    done
    
    if [[ "$healthy" == true ]]; then
        print_success "YUZU is ready (http://localhost:8080)"
    else
        print_error "YUZU health check failed after ${max_attempts}s"
        exit 1
    fi
}

extract_screenshots() {
    if [[ "$SKIP_EXTRACT" == true ]]; then
        print_step "Step 3: Extract Raw Screenshots [SKIPPED]"
        print_info "Using existing raw/ screenshots"
        
        if [[ ! -d "$SCRIPT_DIR/raw" ]] || [[ -z "$(ls -A "$SCRIPT_DIR/raw" 2>/dev/null)" ]]; then
            print_error "No raw screenshots found in $SCRIPT_DIR/raw/"
            print_info "Remove --skip-extract flag to extract from .xcresult"
            exit 1
        fi
        
        local raw_count=$(find "$SCRIPT_DIR/raw" -name "*.png" 2>/dev/null | wc -l | tr -d ' ')
        print_success "Found $raw_count raw screenshots"
        return
    fi
    
    print_step "Step 3: Extract Raw Screenshots"
    
    if [[ -z "$XCRESULT_PATH" ]]; then
        print_error "Missing required argument: --xcresult-path"
        print_info "Use --skip-extract to skip extraction and use existing raw/ screenshots"
        exit 1
    fi
    
    cd "$SCRIPT_DIR"
    
    print_info "Running extraction script..."
    if ./extract-screenshots.sh --xcresult-path "$XCRESULT_PATH"; then
        print_success "Raw screenshots extracted successfully"
    else
        print_error "Screenshot extraction failed"
        exit 1
    fi
}

generate_screenshots() {
    print_step "Step 4: Generate Framed Screenshots"
    
    cd "$SCRIPT_DIR"
    
    print_info "Running YUZU automation engine..."
    if node generate.mjs; then
        print_success "Framed screenshots generated successfully"
    else
        print_error "Screenshot generation failed"
        exit 1
    fi
}

organize_output() {
    print_step "Step 5: Organize Output"
    
    local output_path=$(node -p "require('$CONFIG_FILE').output.path")
    local source_dir="$SCRIPT_DIR/$output_path"
    local dest_dir="$PROJECT_ROOT/fastlane/screenshots"
    
    print_info "Source: $source_dir"
    print_info "Destination: $dest_dir"
    
    if [[ ! -d "$source_dir" ]]; then
        print_error "Source directory not found: $source_dir"
        exit 1
    fi
    
    mkdir -p "$dest_dir"
    
    local locales=($(ls -1 "$source_dir" 2>/dev/null || true))
    
    if [[ ${#locales[@]} -eq 0 ]]; then
        print_error "No locale directories found in $source_dir"
        exit 1
    fi
    
    local total_files=0
    
    for locale in "${locales[@]}"; do
        local locale_source="$source_dir/$locale"
        local locale_dest="$dest_dir/$locale"
        
        if [[ ! -d "$locale_source" ]]; then
            continue
        fi
        
        mkdir -p "$locale_dest"
        
        local size_folders=($(ls -1 "$locale_source" 2>/dev/null || true))
        
        for size_folder in "${size_folders[@]}"; do
            local size_source="$locale_source/$size_folder"
            
            if [[ ! -d "$size_source" ]]; then
                continue
            fi
            
            for screenshot in "$size_source"/*.png; do
                if [[ ! -f "$screenshot" ]]; then
                    continue
                fi
                
                local screenshot_id=$(basename "$screenshot" .png)
                local new_name="${screenshot_id}_${size_folder}.png"
                local dest_file="$locale_dest/$new_name"
                
                cp "$screenshot" "$dest_file"
                ((total_files++))
            done
        done
        
        local locale_count=$(find "$locale_dest" -name "*.png" 2>/dev/null | wc -l | tr -d ' ')
        print_success "$locale: $locale_count files"
    done
    
    print_success "Organized $total_files screenshots to $dest_dir"
}

stop_yuzu() {
    if [[ "$SKIP_CLEANUP" == true ]]; then
        print_step "Step 6: Stop YUZU Docker Container [SKIPPED]"
        print_info "YUZU container left running (use 'docker compose down' to stop manually)"
        DOCKER_RUNNING=false
        return
    fi
    
    print_step "Step 6: Stop YUZU Docker Container"
    
    cd "$SCRIPT_DIR"
    
    if docker compose down; then
        DOCKER_RUNNING=false
        print_success "YUZU container stopped"
    else
        print_error "Failed to stop YUZU container"
        exit 1
    fi
}

print_summary() {
    print_step "Step 7: Summary Report"
    
    local dest_dir="$PROJECT_ROOT/fastlane/screenshots"
    
    if [[ ! -d "$dest_dir" ]]; then
        print_error "Output directory not found: $dest_dir"
        return
    fi
    
    local locales=($(ls -1 "$dest_dir" 2>/dev/null || true))
    local total_files=0
    
    echo ""
    for locale in "${locales[@]}"; do
        if [[ ! -d "$dest_dir/$locale" ]]; then
            continue
        fi
        
        local count=$(find "$dest_dir/$locale" -name "*.png" 2>/dev/null | wc -l | tr -d ' ')
        total_files=$((total_files + count))
        print_success "$locale: $count files"
    done
    
    echo ""
    print_success "Total: $total_files files generated"
    
    local end_time=$(date +%s)
    local elapsed=$((end_time - START_TIME))
    local minutes=$((elapsed / 60))
    local seconds=$((elapsed % 60))
    
    echo ""
    print_info "Pipeline completed in ${minutes}m ${seconds}s"
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-extract)
                SKIP_EXTRACT=true
                shift
                ;;
            --skip-cleanup)
                SKIP_CLEANUP=true
                shift
                ;;
            --xcresult-path)
                XCRESULT_PATH="$2"
                shift 2
                ;;
            --help)
                print_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo ""
                print_usage
                exit 1
                ;;
        esac
    done
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "  CarChum Screenshot Generation Pipeline"
    echo "═══════════════════════════════════════════════════════════════"
    
    check_prereqs
    start_yuzu
    extract_screenshots
    generate_screenshots
    organize_output
    stop_yuzu
    print_summary
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo -e "${GREEN}  🎉 Pipeline completed successfully!${NC}"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
}

main "$@"