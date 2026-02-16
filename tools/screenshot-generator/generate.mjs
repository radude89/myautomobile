#!/usr/bin/env node

/**
 * YUZU AppScreen Automation Engine
 * 
 * Generates beautifully framed App Store screenshots by automating YUZU AppScreen.
 * Reads configuration from config.json and processes raw screenshots into output directory.
 * 
 * Selectors discovered from YUZU AppScreen (https://github.com/YUZU-Hub/appscreen):
 * Verified via live exploration on 2026-02-16
 * 
 * - File upload: #file-input (hidden file input)
 * - Output size dropdown: #output-size-trigger, .device-option[data-device="iphone-6.9|iphone-6.7"]
 * - Tab navigation: button.tab[data-tab="background|screenshot|text"]
 * - Background type: #bg-type-selector button[data-type="gradient"]
 * - Gradient angle: #gradient-angle (range input)
 * - Gradient stops: #gradient-stops .gradient-stop input[type="color"]
 * - Device type: #device-type-selector button[data-type="2d"]
 * - Position presets: button.position-preset[data-preset="bleed-bottom"]
 * - Headline toggle: #headline-toggle (div.toggle)
 * - Headline text: #headline-text (textarea!)
 * - Headline font picker: #font-picker-trigger
 * - Font search: #font-search
 * - Headline weight: #headline-weight (select)
 * - Headline color: #headline-color (input color)
 * - Subheadline toggle: #subheadline-toggle
 * - Export button: #export-current
 * 
 * Usage:
 *   node generate.mjs [--config path/to/config.json] [--yuzu-url http://localhost:8080]
 * 
 * @author CarChum Screenshot Pipeline
 * @version 1.0.0
 */

import { chromium } from 'playwright';
import { readFileSync } from 'fs';
import { mkdir, rename, access } from 'fs/promises';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Parse CLI arguments
const args = process.argv.slice(2);
const configPath = args.includes('--config') 
  ? args[args.indexOf('--config') + 1] 
  : join(__dirname, 'config.json');
const yuzuBaseUrl = args.includes('--yuzu-url')
  ? args[args.indexOf('--yuzu-url') + 1]
  : null; // Auto-detect

// Configuration
const MAX_RETRIES = 3;
const CANVAS_WAIT_MS = 3000; // Wait for canvas to render
const DOWNLOAD_TIMEOUT_MS = 30000;

// Load configuration
console.log(`Loading configuration from: ${configPath}`);
const config = JSON.parse(readFileSync(configPath, 'utf-8'));

/**
 * Detect if YUZU is running locally or use live demo
 */
async function detectYuzuUrl() {
  if (yuzuBaseUrl) {
    console.log(`Using YUZU URL from CLI: ${yuzuBaseUrl}`);
    return yuzuBaseUrl;
  }

  // Try localhost first
  try {
    const response = await fetch('http://localhost:8080', { 
      method: 'HEAD',
      signal: AbortSignal.timeout(3000)
    });
    if (response.ok) {
      console.log('✓ Using local YUZU instance at http://localhost:8080');
      return 'http://localhost:8080';
    }
  } catch (err) {
    // Localhost not available
  }

  // Fallback to live demo
  console.log('⚠ Local YUZU not available, using live demo: https://yuzu-hub.github.io/appscreen/');
  return 'https://yuzu-hub.github.io/appscreen/';
}

/**
 * Create output directory if it doesn't exist
 */
async function ensureDir(path) {
  try {
    await access(path);
  } catch {
    await mkdir(path, { recursive: true });
  }
}

/**
 * Sanitize size name for filesystem (replace " with _)
 */
function sanitizeSize(sizeName) {
  return sizeName.replace(/"/g, '_').replace(/\s+/g, '_');
}

/**
 * Get device selector attribute for YUZU size picker
 */
function getDeviceSelectorAttr(sizeName) {
  // Map "iPhone 6.9"" to "iphone-6.9"
  return sizeName.toLowerCase().replace(/\s+/g, '-').replace(/"/g, '');
}

/**
 * Wait for canvas to finish rendering
 * YUZU uses HTML Canvas which requires time to paint after settings change
 */
async function waitForCanvasRender(page) {
  // Strategy: Fixed delay + check if canvas has content
  await page.waitForTimeout(CANVAS_WAIT_MS);
  
  // Optional: Verify canvas has non-blank content
  const hasContent = await page.evaluate(() => {
    const canvas = document.getElementById('preview-canvas');
    if (!canvas) return false;
    const ctx = canvas.getContext('2d');
    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    // Check if at least some pixels are non-transparent
    for (let i = 3; i < imageData.data.length; i += 4) {
      if (imageData.data[i] > 0) return true;
    }
    return false;
  });
  
  if (!hasContent) {
    console.warn('    ⚠ Canvas appears blank, waiting additional time...');
    await page.waitForTimeout(2000);
  }
}

/**
 * Dismiss duplicate screenshot modal if present
 * The live YUZU demo shows this modal when uploading the same screenshot multiple times
 */
async function dismissDuplicateModal(page) {
  try {
    // Wait a bit for modal to appear
    await page.waitForTimeout(1000);
    
    const modal = page.locator('#duplicate-screenshot-modal');
    const isVisible = await modal.isVisible({ timeout: 1000 }).catch(() => false);
    
    if (isVisible) {
      console.log('    ℹ Duplicate screenshot modal detected, dismissing...');
      
      // Strategy 1: Try clicking any button in the modal
      const buttons = await page.locator('#duplicate-screenshot-modal button').all();
      if (buttons.length > 0) {
        // Click the first button (usually "Replace" or "Add")
        await buttons[0].click();
        await page.waitForTimeout(500);
        console.log('    ✓ Dismissed duplicate screenshot modal');
        return;
      }
      
      // Strategy 2: Try pressing Escape
      await page.keyboard.press('Escape');
      await page.waitForTimeout(500);
      console.log('    ✓ Dismissed modal with Escape key');
      return;
    }
  } catch (error) {
    // Modal dismiss failed or not present - continue anyway
    console.warn('    ⚠ Could not dismiss duplicate modal:', error.message);
  }
}

/**
 * Upload a screenshot to YUZU
 */
async function uploadScreenshot(page, screenshotPath) {
  const fileInput = await page.locator('#file-input');
  await fileInput.setInputFiles(screenshotPath);
  await page.waitForTimeout(500); // Wait for upload to process
  
  // Dismiss duplicate modal if it appears (live demo has persistent state)
  await dismissDuplicateModal(page);
  
  // Wait for canvas to show the uploaded image
  await waitForCanvasRender(page);
}

/**
 * Select output size in YUZU
 */
async function selectOutputSize(page, size) {
  const deviceAttr = getDeviceSelectorAttr(size.device);
  
  // Open size dropdown
  await page.click('#output-size-trigger');
  await page.waitForTimeout(300);
  
  // Click the device option
  await page.click(`.device-option[data-device="${deviceAttr}"]`);
  await page.waitForTimeout(500);
}

/**
 * Configure Background tab settings
 */
async function configureBackground(page, design) {
  // Switch to Background tab
  await page.click('button.tab[data-tab="background"]');
  await page.waitForTimeout(300);
  
  // Select gradient type
  await page.click('#bg-type-selector button[data-type="gradient"]');
  await page.waitForTimeout(300);
  
  // Set gradient angle
  await page.fill('#gradient-angle', design.background.angle.toString());
  await page.waitForTimeout(200);
  
  // Set gradient colors
  const stops = await page.locator('#gradient-stops .gradient-stop').all();
  if (stops.length >= 2) {
    // First color stop
    const color1Input = stops[0].locator('input[type="color"]');
    await color1Input.fill(design.background.color1);
    
    // Second color stop
    const color2Input = stops[1].locator('input[type="color"]');
    await color2Input.fill(design.background.color2);
    
    await page.waitForTimeout(300);
  }
  
  await waitForCanvasRender(page);
}

/**
 * Configure Device tab settings
 */
async function configureDevice(page, design) {
  // Switch to Device tab (labeled "Screenshot" in YUZU)
  await page.click('button.tab[data-tab="screenshot"]');
  await page.waitForTimeout(500);
  
  // Wait for tab content to be visible
  await page.waitForSelector('#device-type-selector', { state: 'visible', timeout: 5000 });
  
  // Select 2D device type
  await page.click('#device-type-selector button[data-type="2d"]');
  await page.waitForTimeout(500);
  
  // Try to click "Bleed Bottom" preset (optional - may not be available in live demo)
  try {
    const presetBtn = page.locator('button.position-preset[data-preset="bleed-bottom"]');
    const isVisible = await presetBtn.isVisible({ timeout: 2000 }).catch(() => false);
    if (isVisible) {
      await presetBtn.click();
      await page.waitForTimeout(300);
    } else {
      console.log('    ⚠ Position preset not available (using default)');
    }
  } catch (err) {
    console.log('    ⚠ Position preset not available (using default)');
  }
  
  await waitForCanvasRender(page);
}

/**
 * Configure Text tab settings
 */
async function configureText(page, design, titleText) {
  // Switch to Text tab
  await page.click('button.tab[data-tab="text"]');
  await page.waitForTimeout(300);
  
  // Enable headline if not already enabled
  const headlineToggle = page.locator('#headline-toggle');
  const isEnabled = await headlineToggle.evaluate(el => el.classList.contains('active'));
  if (!isEnabled) {
    await headlineToggle.click();
    await page.waitForTimeout(500);
  }
  
  // Set headline text (using textarea, not input!)
  await page.fill('#headline-text', titleText);
  await page.waitForTimeout(300);
  
  // Set font to Inter using the font picker
  await page.click('#font-picker-trigger');
  await page.waitForTimeout(300);
  
  // Search for "Inter"
  await page.fill('#font-search', 'Inter');
  await page.waitForTimeout(500);
  
  // Click the Inter font option
  try {
    await page.click('.font-option:has-text("Inter")', { timeout: 3000 });
    await page.waitForTimeout(300);
  } catch (error) {
    console.warn('    ⚠ Could not find Inter font, using default');
  }
  
  // Set font weight to Bold (700)
  await page.selectOption('#headline-weight', '700');
  await page.waitForTimeout(300);
  
  // Set text color to white
  await page.fill('#headline-color', design.text.headlineColor);
  await page.waitForTimeout(300);
  
  // Note: Position (top/center/bottom) is controlled by text layout settings
  // The config specifies "top" position which is typically the default in YUZU
  
  // Disable subheadline if enabled (as per design config)
  const subheadlineToggle = page.locator('#subheadline-toggle');
  const subEnabled = await subheadlineToggle.evaluate(el => el.classList.contains('active'));
  if (subEnabled) {
    await subheadlineToggle.click();
    await page.waitForTimeout(300);
  }
  
  await waitForCanvasRender(page);
}

/**
 * Export/download the framed screenshot
 */
async function exportScreenshot(page, outputPath) {
  await ensureDir(dirname(outputPath));
  
  // Set up download listener
  const downloadPromise = page.waitForEvent('download', { timeout: DOWNLOAD_TIMEOUT_MS });
  
  // Click export button
  await page.click('#export-current');
  
  // Wait for download
  const download = await downloadPromise;
  
  // Save to output path
  await download.saveAs(outputPath);
}

/**
 * Process a single screenshot with retry logic
 */
async function processScreenshot(page, screenshot, locale, size, design, rawDir, outputDir, attempt = 1) {
  const screenshotId = screenshot.id;
  const title = screenshot.titles[locale];
  const rawPath = join(rawDir, locale, `${screenshotId}.png`);
  const sizeFolder = sanitizeSize(size.device);
  const outputPath = join(outputDir, locale, sizeFolder, `${screenshotId}.png`);
  
  const logPrefix = `  [${locale}] [${size.device}] ${screenshotId}`;
  
  try {
    // Check if raw screenshot exists
    try {
      await access(rawPath);
    } catch {
      console.error(`${logPrefix} - ✗ Raw screenshot not found: ${rawPath}`);
      return false;
    }
    
    console.log(`${logPrefix} - Processing... (attempt ${attempt}/${MAX_RETRIES})`);
    
    // Reload page to clear any modal state (live demo persists state)
    if (attempt === 1) {
      await page.reload({ waitUntil: 'networkidle' });
      await page.waitForTimeout(1000);
      // Re-select output size after reload
      await selectOutputSize(page, size);
    }
    
    // Upload screenshot
    await uploadScreenshot(page, rawPath);
    
    // Configure Background
    await configureBackground(page, design);
    
    // Configure Device
    await configureDevice(page, design);
    
    // Configure Text
    await configureText(page, design, title);
    
    // Export
    await exportScreenshot(page, outputPath);
    
    console.log(`${logPrefix} - ✓ Done`);
    return true;
    
  } catch (error) {
    console.error(`${logPrefix} - ✗ Error: ${error.message}`);
    
    if (attempt < MAX_RETRIES) {
      console.log(`${logPrefix} - Retrying...`);
      // Wait a bit before retry
      await page.waitForTimeout(2000);
      // Reload page to clear state
      await page.reload({ waitUntil: 'networkidle' });
      await page.waitForTimeout(2000);
      return processScreenshot(page, screenshot, locale, size, design, rawDir, outputDir, attempt + 1);
    } else {
      console.error(`${logPrefix} - ✗ Failed after ${MAX_RETRIES} attempts`);
      return false;
    }
  }
}

/**
 * Main execution
 */
async function main() {
  console.log('═══════════════════════════════════════════════════');
  console.log('  YUZU AppScreen Automation Engine');
  console.log('  CarChum Screenshot Generator');
  console.log('═══════════════════════════════════════════════════\n');
  
  // Detect YUZU URL
  const yuzuUrl = await detectYuzuUrl();
  
  // Calculate total screenshots
  const totalScreenshots = config.screenshots.length * 
                          Object.keys(config.screenshots[0].titles).length * 
                          config.output.sizes.length;
  console.log(`Configuration loaded:`);
  console.log(`  Screenshots: ${config.screenshots.length}`);
  console.log(`  Locales: ${Object.keys(config.screenshots[0].titles).length}`);
  console.log(`  Sizes: ${config.output.sizes.length}`);
  console.log(`  Total to generate: ${totalScreenshots}\n`);
  
  // Launch browser
  console.log('Launching browser...');
  const browser = await chromium.launch({
    headless: true,
    args: ['--disable-web-security'] // Allow canvas exports
  });
  
  const rawDir = join(__dirname, 'raw');
  const outputDir = join(__dirname, config.output.path);
  
  let successCount = 0;
  let failureCount = 0;
  
  try {
    // Process each output size
    for (const size of config.output.sizes) {
      console.log(`\n${'='.repeat(50)}`);
      console.log(`Output Size: ${size.device} (${size.width}×${size.height})`);
      console.log('='.repeat(50));
      
      // Create fresh browser context for each size to avoid state conflicts
      const context = await browser.newContext({
        viewport: { width: 1920, height: 1080 },
        permissions: ['clipboard-read', 'clipboard-write']
      });
      
      const page = await context.newPage();
      
      // Navigate to YUZU
      console.log(`\nNavigating to YUZU...`);
      await page.goto(yuzuUrl, { waitUntil: 'networkidle' });
      await page.waitForTimeout(2000); // Wait for full initialization
      
      // Select output size
      await selectOutputSize(page, size);
      
      // Process each screenshot
      for (const screenshot of config.screenshots) {
        // Process each locale
        for (const locale of Object.keys(screenshot.titles)) {
          const success = await processScreenshot(
            page,
            screenshot,
            locale,
            size,
            config.design,
            rawDir,
            outputDir
          );
          
          if (success) {
            successCount++;
          } else {
            failureCount++;
          }
        }
      }
      
      // Close context after processing this size
      await context.close();
    }
    
  } finally {
    await browser.close();
  }
  
  // Summary
  console.log('\n' + '═'.repeat(50));
  console.log('  GENERATION COMPLETE');
  console.log('═'.repeat(50));
  console.log(`  ✓ Success: ${successCount}/${totalScreenshots}`);
  console.log(`  ✗ Failures: ${failureCount}/${totalScreenshots}`);
  
  if (failureCount > 0) {
    console.log('\n⚠ Some screenshots failed to generate. Check errors above.');
    process.exit(1);
  } else {
    console.log('\n🎉 All screenshots generated successfully!');
  }
}

// Execute
main().catch(error => {
  console.error('\n✗ Fatal error:', error);
  process.exit(1);
});