import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.controller});
  final AuthController controller;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();

  @override
  void dispose() {
    _idCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await widget.controller.sendPasswordResetCode(_idCtrl.text);
    if (!mounted) return;
    if (ok) {
      showAppSnack(context, 'تم إرسال رمز التحقق (الرمز التجريبي: 123456)',
          success: true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(controller: widget.controller),
        ),
      );
    } else {
      showAppSnack(context, widget.controller.errorMessage ?? 'تعذر إرسال الرمز');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('استعادة كلمة المرور')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: scheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                color: scheme.onPrimaryContainer),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'أدخل بريدك الجامعي أو رقمك الأكاديمي، وسنرسل '
                                'لك رمز تحقق مكوّناً من 6 أرقام لتتمكن من '
                                'تعيين كلمة مرور جديدة.',
                                style: TextStyle(
                                    color: scheme.onPrimaryContainer),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _idCtrl,
                      validator: FormValidators.identifier,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'البريد أو الرقم الأكاديمي',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                    ),
                    const SizedBox(height: 20),
                    LoadingButton(
                      controller: widget.controller,
                      label: 'إرسال رمز التحقق',
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('العودة لتسجيل الدخول'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
