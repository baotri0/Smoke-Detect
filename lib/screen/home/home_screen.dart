import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:detect_smoke/model/warning_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../fetch_data/fetch_data.dart';
import '../../firebase_helper/firebase_firestore.dart';
import '../../model/log_model.dart';
import '../../provider/app_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Log> warningModelList = [];
  bool isLoading = false;
  //late Future<Log> futureAlbum;
  ///List<Log> albumList = [];
  late Timer _timer1;
  bool isMq2AboveThreshold = false;

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getLog(appProvider);
    getLogList();
    print('cccccccccccccccccccccccccccc');
    super.initState();
  }
  void getLogList() async {
    warningModelList = await FirebaseFirestoreHelper.instance.getLog();
    warningModelList.shuffle();
    print('bbbbbbbbbbbbbbbbbbbbbb');
    print(warningModelList.length);
  }

  void getLog(AppProvider appProvider) async {
      await appProvider.fetchLog();
      Log log = appProvider.getLog;
      int mq2Value = log.mq2;
      print(log);
      print(mq2Value);
      print(isMq2AboveThreshold);

      if (mq2Value > 250) {
        if (!isMq2AboveThreshold) {
          setState(() {
            isMq2AboveThreshold = true;
          });
          await FirebaseFirestoreHelper.instance.addLog(log);
          playSound();
          _timer1 = Timer.periodic(Duration(seconds: 3), (timer) {
            playSound();
          });
          showAlertDialog(context);
          print(log.Area);
          // isMq2AboveThreshold = true;
          print(isMq2AboveThreshold);
          getLogList();
        }else{
          setState(() {
            isMq2AboveThreshold = true;
          });
        }
      } else {
        if (isMq2AboveThreshold) {
          print("Reset trạng thái: Mq2 không lớn hơn 200");
          //isMq2AboveThreshold = false;
          setState(() {
            isMq2AboveThreshold = false;
          });
        }
      }
      print('aaaaaaaaaaaaaaaaaaaaa');
      Future.delayed(Duration(seconds: 5), () {
        getLog(appProvider);
      });

  }

  void playSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('warning.mp3'));
  }

  // void getAlbum() async {
  //   futureAlbum = fetchAlbum();
  // }

  TextEditingController search = TextEditingController();
  List<Log> searchList = [];
  void searchProducts(String value) {
    searchList = warningModelList
        .where((element) =>
            element.Area.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12.0,
                  ),
                  !isSearched()
                      ? const Padding(
                          padding: EdgeInsets.only(top: 12.0, left: 12.0),
                          child: Text(
                            "All Log",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : SizedBox.fromSize(),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: search,
                      onChanged: (String value) {
                        searchProducts(value);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Search....",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  search.text.isNotEmpty && searchList.isEmpty
                      ? const Center(
                          child: Text("No Log Found"),
                        )
                      : searchList.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 50),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: searchList.length,
                                  itemBuilder: (ctx, index) {
                                    Log singleLog = searchList[index];
                                    return Center(
                                      child: Card(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading:
                                                  Icon(Icons.warning_outlined),
                                              title: Text(singleLog.Area),
                                              subtitle: Text(singleLog.createdOn
                                                  !.toDate()
                                                  .toString()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : warningModelList.isEmpty
                              ? const Center(
                                  child: Text("Log is empty"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ListView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 50),
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: warningModelList.length,
                                      itemBuilder: (ctx, index) {
                                        Log singleLog =
                                            warningModelList[index];
                                        return Center(
                                          child: Card(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading: Icon(
                                                      Icons.warning_outlined),
                                                  title: Text(singleLog.Area),
                                                  subtitle: Text(singleLog
                                                      .createdOn!.toDate()
                                                      .toString()),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      child: Text("aaaaaa"),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
    );
  }

  bool isSearched() {
    if (search.text.isNotEmpty && searchList.isEmpty) {
      return true;
    } else if (search.text.isEmpty && searchList.isNotEmpty) {
      return false;
    } else if (searchList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget continueButton = TextButton(
      child: Text("Xác nhận"),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
        _timer1.cancel();
        //getCategoryList();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      icon: Icon(Icons.warning_outlined),
      title: Text("Cảnh báo"),
      content: Text("Có phát hiện khói thuốc"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
