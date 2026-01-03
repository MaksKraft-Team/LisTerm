import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';
import 'package:dartssh2/dartssh2.dart';
import '../models/connection.dart';

class SshTerminal extends StatefulWidget {
  final Connection connection;
  final void Function(SSHClient client)? onConnected;

  const SshTerminal({
    super.key,
    required this.connection,
    this.onConnected,
  });

  @override
  State<SshTerminal> createState() => _SshTerminalState();
}

class _SshTerminalState extends State<SshTerminal> {
  late Terminal terminal;
  SSHClient? client;
  SSHSession? session;

  // Цветовая тема терминала
  final TerminalTheme lisFoxTheme = TerminalTheme(
    cursor: Color(0xFFFF8A3D),
    selection: Color(0x33FF8A3D),
    foreground: Color(0xFFEDEDED),
    background: Color(0xFF121212),

    black: Color(0xFF000000),
    red: Color(0xFFFF5F56),
    green: Color(0xFF27C93F),
    yellow: Color(0xFFFFBD2E),
    blue: Color(0xFF1E90FF),
    magenta: Color(0xFFFF79C6),
    cyan: Color(0xFF8BE9FD),
    white: Color(0xFFEDEDED),

    brightBlack: Color(0xFF4D4D4D),
    brightRed: Color(0xFFFF6E67),
    brightGreen: Color(0xFF5AF78E),
    brightYellow: Color(0xFFF4F99D),
    brightBlue: Color(0xFF57C7FF),
    brightMagenta: Color(0xFFFF92D0),
    brightCyan: Color(0xFF9AEDFE),
    brightWhite: Color(0xFFFFFFFF),

    searchHitBackground: Color(0xFFFFFF2B),
    searchHitBackgroundCurrent: Color(0xFF31FF26),
    searchHitForeground: Color(0xFF000000),
  );

  @override
  void initState() {
    super.initState();

    terminal = Terminal(maxLines: 20000);

    // Проброс ввода напрямую в SSH shell
    terminal.onOutput = (String data) {
      session?.write(Uint8List.fromList(utf8.encode(data)));
    };

    _connect();
  }

  Future<void> _connect() async {
    terminal.write('Connecting to ${widget.connection.host}...\r\n');

    try {
      final socket = await SSHSocket.connect(
        widget.connection.host,
        widget.connection.port,
      );

      // Выбор метода аутентификации
      if (widget.connection.privateKeyPath != null &&
          widget.connection.privateKeyPath!.isNotEmpty) {
        // 🔑 Подключение по ключу
        terminal.write('Using private key authentication...\r\n');

        final keyContent =
            await File(widget.connection.privateKeyPath!).readAsString();

        final keyPair = SSHKeyPair.fromPem(
          keyContent,
          widget.connection.passphrase,
        );

        client = SSHClient(
          socket,
          username: widget.connection.username,
          identities: keyPair,
        );
      } else {
        // 🔑 Подключение по паролю
        terminal.write('Using password authentication...\r\n');

        client = SSHClient(
          socket,
          username: widget.connection.username,
          onPasswordRequest: () => widget.connection.password,
        );
      }

      widget.onConnected?.call(client!);

      terminal.write('Connected. Opening shell...\r\n');

      session = await client!.shell();

      session!.stdout.listen((Uint8List data) {
        terminal.write(utf8.decode(data));
      });

      session!.stderr.listen((Uint8List data) {
        terminal.write(utf8.decode(data));
      });

      session!.done.then((_) {
        terminal.write('\r\nConnection closed.\r\n');
      });
    } catch (e) {
      terminal.write('Error: $e\r\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TerminalView(
      terminal,
      theme: lisFoxTheme,
      autofocus: true,
      backgroundOpacity: 1.0,
    );
  }
}
