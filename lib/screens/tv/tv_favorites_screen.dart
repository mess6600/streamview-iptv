import 'package:flutter/material.dart';
import '../../models/channel.dart';
import '../../services/playlist_service.dart';
import '../../services/storage_service.dart';
import '../../utils/theme.dart';
import '../player_screen.dart';

class TVFavoritesScreen extends StatefulWidget {
  const TVFavoritesScreen({super.key});

  @override
  State<TVFavoritesScreen> createState() => _TVFavoritesScreenState();
}

class _TVFavoritesScreenState extends State<TVFavoritesScreen> {
  final PlaylistService _playlistService = PlaylistService();
  final StorageService _storage = StorageService();
  List<Channel> _favorites = [];
  bool _isLoading = true;
  int _focusedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);

    final playlists = await _playlistService.getAllPlaylists();
    final favoriteIds = await _storage.getFavorites();

    final favorites = <Channel>[];
    for (final playlist in playlists) {
      for (final channel in playlist.channels) {
        if (favoriteIds.contains(channel.id)) {
          favorites.add(channel..isFavorite = true);
        }
      }
    }

    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
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
                  child: Text(
                    'Favorite Channels',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Favorites Grid
                Expanded(
                  child: _favorites.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 80,
                                color: AppTheme.textMuted.withOpacity(0.5),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No favorites yet',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Add channels to favorites from the Live tab',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                          itemCount: _favorites.length,
                          itemBuilder: (context, index) {
                            final channel = _favorites[index];
                            return _TVFavoriteCard(
                              channel: channel,
                              isFocused: _focusedIndex == index,
                              onTap: () => _playChannel(channel),
                              onFocusChange: (focused) {
                                if (focused) setState(() => _focusedIndex = index);
                              },
                              onRemove: () => _removeFavorite(channel),
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

  Future<void> _removeFavorite(Channel channel) async {
    await _playlistService.toggleFavorite(channel.id);
    _loadFavorites();
  }
}

class _TVFavoriteCard extends StatefulWidget {
  final Channel channel;
  final bool isFocused;
  final VoidCallback onTap;
  final ValueChanged<bool> onFocusChange;
  final VoidCallback onRemove;

  const _TVFavoriteCard({
    required this.channel,
    required this.isFocused,
    required this.onTap,
    required this.onFocusChange,
    required this.onRemove,
  });

  @override
  State<_TVFavoriteCard> createState() => _TVFavoriteCardState();
}

class _TVFavoriteCardState extends State<_TVFavoriteCard> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: widget.onFocusChange,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.isFocused
                ? Colors.red.withOpacity(0.2)
                : AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: widget.isFocused
                ? Border.all(color: Colors.red, width: 2)
                : null,
            boxShadow: widget.isFocused
                ? [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.channel.name,
                      style: TextStyle(
                        color: widget.isFocused ? Colors.red : Colors.white,
                        fontWeight: widget.isFocused ? FontWeight.bold : FontWeight.w500,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.channel.group ?? 'General',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              // Favorite Icon
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

              // Remove button on focus
              if (widget.isFocused)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: widget.onRemove,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'REMOVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
