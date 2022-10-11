
import 'package:flutter/material.dart';
import 'package:mycbt/src/utils/colors.dart';

class NewSubTile extends StatelessWidget {
  const NewSubTile({
   required this.orderNo,
   required this.date,
   required this.title,
   required this.amount,
   required this.status,
  });

  final String orderNo, date, title, amount, status;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [kDefaultShadow]),
            child: Column(
              children: [    
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderNo,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Theme.of(context).hintColor),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize:14,
                          color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
                SizedBox(
                  height:10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                        )
                      ),
                    ),
                    Text(
                      'N' + amount,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: kSecondaryColor),
                    ),
                  ],
                ),
              
              ],
            ),
          ),
      )
    );
  }
}
