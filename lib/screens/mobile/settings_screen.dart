import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Info Section
          _buildSectionHeader(context, 'App Information'),
          _buildSettingCard(
            context,
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version ${AppConstants.appVersion}',
            onTap: () => _showAboutDialog(context),
          ),

          const SizedBox(height: 24),

          // Playback Section
          _buildSectionHeader(context, 'Playback'),
          _buildSettingCard(
            context,
            icon: Icons.play_circle_outline,
            title: 'Default Player',
            subtitle: 'Built-in Player',
            onTap: () {},
          ),
          _buildSettingCard(
            context,
            icon: Icons.high_quality,
            title: 'Video Quality',
            subtitle: 'Auto',
            onTap: () {},
          ),
          _buildSettingCard(
            context,
            icon: Icons.closed_caption,
            title: 'Subtitles',
            subtitle: 'Enabled',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Interface Section
          _buildSectionHeader(context, 'Interface'),
          _buildSettingCard(
            context,
            icon: Icons.dark_mode,
            title: 'Theme',
            subtitle: 'Dark (Default)',
            onTap: () {},
          ),
          _buildSettingCard(
            context,
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Data Section
          _buildSectionHeader(context, 'Data'),
          _buildSettingCard(
            context,
            icon: Icons.delete_outline,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () => _showClearCacheDialog(context),
            isDestructive: true,
          ),
          _buildSettingCard(
            context,
            icon: Icons.backup,
            title: 'Backup & Restore',
            subtitle: 'Export your playlists',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          // Legal Section
          _buildSectionHeader(context, 'Legal'),
          _buildSettingCard(
            context,
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms',
            onTap: () {},
          ),
          _buildSettingCard(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How we handle your data',
            onTap: () {},
          ),

          const SizedBox(height: 32),

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.warningColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: AppTheme.warningColor,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'Disclaimer',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This app is a player only and does not provide any content. Users are responsible for obtaining their own playlists and ensuring compliance with local laws.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppTheme.errorColor : null,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('About StreamView'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.live_tv,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Version ${AppConstants.appVersion}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.appDescription,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached data including EPG information. Your playlists will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
