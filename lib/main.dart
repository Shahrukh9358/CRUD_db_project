import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moor_drift_project/database/database.dart';
import 'package:moor_drift_project/screens/note_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AppDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          textTheme: const TextTheme(
            headlineSmall: TextStyle(
                fontFamily: 'Sans',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24),
            bodyMedium: TextStyle(
                fontFamily: 'Sans',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20),
            bodyLarge: TextStyle(
                fontFamily: 'Sans',
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 18),
            titleSmall: TextStyle(
                fontFamily: 'Sans',
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 14),
          ),
        ),
        home: const NoteListPage(),
      ),
    );
  }
}
