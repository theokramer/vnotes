import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vnotes_flutter/utils/note_tile.dart';

import '../database/db.dart';

class EditNote extends StatefulWidget {
  final controllerTitle;
  final controllerBody;
  final controllerTime;
  final change;
  final createdAt;
  VoidCallback onSave;
  VoidCallback onChange;
  VoidCallback onCancel;
  EditNote(
      {super.key,
      required this.controllerTitle,
      required this.controllerBody,
      required this.controllerTime,
      required this.change,
      required this.createdAt,
      required this.onSave,
      required this.onChange,
      required this.onCancel});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  NoteDataBase db = NoteDataBase();
  var time = "0";
  var lastVal = "pinned";

  @override
  void initState() {
    widget.controllerTime.addListener(refreshTime);
    lastVal = widget.controllerTime.text;
    super.initState();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  refreshTime() {
    setState(() {
      widget.controllerTime.text;
    });
  }

  void changeDisTime() {
    showDialog(
      barrierColor: Colors.white.withOpacity(0.3),
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Dialog(
            alignment: Alignment.topCenter,
            insetPadding: EdgeInsets.symmetric(vertical: 70),
            backgroundColor: Colors.white,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.all(10), child: Text("Save")),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "The Note disappears after",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  // get user input
                  Container(
                    width: 250,
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      controller: widget.controllerTime,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Disappear after...",
                      ),
                    ),
                    //TODO: Display here a text which says "hours"
                  ),
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        //TODO: Implement that you can pin the note
                        onTap: () {
                          setState(() {
                            if (lastVal == "pinned") {
                              lastVal = widget.controllerTime.text;
                              widget.controllerTime.text = "pinned";
                            } else {
                              widget.controllerTime.text = lastVal;
                              lastVal = "pinned";
                            }
                          });
                        },
                        child: Container(
                            child: Row(
                          children: [
                            Stack(
                              children: [
                                widget.controllerTime.text != "pinned"
                                    ? Icon(Icons.check_box_outline_blank)
                                    : Icon(Icons.check_box),
                              ],
                            ),
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Text("Pin?")),
                          ],
                        )),
                      ),
                      Spacer()
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return TooltipVisibility(
      visible: false,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          leading: GestureDetector(
            onTap: widget.onSave,
            child: Row(
              children: [
                BackButton(
                  onPressed: widget.change ? widget.onChange : widget.onSave,
                  color: Colors.green,
                ),
                //TODO: Display Logo and improve Text
                const Text("vnotes",
                    style: TextStyle(fontSize: 15, color: Colors.green)),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  TimeLeft(
                    value: widget.controllerTime.text != "pinned"
                        ? isNumeric(widget.controllerTime.text)
                            ? calcTimeLeft(widget.createdAt,
                                int.parse(widget.controllerTime.text))
                            : 1
                        : -1,
                    hours: widget.controllerTime.text != "pinned"
                        ? isNumeric(widget.controllerTime.text)
                            ? int.parse(widget.controllerTime.text)
                            : 24
                        : -1,
                  ),
                  GestureDetector(
                      onTap: changeDisTime,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                          size: 28,
                        ),
                      )),
                ],
              ),
            )
          ],
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
                    controller: widget.controllerTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SingleChildScrollView(
                    //TODO: Can you press return at the heading, so you can type the body?
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: widget.controllerBody,
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
