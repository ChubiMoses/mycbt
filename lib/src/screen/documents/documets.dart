import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/document_tile.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/pdf_docs_tile.dart';

class Documents extends StatefulWidget {
  final List<DocModel> docs;
  final String title;
  final VoidCallback refresh;
  const Documents(this.docs, this.title, this.refresh);
  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Documents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBgScaffold,
        appBar: header(context, strTitle:widget.title),
        body: widget.docs.isEmpty
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: GridView.count(
                  padding: const EdgeInsets.all(0),
                       physics: const NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                       crossAxisSpacing: 10.0,
                       mainAxisSpacing: 10.0,
                       childAspectRatio: MediaQuery.of(context).size.width /
                       (MediaQuery.of(context).size.height / (ResponsiveHelper.isDesktop(context) ? 1.8 : ResponsiveHelper.isTab(context) ? 3 : 3.8)),
                  children: List.generate( widget.docs.length,(i) {
                      return DocumentTile(
                     document:  widget.docs[i],
                      view: '',
                      refresh: () {},
                                
                  );
                  }),
                ),
              ));
  }
}
