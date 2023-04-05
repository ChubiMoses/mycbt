import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PhotoPreview extends StatelessWidget {
  final String url;
  PhotoPreview(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:AppBar(
         backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:Container(
        alignment: Alignment.center,
        child: Image(
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.contain,
          ),
      ),
    );
  }
}