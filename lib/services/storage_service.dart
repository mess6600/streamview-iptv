import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/channel.dart';
import '../models/playlist.dart';
import '../models/epg_program.dart';

class StorageService {
  static const String _playlistsKey = 'playlists';
  static const String _epgKey = 'epg_data';
  static const String _favoritesKey = 'favorites';
  static const String _settingsKey = 'settings';

  Future<void> savePlaylist(Playlist playlist) async {
    final prefs = await SharedPreferences.getInstance();
    final playlists = await getAllPlaylists();

    // Remove existing playlist with same ID
    playlists.removeWhere((p) => p.id == playlist.id);
    playlists.add(playlist);

    final data = playlists.map((p) => _playlistToJson(p)).toList();
    await prefs.setString(_playlistsKey, jsonEncode(data));
  }

  Future<List<Playlist>> getAllPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_playlistsKey);

    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((j) => _playlistFromJson(j)).toList();
  }

  Future<void> deletePlaylist(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final playlists = await getAllPlaylists();
    playlists.removeWhere((p) => p.id == id);

    final data = playlists.map((p) => _playlistToJson(p)).toList();
    await prefs.setString(_playlistsKey, jsonEncode(data));
  }

  Future<void> toggleFavorite(String channelId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];

    if (favorites.contains(channelId)) {
      favorites.remove(channelId);
    } else {
      favorites.add(channelId);
    }

    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  Future<void> saveEPG(List<EPGProgram> programs) async {
    final prefs = await SharedPreferences.getInstance();
    final data = programs.map((p) => _epgToJson(p)).toList();
    await prefs.setString(_epgKey, jsonEncode(data));
  }

  Future<List<EPGProgram>> getAllEPG() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_epgKey);

    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((j) => _epgFromJson(j)).toList();
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings));
  }

  Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_settingsKey);
    return data != null ? jsonDecode(data) : {};
  }

  // JSON Helpers
  Map<String, dynamic> _playlistToJson(Playlist p) {
    return {
      'id': p.id,
      'name': p.name,
      'url': p.url,
      'channels': p.channels.map((c) => _channelToJson(c)).toList(),
      'createdAt': p.createdAt.toIso8601String(),
      'epgUrl': p.epgUrl,
      'isActive': p.isActive,
    };
  }

  Playlist _playlistFromJson(Map<String, dynamic> j) {
    return Playlist(
      id: j['id'],
      name: j['name'],
      url: j['url'],
      channels: (j['channels'] as List).map((c) => _channelFromJson(c)).toList(),
      createdAt: DateTime.parse(j['createdAt']),
      epgUrl: j['epgUrl'],
      isActive: j['isActive'] ?? true,
    );
  }

  Map<String, dynamic> _channelToJson(Channel c) {
    return {
      'id': c.id,
      'name': c.name,
      'url': c.url,
      'logo': c.logo,
      'group': c.group,
      'epgId': c.epgId,
      'isFavorite': c.isFavorite,
      'extraData': c.extraData,
    };
  }

  Channel _channelFromJson(Map<String, dynamic> j) {
    return Channel(
      id: j['id'],
      name: j['name'],
      url: j['url'],
      logo: j['logo'],
      group: j['group'],
      epgId: j['epgId'],
      isFavorite: j['isFavorite'] ?? false,
      extraData: j['extraData'] != null ? Map<String, dynamic>.from(j['extraData']) : null,
    );
  }

  Map<String, dynamic> _epgToJson(EPGProgram p) {
    return {
      'channelId': p.channelId,
      'title': p.title,
      'description': p.description,
      'startTime': p.startTime.toIso8601String(),
      'endTime': p.endTime.toIso8601String(),
      'category': p.category,
      'icon': p.icon,
    };
  }

  EPGProgram _epgFromJson(Map<String, dynamic> j) {
    return EPGProgram(
      channelId: j['channelId'],
      title: j['title'],
      description: j['description'],
      startTime: DateTime.parse(j['startTime']),
      endTime: DateTime.parse(j['endTime']),
      category: j['category'],
      icon: j['icon'],
    );
  }
}
