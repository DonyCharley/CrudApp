library common_widgets;
import 'package:crud_lp/providers/database_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextEditingController tweetController=TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
Widget exitDialogWidget(context) {
  return SimpleDialog(
    contentPadding:const  EdgeInsets.all(10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
    children: <Widget>[
       SizedBox(
        height: 240.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
         
            Center(
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Center(
                  child: Text(
                    'Are you sure you want to exit?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  icon:const Icon(Icons.close, size: 32),
                ),
                IconButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  icon: Icon(
                    Icons.check,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ],
  );
}
Widget editDialogWidget(context, FirebaseAuth userData, String tweet, String documentID, Database database,  ) {
  tweetController.text=tweet;
   tweetController.selection = TextSelection.fromPosition(TextPosition(offset: tweetController.text.length));
  return SimpleDialog(

    contentPadding:const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
    children: <Widget>[
      SizedBox(

        height: 200.0,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Center(child:Text("Edit Tweet",style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 24,
                // color: App24Colors.darkTextColor,
                fontWeight: FontWeight.w600,
              ),)),
              //Divider(thickness: 1.0,endIndent: 10,indent: 10,),

              Padding (
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: TextFormField(

                  controller: tweetController,
                  maxLines: 3,

                  textAlign: TextAlign.start,
                  maxLength: 280,

                  validator: ( arg) {


                    if (arg!.isEmpty) {

                      return 'Please type something';
                    } else {

                      return null;
                    }
                  },
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 24,
                    // color: App24Colors.darkTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                  // decoration: InputDecoration(
                  //   // prefixIcon: /* userData.currentUser!.photoURL!=null?    Container(
                  //   //   width: 30.0,
                  //   //   height: 30.0,
                  //   //   //padding: EdgeInsets.all(50),
                  //   //   decoration: BoxDecoration(
                  //   //       shape: BoxShape.circle,
                  //   //       color: Colors.white,
                  //   //       border: Border.all(
                  //   //           color: Colors.transparent,
                  //   //           width: 2.0,
                  //   //           style: BorderStyle.solid),
                  //   //       image: DecorationImage(
                  //   //           fit: BoxFit.scaleDown, image: NetworkImage(userData.currentUser!.photoURL.toString()))),
                  //   //   // child:
                  //   // ): */Container(
                  //   //     width: 30.0,
                  //   //     height: 30.0,
                  //   //     //padding: EdgeInsets.all(50),
                  //   //     decoration:  BoxDecoration(
                  //   //       shape: BoxShape.circle,
                  //   //       color: Colors.white,
                  //   //       border: Border.all(
                  //   //           color: Colors.transparent,
                  //   //           width: 2.0,
                  //   //           style: BorderStyle.solid),
                  //   //       /* image: new DecorationImage(
                  //   //           fit: BoxFit.scaleDown, image: ())*/),
                  //   //     child: const Icon(Icons.account_circle)
                  //   //
                  //   // ),
                  //
                  //   border: InputBorder.none,
                  //   errorBorder: InputBorder.none,
                  //   disabledBorder: InputBorder.none,
                  //   contentPadding:EdgeInsets.only(left: 50,right: 20,bottom: 20,top:50),
                  //   // contentPadding:
                  //   // const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  //   fillColor: Colors.white,
                  //   filled: true,
                  //   //hintText: tweet,
                  //   hintStyle: TextStyle(
                  //       fontSize: MediaQuery.of(context).size.width / 24,
                  //       fontWeight: FontWeight.w600,
                  //       color: Color(0xff929292)),
                  //   focusedBorder: OutlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.white),
                  //     borderRadius: BorderRadius.circular(15),
                  //   ),
                  //   enabledBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.white),
                  //     borderRadius: BorderRadius.circular(15),
                  //   ),
                  // ),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onPressed: () {
                 // cartContentBody["retweet"] = tweetController.text;
                  if (_formKey.currentState!.validate()) {
                    Database().editTweet(tweetController.text, documentID);
                    Navigator.pop(context);
                  }


                },
                child: const Text(
                  "Retweet",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}



