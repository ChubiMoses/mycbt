import 'package:flutter/material.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/screen/documents/documets.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/widgets/more_tile.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/document_tile.dart';

class PDFGridviewTile extends StatelessWidget {
  final List<DocModel> docs;
  final String title;
  final VoidCallback refresh;
  const PDFGridviewTile(this.docs, this.title, this.refresh, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        docs.isEmpty
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.count(
                 padding: const EdgeInsets.all(0),
                       physics: const NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                       crossAxisSpacing: 10.0,
                       mainAxisSpacing: 10.0,
                       childAspectRatio: MediaQuery.of(context).size.width /
                       (MediaQuery.of(context).size.height / (ResponsiveHelper.isDesktop(context) ? 1.8 : ResponsiveHelper.isTab(context) ? 3 : 3.8)),
                  children:List.generate(docs.length > 4 ? 4 : docs.length, (i) {
                    return DocumentTile(
                      document: docs[i],
                      view: '',
                     
                      refresh: refresh,
                     
                    );
                  }),
                ),
              ),
            
        docs.isEmpty
            ? const SizedBox.shrink()
            : MoreCard(
                title: title,
                press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Documents(docs, title, refresh)))),
      ],
    );
  }
}
