import 'package:anymex/widgets/custom_widgets/echosphere_chip.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'title': 'Urgent: Campus Weather Alert Issued',
      'message': 'All afternoon lab sessions are cancelled due to heavy rain advisory.',
      'type': 'EMERGENCY',
      'time': DateTime.now().subtract(const Duration(minutes: 15)),
      'isRead': false,
    },
    {
      'id': 2,
      'title': 'Announcement Approved',
      'message': 'Your notice "End-Sem Practical Exam Schedule" has been approved by HoD.',
      'type': 'APPROVAL',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
    },
    {
      'id': 3,
      'title': 'Placement Drive Reminder',
      'message': 'TCS campus recruitment registration closes at 5:00 PM today.',
      'type': 'PLACEMENT',
      'time': DateTime.now().subtract(const Duration(hours: 5)),
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount = notifications.where((n) => !n['isRead']).length;

    return Column(
      children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.notifications, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontFamily: 'Poppins-Bold',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  EchoSphereChip(
                    label: '$unreadCount Unread',
                    isSelected: true,
                    onSelected: (_) {},
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Mark all as read',
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.done_all, size: 20, color: theme.colorScheme.primary),
                    onPressed: () {
                      setState(() {
                        for (var n in notifications) {
                          n['isRead'] = true;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Notifications List
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Text(
                        'No notifications.',
                        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: notifications.length,
                      itemBuilder: (ctx, i) {
                        final n = notifications[i];
                        final isRead = n['isRead'] as bool;
                        final type = n['type'] as String;

                        IconData iconData = Icons.notifications;
                        Color iconColor = theme.colorScheme.primary;
                        if (type == 'EMERGENCY') {
                          iconData = Icons.warning;
                          iconColor = Colors.red;
                        } else if (type == 'APPROVAL') {
                          iconData = Icons.verified;
                          iconColor = Colors.green;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                n['isRead'] = true;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: EchoSphereContainer(
                              padding: const EdgeInsets.all(16.0),
                              color: isRead ? null : theme.colorScheme.primary.withOpacity(0.06),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: iconColor.withOpacity(0.15),
                                    ),
                                    child: Icon(iconData, color: iconColor, size: 20),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                n['title'],
                                                style: TextStyle(
                                                  fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              DateFormat('hh:mm a').format(n['time']),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          n['message'],
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
