import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/epg_program.dart';
import 'storage_service.dart';

class EPGService {
  final StorageService _storage = StorageService();

  Future<List<EPGProgram>> parseXMLTV(String content) async {
    final programs = <EPGProgram>[];
    final document = XmlDocument.parse(content);

    final programmeElements = document.findAllElements('programme');

    for (final element in programmeElements) {
      final channelId = element.getAttribute('channel') ?? '';
      final startStr = element.getAttribute('start') ?? '';
      final stopStr = element.getAttribute('stop') ?? '';

      final titleElement = element.findElements('title').firstOrNull;
      final descElement = element.findElements('desc').firstOrNull;
      final categoryElement = element.findElements('category').firstOrNull;
      final iconElement = element.findElements('icon').firstOrNull;

      final startTime = _parseEPGTime(startStr);
      final endTime = _parseEPGTime(stopStr);

      if (startTime != null && endTime != null) {
        programs.add(EPGProgram(
          channelId: channelId,
          title: titleElement?.text ?? 'Unknown Program',
          description: descElement?.text,
          startTime: startTime,
          endTime: endTime,
          category: categoryElement?.text,
          icon: iconElement?.getAttribute('src'),
        ));
      }
    }

    await _storage.saveEPG(programs);
    return programs;
  }

  Future<List<EPGProgram>> loadFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load EPG: ${response.statusCode}');
    }
    return parseXMLTV(response.body);
  }

  Future<List<EPGProgram>> getProgramsForChannel(String channelId, {DateTime? date}) async {
    final allPrograms = await _storage.getAllEPG();
    final targetDate = date ?? DateTime.now();

    return allPrograms.where((p) {
      return p.channelId == channelId &&
             p.startTime.year == targetDate.year &&
             p.startTime.month == targetDate.month &&
             p.startTime.day == targetDate.day;
    }).toList();
  }

  Future<EPGProgram?> getCurrentProgram(String channelId) async {
    final programs = await getProgramsForChannel(channelId);
    final now = DateTime.now();

    try {
      return programs.firstWhere(
        (p) => now.isAfter(p.startTime) && now.isBefore(p.endTime),
      );
    } catch (e) {
      return null;
    }
  }

  DateTime? _parseEPGTime(String timeStr) {
    // EPG time format: 20240115120000 +0000
    if (timeStr.length < 14) return null;

    try {
      final year = int.parse(timeStr.substring(0, 4));
      final month = int.parse(timeStr.substring(4, 6));
      final day = int.parse(timeStr.substring(6, 8));
      final hour = int.parse(timeStr.substring(8, 10));
      final minute = int.parse(timeStr.substring(10, 12));
      final second = int.parse(timeStr.substring(12, 14));

      return DateTime(year, month, day, hour, minute, second);
    } catch (e) {
      return null;
    }
  }
}
