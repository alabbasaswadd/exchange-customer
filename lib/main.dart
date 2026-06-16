import 'package:exchange_customer/core/constants/functions.dart';
import 'package:exchange_customer/core/services/notification_service.dart';
import 'package:exchange_customer/core/signalr/signalr_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:exchange_customer/core/di/dependency_injection.dart';
import 'package:exchange_customer/l10n/app_localizations.dart';
import 'package:exchange_customer/routes.dart';
import 'package:exchange_customer/theme.dart';
import 'package:exchange_customer/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initFCM();
  await UserSession.init();
  await initDI();
  await NotificationService.init();
  if (UserSession.isLoggedIn &&
      UserSession.token != null &&
      UserSession.role != null) {
    final signalRService = SignalRService();
    await signalRService.connect(
      UserSession.token!,
      UserSession.role!.toString(),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
      locale: const Locale("ar"),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
