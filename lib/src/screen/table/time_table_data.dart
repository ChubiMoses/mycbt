import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mycbt/src/models/event_model.dart';
import 'package:mycbt/src/screen/table/add_edit_event.dart';
import 'package:mycbt/src/services/ads_service.dart';
import 'package:mycbt/src/services/events_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/empty_state_widget.dart';

class TimeTableData extends StatefulWidget {
  final String day;
  TimeTableData({required this.day});

  @override
  _TimeTableDataState createState() => _TimeTableDataState();
}

class _TimeTableDataState extends State<TimeTableData> {
  List<EventModel> events = [];
  List<EventModel> todayEvents = [];
  late BannerAd _bannerAd;
  bool adReady = false;
  @override
  void initState() {
    getEvents();

    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            adReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          adReady = false;
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();
    super.initState();
  }

  void getEvents() async {
    todayEvents = [];
    events = await fetchEvents();
    events.forEach((element) {
      if (element.day == widget.day) {
        todayEvents.add(element);
      }
      setState(() => todayEvents == todayEvents);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: todayEvents.isEmpty
            ? EmptyStateWidget("Add Event", Icons.event)
            : Container(
                margin: const EdgeInsets.only(top: 10),
                child: ListView.separated(
                    separatorBuilder: (context, i) {
                      if (i == 2) {
                        return adReady
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: SizedBox(
                                  height: _bannerAd.size.height.toDouble(),
                                  width: _bannerAd.size.width.toDouble(),
                                  child: AdWidget(ad: _bannerAd),
                                ),
                              )
                            : const SizedBox.shrink();
                      }

                      return SizedBox.shrink();
                    },
                    itemCount: todayEvents.length,
                    itemBuilder: (context, i) {
                      EventModel event = todayEvents[i];

                      return Card(
                        elevation: 0.0,
                        color: kWhite,
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.event,
                            color: kGrey600,
                          ),
                          title: Text(
                            event.title!.toUpperCase(),
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            event.starts! + " - " + event.ends!,
                            style: TextStyle(
                                color: kGrey600, fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 18,
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEvent(
                                          day: widget.day,
                                          refresh: getEvents,
                                          view: "edit",
                                          id: event.id ?? 1,
                                          starts: event.starts ?? "",
                                          ends: event.ends ?? "",
                                          title: event.title ?? "",
                                        ))),
                          ),
                        ),
                      );
                    }),
              ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: kWhite),
            backgroundColor: Theme.of(context).primaryColor,
            splashColor: kSecondaryColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEvent(
                          day: widget.day,
                          title: "",
                          id: 1,
                          starts: "",
                          ends: "",
                          refresh: getEvents,
                          view: "new")));
            }));
  }
}
