import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../widgets/backgrounds/background.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
    this.scrollable = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    Widget content = SafeArea(
      child: Padding(padding: padding, child: child),
    );

    if (scrollable) {
      content = SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: content,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Background(child: content),
    );
  }
}
