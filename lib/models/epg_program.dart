import 'package:hive/hive.dart';

part 'epg_program.g.dart';

@HiveType(typeId: 2)
class EPGProgram {
  @HiveField(0)
  final String channelId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime startTime;

  @HiveField(4)
  final DateTime endTime;

  @HiveField(5)
  final String? category;

  @HiveField(6)
  final String? icon;

  EPGProgram({
    required this.channelId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.category,
    this.icon,
  });

  bool get isCurrentlyAiring {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  String get duration {
    final diff = endTime.difference(startTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}
