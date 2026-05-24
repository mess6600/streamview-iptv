import 'package:flutter/material.dart';
import '../../models/channel.dart';
import '../../models/playlist.dart';
import '../../services/playlist_service.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../player_screen.dart';
import 'playlist_import_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlaylistService _playlistService = PlaylistService();
  List<Playlist> _playlists = [];
  Playlist? _selectedPlaylist;
  String _selectedGroup = 'All';
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    setState(() => _isLoading = true);

    final playlists = await _playlistService.getAllPlaylists();

    if (playlists.isEmpty) {
      // Create demo playlist
      final demoPlaylist = await _createDemoPlaylist();
      playlists.add(demoPlaylist);
    }

    setState(() {
      _playlists = playlists;
      _selectedPlaylist = playlists.first;
      _isLoading = false;
    });
  }

  Future<Playlist> _createDemoPlaylist() async {
    final channels = AppConstants.demoChannels.map((data) => Channel(
      id: DateTime.now().millisecondsSinceEpoch.toString() + data['name']!,
      name: data['name']!,
      url: data['url']!,
      logo: data['logo'],
      group: data['group'],
    )).toList();

    final playlist = Playlist(
      id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Demo Playlist',
      channels: channels,
      createdAt: DateTime.now(),
    );

    await _playlistService.parseM3U(''); // Initialize storage
    return playlist;
  }

  List<Channel> get _filteredChannels {
    if (_selectedPlaylist == null) return [];

    var channels = _selectedPlaylist!.getChannelsByGroup(_selectedGroup);

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      channels = channels.where((c) => 
        c.name.toLowerCase().contains(query)
      ).toList();
    }

    return channels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlaylistImportScreen()),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search channels...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                  ),
                ),

                // Group Filter
                if (_selectedPlaylist != null)
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ['All', 'Favorites', ..._selectedPlaylist!.groups].length,
                      itemBuilder: (context, index) {
                        final groups = ['All', 'Favorites', ..._selectedPlaylist!.groups];
                        final group = groups[index];
                        final isSelected = _selectedGroup == group;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(group),
                            selected: isSelected,
                            onSelected: (_) => setState(() => _selectedGroup = group),
                            backgroundColor: AppTheme.cardColor,
                            selectedColor: AppTheme.primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Channel List
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
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredChannels.length,
                          itemBuilder: (context, index) {
                            final channel = _filteredChannels[index];
                            return _ChannelCard(
                              channel: channel,
                              onTap: () => _playChannel(channel),
                              onFavoriteToggle: () => _toggleFavorite(channel),
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

  Future<void> _toggleFavorite(Channel channel) async {
    await _playlistService.toggleFavorite(channel.id);
    setState(() {
      channel.isFavorite = !channel.isFavorite;
    });
  }
}

class _ChannelCard extends StatelessWidget {
  final Channel channel;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const _ChannelCard({
    required this.channel,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Channel Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.elevatedCardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: channel.logo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          channel.logo!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.tv,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      )
                    : const Icon(Icons.tv, color: AppTheme.textMuted),
              ),
              const SizedBox(width: 16),

              // Channel Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channel.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      channel.group ?? 'Uncategorized',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              // Favorite Button
              IconButton(
                icon: Icon(
                  channel.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: channel.isFavorite ? Colors.red : AppTheme.textMuted,
                ),
                onPressed: onFavoriteToggle,
              ),

              // Play Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
