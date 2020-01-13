import 'harness/app.dart';

void main() async {
  final harness = TestHarness<DartRestChannel>()..install();

  const String token = "EkOSSljWS5CppGrPNTwNNZof794Unk3H";

  const String testCacusName = "Testus";
  Map<String, dynamic> postedCactus;

  test("GET /cactuses returns 200 OK", () async {
    harness.agent.bearerAuthorization = token;

    final response = await harness.agent.get("/cactuses");
    expectResponse(response, 200,
        body: allOf({
          "status": isInteger,
          "message": isString,
          "data": everyElement({"id": greaterThan(0), "name": isString})
        }));
  });

  test("GET /cactuses?name=us returns 200 OK", () async {
    harness.agent.bearerAuthorization = token;
    
    final response = await harness.agent.get("/cactuses?name=us");
    expectResponse(response, 200,
        body: allOf({
          "status": isInteger,
          "message": isString,
          "data": everyElement({"id": greaterThan(0), "name": isString})
        }));
  });

  test("GET /cactuses/id returns 200 OK", () async {
    harness.agent.bearerAuthorization = token;
    
    final response = await harness.agent.get("/cactuses/1");
    expectResponse(response, 200,
        body: allOf({
          "status": isInteger,
          "message": isString,
          "data": allOf({"id": greaterThan(0), "name": isString})
        }));
  });

  test("GET /cactuses/id returns 404 NotFound", () async {
    harness.agent.bearerAuthorization = token;
    
    final response = await harness.agent.get("/cactuses/0");
    expectResponse(response, 404);
  });

  test("POST /cactuses returns 200 OK", () async {
    harness.agent.bearerAuthorization = token;
    
    final response = await harness.agent.post("/cactuses", body: {
      "name" : testCacusName
    });

    postedCactus = await response.body.decode();
    
    expectResponse(response, 200, body: allOf({
      "status": isInteger,
          "message": isString,
          "data": allOf({"id": greaterThan(0), "name": testCacusName})
    }));
  });

  test("POST /cactuses returns 409 BadResponse", () async {
    harness.agent.bearerAuthorization = token;
    
    final response = await harness.agent.post("/cactuses", body: {
      "name" : "Testus"
    });
    expectResponse(response, 409);
  });

  test("DELETE /cactuses returns 200 OK", () async {
    harness.agent.bearerAuthorization = token;
    
    final id = postedCactus["data"]["id"];
    final response = await harness.agent.delete("/cactuses/$id");

    expectResponse(response, 200, body: allOf({
      "status" : 200,
      "message" : isString,
      "data" : isNull
    }));
  });
}
