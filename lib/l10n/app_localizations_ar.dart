// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get hello => 'مرحبا';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgot_password => 'نسيت كلمة المرور؟';

  @override
  String get signin => 'تسجيل الدخول';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get welcome_back => 'مرحباً بعودتك';

  @override
  String get signin_subtitle => 'سجل دخولك للمتابعة إلى حسابك';

  @override
  String get username_required => 'الرجاء إدخال اسم المستخدم';

  @override
  String get password_required => 'الرجاء إدخال كلمة المرور';

  @override
  String get password_min_length => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get dont_have_account => 'ليس لديك حساب؟';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get speed_test => 'اختبار السرعة';

  @override
  String get start_test => 'بدء الاختبار';

  @override
  String get stop_test => 'إيقاف الاختبار';

  @override
  String get download_speed => 'سرعة التحميل';

  @override
  String get upload_speed => 'سرعة الرفع';

  @override
  String get ping => 'زمن الاستجابة';

  @override
  String get testing_download => 'جاري اختبار التحميل...';

  @override
  String get testing_upload => 'جاري اختبار الرفع...';

  @override
  String get test_completed => 'اكتمل الاختبار';

  @override
  String get mbps => 'ميجابت/ث';

  @override
  String get ms => 'مللي ثانية';

  @override
  String get idle => 'اضغط بدء للاختبار';

  @override
  String get test_again => 'اختبار مرة أخرى';

  @override
  String get connected_devices => 'الأجهزة المتصلة';

  @override
  String get scan_network => 'فحص الشبكة';

  @override
  String get scanning => 'جاري الفحص...';

  @override
  String get stop_scan => 'إيقاف الفحص';

  @override
  String get no_devices_found => 'لم يتم العثور على أجهزة';

  @override
  String devices_found(int count) {
    return 'تم العثور على $count جهاز';
  }

  @override
  String get device_details => 'تفاصيل الجهاز';

  @override
  String get ip_address => 'عنوان IP';

  @override
  String get mac_address => 'عنوان MAC';

  @override
  String get hostname => 'اسم المضيف';

  @override
  String get vendor => 'المصنع';

  @override
  String get unknown => 'غير معروف';

  @override
  String get this_device => 'هذا الجهاز';

  @override
  String get active => 'نشط';

  @override
  String get filter_all => 'الكل';

  @override
  String get filter_active => 'نشط';

  @override
  String get search_devices => 'البحث عن الأجهزة...';

  @override
  String scan_progress(int progress) {
    return 'جاري الفحص: $progress%';
  }

  @override
  String get network_error => 'خطأ في الشبكة. يرجى التحقق من الاتصال.';

  @override
  String get scan_complete => 'اكتمل الفحص';

  // Home Feature Strings

  @override
  String get home => 'الرئيسية';

  @override
  String get features => 'الخدمات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get hello_user => 'مرحباً';

  @override
  String get home_subtitle => 'مرحباً بك في تطبيقك';

  @override
  String get current_balance => 'الرصيد الحالي';

  @override
  String get recharge => 'شحن';

  @override
  String get subscription => 'الاشتراك';

  @override
  String get subscription_active => 'نشط';

  @override
  String get subscription_expired => 'منتهي';

  @override
  String get subscription_expired_message => 'انتهى اشتراكك، يرجى التجديد';

  @override
  String get time_remaining => 'الوقت المتبقي';

  @override
  String get days => 'يوم';

  @override
  String get hours => 'ساعة';

  @override
  String get minutes => 'دقيقة';

  @override
  String get seconds => 'ثانية';

  @override
  String get renew_subscription => 'تجديد الاشتراك';

  @override
  String get error_occurred => 'حدث خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get features_subtitle => 'استكشف خدماتنا المتاحة';

  @override
  String get invoices => 'الفواتير';

  @override
  String get support => 'الدعم الفني';

  @override
  String get settings_subtitle => 'تخصيص إعدادات التطبيق';

  @override
  String get account_settings => 'إعدادات الحساب';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get change_password => 'تغيير كلمة المرور';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get app_settings => 'إعدادات التطبيق';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get dark_mode => 'الوضع الداكن';

  @override
  String get other => 'أخرى';

  @override
  String get about => 'حول التطبيق';

  @override
  String get help => 'المساعدة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logout_confirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  // Subscriptions
  @override
  String get subscriptions => 'الباقات';

  @override
  String get subscriptions_subtitle => 'اختر الباقة المناسبة لك';

  @override
  String get current_plan => 'باقتك الحالية';

  @override
  String get popular => 'الأكثر شعبية';

  @override
  String get month => 'شهر';

  @override
  String get select_plan => 'اختيار';

  @override
  String get current => 'الحالية';

  @override
  String get plan_features => 'مميزات الباقة';

  @override
  String get plan_selected => 'تم اختيار الباقة بنجاح';

  @override
  String get subscribe_now => 'اشترك الآن';

  // Support
  @override
  String get support_subtitle => 'نحن هنا لمساعدتك';

  @override
  String get contact_support => 'تواصل معنا';

  @override
  String get available_24_7 => 'متاحون على مدار الساعة';

  @override
  String get call_us => 'اتصل بنا';

  @override
  String get whatsapp => 'واتساب';

  @override
  String get submit_complaint => 'أرسل شكوى';

  @override
  String get full_name => 'الاسم الكامل';

  @override
  String get phone_number => 'رقم الهاتف';

  @override
  String get subject => 'الموضوع';

  @override
  String get message => 'الرسالة';

  @override
  String get submit => 'إرسال';

  @override
  String get name_required => 'الرجاء إدخال الاسم';

  @override
  String get phone_required => 'الرجاء إدخال رقم الهاتف';

  @override
  String get phone_invalid => 'رقم الهاتف غير صحيح';

  @override
  String get subject_required => 'الرجاء إدخال الموضوع';

  @override
  String get message_required => 'الرجاء إدخال الرسالة';

  @override
  String get message_too_short => 'الرسالة قصيرة جداً';

  @override
  String get complaint_submitted => 'تم إرسال الشكوى بنجاح';

  // Quick Actions
  @override
  String get quick_actions => 'إجراءات سريعة';

  @override
  String get usage_history => 'سجل الاستخدام';

  // Payment
  @override
  String get enter_amount => 'أدخل المبلغ';

  @override
  String get payment_method => 'طريقة الدفع';

  @override
  String get pay_now => 'ادفع الآن';

  @override
  String get secure_payment => 'دفع آمن';

  @override
  String get payment_secure_note => 'معلومات الدفع الخاصة بك مشفرة وآمنة';

  @override
  String get payment_successful => 'تم الدفع بنجاح!';

  @override
  String get balance_recharged => 'تم شحن رصيدك';

  @override
  String get done => 'تم';
}
