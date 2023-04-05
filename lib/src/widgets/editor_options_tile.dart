import 'package:mycbt/src/utils/firebase_collections.dart';
import 'package:mycbt/src/widgets/displayToast.dart';

import 'package:flutter/material.dart';
import 'package:katex_flutter/katex_flutter.dart';

class EditorOptions extends StatefulWidget {
  final String question, answer, option1, option2, option3, id;
  EditorOptions(
      {
        required this.question,
      required this.option1,
      required this.option2,
      required this.option3,
      required this.answer,
      required this.id});
  @override
  _EditorOptionsState createState() => _EditorOptionsState();
}

class _EditorOptionsState extends State<EditorOptions> {
  String answer = "";

  @override
  void initState() {
    super.initState();
    answer = widget.answer;
  }

  @override
  Widget build(BuildContext context) {
    List options = [
      widget.option1,
      widget.option2,
      widget.option3,
      widget.answer,
    ];
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          optionTile("A", options[0]),
          SizedBox(height: 5.0),
          optionTile("B", options[1]),
          SizedBox(height: 5.0),
          optionTile("C", options[2]),
          SizedBox(height: 5.0),
          optionTile("D", options[3]),
        ],
      ),
    );
  }

  Widget optionTile(
    String label,
    String option,
  ) {
    return InkWell(
      onTap: () {
        updateAnswer(widget.id, option, answer, label);
        setState(() => answer = option);
      },
      child: Row(
        children: [
          Icon(answer == option ? Icons.check_box : Icons.cancel_outlined,
              size: 20.0,
              color: answer == option ? Colors.lightGreen : Colors.red),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 80,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: KaTeX(
                  laTeXCode: Text(
                label + ": " + option,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              )),
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }

  //Professional Answers update
  void updateAnswer(String id, String option, String answer, String label) {
    label == "A"
        ? updateOption1(id, option, answer)
        : label == "B"
            ? updateOption2(id, option, answer)
            : label == "C"
                ? updateOption3(id, option, answer)
                : updateOption4(id);
    displayToast("Answer updated");
  }

  void updateOption1(
    String id,
    String option,
    String answer,
  ) {
    yearOneQuestionsRef.doc(id).update({'answer': option, 'option1': answer});
  }

  void updateOption2(
    String id,
    String option,
    String answer,
  ) {
    yearOneQuestionsRef.doc(id).update({'answer': option, 'option2': answer});
  }

  void updateOption3(
    String id,
    String option,
    String answer,
  ) {
    yearOneQuestionsRef.doc(id).update({'answer': option, 'option3': answer});
  }

  void updateOption4(
    String id,
  ) {
    yearOneQuestionsRef.doc(id).update({
      'answer': widget.answer,
      'option1': widget.option1,
      'option2': widget.option2,
      'option3': widget.option3
    });
  }
}
