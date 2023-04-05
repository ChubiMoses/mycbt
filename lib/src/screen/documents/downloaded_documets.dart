import 'package:mycbt/src/models/docs.dart';
import 'package:mycbt/src/models/pdf.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/pdf_docs_tile.dart';

class DownloadedDocs extends StatefulWidget {
  final List<DocsModel> docs;
  final String title;
   final VoidCallback refresh;
  const DownloadedDocs(this.docs, this.title, this.refresh);
  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<DownloadedDocs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBgScaffold,
        appBar: header(context, strTitle: widget.title),
        body: 
            widget.docs.isEmpty
                ? const SizedBox.shrink()
                : SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: GridView.count(
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: MediaQuery.of(context).size.width /(MediaQuery.of(context).size.height / 2.0),
                        children: List.generate(
                            widget.docs.length, (i) {
                            return PDFDocTile(
                            code: widget.docs[i].code!,
                            title: widget.docs[i].title!,
                            url: widget.docs[i].filePath!,
                            firebaseId:"",
                            conversation:0,
                            refresh: widget.refresh,
                            id: widget.docs[i].id!,
                            view: 'OfflinePDF', readProgress:widget.docs[i].progress!, pages:widget.docs[i].pages!,
                          );
                        }),
                      ),
                    ),
                ),
          
        );
  }
}
