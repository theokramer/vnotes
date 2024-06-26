import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:calendar_time/calendar_time.dart';

class NoteTile extends StatelessWidget {
  final String noteTitle;
  final String noteBody;
  final DateTime createdAt;
  final int delTime;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;

  const NoteTile({
    super.key,
    required this.noteTitle,
    required this.noteBody,
    required this.createdAt,
    required this.delTime,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(3),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                    spreadRadius: 5),
              ]),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    noteTitle == "" ? "Ohne Titel" : noteTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Spacer(),
                  //TODO: Fix Time Left Tile for Notes List
                  TimeLeft(
                    value: calcTimeLeft(createdAt, delTime),
                    hours: delTime,
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Text(
                      //Display updatedAt instead?
                      CalendarTime(createdAt).toHuman,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        noteBody.contains("\n")
                            ? noteBody
                                        .substring(0, noteBody.indexOf("\n"))
                                        .length <
                                    30
                                ? noteBody.substring(0, noteBody.indexOf("\n"))
                                : "${noteBody.substring(0, 30)}..."
                            : noteBody.length < 30
                                ? noteBody
                                : "${noteBody.substring(0, 30)}...",
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

int calcTimeLeft(DateTime updatedAt, int hours) {
  return !(hours == -1)
      ? updatedAt
          .add(Duration(hours: hours))
          .difference(DateTime.now())
          .inMinutes
      : -1;
}

class TimeLeft extends StatelessWidget {
  final int hours;
  final int value;
  const TimeLeft({
    required this.hours,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      height: 35,
      child: Stack(children: [
        value != -1
            ? Center(
                child: Stack(children: [
                  CircularProgressIndicator(
                    strokeWidth: 2.5,
                    value: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  CircularProgressIndicator(
                    strokeWidth: 2.5,
                    value: (value / (hours * 60)),
                    color: (value / (hours * 60)) > 0.7
                        ? Colors.green
                        : value / (hours * 60) > 0.4
                            ? Colors.orange
                            : Colors.red,
                  ),
                ]),
              )
            : Text(""),
        Center(
            child: value != -1
                ? Text((value / 60).round().toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.black))
                : Icon(Icons.push_pin)),
      ]),
    );
  }
}
