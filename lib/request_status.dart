//ignore_for_file: constant_identifier_names

class RequestStatus<T> {

  static const FAILURE = 0;
  static const SUCCESS = 1;
  static const LOADING = 2;

  final int status;
  String? message;
  late final T? body;

  String? get errorMsg => status == FAILURE ? message : null;

  RequestStatus({required this.status, this.message, this.body});

  @override
  String toString() {
    String ss = status == SUCCESS ? 'Success' : 'Failure' ;
    return 'RequestStatus(status: $ss, message: $message, body: $body)';
  }
}