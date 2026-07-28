import 'package:anymex/widgets/custom_widgets/echosphere_button.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_chip.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_container.dart';
import 'package:anymex/widgets/non_widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SpeakerQueuePage extends StatefulWidget {
  const SpeakerQueuePage({super.key});

  @override
  State<SpeakerQueuePage> createState() => _SpeakerQueuePageState();
}

class _SpeakerQueuePageState extends State<SpeakerQueuePage> {
  bool isPlaying = false;
  int activeIndex = 0;

  final List<Map<String, dynamic>> queueItems = [
    {
      'id': 101,
      'title': 'Emergency Campus Weather Advisory',
      'department': 'College-Wide',
      'duration': '00:45',
      'scheduledTime': DateTime.now().add(const Duration(minutes: 2)),
      'type': 'AI Speech',
      'status': 'Next in Queue',
    },
    {
      'id': 102,
      'title': 'End Semester Practical Exam Guidelines',
      'department': 'CSE Dept',
      'duration': '01:20',
      'scheduledTime': DateTime.now().add(const Duration(minutes: 8)),
      'type': 'Recorded Voice',
      'status': 'Queued',
    },
    {
      'id': 103,
      'title': 'Placement Drive Briefing - TCS & Infosys',
      'department': 'Placement Cell',
      'duration': '01:00',
      'scheduledTime': DateTime.now().add(const Duration(minutes: 15)),
      'type': 'AI Speech',
      'status': 'Queued',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.volume_up, size: 24, color: Colors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Speaker Announcement Queue',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  EchoSphereChip(
                    label: '${queueItems.length} in Queue',
                    isSelected: true,
                    onSelected: (_) {},
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Active Speaker Banner
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: EchoSphereContainer(
                padding: const EdgeInsets.all(20.0),
                color: theme.colorScheme.primary.withOpacity(0.12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isPlaying ? Icons.graphic_eq : Icons.pause_circle_filled,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isPlaying ? 'Now Broadcasting on Campus Speakers' : 'Speaker Queue Ready',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                queueItems.isNotEmpty
                                    ? queueItems[activeIndex]['title']
                                    : 'No active speaker announcement',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        EchoSphereButton(
                          height: 38,
                          onTap: () {
                            setState(() => isPlaying = !isPlaying);
                            snackBar(
                              isPlaying ? 'Started speaker playback...' : 'Paused speaker queue.',
                            );
                          },
                          child: Row(
                            children: [
                              Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 18),
                              const SizedBox(width: 6),
                              Text(isPlaying ? 'Pause' : 'Play'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Minimum 2-minute gap strictly maintained between speaker announcements.',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),

            // Queue Items List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: queueItems.length,
                itemBuilder: (ctx, i) {
                  final item = queueItems[i];
                  final isCurrent = i == activeIndex;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: EchoSphereContainer(
                      padding: const EdgeInsets.all(16.0),
                      color: isCurrent ? theme.colorScheme.primary.withOpacity(0.08) : null,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.primary.withOpacity(0.15),
                            ),
                            child: Text(
                              '#${i + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    EchoSphereChip(
                                      label: item['type'],
                                      isSelected: true,
                                      onSelected: (_) {},
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['department'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Scheduled: ${DateFormat("hh:mm a").format(item["scheduledTime"])} • Duration: ${item["duration"]}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_upward, size: 20),
                            onPressed: i == 0
                                ? null
                                : () {
                                    setState(() {
                                      final temp = queueItems[i];
                                      queueItems[i] = queueItems[i - 1];
                                      queueItems[i - 1] = temp;
                                    });
                                    snackBar('Reordered announcement in speaker queue.');
                                  },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
  }
}
