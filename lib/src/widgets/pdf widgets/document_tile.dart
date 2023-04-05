import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:mycbt/src/models/doc.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/modal/pdf_render_modal.dart';
import 'package:mycbt/src/screen/profile/user_info.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/services/hide_content.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/utils/network_utils.dart';
import 'package:mycbt/src/widgets/displayToast.dart';
import 'package:mycbt/src/widgets/more_action_dialog.dart';
import 'package:mycbt/src/widgets/smooth_star_rating.dart';

class DocumentTile extends StatefulWidget {
  const DocumentTile(
      {Key? key,
  required this.document,
  required this.view,
  required this.refresh,
  })
  : super(key: key);
  final VoidCallback refresh;
  final String view;
  final DocModel document;

  @override
  State<DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
 
 
  bool hidden = false;
  Widget _companyInitial(ThemeData theme, context) {
    return GestureDetector(
     onTap: (){
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  UserInfo(widget.document.ownerId??"")));
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
              image: DecorationImage(image:CachedNetworkImageProvider(widget.document.ownerImage??""), fit: BoxFit.cover),
                color:kWhite,
                borderRadius: BorderRadius.circular(100)),
                child:Center(child: widget.document.ownerImage == "" ? const Icon(Icons.person, color: kGrey400,size: 25,) : null),
          ),
        ],
      ),
    );
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
      int result = 1;
      if (ResponsiveHelper.isMobilePhone()) {
          result = await checkConnetion();
      }
      if (currentUser == null) {
        displayToast("Please login");
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginRegisterPage()));
      } else {
        if (widget.view != "OfflinePDF" && result == 0) {
          displayToast("No internet connection");
        } else {
          // ignore: use_build_context_synchronously
          handleDocsRender(context,
              title: widget.document.title??"",
              firebaseId: widget.document.fID??"",
              conversation: widget.document.conversation??0,
              id: widget.document.id??0,
              progress: 0,
              preview: false,
              code: widget.document.code??"",
              view: widget.view,
              refresh: widget.refresh,
              filePath: widget.document.url??"");
        }
      }
    
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.document.username??"",
                style: theme.textTheme.headline6!.copyWith(
                    fontSize: 12, color: kGrey600, fontWeight: FontWeight.w600)),
             
             
             InkWell(
              onTap:(){
                 moreAction(context,
                    userId: widget.document.ownerImage??"",
                    id: widget.document.fID??"",
                    question: widget.document.title??"",
                    title: widget.document.title??"",
                    username: widget.document.username??"");
              },
              child: const Icon(Icons.more_vert, color: kGrey600, size: 25,))
            
          ],
        ),
         const SizedBox(
          height: 5,
        ),
       
        Text(
               widget.document.title??"",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Posted on",
                style: TextStyle(color: kGrey600, fontSize: 10),
              ),
              Text(
                widget.document.dateUploaded??"",
                style: theme.textTheme.bodyText1!.copyWith(
                  color: kGrey600, fontSize: 11
                ),
              ),
            ],
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
              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("PDF", style: const TextStyle(fontSize: 8, color:kWhite,),
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
                              Icon(CupertinoIcons.heart_slash,
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
    HideContentService().hideContent(Content(id: widget.document.ownerId??""));
    displayToast("Removing content");
  }

}