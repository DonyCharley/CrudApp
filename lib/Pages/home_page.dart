import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_lp/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Utils/common_widgets/common_widgets.dart';
import '../constants/color_path.dart';
import '../models/auth_model.dart';
import '../models/database_model.dart';
import '../providers/database_provider.dart';
import 'home_page_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.data,{Key? key}) : super(key: key);
final  User data;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController tweetController = TextEditingController();

  static final GlobalKey<ScaffoldState> _scaffoldKey =
  GlobalKey<ScaffoldState>();
  final pageStorageBucket = PageStorageBucket();
  bool _isLoading = false;



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return willPop(context);
      },
      child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.blue.shade300,
            elevation: 1.0,
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  willPop(context);
                  // _scaffoldKey.currentState!.openDrawer();
                }),
          ),
          endDrawer: drawer(widget.data ),
          body:  SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Form(
                      key: _formKey,
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            autofocus: true,
                            controller: tweetController,
                            maxLines: 4,
                            textAlign: TextAlign.start,
                            maxLength: 280,

                            validator: (String? arg) {
                              if (arg!.isEmpty) {

                                return 'Please enter some text to tweet';}
                              // } else {
                              //
                              //   return null;
                              // }
                            },
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 24,

                              // color: App24Colors.darkTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: widget.data.photoURL != null
                                  ? Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  width: 60.0,
                                  height: 60.0,
                                  // padding: EdgeInsets.all(50),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.transparent,
                                          width: 2.0,
                                          style: BorderStyle.solid),
                                      image: DecorationImage(
                                          fit: BoxFit.scaleDown,
                                          image: NetworkImage(widget.data.photoURL
                                              .toString()))),
                                  // child:
                                ),
                              )
                                  : Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.transparent,
                                          width: 2.0,
                                          style: BorderStyle.solid)),
                                  child: const Icon(Icons.account_circle)),
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,

                              contentPadding: const EdgeInsets.only(
                                  left: 50, right: 20, bottom: 20, top: 50),
                              //  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              fillColor: Colors.white,
                              filled: true,

                              hintText: "What's happening?",
                              hintStyle: TextStyle(
                                fontSize: MediaQuery.of(context).size.width / 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lightTextColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Database().addNewTweet(
                                    Tweet(tweetText: tweetController.text));
                                tweetController.clear();
                                //FocusScope.of(context).requestFocus(FocusNode());
                              }
                            },
                            child: const Text(
                              "Tweet",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.blue[300],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const TweetList(),

                ],
              ),
            )
          )
    );
  }


  void loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<bool> willPop(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) => exitDialogWidget(context));
  }

  Widget drawer(User data) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.blue,
                    Colors.blue.shade300,
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp),

              // border: Border.all(color: Colors.green),
            ),
            child: Column(
              children: [
                data.photoURL != null
                    ? Container(
                  width: 80.0,
                  height: 80.0,
                  //padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.transparent,
                          width: 2.0,
                          style: BorderStyle.solid),
                      image: DecorationImage(
                          fit: BoxFit.scaleDown,
                          image: NetworkImage(
                              data.photoURL.toString()))),
                  // child:
                )
                    : Container(
                    width: 80.0,
                    height: 80.0,
                    //padding: EdgeInsets.all(50),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.transparent,
                          width: 2.0,
                          style: BorderStyle.solid),
                      /* image: new DecorationImage(
                          fit: BoxFit.scaleDown, image: ())*/
                    ),
                    child: const Icon(Icons.account_circle)),

                Text(
                  data.displayName ?? ' ',
                  style: const TextStyle(
                      fontSize: 17, color: AppColors.darkTextColor),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(
                  Icons.logout,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Log out"),
              ],
            ),
            onTap: () async {

             signout();


            },
            // Update the state of the app.
            // ...
          ),
        ],
      ),
    );
  }



  Future<void> signout() async {


    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:  Text(e.toString()),
        duration: const Duration(seconds: 1),

      ));
    }
  }
}

class TweetList extends StatelessWidget{
  const TweetList( {Key? key}) : super(key: key);
 //final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  @override
  Widget build(BuildContext context) {
   return
     Flexible(

       child: StreamBuilder<QuerySnapshot>(
         stream: Database().allTweets,
         builder: (BuildContext context,
             AsyncSnapshot<QuerySnapshot> snapshot) {
           if (snapshot.hasError) {
             return const Text('Something went wrong');
           }

           if (snapshot.connectionState == ConnectionState.waiting) {
             return const HomePageLoading();
           } else {
             if (snapshot.data!.docs.isNotEmpty) {
               return  Consumer(builder: ( context, ref, _) {

                 final userData = ref.watch(fireBaseAuthProvider);
                 final database = ref.watch(databaseProvider);
                // final _auth = ref.watch(authenticationProvider);
                 return

                   ListView(
                     shrinkWrap: true,
                     padding: const EdgeInsets.only(bottom: 10),
                     physics: const NeverScrollableScrollPhysics(),
                     // padding: EdgeInsets.all(10),
                     children: snapshot.data!.docs
                         .map((DocumentSnapshot document) {
                       Map<String, dynamic> data =
                       document.data()! as Map<String, dynamic>;

                       return Container(
                         margin: const EdgeInsets.all(10),
                         padding: const EdgeInsets.symmetric(
                             horizontal: 15, vertical: 20),
                         // padding: const EdgeInsets.all(10),
                         decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: const BorderRadius.all(
                                 Radius.circular(15)),
                             border: Border.all(
                                 color: Colors.white, width: 1.0)),
                         child: Column(
                           children: [
                             Row(
                               //  crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.end,
                               children: [
                                 userData.currentUser!.photoURL != null
                                     ? Container(
                                   width: 30.0,
                                   height: 30.0,
                                   //padding: EdgeInsets.all(50),
                                   decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       color: Colors.white,
                                       border: Border.all(
                                           color:
                                           Colors.transparent,
                                           width: 2.0,
                                           style:
                                           BorderStyle.solid),
                                       image: DecorationImage(
                                           fit: BoxFit.scaleDown,
                                           image: NetworkImage(
                                               userData
                                                   .currentUser!
                                                   .photoURL
                                                   .toString()))),
                                   // child:
                                 )
                                     : Container(
                                     width: 30.0,
                                     height: 30.0,
                                     //padding: EdgeInsets.all(50),
                                     decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       color: Colors.white,
                                       border: Border.all(
                                           color: Colors.transparent,
                                           width: 2.0,
                                           style: BorderStyle.solid),
                                     ),
                                     child: const Icon(
                                         Icons.account_circle)),
                                 const SizedBox(
                                   width: 10,
                                 ),
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment:
                                     CrossAxisAlignment.start,
                                     children: [
                                       Row(
                                         children: [
                                           Expanded(
                                               child: Text(
                                                 data['tweet'].toString(),
                                                 style: const TextStyle(
                                                     fontWeight:
                                                     FontWeight.w600,
                                                     color: AppColors
                                                         .darkTextColor),
                                               )),
                                           DropdownButtonHideUnderline(
                                             child: DropdownButton<String>(

                                               icon: Icon(Icons.more_horiz),
                                               items: <String>['Edit', 'Delete'].map((String value) {
                                                 return DropdownMenuItem<String>(
                                                   value: value,
                                                   child: Text(value),
                                                 );
                                               }).toList(),
                                               onChanged: (value) async {


                                                 switch (value) {
                                                   case 'Delete':database.removeTweet(
                                                       document.id);
                                                   break;
                                                   case 'Edit': await showDialog(
                                                       context: context,
                                                       builder: (BuildContext
                                                       context) =>
                                                           editDialogWidget(
                                                               context,
                                                               userData,
                                                               data['tweet']
                                                                   .toString(),
                                                               document
                                                                   .id,
                                                               database));
                                                   break;
                                                 }

                                               },
                                             ),
                                           ),


                                         ],
                                       ),
                                       //Text(_posts[i].desc.toString()),
                                       const SizedBox(
                                         height: 10,
                                       ),
                                     ],
                                   ),
                                 ),
                                 // Material(child: InkWell(
                                 //     onTap: (){},
                                 //     child: Icon(Icons.more_horiz))),
                               ],
                             ),
                             const SizedBox(
                               height: 30,
                             )
                           ],
                         ),
                       );
                     }).toList(),
                   );



               } );


             }

             else {
               return Card(
                   margin: const EdgeInsets.all(10),
                   child: Container(
                       height: 80,
                       width: MediaQuery.of(context).size.width,
                       padding: const EdgeInsets.all(30),
                       child: const Text("No Tweets yet!")));
             }
           }
         },
       ),
     );





  }
  

}
