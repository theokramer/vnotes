import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../database/db.dart';

class EditNote extends StatelessWidget {
  NoteDataBase db = NoteDataBase();
  final controllerTitle;
  final controllerBody;
  final change;
  VoidCallback onSave;
  VoidCallback onChange;
  VoidCallback onCancel;
  EditNote(
      {super.key,
      required this.controllerTitle,
      required this.controllerBody,
      required this.change,
      required this.onSave,
      required this.onChange,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return TooltipVisibility(
      visible: false,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          leading: GestureDetector(
            onTap: onSave,
            child: Row(
              children: [
                BackButton(
                  onPressed: change ? onChange : onSave,
                  color: Colors.green,
                ),
                const Text("vnotes",
                    style: TextStyle(fontSize: 15, color: Colors.green))
              ],
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.green, //change your color here
          ),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          constraints: BoxConstraints(maxHeight: 1000),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: TextField(
                    controller: controllerTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SingleChildScrollView(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: controllerBody,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
