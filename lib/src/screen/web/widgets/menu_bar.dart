import 'package:flutter/material.dart';
import 'package:mycbt/src/screen/home_tab.dart';
import 'package:mycbt/src/screen/home_top_tabs.dart';
import 'package:mycbt/src/screen/web/widgets/search_field.dart';
import 'package:mycbt/src/screen/web/widgets/text_hover.dart';
import 'package:mycbt/src/screen/welcome/loginRegisterPage.dart';
import 'package:mycbt/src/services/responsive_helper.dart';

class WebMenuBar extends StatefulWidget {
  const WebMenuBar({Key? key}) : super(key: key);

  @override
  State<WebMenuBar> createState() => _WebMenuBarState();
}

class _WebMenuBarState extends State<WebMenuBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            spreadRadius: 1,
            blurRadius: 5,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            InkWell(
              child: Image.asset(
                "assets/images/logo.png",
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: ResponsiveHelper.isDesktop(context) ? 200 : ResponsiveHelper.isTab(context) ? 100 : 50,
            child: SearchField(
              controller: _searchController,
              iconPressed: () {},
              hint: 'Search',
            ),
          ),
          const SizedBox(width: 20),
          MenuButton(title: 'home', onTap: () {}),
          const SizedBox(width: 20),
          MenuButton(title: 'about', onTap: () {}),
          const SizedBox(width: 20),
          MenuIconButton(icon: Icons.notifications, onTap: () {}),
          const SizedBox(width: 20),
          MenuIconButton(icon: Icons.favorite, onTap: () {}),
          const SizedBox(width: 20),
          const SizedBox(width: 20),

          currentUser != null ?
             InkWell(
              //  onTap:()=>photoPreview(context,currentUser!.url),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    currentUser!.url),
                radius: 20.0,
                backgroundColor: Colors.grey[300],
              ),
            ):
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginRegisterPage()));
            },
            child: Container(
              height: 30,
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Theme.of(context).primaryColor,
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(currentUser != null ? 'Profile' : 'Login',
                    style: const TextStyle(fontSize: 11, color: Colors.white)),
                const SizedBox(width: 10),
                Icon(
                    currentUser != null
                        ? Icons.person_pin_rounded
                        : Icons.keyboard_arrow_down,
                    size: 12,
                    color: Colors.white),
              ]),
            ),
          )
        ]),
      ]),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const MenuButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextHover(builder: (hovered) {
      return InkWell(
        onTap: onTap,
        child: Text(title,
            style: TextStyle(
                fontSize: 14,
                color: hovered ? Theme.of(context).primaryColor : null)),
      );
    });
  }
}

class MenuIconButton extends StatelessWidget {
  final IconData icon;
  final bool isCart;
  final VoidCallback onTap;
  const MenuIconButton(
      {Key? key, required this.icon, this.isCart = false, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextHover(builder: (hovered) {
      return IconButton(
          onPressed: onTap,
          icon: Stack(clipBehavior: Clip.none, children: [
            // Icon(
            //   icon,
            //   color: hovered ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyText1.color,
            // ),
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            (isCart)
                ? Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      height: 15,
                      width: 15,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor),
                      child: Text(
                        '10',
                        style: TextStyle(
                            fontSize: 12, color: Theme.of(context).cardColor),
                      ),
                    ),
                  )
                : const SizedBox()
          ]));
    });
  }
}
