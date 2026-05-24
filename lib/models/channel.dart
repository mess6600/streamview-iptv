import 'package:hive/hive.dart';

part 'channel.g.dart';

@HiveType(typeId: 0)
class Channel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String? logo;

  @HiveField(4)
  final String? group;

  @HiveField(5)
  final String? epgId;

  @HiveField(6)
  bool isFavorite;

  @HiveField(7)
  final Map<String, dynamic>? extraData;

  Channel({
    required this.id,
    required this.name,
    required this.url,
    this.logo,
    this.group,
    this.epgId,
    this.isFavorite = false,
    this.extraData,
  });

  Channel copyWith({
    String? id,
    String? name,
    String? url,
    String? logo,
    String? group,
    String? epgId,
    bool? isFavorite,
    Map<String, dynamic>? extraData,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      logo: logo ?? this.logo,
      group: group ?? this.group,
      epgId: epgId ?? this.epgId,
      isFavorite: isFavorite ?? this.isFavorite,
      extraData: extraData ?? this.extraData,
    );
  }
}
