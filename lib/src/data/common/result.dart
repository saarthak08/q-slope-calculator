abstract class Result<T> {
  const Result();

  T? get value;
  Error? get error;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;

  R? when<R>(
      {R Function(T value)? onSuccess, R Function(Error failure)? onError});
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data) : super();

  @override
  T get value => data;

  @override
  Error? get error => null;

  @override
  R? when<R>(
          {R Function(T value)? onSuccess,
          R Function(Error failure)? onError}) =>
      onSuccess != null ? onSuccess(data) : null;
}

class Failure<T> extends Result<T> {
  final Error failure;

  const Failure(this.failure) : super();

  @override
  T? get value => null;

  @override
  Error get error => failure;

  @override
  R? when<R>(
          {R Function(T value)? onSuccess,
          R Function(Error failure)? onError}) =>
      onError != null ? onError(failure) : null;
}
