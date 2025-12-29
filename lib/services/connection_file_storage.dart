import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/connection.dart';

class ConnectionFileStorage {
  static const String fileName = 'connections.json';

  /// Путь к файлу
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  /// Сохранение списка подключений в файл
  static Future<void> save(List<Connection> connections) async {
    final file = await _getFile();
    final jsonList = connections.map((c) => c.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  /// Загрузка списка подключений из файла
  static Future<List<Connection>> load() async {
    try {
      final file = await _getFile();

      if (!await file.exists()) {
        return [];
      }

      final content = await file.readAsString();
      final List<dynamic> decoded = jsonDecode(content);

      return decoded
          .map((item) => Connection.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
