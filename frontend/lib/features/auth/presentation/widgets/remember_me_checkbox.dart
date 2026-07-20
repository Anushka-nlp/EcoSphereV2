import 'package:flutter/material.dart';

import 'package:ecosphere/core/theme/app_spacing.dart';
import 'package:ecosphere/core/theme/app_text_styles.dart';

class RememberMeCheckbox extends StatelessWidget {
  const RememberMeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: value,
                onChanged: (checked) {
                  onChanged(checked ?? false);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text('Remember me', style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}
