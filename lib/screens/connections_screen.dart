import 'package:flutter/material.dart';
import '../models/connection.dart';
import '../services/connection_file_storage.dart';
import 'add_connection_sheet.dart';
import 'terminal_screen.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  List<Connection> _connections = [];

  @override
  void initState() {
    super.initState();
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    final loaded = await ConnectionFileStorage.load();
    setState(() {
      _connections = loaded;
    });
  }

  Future<void> _saveConnections() async {
    await ConnectionFileStorage.save(_connections);
  }

  void _showAddConnectionDialog() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddConnectionSheet(),
    );

    if (result != null) {
      setState(() {
        _connections.add(
          Connection(
            host: result['host'],
            port: int.tryParse(result['port']) ?? 22,
            username: result['user'],
            password: result['pass'],
          ),
        );
      });

      _saveConnections();
    }
  }

  void _deleteConnection(int index) {
    setState(() {
      _connections.removeAt(index);
    });
    _saveConnections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connections')),
      body: ListView.builder(
        itemCount: _connections.length,
        itemBuilder: (context, index) {
          final c = _connections[index];
          return ListTile(
            leading: const Icon(Icons.storage),
            title: Text('${c.host}:${c.port}'),
            subtitle: Text('User: ${c.username}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TerminalScreen(connection: c),
                ),
              );
            },

            // Кнопка удаления соединения
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteConnection(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddConnectionDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
