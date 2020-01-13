import 'package:aqueduct/managed_auth.dart';
import 'package:dart_rest/controller/users_controller.dart';

import 'controller/auth_exec_controller.dart';
import 'controller/cactus_controller.dart';
import 'controller/register_controller.dart';
import 'dart_rest.dart';
import 'model/user.dart';

class DartRestChannel extends ApplicationChannel {
  ManagedContext context;

  AuthServer authServer;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = CactusesConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);

    context = ManagedContext(dataModel, persistentStore);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route('/auth/token').link(() => AuthController(authServer));

    router.route('/auth-exec').link(() => AuthExecController());

    router
        .route('/register')
        .link(() => RegisterController(context, authServer));

    router
        .route('/users/[:id]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => UsersController(context, authServer));

    router
        .route('/cactuses/[:id]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => CactusesController(context));

    return router;
  }
}

class CactusesConfig extends Configuration {
  CactusesConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
