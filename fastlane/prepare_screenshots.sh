#!/usr/bin/env python3
import os
import shutil

SOURCE = "/Users/rdan/Documents/CarChum/Screnshots/AppStore"
DEST = os.path.join(os.path.dirname(os.path.abspath(__file__)), "screenshots")

LOCALE_MAP = {
    "en": "en-US",
    "de": "de-DE",
    "fr": "fr-FR",
    "es": "es-ES",
    "it": "it",
    "ro": "ro",
}

DEVICE_MAP = {
    "iPhone_6.7_": "iPhone67",
    "iPhone_6.9_": "iPhone69",
    "iPad_12.9_": "iPad129",
    "iPad_13_": "iPad13",
}

ORDER_MAP = {
    "vehicle-list": "01",
    "vehicle-details": "02",
    "event-list": "03",
    "expense-list": "04",
    "expense-chart": "05",
    "fuel-calculator": "06",
}

print(f"Cleaning {DEST}...")
shutil.rmtree(DEST, ignore_errors=True)

total = 0
for lang, locale in LOCALE_MAP.items():
    locale_dir = os.path.join(DEST, locale)
    os.makedirs(locale_dir, exist_ok=True)

    for device, prefix in DEVICE_MAP.items():
        src_dir = os.path.join(SOURCE, lang, device)
        if not os.path.isdir(src_dir):
            print(f"  Missing: {src_dir}")
            continue

        for fname in sorted(os.listdir(src_dir)):
            if not fname.endswith(".png"):
                continue
            name = fname[:-4]
            order = ORDER_MAP.get(name, "99")
            dest_name = f"{prefix}-{order}-{name}.png"
            shutil.copy2(os.path.join(src_dir, fname), os.path.join(locale_dir, dest_name))
            print(f"  {lang}/{device}/{fname} -> {locale}/{dest_name}")
            total += 1

print(f"\nDone. {total} screenshots staged in: {DEST}")
