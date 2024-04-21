import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:calendar_time/calendar_time.dart';

class NoteTile extends StatelessWidget {
  final String noteTitle;
  final String noteBody;
  final DateTime updatedAt;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  NoteTile({
    super.key,
    required this.noteTitle,
    required this.noteBody,
    required this.updatedAt,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
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
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: Offset(4, 4),
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
                  const Spacer()
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      CalendarTime(updatedAt).toHuman,
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
