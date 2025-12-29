import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import '../models/connection.dart';
import '../widgets/file_list_panel.dart';
import '../widgets/ssh_terminal.dart';

class TerminalScreen extends StatefulWidget {
  final Connection connection;

  const TerminalScreen({super.key, required this.connection});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  SSHClient? client;

  String explorerDirectory = ''; // Текущая директория в файловом менеджере

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.grey.shade900,
                  title: const Text(
                    "Disconnect from SSH?",
                    style: TextStyle(fontSize: 18),
                  ),
                  content: const Text(
                    "Current connection will be closed.",
                    style: TextStyle(fontSize: 14),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Disconnect"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                  ],
                );
              },
            );

            if (confirm == true) {
              Navigator.pop(context); // Закрытие экран терминала
            }
          },
        ),

        title: Text(
          '${widget.connection.host}:${widget.connection.port}',
          style: const TextStyle(fontSize: 18),
        ),
      ),

      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8),
              child:
                  client == null || explorerDirectory.isEmpty
                      ? const Center(child: Text("Loading files..."))
                      : FileListPanel(
                        client: client!,
                        directory: explorerDirectory,

                        // Обработка выбора директории
                        onDirectorySelected: (newDir) {
                          setState(() => explorerDirectory = newDir);
                        },
                      ),
            ),
          ),

          const VerticalDivider(
            width: 2,
            thickness: 2,
            color: Color(0xFF1E1E1E),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SshTerminal(
                connection: widget.connection,
                onConnected: (c) async {
                  setState(() => client = c);

                  // Получение домашней директории пользователя
                  final result = await c.run('pwd');
                  final home = String.fromCharCodes(result).trim();

                  setState(() => explorerDirectory = home);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
