class Connection {
  final String host;        // Хост
  final int port;           // Порт
  final String username;    // Имя пользователя
  final String password;    // Пароль

  const Connection({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
  });

  String get address => '$host:$port';

  /// Сохранение в JSON
  Map<String, dynamic> toJson() => {
        'host': host,
        'port': port,
        'username': username,
        'password': password,
      };

  /// Восстановление из JSON
  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      host: json['host'],
      port: json['port'],
      username: json['username'],
      password: json['password'],
    );
  }
}
