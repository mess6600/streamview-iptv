# StreamView IPTV

A modern, cross-platform IPTV player application inspired by TiviMate, built with Flutter. Supports both mobile (Android/iOS) and TV (Android TV, Fire TV) platforms.

## Features

### Core Features
- **M3U/M3U8 Playlist Support** - Import and manage IPTV playlists
- **Xtream Codes API** - Connect to IPTV services using Xtream Codes
- **Electronic Program Guide (EPG)** - View TV schedules and program information
- **Favorites Management** - Save and quickly access favorite channels
- **Video Player** - Full-featured player with controls, fullscreen, and PiP
- **TV-Optimized Interface** - 10-foot UI designed for remote control navigation
- **Mobile Interface** - Touch-optimized with bottom navigation

### Player Features
- Hardware-accelerated video playback
- Adaptive bitrate streaming (HLS/DASH)
- Picture-in-Picture mode
- Background audio playback
- Fullscreen support
- Seek controls (10s forward/backward)
- Volume and brightness controls

### TV Features
- D-pad/Remote navigation with visual focus indicators
- Grid-based channel browser
- Sidebar navigation
- Large fonts and high contrast for TV viewing
- Channel zapping support

## Screenshots

### Mobile
- Live Channels list with search and group filters
- TV Guide with timeline view
- Favorites management
- Settings and configuration

### TV
- Grid-based channel browser
- TV Guide optimized for large screens
- Remote-friendly navigation
- Focus management with visual feedback

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Android SDK (API 21+)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd tivimate_clone
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# For mobile
flutter run

# For Android TV
flutter run -d <tv-device-id>
```

### Building APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle for Play Store
flutter build appbundle

# Android TV APK
flutter build apk --release --target-platform android-arm64
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── channel.dart         # Channel model
│   ├── playlist.dart        # Playlist model
│   └── epg_program.dart     # EPG program model
├── screens/                 # UI screens
│   ├── mobile/             # Mobile-specific screens
│   │   ├── main_screen.dart
│   │   ├── home_screen.dart
│   │   ├── epg_screen.dart
│   │   ├── favorites_screen.dart
│   │   ├── settings_screen.dart
│   │   └── playlist_import_screen.dart
│   ├── tv/                 # TV-specific screens
│   │   ├── tv_main_screen.dart
│   │   ├── tv_home_screen.dart
│   │   ├── tv_epg_screen.dart
│   │   ├── tv_favorites_screen.dart
│   │   └── tv_settings_screen.dart
│   └── player_screen.dart  # Shared video player
├── services/               # Business logic
│   ├── playlist_service.dart
│   ├── epg_service.dart
│   └── storage_service.dart
├── utils/                  # Utilities
│   ├── constants.dart
│   └── theme.dart
└── widgets/               # Reusable widgets
```

## Supported Platforms

| Platform | Support | Notes |
|----------|---------|-------|
| Android | ✅ Full | Mobile & TV |
| iOS | ✅ Full | Mobile only |
| Android TV | ✅ Full | Leanback launcher |
| Fire TV | ✅ Full | Amazon Appstore |
| Web | ⚠️ Partial | Limited testing |

## Dependencies

- `video_player` - Video playback
- `flutter_bloc` - State management
- `http` / `dio` - Networking
- `shared_preferences` - Local storage
- `xml` - XMLTV parsing
- `intl` - Date formatting
- `cached_network_image` - Image caching

## Legal Disclaimer

This application is a **player only** and does not provide any content. Users are responsible for:
- Obtaining their own IPTV playlists from legitimate providers
- Ensuring compliance with local laws and regulations
- Respecting content providers' terms of service

The developers assume no liability for the content accessed through this application.

## License

This project is for educational purposes. Please respect intellectual property rights.

## Acknowledgments

- Inspired by TiviMate's user interface design
- Built with Flutter framework
- Icons by Material Design
