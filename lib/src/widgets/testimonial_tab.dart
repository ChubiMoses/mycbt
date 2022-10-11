import 'package:mycbt/src/screen/question/photo_preview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/testimonial/testimonials_view.dart';
import 'package:mycbt/src/utils/colors.dart';

class TestimonialTab extends StatelessWidget {
  final String name;
  final String testimonial;
  final String image;
  final String url;
  final String option;
  TestimonialTab(
      {required this.name,required this.testimonial,required this.image, required this.url,required this.option});

  @override
  Widget build(BuildContext context) {
    String sub = testimonial.substring(0, 50);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        //  border: Border.all(color: Colors.grey)
          ),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TestimonialView(
                    name: name,
                    url: url,
                    option: option,
                    image: image,
                    testimonial: testimonial))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(image),
                radius: 45.0,
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: 5.0),
              Text("$name".toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                    color:kBlack400,
                    fontWeight: FontWeight.w600,
                  )),

              SizedBox(height: 5.0),
             
              RichText(
                text: TextSpan(
                    text: sub,
                    style: TextStyle(color: Colors.black87, fontSize: 12.0),
                    children: [
                      TextSpan(
                          text: "...read",
                          style: TextStyle(
                            color: Colors.lightGreen,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              //Navigator.of(context).push(MaterialPageRoute(builder:
                              /// (BuildContext context)=>ActivateOnline()));
                            }),
                    ]),
              ),
              SizedBox(height: 6.0),
              CircleAvatar(
                radius: 11.0,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage("assets/images/facebook.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  photoPreview(BuildContext context, String photo) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhotoPreview(photo)));
  }
}
