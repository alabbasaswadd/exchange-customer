import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signin;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome_back;

  /// No description provided for @signin_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your account'**
  String get signin_subtitle;

  /// No description provided for @username_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get username_required;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get password_required;

  /// No description provided for @password_min_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_min_length;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_account;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @speed_test.
  ///
  /// In en, this message translates to:
  /// **'Speed Test'**
  String get speed_test;

  /// No description provided for @start_test.
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get start_test;

  /// No description provided for @stop_test.
  ///
  /// In en, this message translates to:
  /// **'Stop Test'**
  String get stop_test;

  /// No description provided for @download_speed.
  ///
  /// In en, this message translates to:
  /// **'Download Speed'**
  String get download_speed;

  /// No description provided for @upload_speed.
  ///
  /// In en, this message translates to:
  /// **'Upload Speed'**
  String get upload_speed;

  /// No description provided for @ping.
  ///
  /// In en, this message translates to:
  /// **'Ping'**
  String get ping;

  /// No description provided for @testing_download.
  ///
  /// In en, this message translates to:
  /// **'Testing Download...'**
  String get testing_download;

  /// No description provided for @testing_upload.
  ///
  /// In en, this message translates to:
  /// **'Testing Upload...'**
  String get testing_upload;

  /// No description provided for @test_completed.
  ///
  /// In en, this message translates to:
  /// **'Test Completed'**
  String get test_completed;

  /// No description provided for @mbps.
  ///
  /// In en, this message translates to:
  /// **'Mbps'**
  String get mbps;

  /// No description provided for @ms.
  ///
  /// In en, this message translates to:
  /// **'ms'**
  String get ms;

  /// No description provided for @idle.
  ///
  /// In en, this message translates to:
  /// **'Tap Start to begin'**
  String get idle;

  /// No description provided for @test_again.
  ///
  /// In en, this message translates to:
  /// **'Test Again'**
  String get test_again;

  /// No description provided for @connected_devices.
  ///
  /// In en, this message translates to:
  /// **'Connected Devices'**
  String get connected_devices;

  /// No description provided for @scan_network.
  ///
  /// In en, this message translates to:
  /// **'Scan Network'**
  String get scan_network;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @stop_scan.
  ///
  /// In en, this message translates to:
  /// **'Stop Scan'**
  String get stop_scan;

  /// No description provided for @no_devices_found.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get no_devices_found;

  /// No description provided for @devices_found.
  ///
  /// In en, this message translates to:
  /// **'{count} device(s) found'**
  String devices_found(int count);

  /// No description provided for @device_details.
  ///
  /// In en, this message translates to:
  /// **'Device Details'**
  String get device_details;

  /// No description provided for @ip_address.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ip_address;

  /// No description provided for @mac_address.
  ///
  /// In en, this message translates to:
  /// **'MAC Address'**
  String get mac_address;

  /// No description provided for @hostname.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get hostname;

  /// No description provided for @vendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get vendor;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @this_device.
  ///
  /// In en, this message translates to:
  /// **'This Device'**
  String get this_device;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filter_all;

  /// No description provided for @filter_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filter_active;

  /// No description provided for @search_devices.
  ///
  /// In en, this message translates to:
  /// **'Search devices...'**
  String get search_devices;

  /// No description provided for @scan_progress.
  ///
  /// In en, this message translates to:
  /// **'Scanning: {progress}%'**
  String scan_progress(int progress);

  /// No description provided for @network_error.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get network_error;

  /// No description provided for @scan_complete.
  ///
  /// In en, this message translates to:
  /// **'Scan complete'**
  String get scan_complete;

  // Home Feature Strings

  /// No description provided for @home.
  String get home;

  /// No description provided for @features.
  String get features;

  /// No description provided for @settings.
  String get settings;

  /// No description provided for @hello_user.
  String get hello_user;

  /// No description provided for @home_subtitle.
  String get home_subtitle;

  /// No description provided for @current_balance.
  String get current_balance;

  /// No description provided for @recharge.
  String get recharge;

  /// No description provided for @subscription.
  String get subscription;

  /// No description provided for @subscription_active.
  String get subscription_active;

  /// No description provided for @subscription_expired.
  String get subscription_expired;

  /// No description provided for @subscription_expired_message.
  String get subscription_expired_message;

  /// No description provided for @time_remaining.
  String get time_remaining;

  /// No description provided for @days.
  String get days;

  /// No description provided for @hours.
  String get hours;

  /// No description provided for @minutes.
  String get minutes;

  /// No description provided for @seconds.
  String get seconds;

  /// No description provided for @renew_subscription.
  String get renew_subscription;

  /// No description provided for @error_occurred.
  String get error_occurred;

  /// No description provided for @retry.
  String get retry;

  /// No description provided for @features_subtitle.
  String get features_subtitle;

  /// No description provided for @invoices.
  String get invoices;

  /// No description provided for @support.
  String get support;

  /// No description provided for @settings_subtitle.
  String get settings_subtitle;

  /// No description provided for @account_settings.
  String get account_settings;

  /// No description provided for @profile.
  String get profile;

  /// No description provided for @change_password.
  String get change_password;

  /// No description provided for @notifications.
  String get notifications;

  /// No description provided for @app_settings.
  String get app_settings;

  /// No description provided for @language.
  String get language;

  /// No description provided for @arabic.
  String get arabic;

  /// No description provided for @english.
  String get english;

  /// No description provided for @dark_mode.
  String get dark_mode;

  /// No description provided for @other.
  String get other;

  /// No description provided for @about.
  String get about;

  /// No description provided for @help.
  String get help;

  /// No description provided for @logout.
  String get logout;

  /// No description provided for @logout_confirmation.
  String get logout_confirmation;

  // Subscriptions
  String get subscriptions;
  String get subscriptions_subtitle;
  String get current_plan;
  String get popular;
  String get month;
  String get select_plan;
  String get current;
  String get plan_features;
  String get plan_selected;
  String get subscribe_now;

  // Support
  String get support_subtitle;
  String get contact_support;
  String get available_24_7;
  String get call_us;
  String get whatsapp;
  String get submit_complaint;
  String get full_name;
  String get phone_number;
  String get subject;
  String get message;
  String get submit;
  String get name_required;
  String get phone_required;
  String get phone_invalid;
  String get subject_required;
  String get message_required;
  String get message_too_short;
  String get complaint_submitted;

  // Quick Actions
  String get quick_actions;
  String get usage_history;

  // Payment
  String get enter_amount;
  String get payment_method;
  String get pay_now;
  String get secure_payment;
  String get payment_secure_note;
  String get payment_successful;
  String get balance_recharged;
  String get done;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
