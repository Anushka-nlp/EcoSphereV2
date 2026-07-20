import 'package:flutter/material.dart';

import 'package:ecosphere/widgets/inputs/fields/app_text_form_field.dart';

class GlassPasswordField extends StatefulWidget {
  const GlassPasswordField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = 'Password',
    this.labelText = 'Password',
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final String labelText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction textInputAction;

  @override
  State<GlassPasswordField> createState() => _GlassPasswordFieldState();
}

class _GlassPasswordFieldState extends State<GlassPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ApptextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      labelText: widget.labelText,
      hintText: widget.hintText,
      obscureText: _obscureText,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      prefixIcon: const Icon(Icons.lock_outline_rounded),
      suffixIcon: IconButton(
        splashRadius: 20,
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      ),
    );
  }
}
