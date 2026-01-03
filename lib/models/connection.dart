class Connection {
  final String host;             // Хост
  final int port;                // Порт
  final String username;         // Имя пользователя
  final String? password;        // Пароль (если используется)
  final String? privateKeyPath;  // Путь к приватному ключу (если используется)
  final String? passphrase;      // Парольная фраза для ключа (если ключ зашифрован)

  const Connection({
    required this.host,
    required this.port,
    required this.username,
    this.password,
    this.privateKeyPath,
    this.passphrase,
  });

  String get address => '$host:$port';

  /// Сохранение в JSON
  Map<String, dynamic> toJson() => {
        'host': host,
        'port': port,
        'username': username,
        'password': password,
        'privateKeyPath': privateKeyPath,
        'passphrase': passphrase,
      };

  /// Восстановление из JSON
  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      host: json['host'],
      port: json['port'],
      username: json['username'],
      password: json['password'],
      privateKeyPath: json['privateKeyPath'],
      passphrase: json['passphrase'],
    );
  }

  /// Проверка: используется ли ключ вместо пароля
  bool get usesKeyAuth => privateKeyPath != null && privateKeyPath!.isNotEmpty;
}
