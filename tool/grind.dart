import 'dart:io';

import 'package:grinder/grinder.dart';

main(args) => grind(args);

/// Installs the `arb_translate` package globally.
@Task()
setup() {
  _runProcess(
    'dart',
    ['pub', 'global', 'activate', 'arb_translate'],
  );
}

/// Runs the `arb_translate` command to generate the `.arb` files.
///
/// You can run this command with `grind`.
///
/// Use this command after:
/// - installing the package with [setup]
/// - copying `.env.example` and creating `.env` file for the API key
@DefaultTask()
translate() {
  try {
    final envEntries = File('.env').readAsLinesSync();
    final apiKey = envEntries
        .firstWhere((e) => e.startsWith('ARB_TRANSLATE_API_KEY='))
        .split('=')[1];
    _runProcess(
      'arb_translate',
      ['--api-key', apiKey],
    );
  } catch (_) {
    stderr.writeln('Please create `.env` file with the API key.');
    exit(1);
  }
}

void _runProcess(String executable, List<String> arguments) {
  final result = Process.runSync(
    executable,
    arguments,
  );

  stdout.writeln(result.stdout);
  stderr.writeln(result.stderr);
}
