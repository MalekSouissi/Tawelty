class APIResponse<T> {
  T data;
  bool error;
  String errorMessage;

  APIResponse({required this.data, required this.errorMessage, this.error=false});
}