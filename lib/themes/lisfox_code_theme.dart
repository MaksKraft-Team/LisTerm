import 'package:flutter/material.dart';

/// Тема для редактора
final Map<String, TextStyle> lisFoxCodeTheme = {
  'root': const TextStyle(
    backgroundColor: Color(0xFF121212),
    color: Color(0xFFEDEDED),
    fontFamily: 'monospace',
    fontSize: 14,
  ),

  // Комментарии
  'comment': TextStyle(
    color: Colors.grey.shade600,
    fontStyle: FontStyle.italic,
  ),

  // Ключевые слова (def, class, return…)
  'keyword': const TextStyle(
    color: Color(0xFFFF8A3D),
    fontWeight: FontWeight.bold,
  ),

  // Строки
  'string': const TextStyle(
    color: Color(0xFF8BE9FD),
  ),

  // Числа
  'number': const TextStyle(
    color: Color(0xFFFFBD2E),
  ),

  // Функции
  'title': const TextStyle(
    color: Color(0xFF57C7FF),
  ),

  // Имена переменных
  'variable': const TextStyle(
    color: Color(0xFFFF92D0),
  ),

  // Булевы значения / литералы
  'literal': const TextStyle(
    color: Color(0xFF5AF78E),
  ),

  // Ошибки
  'error': const TextStyle(
    color: Colors.redAccent,
    fontWeight: FontWeight.bold,
  ),
};
