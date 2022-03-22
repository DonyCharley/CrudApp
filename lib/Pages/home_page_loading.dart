import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageLoading extends StatefulWidget {
  const HomePageLoading({Key? key}) : super(key: key);

  @override
  _HomePageLoadingState createState() => _HomePageLoadingState();
}

class _HomePageLoadingState extends State<HomePageLoading> {
  Timer? _timer;
  int _start = 10; // time to popup still working window /// in seconds

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        setState(() {
          if (_start < 1) {
            _timer!.cancel();
          } else {
            _start = _start - 1;
          }
        });
      });
    }
  }

  buildLoadingShimmerItem(context) {
    List<Widget> list = [];

    for (var i = 0; i < 10; i++) {
      list.add(Container(

        height: 80,
        width: MediaQuery.of(context).size.width / 2.5,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(
              width: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 15,),
                Container(
                  width: 30,
                  height:
                  30,
                  margin: const EdgeInsets.only(right: 30, top: 15),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffefefef),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ]),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      margin: const EdgeInsets.only(top: 40, left: 0),
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffefefef),
                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                          ]),
                    ),

                  ],),



              ],
            ),
          ],
        ),
      ));
    }

    return list;
  }

  buildStillLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      width: MediaQuery.of(context).size.width,
      child: const ListTile(
        title: Text("Please wait..."),
        subtitle: Text(
            "The network seems to be too busy. We suggest you to wait for some more time."),
        leading: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  SizedBox(

        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView(
                    shrinkWrap: true,
                    children: buildLoadingShimmerItem(context))),
            Positioned(
              left: 20,
              right: 20,
              top: 230,
              child: _start == 0 ? buildStillLoadingWidget() : Container(),
            )
          ],
        ));
  }
}
