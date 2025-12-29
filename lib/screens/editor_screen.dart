import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:highlight/languages/python.dart';
import '../widgets/code_editor.dart';

class EditorScreen extends StatefulWidget {
  final SSHClient client;
  final String filePath;

  const EditorScreen({super.key, required this.client, required this.filePath});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String fileText = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    final result = await widget.client.run("cat '${widget.filePath}'");
    fileText = utf8.decode(result);

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filePath),
        toolbarHeight: 56,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.amber),
            onPressed: () async {
              // Индикатор загрузки
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => const Center(child: CircularProgressIndicator()),
              );

              try {
                // Экранирование пути файла
                final safePath = widget.filePath.replaceAll("'", "'\\''");

                // Экранирование содержимого файла
                final encoded = fileText
                    .replaceAll(r'\', r'\\')
                    .replaceAll(r'$', r'\$')
                    .replaceAll('`', r'\`')
                    .replaceAll('"', r'\"');

                // Запись файла через SSH
                await widget.client.run('printf "%s" "$encoded" > "$safePath"');

                Navigator.pop(context);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Файл сохранён"), backgroundColor: Color(0xFFFF8A3D),));
              } catch (e) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Ошибка сохранения: $e"), backgroundColor: Colors.redAccent,),
                );
              }
            },
          ),
          Container(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        child: CodeEditor(
          initialText: fileText,
          language: python,
          onChanged: (text) {
            fileText = text;
          },
        ),
      ),
    );
  }
}
