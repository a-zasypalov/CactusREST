import 'package:dart_rest/dart_rest.dart';
import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:dart_rest/dart_rest.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';

class Harness extends TestHarness<DartRestChannel> with TestHarnessORMMixin {
  @override
  ManagedContext get context => channel.context;

  @override
  Future onSetUp() async {
    await resetData();
  }

  @override
  Future onTearDown() async {}
}
