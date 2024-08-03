enum ErrorType { network, server, unexpected }

class AppError extends Error {
  final ErrorType type;
  final String message;

  AppError({required this.type, required this.message});
}
