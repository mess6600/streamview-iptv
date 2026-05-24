import 'package:hive/hive.dart';
import 'channel.dart';

part 'playlist.g.dart';

@HiveType(typeId: 1)
class Playlist {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? url;

  @HiveField(3)
  final List<Channel> channels;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? epgUrl;

  @HiveField(6)
  bool isActive;

  Playlist({
    required this.id,
    required this.name,
    this.url,
    required this.channels,
    required this.createdAt,
    this.epgUrl,
    this.isActive = true,
  });

  List<String> get groups {
    final groups = channels.map((c) => c.group).whereType<String>().toSet().toList();
    groups.sort();
    return groups;
  }

  List<Channel> getChannelsByGroup(String group) {
    if (group == 'All') return channels;
    if (group == 'Favorites') return channels.where((c) => c.isFavorite).toList();
    return channels.where((c) => c.group == group).toList();
  }
}
