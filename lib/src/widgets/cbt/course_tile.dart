import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/modal/pdf_render_modal.dart';
import 'package:mycbt/src/screen/modal/quiz_options_modal.dart';
import 'package:mycbt/src/screen/profile/user_info.dart';
import 'package:mycbt/src/services/favorite_courses_service.dart';
import 'package:mycbt/src/services/hide_content.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/more_action_dialog.dart';
import 'package:mycbt/src/widgets/smooth_star_rating.dart';

class CBTCourseTileWidget extends StatefulWidget {
  const CBTCourseTileWidget(
      {Key? key,
      required this.docModel,

  })
  : super(key: key);

  final DocModel docModel;
  


  @override
  State<CBTCourseTileWidget> createState() => _CBTCourseTileWidgetState();
}

class _CBTCourseTileWidgetState extends State<CBTCourseTileWidget> {
 
 
  bool hidden = false;
  Widget _companyInitial(ThemeData theme, context) {
    return GestureDetector(
     onTap: (){
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  UserInfo(widget.docModel.ownerId!)));
     },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 4,color:kWhite),
                color:kWhite,
                borderRadius: BorderRadius.circular(100)),
                child:Image.asset("assets/images/logo.png", fit: BoxFit.cover,) 
          ),
        ],
      ),
    );
  }

   bool fav = true;
  @override
  void initState() {
    fav = widget.docModel.favorite == 1 ? true : false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return hidden ? const SizedBox.shrink()  :  
    Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
                vertical: 5,
              ) +
          const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.only(left: 24, right: 16, bottom: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: kWhite
          ),
          child: InkWell(
             onTap:() async{
          startQuizModal(
              context,
              widget.docModel.code!,
              widget.docModel.school!,
              widget.docModel.title!,
            );
        
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("MY CBT",
                style: theme.textTheme.headline6!.copyWith(
                    fontSize: 12, color: kGrey600, fontWeight: FontWeight.w600)),
             
             
             InkWell(
              onTap:(){
                 moreAction(context,
                    userId: widget.docModel.ownerImage!,
                    id: widget.docModel.fID!,
                    question: widget.docModel.title!,
                    title: widget.docModel.title!,
                    username: widget.docModel.username!);
              },
              child: const Icon(Icons.more_vert, color: kGrey600, size: 25,))
            
          ],
        ),
         const SizedBox(
          height: 5,
        ),
       
        Text(
               widget.docModel.title!,
               maxLines: 1,
               overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyText1!.copyWith(
                color: theme.textTheme.subtitle1!.color, fontSize: 14, fontWeight: FontWeight.w600
              ),
            ),
       
        const SizedBox(height: 5),
     
        Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
            child:  Row(
              children: <Widget>[
                SmoothStarRating(
                  starCount:5,
                  color: kPrimaryColor,
                  allowHalfRating: true,
                  rating:3.6,
                  size: 10.0,
                ),
                const SizedBox(width: 10.0),
                const Text(
                        "4.5 (5 Reviews)",
                        style: TextStyle(
                          fontSize: 11.0,
                        ),
                      ),
              ],
            ),
          ),

           SizedBox(
            height: 25.0,
            child: InkWell(
              splashColor: Theme.of(context).primaryColor,
              onTap: () {
                if (fav) {
                  setState(() {
                    fav = false;
                  });
                } else {
                  setState(() {
                    fav = true;
                  });
                }
                addFavorite(
                  context,
                  widget.docModel,
                );
              },
              child: Icon(
                  fav ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).primaryColor),
            ),
          ),
         
          const SizedBox(
            height: 1,
          ),
           
        ],
         ),
         ),
          ),
          
          _companyInitial(theme, context), 
          Positioned(
            right: 10,
            bottom: 5,
            child:Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                )
              ),
              child:  const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("CBT", style: TextStyle(fontSize: 8, color:kWhite,),
              ))
          ),
          )
        ],
      );
  }

handleDocsRender(BuildContext context,
    {required int progress,
    required String firebaseId,
    required int conversation,
    required String title,
    required String code,
    required String filePath,
    required String view,
    required int id,
    required VoidCallback refresh,
    required preview}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PDFRenderModal(
            title: title,
            firebaseId: firebaseId,
            progress: 0,
            id: id,
            view: view,
            conversation: conversation,
            code: code,
            refresh: refresh,
            preview: false,
            filePath: filePath);
      });
}

  moreAction(
    mContext, {
    required String userId,
    required String id,
    required String title,
    required String question,
    required String username,
  }) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("What will you like to do?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1),
            children: <Widget>[
             SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.flag, color: Colors.grey),
                              SizedBox(width: 10.0),
                              Text("Report",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      onPressed: () => reportPost(context),
                    ),
              SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(CupertinoIcons.heart_slash,
                                  color: Colors.grey),
                              SizedBox(width: 10.0),
                              Text("Not interested",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      onPressed: () => notInterested(context),
                    ),
              SimpleDialogOption(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.visibility_off, color: Colors.grey),
                              const SizedBox(width: 10.0),
                              SizedBox(
                                width: 150,
                                child: Text("Hide all from $username", overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyText1),
                              ),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                      onPressed: () => notInterested(context),
                    ),
            
            ],
          );
        });

  }

//Hide not intrested content
  dynamic notInterested(context) async{
    List<String> ids = [];
    Navigator.pop(context);
    setState(() => hidden = true);
    HideContentService().hideContent(Content(id: widget.docModel.ownerId!));
    displayToast("Removing content");
  }
  
  void addFavorite(BuildContext context, final DocModel courses) {
    if (courses.favorite == 1) {
      deleteFavorite(courses.fID!);
      displayToast("Course removed from favorite.");
    } else {
      addTofavorite(courses.fID!)
          .then((value) => displayToast("Added to favorite courses."));
    }
  }
}