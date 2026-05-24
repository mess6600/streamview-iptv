class AppConstants {
  // App Info
  static const String appName = 'StreamView IPTV';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A modern IPTV player for all your streaming needs';

  // Colors
  static const int primaryColor = 0xFF1E88E5;
  static const int accentColor = 0xFF00BCD4;
  static const int backgroundColor = 0xFF121212;
  static const int surfaceColor = 0xFF1E1E1E;
  static const int cardColor = 0xFF2D2D2D;

  // TV Navigation
  static const double tvFocusScale = 1.05;
  static const double tvFocusElevation = 8.0;

  // Player
  static const int bufferDuration = 30000; // 30 seconds
  static const int seekStep = 10000; // 10 seconds

  // EPG
  static const int epgHoursAhead = 24;
  static const int epgHoursBehind = 2;

  // Demo Data
  static const List<Map<String, String>> demoChannels = [
    {
      'name': 'BBC One',
      'url': 'https://test-streams.mux.dev/xiaomi-30s.mp4',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/BBC_One_logo_2021.svg/120px-BBC_One_logo_2021.svg.png',
      'group': 'News',
    },
    {
      'name': 'CNN International',
      'url': 'https://test-streams.mux.dev/xiaomi-30s.mp4',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/CNN.svg/120px-CNN.svg.png',
      'group': 'News',
    },
    {
      'name': 'ESPN',
      'url': 'https://test-streams.mux.dev/xiaomi-30s.mp4',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/ESPN_logo.svg/120px-ESPN_logo.svg.png',
      'group': 'Sports',
    },
    {
      'name': 'Sky Sports',
      'url': 'https://test-streams.mux.dev/xiaomi-30s.mp4',
      'logo': 'https://upload.wikimedia.org/wikipedia/en/thumb/6/6c/Sky_Sports_logo_2020.svg/120px-Sky_Sports_logo_2020.svg.png',
      'group': 'Sports',
    },
    {
      'name': 'HBO',
      'url': 'https://test-streams.mux.dev/xiaomi-30s.mp4',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/HBO_logo.svg/120px-HBO_logo.svg.png',
      'group': 'Movies',
    },
    {
      'name': 'Netflix Channel',
      'url': 'https://test-streams.mux.dev/xiaomi-30s.mp4',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Netflix_2015_logo.svg/120px-Netflix_2015_logo.svg.png',
      'group': 'Movies',
    },
    {
      'name': 'Discovery',
      'url': 'https://test-streams.mux.dev/xiaomi-30s.mp4',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Discovery_Channel_logo_2019.svg/120px-Discovery_Channel_logo_2019.svg.png',
      'group': 'Documentary',
    },
    {
      'name': 'National Geographic',
      'url': 'https://test-streams.mux.dev/xiaomi-30s.mp4',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/National_Geographic_Channel_logo.svg/120px-National_Geographic_Channel_logo.svg.png',
      'group': 'Documentary',
    },
    {
      'name': 'MTV',
      'url': 'https://test-streams.mux.dev/xiaomi-30s.mp4',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/MTV_Logo_2010.svg/120px-MTV_Logo_2010.svg.png',
      'group': 'Music',
    },
    {
      'name': 'VH1',
      'url': 'https://test-streams.mux.dev/xiaomi-30s.mp4',
      'logo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/VH1_logo.svg/120px-VH1_logo.svg.png',
      'group': 'Music',
    },
  ];
}
