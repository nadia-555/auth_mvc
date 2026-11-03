import '../models/auth_requests.dart';
import '../models/user_model.dart';

/// استثناء موحّد لأخطاء المصادقة، تعرضه الواجهة كرسالة للمستخدم.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// العقد التجريدي (Repository Pattern): الـ Controller يعتمد عليه
/// ولا يعرف شيئاً عن طريقة التنفيذ.
abstract class AuthRepository {
  Future<UserModel> login(LoginRequest request);
  Future<UserModel> register(RegisterRequest request);
  Future<void> sendPasswordResetCode(String identifier);
  Future<void> resetPassword(ResetPasswordRequest request);
}
