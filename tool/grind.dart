import 'dart:io';

import 'package:grinder/grinder.dart';

main(args) => grind(args);

/// Installs the `arb_translate` package globally.
@Task()
setup() {
  run(
    'dart',
    arguments: ['pub', 'global', 'activate', 'arb_translate'],
  );
}

/// Runs the `arb_translate` command to generate the `.arb` files.
///
/// You can run this command with `grind`.
///
/// Use this command after:
/// - installing the package with [setup]
/// - copying `.secret.example` and creating `.secret` file for the API key
///
/// To improve the quality of translation, update [_translateContext].
@DefaultTask()
translate() {
  try {
    final envEntries = File('.secret').readAsLinesSync();
    final apiKey = envEntries
        .firstWhere((e) => e.startsWith('ARB_TRANSLATE_API_KEY='))
        .split('=')[1];

    // context to improve translation quality
    const context = '''
Japanese words should be translated into English directly.
For example, おにぎり should be Onigiri.
''';

    // choose the highest model, which is expected to be within the free tier
    const model = 'gemini-1.5-pro';

    run('arb_translate', arguments: [
      '--api-key',
      apiKey,
      '--context',
      context,
      '--model',
      model,
    ]);
  } on PathNotFoundException catch (_) {
    exitCode = 1;
    stderr.writeln(
        'PathNotFoundException: `.secret` file is not found. Please create it by copying `.secret.example`.');
  } on StateError catch (_) {
    exitCode = 1;
    stderr.writeln(
        'StateError: `.secret` file does not contain `ARB_TRANSLATE_API_KEY`.');
  }
}
