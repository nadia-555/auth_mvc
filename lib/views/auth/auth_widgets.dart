import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';

void showAppSnack(BuildContext context, String message, {bool success = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
    ));
}

/// حقل كلمة مرور مع زر لاحقة لإخفاء/إظهار النص (Obscure Toggle).
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final TextInputAction textInputAction;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          tooltip: _obscure ? 'إظهار' : 'إخفاء',
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

/// زر رئيسي يعرض مؤشر تحميل أثناء تنفيذ عملية الـ Controller.
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.controller,
    required this.label,
    required this.onPressed,
  });

  final AuthController controller;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton(
          onPressed: controller.isLoading ? null : onPressed,
          child: controller.isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Text(label),
        ),
      ),
    );
  }
}
