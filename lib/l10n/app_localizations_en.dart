// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgot_password => 'Forgot Password?';

  @override
  String get signin => 'Sign In';

  @override
  String get username => 'Username';

  @override
  String get welcome_back => 'Welcome Back';

  @override
  String get signin_subtitle => 'Sign in to continue to your account';

  @override
  String get username_required => 'Please enter your username';

  @override
  String get password_required => 'Please enter your password';

  @override
  String get password_min_length => 'Password must be at least 6 characters';

  @override
  String get dont_have_account => 'Don\'t have an account?';

  @override
  String get signup => 'Sign Up';

  @override
  String get speed_test => 'Speed Test';

  @override
  String get start_test => 'Start Test';

  @override
  String get stop_test => 'Stop Test';

  @override
  String get download_speed => 'Download Speed';

  @override
  String get upload_speed => 'Upload Speed';

  @override
  String get ping => 'Ping';

  @override
  String get testing_download => 'Testing Download...';

  @override
  String get testing_upload => 'Testing Upload...';

  @override
  String get test_completed => 'Test Completed';

  @override
  String get mbps => 'Mbps';

  @override
  String get ms => 'ms';

  @override
  String get idle => 'Tap Start to begin';

  @override
  String get test_again => 'Test Again';

  @override
  String get connected_devices => 'Connected Devices';

  @override
  String get scan_network => 'Scan Network';

  @override
  String get scanning => 'Scanning...';

  @override
  String get stop_scan => 'Stop Scan';

  @override
  String get no_devices_found => 'No devices found';

  @override
  String devices_found(int count) {
    return '$count device(s) found';
  }

  @override
  String get device_details => 'Device Details';

  @override
  String get ip_address => 'IP Address';

  @override
  String get mac_address => 'MAC Address';

  @override
  String get hostname => 'Hostname';

  @override
  String get vendor => 'Vendor';

  @override
  String get unknown => 'Unknown';

  @override
  String get this_device => 'This Device';

  @override
  String get active => 'Active';

  @override
  String get filter_all => 'All';

  @override
  String get filter_active => 'Active';

  @override
  String get search_devices => 'Search devices...';

  @override
  String scan_progress(int progress) {
    return 'Scanning: $progress%';
  }

  @override
  String get network_error => 'Network error. Please check your connection.';

  @override
  String get scan_complete => 'Scan complete';

  // Home Feature Strings

  @override
  String get home => 'Home';

  @override
  String get features => 'Features';

  @override
  String get settings => 'Settings';

  @override
  String get hello_user => 'Hello';

  @override
  String get home_subtitle => 'Welcome to your app';

  @override
  String get current_balance => 'Current Balance';

  @override
  String get recharge => 'Recharge';

  @override
  String get subscription => 'Subscription';

  @override
  String get subscription_active => 'Active';

  @override
  String get subscription_expired => 'Expired';

  @override
  String get subscription_expired_message => 'Your subscription has expired, please renew';

  @override
  String get time_remaining => 'Time Remaining';

  @override
  String get days => 'Days';

  @override
  String get hours => 'Hours';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'Seconds';

  @override
  String get renew_subscription => 'Renew Subscription';

  @override
  String get error_occurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get features_subtitle => 'Explore our available services';

  @override
  String get invoices => 'Invoices';

  @override
  String get support => 'Support';

  @override
  String get settings_subtitle => 'Customize your app settings';

  @override
  String get account_settings => 'Account Settings';

  @override
  String get profile => 'Profile';

  @override
  String get change_password => 'Change Password';

  @override
  String get notifications => 'Notifications';

  @override
  String get app_settings => 'App Settings';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get other => 'Other';

  @override
  String get about => 'About';

  @override
  String get help => 'Help';

  @override
  String get logout => 'Logout';

  @override
  String get logout_confirmation => 'Are you sure you want to logout?';

  // Subscriptions
  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get subscriptions_subtitle => 'Choose the plan that suits you';

  @override
  String get current_plan => 'Current Plan';

  @override
  String get popular => 'Popular';

  @override
  String get month => 'month';

  @override
  String get select_plan => 'Select';

  @override
  String get current => 'Current';

  @override
  String get plan_features => 'Plan Features';

  @override
  String get plan_selected => 'Plan selected successfully';

  @override
  String get subscribe_now => 'Subscribe Now';

  // Support
  @override
  String get support_subtitle => 'We are here to help you';

  @override
  String get contact_support => 'Contact Support';

  @override
  String get available_24_7 => 'Available 24/7';

  @override
  String get call_us => 'Call Us';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get submit_complaint => 'Submit Complaint';

  @override
  String get full_name => 'Full Name';

  @override
  String get phone_number => 'Phone Number';

  @override
  String get subject => 'Subject';

  @override
  String get message => 'Message';

  @override
  String get submit => 'Submit';

  @override
  String get name_required => 'Please enter your name';

  @override
  String get phone_required => 'Please enter your phone number';

  @override
  String get phone_invalid => 'Invalid phone number';

  @override
  String get subject_required => 'Please enter the subject';

  @override
  String get message_required => 'Please enter your message';

  @override
  String get message_too_short => 'Message is too short';

  @override
  String get complaint_submitted => 'Complaint submitted successfully';

  // Quick Actions
  @override
  String get quick_actions => 'Quick Actions';

  @override
  String get usage_history => 'Usage History';

  // Payment
  @override
  String get enter_amount => 'Enter Amount';

  @override
  String get payment_method => 'Payment Method';

  @override
  String get pay_now => 'Pay Now';

  @override
  String get secure_payment => 'Secure Payment';

  @override
  String get payment_secure_note => 'Your payment information is encrypted and secure';

  @override
  String get payment_successful => 'Payment Successful!';

  @override
  String get balance_recharged => 'Your balance has been recharged';

  @override
  String get done => 'Done';
}
