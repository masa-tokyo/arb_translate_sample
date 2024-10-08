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
        // app_ja.art is set in l10n.yaml for automatic translation, but en is used for the fallback
        const fallbackLocale = Locale('en');
        if (locales == null || locales.isEmpty) {
          return fallbackLocale;
        }
        // search for a matched locale based on the user's settings; if none is found, set the fallback.
        final matchedLocale = locales.firstWhere(
          (locale) => supportedLocales.any(
            (supportedLocale) =>
                supportedLocale.languageCode == locale.languageCode,
          ),
          orElse: () => fallbackLocale,
        );
        Intl.defaultLocale = matchedLocale.toString();
        return matchedLocale;
      },
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
