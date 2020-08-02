/// Exception thrown when doing user cancelled the login flow.
class CanceldByUserException implements Exception {
  const CanceldByUserException();
  String toString() => "CanceldByUserException";
}
