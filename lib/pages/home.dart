import 'package:flutter/material.dart';
import 'package:flutter_notekeeper/pages/add_edit.dart';
import 'package:flutter_notekeeper/modal/notes.dart';
import 'package:flutter_notekeeper/pages/view.dart';
import 'package:flutter_notekeeper/services/database_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Notes> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    List<Notes> notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today ${dt.hour}:${dt.minute}';
    } else if (dt.year == now.year && dt.month == now.month && dt.day == now.day - 1) {
      return 'Yesterday ${dt.hour}:${dt.minute}';
    } else if (dt.year == now.year) {
      return '${dt.day}/${dt.month} ${dt.hour}:${dt.minute}';
    }
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Notes App'
          ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7,
        ),
        itemCount: _notes.length,
        itemBuilder: (context, index) {

          final note = _notes[index];
          final homeNoteColor = Color(int.parse(note.color));

          return GestureDetector(
            onTap: () async {
              // Handle note tap
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewNote(note: note),
                ),
              );
              _loadNotes();
            },
            child: Container(
              decoration: BoxDecoration(
                color: homeNoteColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    note.content,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white70,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    _formatDateTime(note.dateTime),
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          // Handle add note button press
          await Navigator.push(context, MaterialPageRoute(
            builder: (context) => const AddEditNote(),
          ));
          _loadNotes();
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
