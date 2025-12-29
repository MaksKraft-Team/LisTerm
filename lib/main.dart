import 'package:flutter/material.dart';
import 'screens/connections_screen.dart';

void main() {
  runApp(const LisTermApp());
}

class LisTermApp extends StatelessWidget {
  const LisTermApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LisTerm',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF8A3D),
          secondary: Color(0xFFFFB56B),
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
        ),

        scaffoldBackgroundColor: const Color(0xFF121212),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFEDEDED),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Color(0xFFFF8A3D)),
        ),

        listTileTheme: const ListTileThemeData(
          iconColor: Color(0xFFFF8A3D),
          textColor: Color(0xFFEDEDED),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF8A3D),
          foregroundColor: Colors.black,
        ),
      ),

      home: const ConnectionsScreen(),
    );
  }
}
