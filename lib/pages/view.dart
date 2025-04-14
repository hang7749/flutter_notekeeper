import 'package:flutter/material.dart';
import 'package:flutter_notekeeper/pages/add_edit.dart';
import 'package:flutter_notekeeper/services/database_helper.dart';
import '../modal/notes.dart';

class ViewNote extends StatelessWidget {
  final Notes note;
  ViewNote({required this.note});

  final DatabaseHelper _databaseHelper = DatabaseHelper();

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
      backgroundColor: Color(int.parse(note.color)),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(note.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Return to previous screen
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditNote(
                    note: note
                  ),
                ),
              );
              Navigator.pop(context, true); // Return to previous screen
            },
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: ()  => _showDeleteDialog(context),
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24,16,24,24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Row(children: [
                  Icon(
                    Icons.access_time,
                    size: 16.0,
                    color: Colors.white70,
                  ),
                  SizedBox(width: 8),
                  Text(
                    _formatDateTime(note.dateTime),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],)
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24,32,24,24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
              ),
            )
            )
          ),
        ],
      ))
    );
  }
  
  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirm = await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          'Delete Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this note?',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Close the dialog and return true
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      ));

    if (confirm == true) {
      await _databaseHelper.deleteNote(note.id!);
      Navigator.pop(context, true); // Return to previous screen
    }
  }

}

