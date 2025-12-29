import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/highlight_core.dart';
import '../themes/lisfox_code_theme.dart';


class CodeEditor extends StatefulWidget {
  final String initialText;
  final Mode language;
  final void Function(String text)? onChanged;

  const CodeEditor({
    super.key,
    required this.initialText,
    required this.language,
    this.onChanged,
  });

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late CodeController controller;

  @override
  void initState() {
    super.initState();

    controller = CodeController(
      text: widget.initialText,
      language: widget.language,
    );

    controller.addListener(() {
      widget.onChanged?.call(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CodeTheme(
      data: CodeThemeData(styles: lisFoxCodeTheme),
      child: CodeField(
        controller: controller,
        textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 14),
      ),
    );
  }
}
