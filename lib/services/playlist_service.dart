import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/channel.dart';
import '../models/playlist.dart';
import 'storage_service.dart';

class PlaylistService {
  final StorageService _storage = StorageService();

  Future<Playlist> parseM3U(String content, {String? url, String? name}) async {
    final channels = <Channel>[];
    final lines = content.split('
');

    String? currentUrl;
    String? currentName;
    String? currentLogo;
    String? currentGroup;
    String? currentEpgId;
    Map<String, dynamic>? currentExtra;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.startsWith('#EXTINF:')) {
        // Parse EXTINF line
        final nameMatch = RegExp(r'tvg-name="([^"]*)"').firstMatch(line);
        final logoMatch = RegExp(r'tvg-logo="([^"]*)"').firstMatch(line);
        final groupMatch = RegExp(r'group-title="([^"]*)"').firstMatch(line);
        final epgMatch = RegExp(r'tvg-id="([^"]*)"').firstMatch(line);

        currentName = nameMatch?.group(1);
        currentLogo = logoMatch?.group(1);
        currentGroup = groupMatch?.group(1) ?? 'Uncategorized';
        currentEpgId = epgMatch?.group(1);

        // Extract name after comma
        final commaIndex = line.lastIndexOf(',');
        if (commaIndex != -1 && commaIndex < line.length - 1) {
          currentName ??= line.substring(commaIndex + 1).trim();
        }

        currentExtra = {
          'rawExtinf': line,
        };
      } else if (line.isNotEmpty && !line.startsWith('#')) {
        currentUrl = line;

        if (currentUrl != null && currentName != null) {
          channels.add(Channel(
            id: '${channels.length}_${DateTime.now().millisecondsSinceEpoch}',
            name: currentName,
            url: currentUrl,
            logo: currentLogo,
            group: currentGroup,
            epgId: currentEpgId,
            extraData: currentExtra,
          ));
        }

        // Reset
        currentUrl = null;
        currentName = null;
        currentLogo = null;
        currentGroup = null;
        currentEpgId = null;
        currentExtra = null;
      }
    }

    final playlist = Playlist(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name ?? 'Imported Playlist',
      url: url,
      channels: channels,
      createdAt: DateTime.now(),
    );

    await _storage.savePlaylist(playlist);
    return playlist;
  }

  Future<Playlist> loadFromUrl(String url, {String? name}) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load playlist: ${response.statusCode}');
    }
    return parseM3U(response.body, url: url, name: name);
  }

  Future<List<Playlist>> getAllPlaylists() async {
    return await _storage.getAllPlaylists();
  }

  Future<void> deletePlaylist(String id) async {
    await _storage.deletePlaylist(id);
  }

  Future<void> toggleFavorite(String channelId) async {
    await _storage.toggleFavorite(channelId);
  }
}
