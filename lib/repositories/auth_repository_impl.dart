import '../models/auth_requests.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class _Account {
  _Account(this.user, this.password);
  final UserModel user;
  String password;
}

/// تنفيذ محاكٍ للشبكة: بيانات في الذاكرة + تأخير زمني.
class AuthRepositoryImpl implements AuthRepository {
  static const _networkDelay = Duration(milliseconds: 900);
  static const String demoResetCode = '123456';

  final List<_Account> _accounts = [
    _Account(
      const UserModel(
        id: '1',
        fullName: 'طالب تجريبي',
        academicId: '202312345',
        email: 'student@univ.edu',
      ),
      'Student123',
    ),
  ];

  // الحساب الذي طُلب له رمز استعادة حالياً.
  _Account? _pendingResetAccount;

  _Account? _find(String identifier) {
    final value = identifier.trim().toLowerCase();
    for (final a in _accounts) {
      if (a.user.email.toLowerCase() == value || a.user.academicId == value) {
        return a;
      }
    }
    return null;
  }

  @override
  Future<UserModel> login(LoginRequest request) async {
    await Future.delayed(_networkDelay);
    final account = _find(request.identifier);
    if (account == null || account.password != request.password) {
      throw const AuthException('بيانات الدخول غير صحيحة');
    }
    return account.user;
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    await Future.delayed(_networkDelay);
    if (_find(request.email) != null || _find(request.academicId) != null) {
      throw const AuthException('يوجد حساب مسجل بنفس البريد أو الرقم الأكاديمي');
    }
    final user = UserModel(
      id: (_accounts.length + 1).toString(),
      fullName: request.fullName.trim(),
      academicId: request.academicId.trim(),
      email: request.email.trim(),
    );
    _accounts.add(_Account(user, request.password));
    return user;
  }

  @override
  Future<void> sendPasswordResetCode(String identifier) async {
    await Future.delayed(_networkDelay);
    final account = _find(identifier);
    if (account == null) {
      throw const AuthException('لا يوجد حساب مرتبط بهذا المعرف');
    }
    _pendingResetAccount = account; // الرمز التجريبي: 123456
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await Future.delayed(_networkDelay);
    final account = _pendingResetAccount;
    if (account == null || _find(request.identifier) != account) {
      throw const AuthException('لم يتم طلب رمز تحقق لهذا الحساب');
    }
    if (request.code != demoResetCode) {
      throw const AuthException('رمز التحقق غير صحيح');
    }
    account.password = request.newPassword;
    _pendingResetAccount = null;
  }
}
