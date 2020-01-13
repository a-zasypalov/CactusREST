import 'package:dart_rest/dart_rest.dart';
import 'package:dart_rest/model/cactus.dart';
import 'package:dart_rest/model/response_form.dart';

class CactusesController extends ResourceController {
  CactusesController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllCactuses({@Bind.query('name') String name}) async {
    final query = Query<Cactus>(context);

    if (name != null) {
      query.where((cactus) => cactus.name).contains(name, caseSensitive: false);
    }

    final cactuses = await query.fetch();

    return Response.ok(ResponseForm(
        status: 200,
        message: "Success",
        data: cactuses.map((c) => c.asMap()).toList()))
      ..contentType = ContentType.json;
  }

  @Operation.get('id')
  Future<Response> getHeroByID(@Bind.path('id') int id) async {
    final query = Query<Cactus>(context)
      ..where((cactus) => cactus.id).equalTo(id);

    final cactus = await query.fetchOne();

    if (cactus == null) {
      return Response.notFound(
          body: ResponseForm(
              status: 404, message: "There are no cactus with id=$id"))
        ..contentType = ContentType.json;
    }

    return Response.ok(
        ResponseForm(status: 200, message: "Success", data: cactus.asMap()))
      ..contentType = ContentType.json;
  }

  @Operation.post()
  Future<Response> createCactus(
      @Bind.body(ignore: ['id']) Cactus inputCactus) async {
    if (inputCactus.name.isEmpty) {
      return Response.badRequest(
          body: ResponseForm(status: 400, message: "Name mustn't be empty"))
        ..contentType = ContentType.json;
    }

    final query = Query<Cactus>(context)..values = inputCactus;
    final insertedCactus = await query.insert();

    return Response.ok(ResponseForm(
        status: 200, message: "Success", data: insertedCactus.asMap()))
      ..contentType = ContentType.json;
  }

  @Operation.delete('id')
  Future<Response> deleteCactusByID(@Bind.path('id') int id) async {
    final query = Query<Cactus>(context)
      ..where((cactus) => cactus.id).equalTo(id);

    final cactus = await query.fetchOne();

    if (cactus == null) {
      return Response.notFound(
          body: ResponseForm(
              status: 404, message: "There are no cactus with id=$id"))
        ..contentType = ContentType.json;
    }

    await query.delete();

    return Response.ok(ResponseForm(status: 200, message: "Success"))..contentType = ContentType.json;
  }
}
