import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/services/courses_service.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/services/system_chrome.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/widgets/cbt/course_tile.dart';
import 'package:mycbt/src/widgets/pdf%20widgets/document_tile.dart';

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

  void emptyFormField() {
    searchFormFiled.clear();
  }

  @override
  void dispose() {
    searchFormFiled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DocModel> list = searchResult.isEmpty ? coursesList : searchResult;
    systemChrome();
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 100),
            child: Container(
            //  height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 65,
                    ),
                     Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Material(
                       elevation: 3.0,
                        borderRadius: BorderRadius.circular(5),
                       child: Row(
                        children: [
                           Expanded(
                            child: TextField(
                               onChanged: controlSearch,
                                decoration:  InputDecoration(
                                  prefixIcon: IconButton(
                                  onPressed:()=>emptyFormField(),
                                  icon: const Icon(
                                    Icons.clear,
                                    size: 20.0,
                                  )),
                                  border: InputBorder.none,
                                  hintText:"Course code", hintStyle: const TextStyle(color:kGrey600)),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              color:kPrimaryColor,
                            ),
                            height: 46,
                            width: 45,
                            child: const Icon(Icons.search,
                                color: kWhite),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                  //  _searchBar(),
                  ],
                ),
              ),
            )),
        backgroundColor: kBgScaffold,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: isLoading
                ? loader()
                : coursesList.isEmpty
                    ? emptyStateWidget(
                        "Search not found.. please use course code as keyword.")
                     : GridView.count(
                       padding: const EdgeInsets.all(0),
                       physics: const BouncingScrollPhysics(),
                       shrinkWrap: true,
                       crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                       crossAxisSpacing: 10.0,
                       mainAxisSpacing: 10.0,
                       childAspectRatio: MediaQuery.of(context).size.width /
                       (MediaQuery.of(context).size.height / (ResponsiveHelper.isDesktop(context) ? 1.8 : ResponsiveHelper.isTab(context) ? 3 : 3.8)),
                       children:List.generate(list.length > 4 ? 4 : list.length, (i) {
                         return list[i].url! == ""
                             ? CBTCourseTileWidget(
                                 docModel: list[i],
                               )
                             : DocumentTile(
                               document: list[i],
                                 view: '',
                                 
                                 refresh: () {},
                                
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
