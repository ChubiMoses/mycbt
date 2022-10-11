import 'package:flutter/material.dart';
import 'package:mycbt/src/models/event_model.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/events_db.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class AddEvent extends StatefulWidget {
  final String day;
  final String view;
  final String title;
  final String ends;
  final String starts;
  final int id;
  final VoidCallback refresh;
  AddEvent(
      {required this.day,
      required this.view,
      required this.starts,
      required this.refresh,
      required this.ends,
      required this.title,
      required this.id});
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  TextEditingController startcontroller = TextEditingController(text: "8.00AM");
  TextEditingController endController = TextEditingController(text: "9.00PM");
  TextEditingController titleController =
      TextEditingController(text: "CODE101");

  void addEvent() async {
    if (widget.view == "edit") {
      updateEvent(context, widget.id, widget.day, titleController.text,
          startcontroller.text, endController.text);
    } else {
      saveEvent(context, widget.day, titleController.text, startcontroller.text,
          endController.text);
    }
    widget.refresh();
  }

  @override
  void initState() {
    if (widget.view == "edit") {
      endController.text = widget.ends;
      titleController.text = widget.title;
      startcontroller.text = widget.starts;
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    startcontroller.dispose();
    endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgScaffold,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.view == "new" ? "NEW EVENT" : "EDIT EVENT",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        actions: [
          widget.view == "edit"
              ? IconButton(
                  icon: Icon(Icons.delete, color: kWhite),
                  onPressed: () {
                    deleteEvent(context, widget.id);
                    widget.refresh();
                  })
              : SizedBox.shrink()
        ],
      ),
      body: Column(
        children: [
          Card(
            elevation: 0,
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                children: [
                  Text(
                    "Title",
                    style:
                        TextStyle(color: kGrey600, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 200,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      style: TextStyle(
                          color: kBlack,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                      controller: titleController,
                    ),
                  )
                ],
              ),
            ),
          ),
          Card(
            elevation: 0.0,
            margin: EdgeInsets.all(8),
            color: kWhite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        "Starts",
                        style: TextStyle(
                            color: kGrey600, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 100,
                        child: TextField(
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                          style: TextStyle(
                              color: kBlack,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600),
                          controller: startcontroller,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Ends",
                        style: TextStyle(
                            color: kGrey600, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 100,
                        child: TextField(
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                          style: TextStyle(
                              color: kBlack,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600),
                          controller: endController,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => addEvent(),
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Text(widget.view == "new" ? "SAVE" : "UPDATE",
                      style: TextStyle(
                          color: kWhite, fontWeight: FontWeight.bold))),
            ),
          )
        ],
      ),
    );
  }

  void saveEvent(
      context, String day, String title, String starts, String ends) async {
    EventsDBHelper eventsDBHelper = EventsDBHelper();
    EventModel data = EventModel(
      day: day,
      title: title,
      starts: starts,
      ends: ends,
    );
    await eventsDBHelper.insertEvent(data);
    displayToast("Event saved");
    Navigator.pop(context);
  }

  void deleteEvent(context, int id) {
    EventsDBHelper eventsDBHelper = EventsDBHelper();
    eventsDBHelper.deleteEvent(id);
    displayToast("Event deleted");
    Navigator.pop(context);
  }

  void updateEvent(context, int id, String day, String title, String starts,
      String ends) async {
    EventsDBHelper eventsDBHelper = EventsDBHelper();
    EventModel data = EventModel.withId(
      id: id,
      day: day,
      title: title,
      starts: starts,
      ends: ends,
    );
    await eventsDBHelper.updateEvent(data);
    displayToast("Event updated");
    Navigator.pop(context);
  }
}
