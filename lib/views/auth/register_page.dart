import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../models/auth_requests.dart';
import '../../utils/form_validators.dart';
import 'auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.controller});
  final AuthController controller;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _academicCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _academicCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await widget.controller.register(RegisterRequest(
      fullName: _nameCtrl.text,
      academicId: _academicCtrl.text,
      email: _emailCtrl.text,
      password: _passCtrl.text,
    ));
    if (!mounted) return;
    if (ok) {
      showAppSnack(context, 'تم إنشاء الحساب بنجاح، سجّل الدخول الآن',
          success: true);
      Navigator.pop(context); // العودة لشاشة الدخول
    } else {
      showAppSnack(context, widget.controller.errorMessage ?? 'فشل إنشاء الحساب');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
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
                    TextFormField(
                      controller: _nameCtrl,
                      validator: FormValidators.fullName,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'الاسم الكامل',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _academicCtrl,
                      validator: FormValidators.academicId,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'الرقم الأكاديمي',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailCtrl,
                      validator: FormValidators.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'البريد الجامعي',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    PasswordField(
                      controller: _passCtrl,
                      label: 'كلمة المرور',
                      validator: FormValidators.strongPassword,
                    ),
                    const SizedBox(height: 14),
                    PasswordField(
                      controller: _confirmCtrl,
                      label: 'تأكيد كلمة المرور',
                      validator: (v) =>
                          FormValidators.confirmPassword(v, _passCtrl.text),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 8),
                    // صندوق الموافقة داخل الـ Form ليُفحص مع بقية الحقول.
                    FormField<bool>(
                      initialValue: false,
                      validator: (v) => (v == true)
                          ? null
                          : 'يجب الموافقة على اللوائح والشروط الأكاديمية',
                      builder: (state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            value: state.value,
                            onChanged: state.didChange,
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text(
                                'أوافق على اللوائح والشروط الأكاديمية'),
                          ),
                          if (state.hasError)
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 12),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    LoadingButton(
                      controller: widget.controller,
                      label: 'إنشاء الحساب',
                      onPressed: _submit,
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
