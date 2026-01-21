/// Result pattern for safe error handling across the app.
/// Use this instead of throwing exceptions for expected failure cases.
sealed class Result<T> {
  const Result();

  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result
  bool get isFailure => this is Failure<T>;

  /// Gets the data if success, throws if failure
  T get data => (this as Success<T>).value;

  /// Gets the error message if failure, null if success
  String? get errorMessage =>
      this is Failure<T> ? (this as Failure<T>).message : null;

  /// Pattern match on the result
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).value);
    } else {
      final f = this as Failure<T>;
      return failure(f.message, f.error);
    }
  }
}

/// Represents a successful operation with data
class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);

  @override
  String toString() => 'Success($value)';
}

/// Represents a failed operation with error details
class Failure<T> extends Result<T> {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.error, this.stackTrace]);

  @override
  String toString() => 'Failure($message, $error)';
}

/// Extension methods for async Result operations
extension ResultFuture<T> on Future<Result<T>> {
  /// Map success value to a new type
  Future<Result<R>> mapSuccess<R>(R Function(T) mapper) async {
    final result = await this;
    return result.when(
      success: (data) => Success(mapper(data)),
      failure: (msg, err) => Failure(msg, err),
    );
  }
}
