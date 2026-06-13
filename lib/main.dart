import 'package:exchange_customer/core/constants/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:exchange_customer/core/di/dependency_injection.dart';
import 'package:exchange_customer/l10n/app_localizations.dart';
import 'package:exchange_customer/routes.dart';
import 'package:exchange_customer/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSession.init();
  await initDI();
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
