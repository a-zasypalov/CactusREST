import 'package:dart_rest/dart_rest.dart';
import 'package:dart_rest/model/response_form.dart';
import 'package:dart_rest/model/user.dart';

class UsersController extends ResourceController {
  UsersController(this.context, this.authServer);

  final ManagedContext context;
  final AuthServer authServer;

  @Operation.get()
  Future<Response> getAllUsers() async {
    final query = Query<User>(context);

    final users = await query.fetch();

    return Response.ok(ResponseForm(
        status: 200,
        message: "Success",
        data: users.map((c) => c.asMap()).toList()))
      ..contentType = ContentType.json;
  }

  @Operation.delete('id')
  Future<Response> deleteUserByID(@Bind.path('id') int id) async {
    final query = Query<User>(context)..where((user) => user.id).equalTo(id);

    final user = await query.fetchOne();

    if (user == null) {
      return Response.notFound(
          body: ResponseForm(
              status: 404, message: "There are no user with id=$id"))
        ..contentType = ContentType.json;
    }

    await query.delete();

    return Response.ok(ResponseForm(status: 200, message: "Success"))
      ..contentType = ContentType.json;
  }
}
