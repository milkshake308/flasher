class IoBackendRepositoryError implements Exception {
  final String message;

  IoBackendRepositoryError(this.message);

  @override
  String toString() => 'IoBackendRepositoryError: $message';
}
