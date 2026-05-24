# APK Build Information

## StreamView IPTV v1.0.0

### Build Status: ✅ Ready to Build

### How to Generate the APK:

#### Option 1: Using Flutter (Recommended)
1. Install Flutter SDK (https://docs.flutter.dev/get-started/install)
2. Install Android Studio with Android SDK
3. Set up an Android emulator or connect a physical device
4. Run the following commands in the project directory:

```bash
# Navigate to project
cd tivimate_clone

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release
```

The APK will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

#### Option 2: Using Android Studio
1. Open the project in Android Studio
2. Select "android" folder
3. Go to Build > Build Bundle(s) / APK(s) > Build APK(s)

#### Option 3: Using VS Code
1. Open the project in VS Code
2. Press Ctrl+Shift+P (Cmd+Shift+P on Mac)
3. Type "Flutter: Build APK"
4. Select "Release"

### Build Requirements:
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android SDK API 21+ (Android 5.0+)
- JDK 8 or higher

### APK Details:
- **Package Name**: com.example.tivimate_clone
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: Latest
- **Architecture**: arm64-v8a, armeabi-v7a
- **Size**: ~15-25 MB (estimated)

### Features Included:
✅ M3U Playlist Import (URL & File)
✅ Xtream Codes API Support
✅ Channel Grid (Mobile & TV)
✅ EPG/TV Guide
✅ Favorites Management
✅ Video Player with Controls
✅ TV-Optimized Interface (Android TV/Fire TV)
✅ Dark Theme
✅ Search & Filter
✅ Settings & Configuration

### Note:
This is a player application only. It does not include any content.
Users must provide their own IPTV playlists.
