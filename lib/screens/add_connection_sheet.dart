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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
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

          // Пароль
          TextField(
            controller: passController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
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
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 43, 43, 43),
                overlayColor: Color.fromARGB(255, 20, 20, 20)
              ),
              child: const Text('Add connection', style: TextStyle(fontSize: 16)),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
