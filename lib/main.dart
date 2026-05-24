import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/mobile/main_screen.dart';
import 'screens/tv/tv_main_screen.dart';
import 'services/playlist_service.dart';
import 'services/epg_service.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force landscape for TV, portrait for mobile
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const TiviMateCloneApp());
}

class TiviMateCloneApp extends StatelessWidget {
  const TiviMateCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => PlaylistService()),
        RepositoryProvider(create: (_) => EPGService()),
      ],
      child: MaterialApp(
        title: 'StreamView IPTV',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: _buildHomeScreen(context),
      ),
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    // Detect if running on TV
    final screenSize = MediaQuery.of(context).size;
    final isTV = screenSize.width > 600 && screenSize.height > 400;

    if (isTV) {
      return const TVMainScreen();
    }
    return const MainScreen();
  }
}
