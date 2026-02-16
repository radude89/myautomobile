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

