import 'dart:convert';

import 'package:dart_rest/dart_rest.dart';
import 'package:dart_rest/model/response_form.dart';
import 'package:dart_rest/model/user.dart';
import 'package:http/http.dart' as http;

class AuthExecController extends ResourceController {

  final String clientID = "com.cactuses.client";
  final String host = "http://localhost:8888/auth/token";

  @Operation.post()
  Future<Response> createUser(@Bind.body() User user) async {
    if (user.username == null || user.password == null) {
      return Response.badRequest(
          body: ResponseForm(
              status: 400, message: "Username and password are required"));
    }

    final body = "username=${user.username}&password=${user.password}&grant_type=password";
    final clientCredentials = const Base64Encoder().convert("$clientID:".codeUnits);

    final response = await http.post(
      host,
      headers: {
        "Content-Type" : "application/x-www-form-urlencoded",
        "Authorization" : "Basic $clientCredentials"
      },
      body: body
    );
    return Response.ok(ResponseForm(status: 200, message: "Success", data: jsonDecode(response.body)));
  }
}
