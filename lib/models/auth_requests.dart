/// نماذج الطلبات المرسلة من الـ Controller إلى الـ Repository.

class LoginRequest {
  final String identifier; // بريد أو رقم أكاديمي
  final String password;
  final bool rememberMe;

  const LoginRequest({
    required this.identifier,
    required this.password,
    required this.rememberMe,
  });
}

class RegisterRequest {
  final String fullName;
  final String academicId;
  final String email;
  final String password;

  const RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
  });
}

class ResetPasswordRequest {
  final String identifier;
  final String code;
  final String newPassword;

  const ResetPasswordRequest({
    required this.identifier,
    required this.code,
    required this.newPassword,
  });
}
