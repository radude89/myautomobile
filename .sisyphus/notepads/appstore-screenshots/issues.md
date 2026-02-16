# Task 5: Issues and Blockers

## Date: 2026-02-16

### Issue 1: Docker Not Available

**Problem**: Task instructions assume Docker is installed and running, but `docker` command not found in PATH.

**Impact**: Cannot run local YUZU instance at `http://localhost:8080`.

**Workaround**: 
- Implemented fallback to YUZU live demo at `https://yuzu-hub.github.io/appscreen/`
- Auto-detection logic tries localhost first, then falls back
- Script is now portable across environments

**Status**: ✅ Resolved with fallback mechanism

**Note for QA**: To test with local Docker instance:
1. Install Docker Desktop
2. Run: `cd tools/screenshot-generator && docker compose up -d`
3. Script will auto-detect localhost:8080

### Issue 2: No Raw Screenshots for Testing

**Problem**: `tools/screenshot-generator/raw/` directory is empty.

**Impact**: Cannot run end-to-end test of the automation script.

**Status**: ⚠️ Blocked - Waiting for Task 6 (raw screenshot generation)

**Dependencies**: 
- Task 6 must complete first to populate `raw/{locale}/{screenshot-id}.png`
- Task 5 (this script) is prerequisite for Task 6

**Circular dependency resolution**: This is expected - Task 5 creates the tool, Task 6 creates the inputs.

### Issue 3: Textarea vs Input for Headline Text

**Problem**: Initial assumption that headline text was an `<input>` element was incorrect.

**Discovery**: Live exploration revealed YUZU uses `<textarea id="headline-text">` instead.

**Impact**: Initial selector would have failed. Corrected in final implementation.

**Resolution**: ✅ Fixed - Use `#headline-text` (textarea) with `.fill()` method

**Lesson**: Always explore live UI before writing automation code. Static HTML analysis can miss dynamic elements.

### Issue 4: Position Selector Not Found

**Problem**: Design config specifies `headlinePosition: "top"` but no selector found for this control.

**Investigation**: 
- Explored all inputs, selects, and controls in Text tab
- No `#headline-position` or similar selector exists
- Checked YUZU source code - position might be implicit based on layout

**Assumption**: YUZU's "top" position may be:
1. Default behavior when headline is enabled
2. Controlled by global canvas layout settings (not per-text-element)
3. Achieved through other controls like vertical offset

**Resolution**: ⚠️ Skipped explicit position setting, relying on YUZU defaults

**Risk**: Output screenshots might not have headline positioned at top as specified

**Mitigation**: Visual QA step will verify position. If incorrect, will need deeper YUZU exploration.

### Issue 5: Canvas Rendering Race Conditions

**Problem**: YUZU uses Canvas API which renders asynchronously. No reliable "render complete" event.

**Approaches tried**:
1. Fixed delay (3 seconds) - Simple but may be too short/long
2. Canvas content check - Verify non-blank pixels exist
3. Hybrid - Fixed delay + blank detection + extra wait

**Current solution**: Hybrid approach in `waitForCanvasRender()`

**Remaining risk**: 
- Complex gradients or slow network might need longer delays
- Retry logic (max 3 attempts) provides safety net

**Future improvement**: Could use visual regression testing to verify render completeness.

