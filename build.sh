#!/bin/bash

# StreamView IPTV Build Script
# This script builds the Flutter APK for Android

echo "=========================================="
echo "  StreamView IPTV - Build Script"
echo "=========================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build APK
echo "🔨 Building release APK..."
flutter build apk --release

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "  ✅ Build Successful!"
    echo "=========================================="
    echo ""
    echo "APK Location: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "To install on device:"
    echo "  flutter install"
    echo ""
    echo "Or manually:"
    echo "  adb install build/app/outputs/flutter-apk/app-release.apk"
else
    echo ""
    echo "=========================================="
    echo "  ❌ Build Failed"
    echo "=========================================="
    echo ""
    echo "Please check the error messages above."
    exit 1
fi
