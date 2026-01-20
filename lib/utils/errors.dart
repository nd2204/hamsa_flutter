abstract class DomainError extends Error {
  final String message;

  DomainError({required this.message});
}

class ValueError extends DomainError {
  final Object? value;
  ValueError({this.value, String reason = "Invalid value"})
    : super(message: reason);
}

class StateError extends DomainError {
  StateError({required super.message});
}

class AuthenticationError extends DomainError {
  AuthenticationError([String reason = "Authentication failed"])
    : super(message: reason);
}
