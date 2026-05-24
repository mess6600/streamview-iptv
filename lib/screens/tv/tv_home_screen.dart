import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/channel.dart';
import '../../models/playlist.dart';
import '../../services/playlist_service.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../player_screen.dart';

class TVHomeScreen extends StatefulWidget {
  const TVHomeScreen({super.key});

  @override
  State<TVHomeScreen> createState() => _TVHomeScreenState();
}

class _TVHomeScreenState extends State<TVHomeScreen> {
  final PlaylistService _playlistService = PlaylistService();
  Playlist? _playlist;
  String _selectedGroup = 'All';
  int _focusedIndex = -1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    final playlists = await _playlistService.getAllPlaylists();

    if (playlists.isEmpty) {
      final demoPlaylist = await _createDemoPlaylist();
      setState(() {
        _playlist = demoPlaylist;
        _isLoading = false;
      });
    } else {
      setState(() {
        _playlist = playlists.first;
        _isLoading = false;
      });
    }
  }

  Future<Playlist> _createDemoPlaylist() async {
    final channels = AppConstants.demoChannels.map((data) => Channel(
      id: DateTime.now().millisecondsSinceEpoch.toString() + data['name']!,
      name: data['name']!,
      url: data['url']!,
      logo: data['logo'],
      group: data['group'],
    )).toList();

    return Playlist(
      id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Demo Playlist',
      channels: channels,
      createdAt: DateTime.now(),
    );
  }

  List<Channel> get _filteredChannels {
    if (_playlist == null) return [];
    return _playlist!.getChannelsByGroup(_selectedGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Live Channels',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Group Filter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGroup,
                            dropdownColor: AppTheme.cardColor,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            icon: const Icon(Icons.arrow_drop_down, color: AppTheme.textMuted),
                            onChanged: (value) => setState(() => _selectedGroup = value!),
                            items: ['All', 'Favorites', ..._playlist!.groups]
                                .map((group) => DropdownMenuItem(
                                      value: group,
                                      child: Text(group),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Channel Grid
                Expanded(
                  child: _filteredChannels.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.tv_off,
                                size: 64,
                                color: AppTheme.textMuted.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No channels found',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(24),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _filteredChannels.length,
                          itemBuilder: (context, index) {
                            final channel = _filteredChannels[index];
                            return _TVChannelCard(
                              channel: channel,
                              isFocused: _focusedIndex == index,
                              onTap: () => _playChannel(channel),
                              onFocusChange: (focused) {
                                if (focused) {
                                  setState(() => _focusedIndex = index);
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _playChannel(Channel channel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(channel: channel),
      ),
    );
  }
}

class _TVChannelCard extends StatefulWidget {
  final Channel channel;
  final bool isFocused;
  final VoidCallback onTap;
  final ValueChanged<bool> onFocusChange;

  const _TVChannelCard({
    required this.channel,
    required this.isFocused,
    required this.onTap,
    required this.onFocusChange,
  });

  @override
  State<_TVChannelCard> createState() => _TVChannelCardState();
}

class _TVChannelCardState extends State<_TVChannelCard> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: widget.onFocusChange,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.isFocused ? AppTheme.primaryColor.withOpacity(0.2) : AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: widget.isFocused
                ? Border.all(color: AppTheme.primaryColor, width: 2)
                : null,
            boxShadow: widget.isFocused
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Channel Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.elevatedCardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: widget.channel.logo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.channel.logo!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.tv,
                            size: 40,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      )
                    : const Icon(Icons.tv, size: 40, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 16),

              // Channel Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.channel.name,
                  style: TextStyle(
                    color: widget.isFocused ? AppTheme.primaryColor : Colors.white,
                    fontWeight: widget.isFocused ? FontWeight.bold : FontWeight.w500,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 4),

              // Group Label
              Text(
                widget.channel.group ?? 'General',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),

              // Live Indicator
              if (widget.isFocused)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PRESS OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
