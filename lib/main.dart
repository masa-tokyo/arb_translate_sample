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
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      localeListResolutionCallback: (locales, supportedLocales) {
        final locale = basicLocaleListResolution(locales, supportedLocales);
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
