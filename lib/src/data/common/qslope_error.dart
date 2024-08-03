enum QSlopeErrorType { saveError, clearListError, deleteError, listLoadError }

class QSlopeError extends Error {
  final QSlopeErrorType type;

  QSlopeError({required this.type});
}
