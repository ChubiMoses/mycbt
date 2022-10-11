
import 'package:flutter/material.dart';
dynamic bottomTabs(context, IconData icon, String label){
    return BottomNavigationBarItem(
            icon: Icon(icon, size: 25.0),
            label: label,
            // activeIcon: Container(
            //   width: 80.0,
            //  decoration: BoxDecoration(
            //     color:Colors.lightGreen,
            //     borderRadius: BorderRadius.circular(30.0)
            //  ),
            //   child:Padding(
            //     padding: const EdgeInsets.all(4.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Icon(icon, size: 22.0, color:Colors.white),
            //       Text(label, style: TextStyle(fontSize: 13.0, color:Colors.white)),
            //     ],
            // ),
            //   )),
            );
   }
  