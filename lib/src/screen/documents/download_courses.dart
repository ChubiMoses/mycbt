import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/file_service.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:flutter/services.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

class ContentUpdate extends StatefulWidget {
  const ContentUpdate({Key? key}) : super(key: key);

  @override
  _ContentUpdateState createState() => _ContentUpdateState();
}

class _ContentUpdateState extends State<ContentUpdate> {
  bool noNetwork = true;

  @override
  void initState() {
    super.initState();

    startUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 150.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 100.0,
                  ),
                  noNetwork
                      ? const CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/no_signal.png"),
                          radius: 50.0,
                          backgroundColor: Colors.transparent,
                        )
                      : SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(kWhite),
                            strokeWidth: 6.0,
                          ),
                        ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 200,
                    child: Text(
                        noNetwork
                            ? "Download failed! \n Please turn on data connection."
                            : "Downloading courses.\n Please wait.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: kWhite)),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  noNetwork
                      ? TextButton(
                           style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    kPrimaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          onPressed: () => startUpdate(),
                          child: Text("Retry ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, color: kWhite)),
                         
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ));
  }

  void startUpdate() async {
    final result = await checkConnetion();
    if (result == 0) {
      setState(() => noNetwork = true);
      final result = await checkConnetion();
      if (result == 0) {
        SnackBar snackBar = SnackBar(
            duration: Duration(seconds: 15),
            content: Text("Please turn on your data."),
            action: SnackBarAction(
                label: 'Close app',
                textColor: Colors.lightGreen,
                onPressed: () {
                  SystemNavigator.pop();
                }));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      setState(() => noNetwork = false);
      await donwloadCourses();
      displayToast("Download complete");
      //save time of last sync
      saveTimestamp(DateTime.now().millisecondsSinceEpoch.toString());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeTab(view: "")));
    }
  }
}
