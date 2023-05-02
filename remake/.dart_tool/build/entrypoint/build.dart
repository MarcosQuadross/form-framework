// ignore_for_file: directives_ordering
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:reflectable/reflectable_builder.dart' as _i2;
import 'package:build_config/build_config.dart' as _i3;
import 'dart:isolate' as _i4;
import 'package:build_runner/build_runner.dart' as _i5;
import 'dart:io' as _i6;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(
    r'reflectable:reflectable',
    [_i2.reflectableBuilder],
    _i1.toRoot(),
    hideOutput: false,
    defaultGenerateFor: const _i3.InputSet(include: [
      r'benchmark/**.dart',
      r'bin/**.dart',
      r'example/**.dart',
      r'lib/main.dart',
      r'test/**.dart',
      r'tool/**.dart',
      r'web/**.dart',
    ]),
  )
];
void main(
  List<String> args, [
  _i4.SendPort? sendPort,
]) async {
  var result = await _i5.run(
    args,
    _builders,
  );
  sendPort?.send(result);
  _i6.exitCode = result;
}
