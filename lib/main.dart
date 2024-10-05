import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/l10n.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => L10n.of(context).exampleTitle,
      // title: 'Example Title',
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      localeListResolutionCallback: (locales, supportedLocales) {
        // fallback locale to en whereas the l10n.yaml is set to ja for automation translation
        const fallbackLocale = Locale('en');
        if (locales == null || locales.isEmpty) {
          return fallbackLocale;
        }
        final currentLocale = locales.first;
        final locale = supportedLocales.firstWhere(
          (e) => e.languageCode == currentLocale.languageCode,
          orElse: () => fallbackLocale,
        );
        Intl.defaultLocale = locale.toString();
        return locale;
      },
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
