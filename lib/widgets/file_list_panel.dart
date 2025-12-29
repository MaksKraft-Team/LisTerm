import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';

import 'file_tile.dart';

class FileListPanel extends StatefulWidget {
  final SSHClient client;
  final String directory;

  /// Родитель передаёт callback, чтобы FileListPanel мог менять путь
  final void Function(String newDirectory)? onDirectorySelected;

  const FileListPanel({
    super.key,
    required this.client,
    required this.directory,
    this.onDirectorySelected,
  });

  @override
  State<FileListPanel> createState() => _FileListPanelState();
}

class _FileListPanelState extends State<FileListPanel> {
  List<String> files = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  @override
  void didUpdateWidget(covariant FileListPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.directory != widget.directory) {
      setState(() {
        loading = true;
        files = [];
      });
      _loadFiles();
    }
  }

  Future<void> _loadFiles() async {
    try {
      final safeDir = "'${widget.directory.replaceAll("'", "'\\''")}'";
      final result = await widget.client.run("ls -1p $safeDir");
      final text = utf8.decode(result);

      setState(() {
        files = text.split('\n').where((e) => e.trim().isNotEmpty).toList();
        loading = false;
      });
    } catch (e) {
      setState(() {
        files = ['Error: $e'];
        loading = false;
      });
    }
  }

  /// Получить путь на уровень выше
  String _parentDirectory(String path) {
    if (path == '/' || path.isEmpty) return '/';
    final parts = path.split('/')..removeWhere((e) => e.isEmpty);
    if (parts.isEmpty) return '/';
    parts.removeLast();
    return '/' + parts.join('/');
  }

  Future<String?> _askName(BuildContext context, String title) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: "Enter name..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Текущий путь
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.directory,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                    softWrap: true,
                    maxLines: null,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Создать папку
              IconButton(
                tooltip: "Create folder",
                icon: const Icon(
                  Icons.create_new_folder,
                  color: Colors.amber,
                  size: 22,
                ),
                onPressed: () async {
                  final name = await _askName(context, "New folder name");
                  if (name == null || name.trim().isEmpty) return;

                  final safeName = name.replaceAll("'", "'\\''");
                  final safeDir = widget.directory.replaceAll("'", "'\\''");

                  await widget.client.run("mkdir '$safeDir/$safeName'");
                  _loadFiles();
                },
              ),

              // Создать файл
              IconButton(
                tooltip: "Create file",
                icon: const Icon(
                  Icons.note_add,
                  color: Color(0xFFFF8A3D),
                  size: 22,
                ),
                onPressed: () async {
                  final name = await _askName(context, "New file name");
                  if (name == null || name.trim().isEmpty) return;

                  final safeName = name.replaceAll("'", "'\\''");
                  final safeDir = widget.directory.replaceAll("'", "'\\''");

                  await widget.client.run("touch '$safeDir/$safeName'");
                  _loadFiles();
                },
              ),
            ],
          ),

          // Кнопка "Вверх"
          TextButton.icon(
            onPressed: () {
              final parent = _parentDirectory(widget.directory);
              widget.onDirectorySelected?.call(parent);
            },
            icon: const Icon(Icons.arrow_upward, size: 18),
            label: const Text("Parent dir..."),
          ),

          const SizedBox(height: 8),

          // Список файлов
          Expanded(
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];

                return FileTile(
                  client: widget.client,
                  directory: widget.directory,
                  file: file,
                  onDirectorySelected: widget.onDirectorySelected,
                  onRefresh: _loadFiles,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
