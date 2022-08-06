class NoodleException implements Exception {
  NoodleException({
    this.errorCode = '0',
    this.message = '',
    this.title,
    this.cause,
  });

  String errorCode;
  String message;
  String? title;
  dynamic cause;

  factory NoodleException.unexpected() = UnexpectedException;
}

class UnexpectedException extends NoodleException {
  UnexpectedException({dynamic cause}) : super(cause: cause);
}

class UserNotFoundException extends NoodleException {
  UserNotFoundException(String message, {dynamic cause})
      : super(message: message, cause: cause);
}
