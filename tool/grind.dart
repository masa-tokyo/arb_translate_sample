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

/// Context to improve translation quality.
const _translateContext = '''
Japanese words should be translated into English directly.
For example, おにぎり should be Onigiri.
''';

/// Runs the `arb_translate` command to generate the `.arb` files.
///
/// You can run this command with `grind`.
///
/// Use this command after:
/// - installing the package with [setup]
/// - copying `.config.example` and creating `.config` file for the API key
///
/// To improve the quality of translation, update [_translateContext].
@DefaultTask()
translate() {
  try {
    final envEntries = File('.config').readAsLinesSync();
    final apiKey = envEntries
        .firstWhere((e) => e.startsWith('ARB_TRANSLATE_API_KEY='))
        .split('=')[1];

    // choose the highest model, which is expected to be within the free tier
    const model = 'gemini-1.5-pro';

    _runProcess(
      'arb_translate',
      [
        '--api-key',
        apiKey,
        '--context',
        _translateContext,
        '--model',
        model,
      ],
    );
  } on PathNotFoundException catch (_) {
    stderr.writeln(
        'PathNotFoundException: `.config` file is not found. Please create it by copying `.config.example`.');
    exit(1);
  } on StateError catch (_) {
    stderr.writeln(
        'StateError: `.config` file does not contain `ARB_TRANSLATE_API_KEY`.');
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
