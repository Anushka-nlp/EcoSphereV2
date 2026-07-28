import 'package:anymex/controllers/announcement_controller.dart';
import 'package:anymex/screens/announcements/announcement_detail_page.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_button.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_chip.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_container.dart';
import 'package:anymex/widgets/custom_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ApprovalQueuePage extends StatelessWidget {
  const ApprovalQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<AnnouncementController>();

    return Column(
      children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.fact_check, size: 24),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: EchoSphereText(
                      text: 'Announcement Approval Queue',
                      size: 16,
                      variant: TextVariant.bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => EchoSphereChip(
                        label: '${controller.pendingApprovals.length} Pending',
                        isSelected: true,
                        onSelected: (_) {},
                      )),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Obx(() {
                final pending = controller.pendingApprovals;
                if (pending.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified,
                            size: 64, color: theme.colorScheme.primary.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'No Pending Approvals',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'All submitted announcements have been reviewed.',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: pending.length,
                  itemBuilder: (context, index) {
                    final item = pending[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: EchoSphereContainer(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                EchoSphereChip(
                                  label: item.category,
                                  isSelected: true,
                                  onSelected: (_) {},
                                ),
                                const SizedBox(width: 8),
                                EchoSphereChip(
                                  label: item.department,
                                  isSelected: false,
                                  onSelected: (_) {},
                                ),
                                const Spacer(),
                                Text(
                                  DateFormat('MMM dd, hh:mm a').format(item.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  'Submitted by: ${item.creatorName}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                EchoSphereButton(
                                  height: 36,
                                  onTap: () => Get.to(() => AnnouncementDetailPage(announcement: item)),
                                  child: const Row(
                                    children: [
                                      Text('Review & Action'),
                                      SizedBox(width: 6),
                                      Icon(Icons.arrow_forward, size: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        );
  }
}
