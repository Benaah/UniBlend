class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ApiResponse._({
    required this.success,
    this.data,
    this.error,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse._(
      success: true,
      data: data,
    );
  }

  factory ApiResponse.error(String error) {
    return ApiResponse._(
      success: false,
      error: error,
    );
  }

  bool get isSuccess => success;
  bool get isError => !success;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error) onError,
  }) {
    if (success && data != null) {
      return onSuccess(data as T);
    } else {
      return onError(error ?? 'Unknown error occurred');
    }
  }
}
