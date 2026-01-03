import 'package:flutter/material.dart';

class AddConnectionSheet extends StatefulWidget {
  const AddConnectionSheet({super.key});

  @override
  State<AddConnectionSheet> createState() => _AddConnectionSheetState();
}

class _AddConnectionSheetState extends State<AddConnectionSheet> {
  final TextEditingController hostController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController keyPathController = TextEditingController();
  final TextEditingController passphraseController = TextEditingController();

  bool usePrivateKey = false; // состояние чекбокса

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'New Connection',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            // Хост, порт
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: hostController,
                    decoration: const InputDecoration(
                      labelText: 'Host',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: portController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Port',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Username
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),

            const SizedBox(height: 16),


            // Если ключ не выбран → показываем пароль
            if (!usePrivateKey)
              TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),

            // Если выбран ключ → показываем поля для ключа и passphrase
            if (usePrivateKey) ...[
              TextField(
                controller: keyPathController,
                decoration: const InputDecoration(
                  labelText: 'Private key path',
                  hintText: '/Users/maxim/.ssh/id_rsa',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passphraseController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Key passphrase (optional)',
                ),
              ),
            ],

            const SizedBox(height: 8),
            // Чекбокс переключения
            Row(
              children: [
                Checkbox(
                  value: usePrivateKey,
                  onChanged: (val) {
                    setState(() => usePrivateKey = val ?? false);
                  },
                ),
                const Text('Use private key pass'),
              ],
            ),

            const SizedBox(height: 24),

            // Кнопка добавления соединения
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'host': hostController.text,
                    'port': portController.text,
                    'user': userController.text,
                    'pass': passController.text,
                    'privateKeyPath': keyPathController.text,
                    'passphrase': passphraseController.text,
                    'usePrivateKey': usePrivateKey,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 43, 43, 43),
                  overlayColor: const Color.fromARGB(255, 20, 20, 20),
                ),
                child: const Text(
                  'Add connection',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
