
import 'package:dart_rest/dart_rest.dart';

class ResponseForm extends Serializable{
  ResponseForm({this.status, this.message, this.data});

  int status;
  dynamic data;
  String message;

  @override
  Map<String, dynamic> asMap() {
    return {
      "status" : status,
      "data" : data,
      "message" : message
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
  }
  
}
