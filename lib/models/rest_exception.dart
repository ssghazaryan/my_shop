class RestException implements Exception {
  final String message;

  RestException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}