import 'package:flutter/material.dart';
import 'package:dartssh2/dartssh2.dart';

import '../screens/editor_screen.dart';

class FileTile extends StatelessWidget {
  final SSHClient client;
  final String directory;
  final String file;
  final void Function(String newDirectory)? onDirectorySelected;
  final VoidCallback onRefresh;

  const FileTile({
    super.key,
    required this.client,
    required this.directory,
    required this.file,
    required this.onRefresh,
    this.onDirectorySelected,
  });

  bool get isDir => file.endsWith('/');

  String get cleanName => isDir ? file.substring(0, file.length - 1) : file;

  /// Диалог ввода имени (для переименования)
  Future<String?> _askName(
    BuildContext context,
    String title,
    String initial,
  ) async {
    final controller = TextEditingController(text: initial);

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
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 12, right: 0),
      title: Text(cleanName, style: const TextStyle(fontSize: 14)),
      leading: Icon(
        isDir ? Icons.folder : Icons.insert_drive_file,
        size: 18,
        color: isDir ? Colors.amber : null,
      ),

      // Переход в папку
      onTap: () {
        if (isDir) {
          final newPath =
              directory == '/' ? '/$cleanName' : '$directory/$cleanName';
          onDirectorySelected?.call(newPath);
        } else {
          final filePath =
              directory == '/' ? '/$cleanName' : '$directory/$cleanName';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditorScreen(client: client, filePath: filePath),
            ),
          );
        }
      },

      // Переименование + удаление
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Переименовать
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.amber, size: 18),
            onPressed: () async {
              final newName = await _askName(
                context,
                "Rename $cleanName",
                cleanName,
              );

              if (newName == null || newName.isEmpty) return;

              final safeOld = cleanName.replaceAll("'", "'\\''");
              final safeNew = newName.replaceAll("'", "'\\''");
              final safeDir = directory.replaceAll("'", "'\\''");

              await client.run("mv '$safeDir/$safeOld' '$safeDir/$safeNew'");
              onRefresh();
            },
          ),

          // Удалить
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 18),
            onPressed: () async {
              final safeName = cleanName.replaceAll("'", "'\\''");
              final safeDir = directory.replaceAll("'", "'\\''");
              final fullPath = "$safeDir/$safeName";

              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey.shade900,
                    title: Text("Delete $cleanName?"),
                    content: Text(
                      isDir
                          ? "This will delete the folder and all its contents."
                          : "This will delete the file.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                },
              );

              if (confirm != true) return;

              if (isDir) {
                await client.run("rm -rf '$fullPath'");
              } else {
                await client.run("rm '$fullPath'");
              }

              onRefresh();
            },
          ),
        ],
      ),
    );
  }
}
