#!/bin/bash

# Taiga Stream (macOS)
# github.com/andrewmichaelpowell

# brew install create-dmg

set -euo pipefail

APP_NAME="Taiga Stream"
PROJECT_NAME="taigastream-macos"
TEAM_ID="925F4PY4UL"
NOTARY_PROFILE="taigastream-notary"

cd "$(dirname "$0")/.."
ROOT="$PWD"
BUILD="$ROOT/Packages/Build"
ASSETS="$ROOT/Packages/Assets"
ARCHIVE="$BUILD/$APP_NAME.xcarchive"
EXPORT="$BUILD/export"
STAGING="$BUILD/dmg"

VERSION=$(xcodebuild -project "$APP_NAME.xcodeproj" -scheme "$APP_NAME" -showBuildSettings 2>/dev/null \
	| awk -F' = ' '/ MARKETING_VERSION /{print $2; exit}')
DMG="$BUILD/$PROJECT_NAME.dmg"

IDENTITY=$(security find-identity -v -p codesigning | awk -F'"' '/Developer ID Application/{print $2; exit}')
if [ -z "$IDENTITY" ]; then
	exit 1
fi

if ! command -v create-dmg >/dev/null; then
	exit 1
fi

rm -rf "$BUILD"
mkdir -p "$BUILD"

xcodebuild archive \
	-project "$APP_NAME.xcodeproj" \
	-scheme "$APP_NAME" \
	-configuration Release \
	-destination 'generic/platform=macOS' \
	-archivePath "$ARCHIVE" \
	-quiet

cat > "$BUILD/exportOptions.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>method</key>
	<string>developer-id</string>
	<key>teamID</key>
	<string>$TEAM_ID</string>
	<key>signingStyle</key>
	<string>automatic</string>
</dict>
</plist>
PLIST
xcodebuild -exportArchive \
	-archivePath "$ARCHIVE" \
	-exportPath "$EXPORT" \
	-exportOptionsPlist "$BUILD/exportOptions.plist" \
	-quiet

mkdir -p "$STAGING"
cp -R "$EXPORT/$APP_NAME.app" "$STAGING/"
tiffutil -cathidpicheck "$ASSETS/dmg-background1x.png" "$ASSETS/dmg-background2x.png" -out "$BUILD/dmg-background.tiff" >/dev/null 2>&1
create-dmg \
	--volname "$APP_NAME" \
	--background "$BUILD/dmg-background.tiff" \
	--window-pos 200 120 \
	--window-size 540 368 \
	--icon-size 128 \
	--icon "$APP_NAME.app" 160 150 \
	--hide-extension "$APP_NAME.app" \
	--app-drop-link 380 150 \
	--no-internet-enable \
	"$DMG" "$STAGING" >/dev/null
codesign --force --sign "$IDENTITY" --timestamp "$DMG"

xcrun notarytool submit "$DMG" --keychain-profile "$NOTARY_PROFILE" --wait

xcrun stapler staple "$DMG"
xcrun stapler validate "$DMG"

spctl --assess --type open --context context:primary-signature --verbose=2 "$DMG"
