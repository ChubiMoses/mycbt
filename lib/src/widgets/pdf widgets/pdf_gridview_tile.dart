import 'package:flutter/material.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/models/pdf.dart';
import 'package:mycbt/src/screen/documents/documets.dart';
import 'package:mycbt/src/widgets/more_tile.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/pdf_docs_tile.dart';

class PDFGridviewTile extends StatelessWidget {
  final List<DocModel> docs;
  final String title;
  final VoidCallback refresh;
  const PDFGridviewTile(this.docs, this.title, this.refresh);

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
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 2.0),
                  children:List.generate(docs.length > 4 ? 4 : docs.length, (i) {
                    return PDFDocTile(
                      code: docs[i].code!,
                      title: docs[i].title!,
                      url: docs[i].url!,
                      firebaseId: docs[i].fID!,
                      id: 0,
                      view: '',
                      conversation:docs[i].conversation!,
                      readProgress: 0,
                      refresh: refresh,
                      pages: 0,
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
