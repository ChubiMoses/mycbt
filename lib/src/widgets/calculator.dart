import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:mycbt/src/services/responsive_helper.dart';
import 'package:mycbt/src/utils/colors.dart';
import 'package:mycbt/src/widgets/buttons.dart';


class MyCalculator extends StatefulWidget {
  @override
  _MyCalculatorState createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
  String strInput = "";
final textControllerInput = TextEditingController();
final textControllerResult = TextEditingController();
  @override
  void initState() {
    super.initState();
    textControllerInput.addListener(() {});
    textControllerResult.addListener(() {});
  }
  @override
  void dispose() {
    textControllerInput.dispose();
    textControllerResult.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 250 : 0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height:45.0,
                child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150.0,
                    child: TextField(
                    decoration:  const InputDecoration.collapsed(
                      hintText: "0",
                      hintStyle: TextStyle(color:Colors.white)
                    ),
                      style: const TextStyle(
                        fontSize: 20,
                       // color:Colors.white,
                         fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.right,
                      controller: textControllerInput,
                      onTap: () =>
                          FocusScope.of(context).requestFocus(new FocusNode()),
                    ),
                  ),
                   Container(
                     width: 100.0,
                child: TextField(
                  decoration: new InputDecoration.collapsed(
                    hintText: "0",
                    hintStyle: TextStyle(color:Colors.black)
                   ),
                  textInputAction: TextInputAction.none,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: 20,
                     // color:Colors.white,
                      fontWeight: FontWeight.bold
                     ),
                  textAlign: TextAlign.left,
                  controller: textControllerResult,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    // ClipboardManager.copyToClipBoard(textControllerResult.text).then((result) {
                    //   Fluttertoast.showToast(
                    //       msg: "Value copied to clipboard!",
                    //       toastLength: Toast.LENGTH_SHORT,
                    //       gravity: ToastGravity.CENTER,
                    //       timeInSecForIos: 1,
                    //       backgroundColor: Colors.blueAccent,
                    //       textColor: Colors.white,
                    //       fontSize: 16.0
                    //   );
                    // });
                  },),
              ),
                ],
              ),
              ),
              SizedBox( height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  btnAC('AC',const Color(0xFFF5F7F9),),
                  btnClear(),
                  btn('%',const Color(0xFFF5F7F9),),
                  btn('/',const Color(0xFFF5F7F9),),],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  btn('7', Colors.white),
                  btn('8', Colors.white),
                  btn('9', Colors.white),
                  btn('*',const Color(0xFFF5F7F9),),],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  btn('4', Colors.white),
                  btn('5', Colors.white),
                  btn('6', Colors.white),
                  btn('-',const Color(0xFFF5F7F9),),],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  btn('1', Colors.white),
                  btn('2', Colors.white),
                  btn('3', Colors.white),
                  btn('+', const Color(0xFFF5F7F9)),],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  btn('0', Colors.white),
                  btn('.', Colors.white),
                  btnEqual('='),],),
              SizedBox(height: 10.0,)],
        ),
      ),
    );
  }
  Widget btn(btntext, Color btnColor) {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: TextButtonWidget(btnText: btntext, 
       onPressed: () {
          setState(() {
            textControllerInput.text = textControllerInput.text + btntext;
          });
        },)
    );
  }

  Widget btnClear() {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: TextButton(
        child: Icon(Icons.backspace, size: 20, color: kWhite),
        onPressed: () {
          textControllerInput.text = (textControllerInput.text.length > 0)
              ? (textControllerInput.text
                  .substring(0, textControllerInput.text.length - 1))
              : "";
        },
        style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(
                    const Color(0xFFF5F7F9),),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(
                          kPrimaryColor),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
      ),
    );
  }
  Widget btnAC(btntext, Color btnColor) {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      child: TextButtonWidget(btnText:btntext,
       onPressed: () {
          setState(() {
            textControllerInput.text = "";
            textControllerResult.text = "";
          });
        },) 
    );
  }
  Widget btnEqual(btnText) {
    return ElevatedButton(
      child: Text(
        btnText,
        style: const TextStyle(fontSize: 20.0, color:kWhite),
      ),
     // color:Colors.lightGreen,
      onPressed: () {
        //Calculate everything here
        // Parse expression:
        Parser p = new Parser();
        // Bind variables:
        ContextModel cm = new ContextModel();
        Expression exp = p.parse(textControllerInput.text);
        setState(() {
          textControllerResult.text =
              "=  "+exp.evaluate(EvaluationType.REAL, cm).toString();
              });
      },
     
    );
  }
}


myCalculator(
  context,
) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MyCalculator();
      });
}
