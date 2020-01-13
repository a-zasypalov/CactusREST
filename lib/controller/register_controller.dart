import 'package:dart_rest/dart_rest.dart';
import 'package:dart_rest/model/response_form.dart';
import 'package:dart_rest/model/user.dart';

class RegisterController extends ResourceController {
  RegisterController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  @Operation.post()
  Future<Response> createUser(@Bind.body() User user) async {
    if (user.username == null || user.password == null) {
      return Response.badRequest(
          body: ResponseForm(
              status: 400, message: "Username and password are required"));
    }

    user
      ..salt = AuthUtility.generateRandomSalt()
      ..hashedPassword = authServer.hashPassword(user.password, user.salt);

    final responseData = await Query(context, values: user).insert();
    return Response.ok(ResponseForm(
        status: 200, message: "Success", data: responseData.asMap()))
      ..contentType = ContentType.json;
  }
}
