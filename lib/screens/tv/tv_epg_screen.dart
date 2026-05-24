import 'package:flutter/material.dart';
import '../../models/epg_program.dart';
import '../../services/epg_service.dart';
import '../../utils/theme.dart';
import 'package:intl/intl.dart';

class TVEPGScreen extends StatefulWidget {
  const TVEPGScreen({super.key});

  @override
  State<TVEPGScreen> createState() => _TVEPGScreenState();
}

class _TVEPGScreenState extends State<TVEPGScreen> {
  final EPGService _epgService = EPGService();
  List<EPGProgram> _programs = [];
  bool _isLoading = true;
  int _focusedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadEPG();
  }

  Future<void> _loadEPG() async {
    setState(() => _isLoading = true);

    // Generate demo EPG data
    _programs = _generateDemoEPG();

    setState(() => _isLoading = false);
  }

  List<EPGProgram> _generateDemoEPG() {
    final programs = <EPGProgram>[];
    final now = DateTime.now();

    final demoShows = [
      {'title': 'Morning News', 'desc': 'Start your day with the latest headlines', 'channel': 'BBC One'},
      {'title': 'Sports Center', 'desc': 'All the sports highlights', 'channel': 'ESPN'},
      {'title': 'Movie Premiere', 'desc': 'Blockbuster movie of the week', 'channel': 'HBO'},
      {'title': 'Documentary Special', 'desc': 'Explore the wonders of nature', 'channel': 'Discovery'},
      {'title': 'Evening Show', 'desc': 'Entertainment and talk show', 'channel': 'BBC One'},
      {'title': 'Late Night Movie', 'desc': 'Classic cinema experience', 'channel': 'HBO'},
      {'title': 'Music Awards', 'desc': 'Annual music celebration', 'channel': 'MTV'},
      {'title': 'Science Today', 'desc': 'Latest scientific discoveries', 'channel': 'National Geographic'},
    ];

    for (var i = 0; i < demoShows.length; i++) {
      final startTime = DateTime(now.year, now.month, now.day, 6 + i * 2, 0);
      final endTime = startTime.add(const Duration(hours: 2));

      programs.add(EPGProgram(
        channelId: demoShows[i]['channel']!,
        title: demoShows[i]['title']!,
        description: demoShows[i]['desc'],
        startTime: startTime,
        endTime: endTime,
        category: 'General',
      ));
    }

    return programs;
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
                    'TV Guide',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // EPG List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _programs.length,
                    itemBuilder: (context, index) {
                      final program = _programs[index];
                      return _TVEPGCard(
                        program: program,
                        isFocused: _focusedIndex == index,
                        onFocusChange: (focused) {
                          if (focused) setState(() => _focusedIndex = index);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _TVEPGCard extends StatefulWidget {
  final EPGProgram program;
  final bool isFocused;
  final ValueChanged<bool> onFocusChange;

  const _TVEPGCard({
    required this.program,
    required this.isFocused,
    required this.onFocusChange,
  });

  @override
  State<_TVEPGCard> createState() => _TVEPGCardState();
}

class _TVEPGCardState extends State<_TVEPGCard> {
  @override
  Widget build(BuildContext context) {
    final isLive = widget.program.isCurrentlyAiring;
    final timeFormat = DateFormat('HH:mm');

    return Focus(
      onFocusChange: widget.onFocusChange,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.isFocused
              ? AppTheme.primaryColor.withOpacity(0.2)
              : isLive
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: widget.isFocused
              ? Border.all(color: AppTheme.primaryColor, width: 2)
              : isLive
                  ? Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1)
                  : null,
        ),
        child: Row(
          children: [
            // Time Column
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeFormat.format(widget.program.startTime),
                    style: TextStyle(
                      color: isLive ? AppTheme.primaryColor : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeFormat.format(widget.program.endTime),
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 24),

            // Progress Bar
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: isLive ? AppTheme.primaryColor : AppTheme.textMuted.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(width: 24),

            // Program Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          widget.program.title,
                          style: TextStyle(
                            color: widget.isFocused ? AppTheme.primaryColor : Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.program.description ?? 'No description available',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.tv,
                        size: 16,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.program.channelId,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: AppTheme.accentColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.program.duration,
                        style: const TextStyle(
                          color: AppTheme.accentColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
