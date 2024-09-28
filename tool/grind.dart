import 'dart:io';

import 'package:grinder/grinder.dart';

main(args) => grind(args);

/// Runs the `arb_translate` command to generate the `.arb` files.
///
/// Use this command after you make `.env` file, copying `.env.example`.
@DefaultTask()
translate() {
  final envFileLines = File('.env').readAsLinesSync();
  final apiKey = envFileLines
      .firstWhere((e) => e.startsWith('ARB_TRANSLATE_API_KEY='))
      .split('=')[1];

  final result = Process.runSync(
    'arb_translate',
    ['--api-key', apiKey],
  );

  stdout.writeln(result.stdout);
}
