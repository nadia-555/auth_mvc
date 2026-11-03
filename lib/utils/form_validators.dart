/// دوال تحقق نقية (Pure Functions): ترجع نص الخطأ أو null عند الصحة.
class FormValidators {
  FormValidators._();

  static final RegExp _emailRegex =
      RegExp(r'^[\w.+\-]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,}$');
  static final RegExp _digitsOnly = RegExp(r'^\d+$');
  static final RegExp _hasDigit = RegExp(r'\d');
  static final RegExp _hasUpper = RegExp(r'[A-Z]');

  static String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;

  /// المعرف الأكاديمي أو البريد (تسجيل الدخول / الاستعادة).
  static String? identifier(String? v) {
    final r = _required(v);
    if (r != null) return r;
    final value = v!.trim();
    if (value.length < 5) return 'يجب ألا يقل عن 5 خانات';
    if (value.contains('@') && !_emailRegex.hasMatch(value)) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }

  /// كلمة مرور تسجيل الدخول (≥ 6).
  static String? loginPassword(String? v) {
    if (v == null || v.isEmpty) return 'كلمة المرور مطلوبة';
    if (v.length < 6) return 'يجب ألا تقل عن 6 محارف';
    return null;
  }

  static String? fullName(String? v) {
    final r = _required(v);
    if (r != null) return r;
    if (v!.trim().length < 3) return 'الاسم يجب ألا يقل عن 3 محارف';
    return null;
  }

  static String? academicId(String? v) {
    final r = _required(v);
    if (r != null) return r;
    final value = v!.trim();
    if (!_digitsOnly.hasMatch(value)) return 'يجب أن يحتوي أرقاماً فقط';
    if (value.length < 9 || value.length > 10) {
      return 'الرقم الأكاديمي من 9 إلى 10 أرقام';
    }
    return null;
  }

  static String? email(String? v) {
    final r = _required(v);
    if (r != null) return r;
    if (!_emailRegex.hasMatch(v!.trim())) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }

  /// سياسة قوية: ≥ 8 محارف + رقم + حرف كبير.
  static String? strongPassword(String? v) {
    if (v == null || v.isEmpty) return 'كلمة المرور مطلوبة';
    if (v.length < 8) return 'يجب ألا تقل عن 8 محارف';
    if (!_hasDigit.hasMatch(v)) return 'يجب أن تحتوي رقماً واحداً على الأقل';
    if (!_hasUpper.hasMatch(v)) {
      return 'يجب أن تحتوي حرفاً كبيراً (A-Z) واحداً على الأقل';
    }
    return null;
  }

  static String? confirmPassword(String? v, String original) {
    if (v == null || v.isEmpty) return 'تأكيد كلمة المرور مطلوب';
    if (v != original) return 'كلمتا المرور غير متطابقتين';
    return null;
  }

  /// رمز OTP: 6 أرقام حصراً.
  static String? otp(String? v) {
    final r = _required(v);
    if (r != null) return r;
    final value = v!.trim();
    if (!_digitsOnly.hasMatch(value)) return 'الرمز أرقام فقط';
    if (value.length != 6) return 'الرمز يتكون من 6 أرقام';
    return null;
  }
}
