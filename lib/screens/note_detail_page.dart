import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moor_drift_project/database/database.dart';

class NoteDetailPage extends StatefulWidget {
  final NoteData? note;

  const NoteDetailPage({Key? key, this.note}) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late AppDatabase database;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int? _priority;
  int? _color;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _priority = widget.note!.priority;
      _color = widget.note!.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Add Note" : "Edit Note"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Title"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  value: _priority,
                  items: [1, 2, 3, 4, 5]
                      .map((e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text("Priority $e"),
                  ))
                      .toList(),
                  decoration: InputDecoration(labelText: "Priority"),
                  onChanged: (value) {
                    setState(() {
                      _priority = value;
                    });
                  },
                ),
                DropdownButtonFormField<int>(
                  value: _color,
                  items: [
                    Colors.red.value,
                    Colors.green.value,
                    Colors.blue.value,
                    Colors.yellow.value
                  ].map((e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text(
                      "Color",
                      style: TextStyle(color: Color(e)),
                    ),
                  )).toList(),
                  decoration: InputDecoration(labelText: "Color"),
                  onChanged: (value) {
                    setState(() {
                      _color = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final note = NoteCompanion(
                        title: drift.Value(_titleController.text),
                        description: drift.Value(_descriptionController.text),
                        priority: _priority != null
                            ? drift.Value(_priority!)
                            : const drift.Value.absent(),
                        color: _color != null
                            ? drift.Value(_color!)
                            : const drift.Value.absent(),
                      );
                      if (widget.note == null) {
                        await database.insertNote(note);
                      } else {
                        final updatedNote = NoteCompanion(
                          id: drift.Value(widget.note!.id),
                          title: drift.Value(_titleController.text),
                          description: drift.Value(_descriptionController.text),
                          priority: _priority != null
                              ? drift.Value(_priority!)
                              : const drift.Value.absent(),
                          color: _color != null
                              ? drift.Value(_color!)
                              : const drift.Value.absent(),
                        );
                        await database.updateNote(updatedNote);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.note == null ? "Add Note" : "Update Note"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
