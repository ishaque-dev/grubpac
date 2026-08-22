abstract class Failure implements Exception {
  final String message;
  Failure({this.message = 'Oops..Something went wrong'});
  @override
  String toString() {
    return message;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

enum RequestMethod {
  getRequest,
  postRequest,
  putRequest,
  deleteRequest,
  patchRequest,
  headRequest,
}

extension RESTMethodString on RequestMethod {
  String get getMethodName {
    switch (this) {
      case RequestMethod.getRequest:
        return "GET";
      case RequestMethod.postRequest:
        return "POST";
      case RequestMethod.putRequest:
        return "PUT";
      case RequestMethod.deleteRequest:
        return "DELETE";
      case RequestMethod.patchRequest:
        return "PATCH";
      case RequestMethod.headRequest:
        return "HEAD";
    }
  }
}

enum ErrorMessageType {
  messageFromResponseBody,
  messageDefaultByDio,
  messageCustomised,
}
