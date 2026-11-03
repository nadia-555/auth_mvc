# نظام المصادقة الطلابي (MVC + Repository)

## التشغيل
1. flutter create auth_mvc
2. احذف lib/ الافتراضي وانسخ مجلد lib/ من هذا المشروع مكانه
3. flutter run

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
