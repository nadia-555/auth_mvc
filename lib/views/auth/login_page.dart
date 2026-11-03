import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.controller});
  final AuthController controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await widget.controller.login(LoginRequest(
      identifier: _idCtrl.text.trim(),
      password: _passCtrl.text,
      rememberMe: _rememberMe,
    ));
    if (!mounted) return;
    if (ok) {
      showAppSnack(
        context,
        'مرحباً ${widget.controller.currentUser?.fullName ?? ''}',
        success: true,
      );
    } else {
      showAppSnack(context, widget.controller.errorMessage ?? 'فشل تسجيل الدخول');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.school,
                        size: 72, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 12),
                    Text('تسجيل الدخول',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _idCtrl,
                      validator: FormValidators.identifier,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'المعرف الأكاديمي أو البريد',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    PasswordField(
                      controller: _passCtrl,
                      label: 'كلمة المرور',
                      validator: FormValidators.loginPassword,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (v) =>
                              setState(() => _rememberMe = v ?? false),
                        ),
                        const Text('تذكرني'),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ForgotPasswordPage(
                                  controller: widget.controller),
                            ),
                          ),
                          child: const Text('نسيت كلمة المرور؟'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LoadingButton(
                      controller: widget.controller,
                      label: 'تسجيل الدخول',
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('ليس لديك حساب؟'),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RegisterPage(controller: widget.controller),
                            ),
                          ),
                          child: const Text('إنشاء حساب جديد'),
                        ),
                      ],
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
