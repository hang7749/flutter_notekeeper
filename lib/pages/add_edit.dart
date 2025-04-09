import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notekeeper/modal/notes.dart';
import 'package:flutter_notekeeper/services/database_helper.dart';

class AddEditNote extends StatefulWidget {
  final Notes? note; // Optional note for editing
  const AddEditNote({this.note});

  @override
  State<AddEditNote> createState() => _AddEditNoteState();
}

class _AddEditNoteState extends State<AddEditNote> {

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Color _selectedColor = Colors.amber;
  final List<Color> _noteColors = [
    Colors.amber,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
  ];
  String _dateTime = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    // Initialize any data if needed
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
      _dateTime = widget.note!.dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter note title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      hintText: 'Enter note content',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter content';
                      }
                      return null;
                    },
                  ),
                  Padding(padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _noteColors.map((color) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8.0),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColor == color ? Colors.black45 : Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ),
                  InkWell(
                    onTap: () {
                      _saveNote();
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Save Note',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,  
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      )
    );
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = Notes(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        color: _selectedColor.value.toString(),
        dateTime: DateTime.now().toString(),
      );
      if (widget.note == null) {
        await _databaseHelper.insertNote(note);
      } else {
        await _databaseHelper.updateNote(note);
      }
    }
  }
}