import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vnotes_flutter/pages/edit_note.dart';
import 'package:vnotes_flutter/utils/note_tile.dart';
import 'package:vnotes_flutter/database/db.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _notes = Hive.box('notes');
  NoteDataBase db = NoteDataBase();
  @override
  void initState() {
    if (_notes.get("NOTES") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    db.updateDataBase();
    super.initState();
  }

  void deleteTask(int index) {
    setState(() {
      db.notes.removeAt(index);
    });
    db.updateDataBase();
  }

  final _controllerTitle = TextEditingController();
  final _controllerBody = TextEditingController();

  void saveNewTask() {
    setState(() {
      _controllerTitle.text.trim().isEmpty &&
              _controllerBody.text.trim().isEmpty
          ? null
          : db.notes.add([
              _controllerTitle.text,
              _controllerBody.text,
              DateTime.now(),
              DateTime.now(),
              24
            ]);
      _controllerTitle.clear();
      _controllerBody.clear();
      db.updateDataBase();
    });
    Navigator.of(context).pop();
  }

  void changeNote(int index) {
    setState(() {
      // Check if both title and body are not empty
      if (_controllerTitle.text.trim().isNotEmpty &&
          _controllerBody.text.trim().isNotEmpty) {
        // Create an updated note with the new values
        var updatedNote = [
          _controllerTitle.text,
          _controllerBody.text,
          DateTime.now(),
          DateTime.now(),
          24
        ];

        // Update the note at the given index with the updated note
        db.notes[index] = updatedNote;

        // Clear text controllers
        _controllerTitle.clear();
        _controllerBody.clear();

        // Update the database
        db.updateDataBase();
      }
    });

    Navigator.of(context).pop();
  }

  void createNewTask() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return EditNote(
          controllerTitle: _controllerTitle,
          controllerBody: _controllerBody,
          onSave: saveNewTask,
          onChange: () {
            changeNote(-1);
          },
          change: false,
          createdAt: DateTime.now(),
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    ));
  }

  void openSettings() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return Settings();
      },
    ));
  }

  void openNote(String title, String body, int index) {
    _controllerTitle.text = title;
    _controllerBody.text = body;
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return EditNote(
          controllerTitle: _controllerTitle,
          controllerBody: _controllerBody,
          change: true,
          createdAt: db.notes[index][2],
          onSave: () {},
          onChange: () {
            changeNote(index);
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "vnotes",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: openSettings,
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.more_horiz,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            createNewTask();
          },
          child: Icon(
            Icons.create,
            color: Colors.black,
          )),
      body: ListView.builder(
        itemCount: db.notes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              openNote(db.notes[index][0], db.notes[index][1], index);
            },
            child: NoteTile(
              noteTitle: db.notes[index][0],
              noteBody: db.notes[index][1],
              createdAt: db.notes[index][3],
              delTime: db.notes[index][4],
              onChanged: (value) => () {},
              deleteFunction: (context) => deleteTask(index),
            ),
          );
        },
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TooltipVisibility(
      visible: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(color: Colors.black),
          ),
          leading: const Row(
            children: [
              BackButton(
                color: Colors.green,
              ),
            ],
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        //TODO: Select default disappearing time - Start with 24 hours?
      ),
    );
  }
}
