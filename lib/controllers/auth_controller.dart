import 'package:flutter/foundation.dart';

import '../models/auth_requests.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

/// الـ Controller: يدير الحالة (تحميل/خطأ/مستخدم) ويتحدث مع الـ Repository.
class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;
  String? _resetIdentifier;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  String? get resetIdentifier => _resetIdentifier;

  /// تنفّذ أي عملية مع إدارة التحميل والأخطاء، وترجع true عند النجاح.
  Future<bool> _run(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'حدث خطأ غير متوقع، حاول مرة أخرى';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(LoginRequest request) =>
      _run(() async => _currentUser = await _repository.login(request));

  Future<bool> register(RegisterRequest request) =>
      _run(() async => await _repository.register(request));

  Future<bool> sendPasswordResetCode(String identifier) => _run(() async {
        await _repository.sendPasswordResetCode(identifier);
        _resetIdentifier = identifier.trim();
      });

  Future<bool> resetPassword({
    required String code,
    required String newPassword,
  }) =>
      _run(() async {
        await _repository.resetPassword(ResetPasswordRequest(
          identifier: _resetIdentifier ?? '',
          code: code,
          newPassword: newPassword,
        ));
        _resetIdentifier = null;
      });
}
