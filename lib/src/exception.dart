/// Exception thrown when doing user cancelled the login flow.
class CanceledByUserException implements Exception {
  const CanceledByUserException();
  @override
  String toString() => 'CanceledByUserException';
}
