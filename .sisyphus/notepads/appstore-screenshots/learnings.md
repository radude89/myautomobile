# Task 5: YUZU Automation Script Learnings

## Date: 2026-02-16

### YUZU UI Selector Discovery

Successfully explored YUZU AppScreen live demo and discovered all required selectors:

**File Upload**:
- Selector: `#file-input` (hidden file input)
- Usage: `page.locator('#file-input').setInputFiles(path)`

**Output Size Selection**:
- Trigger: `#output-size-trigger`
- Options: `.device-option[data-device="iphone-6.9"]` or `[data-device="iphone-6.7"]`
- Device naming: "iPhone 6.9"" → "iphone-6.9" (lowercase, hyphens, no quotes)

**Tab Navigation**:
- Background: `button.tab[data-tab="background"]`
- Device/Screenshot: `button.tab[data-tab="screenshot"]`
- Text: `button.tab[data-tab="text"]`

**Background Tab Controls**:
- Type selector: `#bg-type-selector button[data-type="gradient"]`
- Angle: `#gradient-angle` (range input, accepts string number)
- Color stops: `#gradient-stops .gradient-stop:nth-child(1) input[type="color"]` and `:nth-child(2)`
- Colors can be set with `.fill(hexColor)` method

**Device Tab Controls**:
- Device type: `#device-type-selector button[data-type="2d"]`
- Position presets: `button.position-preset[data-preset="bleed-bottom"]`
- Available presets: centered, bleed-bottom, bleed-top, float-center, tilt-left, tilt-right, perspective, float-bottom

**Text Tab Controls** (CRITICAL - Different from initial assumptions):
- Headline toggle: `#headline-toggle` (div.toggle, not input)
- **Headline text: `#headline-text` (textarea, NOT input!)** ⚠️
- Subheadline toggle: `#subheadline-toggle`
- Subheadline text: `#subheadline-text` (textarea)
- Font picker trigger: `#font-picker-trigger`
- Font search: `#font-search`
- Font options: `.font-option:has-text("Inter")`
- Weight selector: `#headline-weight` (select element)
- Color: `#headline-color` (input[type="color"])
- Position: Not found as separate control - appears to be part of global text layout

**Export**:
- Single screenshot: `#export-current`
- All screenshots: `#export-all`

### Canvas Rendering Wait Strategy

YUZU uses HTML Canvas for rendering, which requires waiting for paint operations:

1. **Fixed delay approach**: 3000ms after configuration changes
2. **Canvas content verification**: Check if canvas has non-transparent pixels
3. **Hybrid approach**: Fixed delay + blank canvas detection + additional wait

Implemented in `waitForCanvasRender()` function with 3-second base delay + 2-second extension if canvas appears blank.

### Docker Availability Issue

**Problem**: Docker not installed on development machine.

**Solution**: 
- Implemented auto-detection logic in `detectYuzuUrl()`
- Tries `http://localhost:8080` first (Docker instance)
- Falls back to `https://yuzu-hub.github.io/appscreen/` (live demo)
- Accepts `--yuzu-url` CLI argument for override

This makes the script portable and testable even without Docker.

### File Naming Conventions

**Size folder naming**:
- Input: `"iPhone 6.9""`
- Output folder: `iPhone_6.9` (quotes → underscores, spaces → underscores)
- Implemented in `sanitizeSize()` function

**Device selector attributes**:
- Input: `"iPhone 6.9""`
- YUZU data-device: `"iphone-6.9"` (lowercase, hyphens, no quotes)
- Implemented in `getDeviceSelectorAttr()` function

### Retry Logic Implementation

- Max 3 retries per screenshot
- On failure: wait 2 seconds, reload page (clear IndexedDB state), retry
- Graceful error handling: log error, continue with next screenshot
- Final summary: success count vs failure count

### Browser Context Strategy

**Key insight**: Use fresh browser context for each output size to avoid state conflicts.

- Separate context per size prevents IndexedDB pollution
- Each context has clean slate for YUZU settings
- Close context after processing all screenshots for that size
- Reduces flakiness from accumulated state

### Multi-Locale Support

- Configuration stores titles in `screenshot.titles[locale]` structure
- Output structure: `output/{locale}/{size}/{screenshot-id}.png`
- Script processes: 6 screenshots × 6 locales × 2 sizes = 72 total files
- Romanian diacritics (ă, î, ș, ț) preserved through textarea input

### Google Fonts Integration

- YUZU uses Google Fonts for typography
- Font picker has search functionality (`#font-search`)
- "Inter" font required per design spec (not SF Pro Display - not in Google Fonts)
- Font options appear as `.font-option` elements with text content

### CLI Arguments

Implemented flexible CLI interface:
- `--config <path>`: Override config file path (default: ./config.json)
- `--yuzu-url <url>`: Override YUZU URL (default: auto-detect)

Examples:
- `node generate.mjs` - Use defaults
- `node generate.mjs --config test-config.json` - Custom config
- `node generate.mjs --yuzu-url http://localhost:8080` - Force local instance


# Task 6: Pipeline Orchestration Learnings

## Date: 2026-02-16

### End-to-End Orchestrator Architecture

Created `pipeline.sh` as the complete workflow orchestrator with 7 steps:
1. Pre-flight checks (Docker, Docker Compose, Node 18+, Playwright)
2. Start YUZU Docker container with health check
3. Extract raw screenshots (or skip with `--skip-extract`)
4. Generate framed screenshots via YUZU automation
5. Organize output (transform nested to flat structure)
6. Stop YUZU container (or skip with `--skip-cleanup`)
7. Print summary with timing

### CLI Flag Design

**Implemented flags**:
- `--skip-extract`: Use existing `raw/` screenshots (bypass XCUITest extraction)
- `--skip-cleanup`: Leave Docker running for debugging
- `--xcresult-path <path>`: Pass to extraction script (required unless --skip-extract)
- `--help`: Show usage documentation

**Use case**: `--skip-extract` enables rapid iteration during development without re-running UI tests.

### Error Handling Strategy

**Trap-based cleanup**:
```bash
trap cleanup EXIT ERR
```

- Cleanup runs on both normal exit and errors
- Checks `DOCKER_RUNNING` flag before stopping containers
- Respects `--skip-cleanup` flag
- Prints exit code on failure for debugging

**Pre-flight validation**:
- Checks all tools before starting Docker (fail fast)
- Node.js version validation (18+ required for Playwright)
- Config file existence check
- Clear error messages with install instructions

### File Organization Logic

**Transformation**:
- Source: `tools/screenshot-generator/fastlane/screenshots/{locale}/{size-folder}/{screenshot-id}.png`
- Destination: `fastlane/screenshots/{locale}/{screenshot-id}_{size-folder}.png`
- Example: `en/iPhone_6.9/vehicle-list.png` → `en/vehicle-list_iPhone_6.9.png`

**Rationale**: 
- Flat structure easier for fastlane to consume
- Filename includes size for clarity: `vehicle-list_iPhone_6.9.png`
- Preserves locale organization: `en/`, `fr/`, `de/`, etc.

### Health Check Implementation

**YUZU health check**:
- Endpoint: `http://localhost:8080/health`
- Max wait: 30 seconds (configurable)
- Uses `curl -sf` for silent fail checking
- Polls every 1 second until healthy or timeout

**Why**: Docker container may take 5-10 seconds to fully start. Health check prevents premature YUZU automation.

### Output Path Configuration

**Reading from config.json**:
```bash
local output_path=$(node -p "require('$CONFIG_FILE').output.path")
```

Uses Node.js to parse JSON (avoids jq dependency). Works because Node.js is already required for Playwright.

### Timing and Reporting

**Summary includes**:
- File count per locale
- Total files generated
- Elapsed time in minutes and seconds

**Calculation**:
```bash
START_TIME=$(date +%s)
# ... pipeline execution ...
elapsed=$(($(date +%s) - START_TIME))
minutes=$((elapsed / 60))
seconds=$((elapsed % 60))
```

### Script Organization

**Section markers**:
```bash
# ============================================================================
# Helper Functions
# ============================================================================
```

Used to divide 434-line script into logical sections:
- Helper Functions (print_error, print_success, etc.)
- Pipeline Steps (check_prereqs, start_yuzu, etc.)
- Main Execution (argument parsing, main loop)

### Color-Coded Output

**Color scheme**:
- RED: Errors
- GREEN: Success messages
- YELLOW: Info/warnings
- BLUE: Step headers
- NC (No Color): Reset

**Step header format**:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Step 1: Pre-flight Checks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Makes terminal output scannable during long pipeline runs.

### Strict Mode Benefits

**`set -euo pipefail`**:
- `-e`: Exit on any command failure
- `-u`: Error on undefined variables
- `-o pipefail`: Fail if any command in pipeline fails (not just last)

**Result**: Pipeline fails fast on errors, preventing partial/corrupted state.

### Docker Compose Commands

**Start**: `docker compose up -d`
- `-d`: Detached mode (background)
- Returns immediately, requires health check

**Stop**: `docker compose down`
- Removes containers (not just stops)
- Clean shutdown

**Working directory**: Must `cd "$SCRIPT_DIR"` before running (docker-compose.yml location).

### Placeholder PNG Generation

For testing without real screenshots:
```bash
printf '\x89\x50\x4e\x47...' > screenshot.png
```

Creates minimal valid 1x1 PNG. Sufficient for testing pipeline logic without image quality concerns.

### Exit Code Propagation

**Cleanup trap preserves exit code**:
```bash
local exit_code=$?
# ... cleanup ...
if [[ $exit_code -ne 0 ]]; then
    print_error "Pipeline failed with exit code $exit_code"
fi
```

Ensures pipeline reports original failure reason, not cleanup errors.

### Script Portability

**Path resolution**:
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
```

- Works regardless of where script is called from
- Absolute paths prevent relative path issues
- Compatible with symlinks (uses `cd` + `pwd`)

### Validation Before Execution

**Extract validation** (when `--skip-extract`):
- Checks if `raw/` directory exists
- Checks if directory has content
- Counts PNG files and reports to user
- Exits with error if validation fails

Prevents confusing errors later in pipeline.

