import 'package:flutter/material.dart';
import 'commit_list_page.dart';

void main() {
  runApp(const CommitListApp());
}

class CommitListApp extends StatelessWidget {
  const CommitListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Commit List App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        hintColor: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      home: const CommitListPage(),
    );
  }
}
