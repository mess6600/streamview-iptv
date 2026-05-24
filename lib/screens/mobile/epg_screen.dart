import 'package:flutter/material.dart';
import '../../models/epg_program.dart';
import '../../services/epg_service.dart';
import '../../utils/theme.dart';
import 'package:intl/intl.dart';

class EPGScreen extends StatefulWidget {
  const EPGScreen({super.key});

  @override
  State<EPGScreen> createState() => _EPGScreenState();
}

class _EPGScreenState extends State<EPGScreen> {
  final EPGService _epgService = EPGService();
  List<EPGProgram> _programs = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadEPG();
  }

  Future<void> _loadEPG() async {
    setState(() => _isLoading = true);

    // For demo, generate fake EPG data
    _programs = _generateDemoEPG();

    setState(() => _isLoading = false);
  }

  List<EPGProgram> _generateDemoEPG() {
    final programs = <EPGProgram>[];
    final now = DateTime.now();

    final demoShows = [
      {'title': 'Morning News', 'desc': 'Start your day with the latest headlines'},
      {'title': 'Sports Center', 'desc': 'All the sports highlights'},
      {'title': 'Movie Premiere', 'desc': 'Blockbuster movie of the week'},
      {'title': 'Documentary Special', 'desc': 'Explore the wonders of nature'},
      {'title': 'Evening Show', 'desc': 'Entertainment and talk show'},
      {'title': 'Late Night Movie', 'desc': 'Classic cinema experience'},
    ];

    for (var i = 0; i < 6; i++) {
      final startTime = DateTime(now.year, now.month, now.day, 6 + i * 3, 0);
      final endTime = startTime.add(const Duration(hours: 3));

      programs.add(EPGProgram(
        channelId: 'channel_$i',
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
      appBar: AppBar(
        title: const Text('TV Guide'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Date Selector
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      final date = DateTime.now().add(Duration(days: index));
                      final isSelected = _selectedDate.day == date.day;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            index == 0 ? 'Today' : DateFormat('EEE').format(date),
                          ),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedDate = date),
                          backgroundColor: AppTheme.cardColor,
                          selectedColor: AppTheme.primaryColor,
                        ),
                      );
                    },
                  ),
                ),

                // EPG List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _programs.length,
                    itemBuilder: (context, index) {
                      final program = _programs[index];
                      return _EPGCard(program: program);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _EPGCard extends StatelessWidget {
  final EPGProgram program;

  const _EPGCard({required this.program});

  @override
  Widget build(BuildContext context) {
    final isLive = program.isCurrentlyAiring;
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isLive ? AppTheme.primaryColor.withOpacity(0.15) : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Time Column
            Column(
              children: [
                Text(
                  timeFormat.format(program.startTime),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isLive ? AppTheme.primaryColor : null,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeFormat.format(program.endTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(width: 16),

            // Progress Indicator
            if (isLive)
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            else
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            const SizedBox(width: 16),

            // Program Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          program.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    program.description ?? 'No description available',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Duration: ${program.duration}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.accentColor,
                    ),
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
