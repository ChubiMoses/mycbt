

import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback iconPressed;
  const SearchField({Key? key, 
    required this.controller, required this.hint, 
    required this.iconPressed, 
    }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(fontSize: 12, color: Theme.of(context).disabledColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
        filled: true, fillColor:Colors.grey[100],
        isDense: true,
        suffixIcon: IconButton(
          onPressed: widget.iconPressed,
          icon: Icon(Icons.search, color: Theme.of(context).textTheme.bodyText1!.color),
        ),
      ),
     
    );
  }
}
