import 'package:flutter/material.dart';
import 'package:mycbt/src/models/event_model.dart';
import 'package:mycbt/src/utils/events_db.dart';
import 'package:sqflite/sqflite.dart';


Future<List<EventModel>> fetchEvents() async {
  EventsDBHelper eventsDBHelper = EventsDBHelper();
  List<EventModel> events = [];
  final Future<Database> dbFuture = eventsDBHelper.initializeDatabase();
  await dbFuture.then((database) async {
    Future<List<EventModel>> noteListFuture = eventsDBHelper.getNoteList();
    await noteListFuture.then((quiz) {
      events = quiz;
    });
  });
  return events;
}
