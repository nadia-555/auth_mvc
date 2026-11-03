# نظام المصادقة الطلابي (MVC + Repository)

لا توجد أي حزم خارجية. (يتطلب Flutter 3.10 أو أحدث بسبب ListenableBuilder)

## بيانات تجريبية
- الدخول: student@univ.edu أو 202312345 / كلمة المرور: Student123
- رمز استعادة كلمة المرور (OTP): 123456

## الهيكل
- models: UserModel وLoginRequest وRegisterRequest وResetPasswordRequest
- repositories: AuthRepository (عقد) وAuthRepositoryImpl (محاكاة شبكة)
- controllers: AuthController extends ChangeNotifier
- utils: FormValidators (دوال نقية)
- views/auth: الشاشات الأربع + auth_widgets.dart (ويدجتس مشتركة)
