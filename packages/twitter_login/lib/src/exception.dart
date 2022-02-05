/// Exception thrown when doing user cancelled the login flow.
class CanceledByUserException implements Exception {
  const CanceledByUserException();
  String toString() => "CanceledByUserException";
}
