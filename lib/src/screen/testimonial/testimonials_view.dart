import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';

class TestimonialView extends StatelessWidget {
  final String name;
  final String testimonial;
  final String image;
  final String option;
  final String url;
  TestimonialView({required this.name, required this.option,required this.url,required this.testimonial,required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Review"),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 100,
            margin: EdgeInsets.only(top: 20.0),
            child: Material(
              elevation: 1.0,
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage(image),
                      radius: 80.0,
                      backgroundColor: Colors.grey[300],
                    ),
                    SizedBox(height: 10.0),
                    Text("$name".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(height: 5.0),
                    Text("$option",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(height: 5.0),
                    Text(
                      testimonial,
                      style: TextStyle(color: Colors.black87, fontSize: 18.0),
                    ),
                    SizedBox(height: 6.0),
                    OutlinedButton(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          CircleAvatar(
                            radius: 11.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage("assets/images/facebook.png"),
                          ),
                          SizedBox(width: 10),
                          Text("Follow",
                              style: TextStyle(
                                color: Colors.black87,
                              )),
                        ],
                      ),
                      onPressed: () => launchURL(url),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
