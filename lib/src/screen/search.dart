import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/screen/cbt/courses_view.dart';
import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/pdf_docs_tile.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchFormFiled = TextEditingController();
  int selectedIndex = 0;
  bool isLoading = false;
  List<DocModel> coursesList = [];
  List<DocModel> searchResult = [];
  bool isPDF = true;
  bool isCBT = false;
  @override
  void initState() {
    getCourses();
    super.initState();
  }

  void getCourses() async {
    coursesList = await getCoursesList(context);
    setState(() {
      coursesList.shuffle();
      isLoading = false;
    });
  }

  void controlSearch(String query) async {
    query = query.toUpperCase();
    if (query.length > 1) {
      setState(() {
        isLoading = true;
        searchResult = [];
      });

      final ids = coursesList.map((e) => e.fID).toSet();
      coursesList.retainWhere((x) => ids.remove(x.fID));

      for (var element in coursesList) {
        String code = element.code!;
        if (code.startsWith(query.toUpperCase())) {
          searchResult.add(element);
        }
      }

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          searchResult = searchResult;
          isLoading = false;
        });
      });
    } else {
      setState(() {
        searchResult = [];
        isLoading = false;
      });
    }
  }

  emptyFormField() {
    searchFormFiled.clear();
  }

  @override
  void dispose() {
    searchFormFiled.dispose();
    super.dispose();
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: SizedBox(
        height: 35.0,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          controller: searchFormFiled,
          style: const TextStyle(fontSize: 16.0, color: kWhite100),
          autofocus: false,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(8.0),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            hintText: "Course Code",
            hintStyle: const TextStyle(
              color: kWhite100,
            ),
            filled: true,
            focusColor: kWhite,
            prefixIcon: const Icon(Icons.search, color: kWhite100, size: 20.0),
            suffixIcon: IconButton(
                onPressed: emptyFormField,
                icon: const Icon(
                  Icons.clear,
                  color: kWhite100,
                  size: 20.0,
                )),
          ),
          onChanged: controlSearch,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DocModel> list = searchResult.isEmpty ? coursesList : searchResult;
    systemChrome();
    return Scaffold(
        appBar: PreferredSize(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 65,
                    ),
                    _searchBar(),
                  ],
                ),
              ),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 100)),
        backgroundColor: kBgScaffold,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: isLoading
              ? loader()
              : coursesList.isEmpty
                  ? emptyStateWidget(
                      "Search not found.. please use course code as keyword.")
                   : Container(
                      child: GridView.count(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2.0),
                        children: List.generate(list.length, (i) {
                          return list[i].url! == ""
                              ? CourseTile(
                                  i: i,
                                  courses: list,
                                )
                              : PDFDocTile(
                                  code: list[i].code!,
                                  title: list[i].title!,
                                  url: list[i].url!,
                                  firebaseId: list[i].fID!,
                                  id: 0,
                                  view: '',
                                  conversation: list[i].conversation!,
                                  readProgress: 0,
                                  refresh: () {},
                                  pages: 0,
                                );
                        }),
                      ),
                    ),
        ));
  }

  Widget emptyStateWidget(String message) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: () => getCourses(),
              child: Icon(Icons.search, size: 100.0, color: Colors.lightGreen)),
          SizedBox(
              width: 150.0,
              child: Text(message,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: kGrey600, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
