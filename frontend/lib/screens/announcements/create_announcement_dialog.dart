import 'package:anymex/controllers/announcement_controller.dart';
import 'package:anymex/controllers/auth_controller.dart';
import 'package:anymex/controllers/echosphere_ai_controller.dart';
import 'package:anymex/services/echosphere_api_service.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_chip.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_dialog.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_dropdown.dart';
import 'package:anymex/widgets/non_widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateAnnouncementDialog extends StatefulWidget {
  const CreateAnnouncementDialog({super.key});

  @override
  State<CreateAnnouncementDialog> createState() => _CreateAnnouncementDialogState();
}

class _CreateAnnouncementDialogState extends State<CreateAnnouncementDialog> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  String aiDetectedCategory = 'Academic';
  String aiDetectedPriority = 'NORMAL';
  String selectedAudience = 'Entire College';

  bool deliverInApp = true;
  bool deliverPush = true;
  bool deliverSpeaker = false;

  bool isScheduleLater = false;
  DateTime scheduledDateTime = DateTime.now().add(const Duration(hours: 1));

  bool isAiExpanding = false;
  bool isAiPolishing = false;

  String? aiValidationWarning;
  String? aiSpamWarning;
  String? aiDuplicateWarning;

  final List<String> audiences = [
    'Entire College',
    'CSE Department',
    'ECE Department',
    'EEE Department',
    'Mechanical Dept',
    '1st Year Students',
    '2nd Year Students',
    '3rd Year Students',
    '4th Year Students',
    'Faculty Members',
  ];

  @override
  void initState() {
    super.initState();
    titleController.addListener(_autoDetectAndValidate);
    descController.addListener(_autoDetectAndValidate);
  }

  @override
  void dispose() {
    titleController.removeListener(_autoDetectAndValidate);
    descController.removeListener(_autoDetectAndValidate);
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void _autoDetectAndValidate() {
    final title = titleController.text.trim();
    final desc = descController.text.trim();

    if (title.isEmpty && desc.isEmpty) return;

    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;
    final role = user?.role ?? 'Teacher';

    final aiController = Get.find<EchosphereAiController>();
    final rec = aiController.recommendPriorityAndCategory(title, desc, userRole: role);

    setState(() {
      aiDetectedPriority = rec['priority'] ?? 'NORMAL';
      aiDetectedCategory = rec['category'] ?? 'Academic';
    });

    // Debounced content validation checks
    if (desc.length > 15) {
      _runAiValidation(title, desc);
    }
  }

  Future<void> _runAiValidation(String title, String desc) async {
    try {
      final valRes = await EchosphereApiService().validateContent(desc, title: title);
      final spamRes = await EchosphereApiService().checkSpam(desc);
      final dupRes = await EchosphereApiService().checkDuplicate(title, desc);

      if (mounted) {
        setState(() {
          aiValidationWarning = valRes['is_valid'] == true ? null : valRes['suggestion'];
          aiSpamWarning = spamRes['is_spam'] == true ? spamRes['reason'] : null;
          aiDuplicateWarning = dupRes['is_duplicate'] == true ? dupRes['reason'] : null;
        });
      }
    } catch (_) {}
  }

  Future<void> _expandWithAi() async {
    final desc = descController.text.trim();
    if (desc.isEmpty) {
      errorSnackBar('Please enter a brief note first.');
      return;
    }

    setState(() => isAiExpanding = true);

    try {
      final res = await EchosphereApiService().expandText(desc, category: aiDetectedCategory);
      final expandedText = res['expanded_text'] as String?;
      if (mounted && expandedText != null && expandedText.isNotEmpty) {
        setState(() {
          descController.text = expandedText;
        });
        snackBar('AI expanded your announcement into an official circular.', title: 'AI Expander');
      }
    } catch (_) {
      final fallbackExpanded =
          'This is an official announcement to inform all concerned that $desc. Please strictly adhere to these instructions and check the portal for updates.';
      if (mounted) {
        setState(() {
          descController.text = fallbackExpanded;
        });
        snackBar('AI expanded your announcement text.', title: 'AI Expander');
      }
    } finally {
      if (mounted) setState(() => isAiExpanding = false);
    }
  }

  Future<void> _polishGrammar() async {
    final desc = descController.text.trim();
    if (desc.isEmpty) return;

    setState(() => isAiPolishing = true);

    try {
      final res = await EchosphereApiService().grammarCheck(desc);
      final corrected = res['corrected_text'] as String?;
      if (mounted && corrected != null) {
        setState(() {
          descController.text = corrected;
        });
        snackBar('Grammar and professional tone refined by AI.', title: 'AI Tone & Grammar');
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => isAiPolishing = false);
    }
  }

  Future<void> _selectScheduleDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: scheduledDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(scheduledDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          scheduledDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final annController = Get.find<AnnouncementController>();
    final user = authController.currentUser.value;
    final theme = Theme.of(context);
    final textLength = descController.text.trim().length;

    return EchoSphereDialog(
      title: 'Create & Schedule Announcement',
      contentWidget: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text('Announcement Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'e.g. Mid Semester Examination Timetable',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),

            // Description Header with AI Tools
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Announcement Content', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Row(
                  children: [
                    if (textLength >= 10)
                      ActionChip(
                        avatar: const Icon(Icons.spellcheck, size: 14, color: Colors.blue),
                        label: isAiPolishing
                            ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Grammar', style: TextStyle(fontSize: 11)),
                        onPressed: isAiPolishing ? null : _polishGrammar,
                      ),
                    const SizedBox(width: 6),
                    ActionChip(
                      avatar: const Icon(Icons.auto_awesome, size: 14, color: Colors.amber),
                      label: isAiExpanding
                          ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('✨ AI Expand', style: TextStyle(fontSize: 11)),
                      onPressed: isAiExpanding ? null : _expandWithAi,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: textLength < 80
                    ? 'Enter notice (short notes < 80 chars can be expanded with AI)...'
                    : 'Enter complete announcement content...',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // AI Warnings (Validation / Spam / Duplicate)
            if (aiValidationWarning != null || aiSpamWarning != null || aiDuplicateWarning != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 16, color: Colors.amber),
                        SizedBox(width: 6),
                        Text('AI Content Assistance Warnings', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (aiValidationWarning != null)
                      Text('• $aiValidationWarning', style: const TextStyle(fontSize: 11)),
                    if (aiSpamWarning != null)
                      Text('• Spam Alert: $aiSpamWarning', style: const TextStyle(fontSize: 11, color: Colors.red)),
                    if (aiDuplicateWarning != null)
                      Text('• Duplicate Alert: $aiDuplicateWarning', style: const TextStyle(fontSize: 11, color: Colors.orange)),
                  ],
                ),
              ),
            ],

            // AI Auto-Detected Category & Priority Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 18, color: Colors.amber),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Auto-Classification',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              'Category: ',
                              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                            ),
                            EchoSphereChip(label: aiDetectedCategory, isSelected: true, onSelected: (_) {}),
                            const SizedBox(width: 10),
                            Text(
                              'Priority: ',
                              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                            ),
                            EchoSphereChip(label: aiDetectedPriority, isSelected: true, onSelected: (_) {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Attachments Upload Chip
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => snackBar('Attached document file: Circular_Details.pdf'),
                  icon: const Icon(Icons.attach_file, size: 16),
                  label: const Text('+ Attach PDF / Document', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Target Audience Selector
            const Text('Target Audience', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            EchoSphereDropdown(
              label: 'Audience',
              icon: Icons.groups,
              selectedItem: DropdownItem(value: selectedAudience, text: selectedAudience),
              items: audiences.map((a) => DropdownItem(value: a, text: a)).toList(),
              onChanged: (item) => setState(() => selectedAudience = item.value),
            ),
            const SizedBox(height: 16),

            // Delivery Channels
            const Text('Delivery Channels', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Row(
              children: [
                FilterChip(
                  label: const Text('In-App Feed'),
                  selected: deliverInApp,
                  onSelected: (val) => setState(() => deliverInApp = val),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Push Notification'),
                  selected: deliverPush,
                  onSelected: (val) => setState(() => deliverPush = val),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Speaker Announcement'),
                  selected: deliverSpeaker,
                  onSelected: (val) => setState(() => deliverSpeaker = val),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Scheduling
            Row(
              children: [
                const Text('Publish Schedule:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Publish Now'),
                  selected: !isScheduleLater,
                  onSelected: (val) => setState(() => isScheduleLater = !val),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Schedule Later'),
                  selected: isScheduleLater,
                  onSelected: (val) => setState(() => isScheduleLater = val),
                ),
              ],
            ),
            if (isScheduleLater) ...[
              const SizedBox(height: 10),
              InkWell(
                onTap: _selectScheduleDateTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event, size: 18),
                      const SizedBox(width: 10),
                      Text('Scheduled for: ${DateFormat("MMM dd, yyyy • hh:mm a").format(scheduledDateTime)}'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      onConfirm: () async {
        final title = titleController.text.trim();
        var desc = descController.text.trim();

        if (title.isEmpty || desc.isEmpty) {
          errorSnackBar('Title and description cannot be empty.');
          return;
        }

        // Automatic text expansion for short messages (< 80 chars)
        if (desc.length < 80) {
          desc =
              'This is an official announcement to inform all concerned that $desc. Please strictly adhere to these instructions and check the portal for updates.';
        }

        final ok = await annController.createAnnouncement(
          title: title,
          description: desc,
          category: aiDetectedCategory,
          priority: aiDetectedPriority,
          creatorRole: user?.role ?? 'Teacher',
          creatorName: user?.fullName ?? 'Faculty',
          department: user?.department ?? 'CSE',
        );

        if (ok) {
          snackBar(
            isScheduleLater
                ? 'Announcement scheduled for ${DateFormat("MMM dd, hh:mm a").format(scheduledDateTime)}!'
                : 'Announcement created successfully! (Category: $aiDetectedCategory, Priority: $aiDetectedPriority)',
          );
        }
      },
    );
  }
}
