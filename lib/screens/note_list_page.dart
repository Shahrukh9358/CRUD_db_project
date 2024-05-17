import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moor_drift_project/database/database.dart';
import 'note_detail_page.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  late AppDatabase database;

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoteDetailPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<NoteData>>(
        future: _getNotesFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<NoteData>? noteList = snapshot.data;
            if (noteList != null && noteList.isNotEmpty) {
              return _noteListUI(noteList);
            } else {
              return Center(
                child: Text(
                  "No Notes Found",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return Center(
            child: Text(
              "Click on add button to add new notes",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        },
      ),
    );
  }

  Future<List<NoteData>> _getNotesFromDatabase() async {
    return await database.getNoteList();
  }

  Widget _noteListUI(List<NoteData> noteList) {
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (context, index) {
        final note = noteList[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text(note.description),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await database.deleteNoteById(note.id);
              setState(() {});
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailPage(note: note),
              ),
            );
          },
        );
      },
    );
  }
}
