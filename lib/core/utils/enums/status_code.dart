enum StatusCode {
  success(200),
  created(201);

  final int code;

  const StatusCode(this.code);
}
