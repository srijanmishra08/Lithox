#!/bin/bash

# Lithox Epoxy App - Build Script
echo "🏗️  Building Lithox Epoxy App..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Check if Android SDK is configured
if [ -z "$ANDROID_HOME" ]; then
    echo "⚠️  ANDROID_HOME is not set. Checking common locations..."
    
    # Common Android SDK locations
    POSSIBLE_PATHS=(
        "$HOME/Android/Sdk"
        "$HOME/Library/Android/sdk"
        "/usr/local/android-sdk"
        "/opt/android-sdk"
    )
    
    for path in "${POSSIBLE_PATHS[@]}"; do
        if [ -d "$path" ]; then
            export ANDROID_HOME="$path"
            export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
            echo "✅ Found Android SDK at: $path"
            break
        fi
    done
    
    if [ -z "$ANDROID_HOME" ]; then
        echo "❌ Android SDK not found. Please install Android SDK or set ANDROID_HOME."
        echo ""
        echo "You can:"
        echo "1. Install Android Studio which includes the SDK"
        echo "2. Use the GitHub Actions workflow to build in the cloud"
        echo "3. Run: flutter build web (for web version)"
        exit 1
    fi
fi

# Create assets directories if they don't exist
echo "📁 Creating assets directories..."
mkdir -p assets/images
mkdir -p assets/icons

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze --no-fatal-infos

# Build APK
echo "🚀 Building release APK..."
flutter build apk --release

# Check if build was successful
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo ""
    echo "✅ Build successful!"
    echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    
    # Get file size
    size=$(ls -lh build/app/outputs/flutter-apk/app-release.apk | awk '{print $5}')
    echo "📊 APK size: $size"
    
    # Copy to easy access location
    cp build/app/outputs/flutter-apk/app-release.apk ./lithox-epoxy-app.apk
    echo "📋 Copied to: ./lithox-epoxy-app.apk"
    
else
    echo "❌ Build failed! Check the output above for errors."
    exit 1
fi

echo ""
echo "🎉 Lithox Epoxy App build complete!"
echo "You can now install the APK on your Android device."
