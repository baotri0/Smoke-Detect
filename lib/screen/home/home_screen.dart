import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:detect_smoke/model/warning_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constaints/notification.dart';
import '../../fetch_data/fetch_data.dart';
import '../../firebase_helper/firebase_firestore.dart';
import '../../model/log_model.dart';
import '../../provider/app_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
  bool isMq2AboveThreshold1 = false;
  bool isMq2AboveThreshold2 = false;
  late Log _log = Log(mq2: 0, Area: "");
  late Log _log1 = Log(mq2: 0, Area: "");

  @override
  void initState() {
    getLogList();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getLog(appProvider);
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
    print(warningModelList.length);
  }

  void getLogList() async {
    print('getLogList');
    warningModelList = await FirebaseFirestoreHelper.instance.getLog();
    warningModelList.shuffle();
    print(warningModelList.length);
  }
  // ===========================================================================================
  void getLog(AppProvider appProvider) async {
    print("getLog(AppProvider appProvider)");
    if(await appProvider.fetchLog() && await appProvider.fetchLog1()){
      print("2 cảm biến hoạt động");
      _log = appProvider.getLog;
      _log1 = appProvider.getLog1;
      int mq2Value = _log.mq2;
      int mq2Value1 = _log1.mq2;

      // Khói tại 2 cảm biến
      if (mq2Value>1100&&mq2Value1>1100) {
        print("Khói tại 2 cảm biến");
        if (!isMq2AboveThreshold2) {
          if (mounted) {
            setState(() {
              _log = appProvider.getLog;
              _log1 = appProvider.getLog1;
              isMq2AboveThreshold2 = true;
            });
          }
          await FirebaseFirestoreHelper.instance.addLog(_log);
          await FirebaseFirestoreHelper.instance.addLog(_log1);
          await Noti.showBigTextNotification(
              title: "Cảnh báo",
              body: "Có phát hiện khói thuốc tại cả 2 khu vực",
              fln: flutterLocalNotificationsPlugin);
          playSound();
          _timer1 = Timer.periodic(Duration(seconds: 3), (timer) async {
            playSound();
          });
          await showAlertDialog2(context);
          getLogList();
        } else {
          if (mounted) {
            setState(() {
              _log = appProvider.getLog;
              _log1 = appProvider.getLog1;
              isMq2AboveThreshold2 = true;
            });
          }
        }
      }
      else {
        if (isMq2AboveThreshold2) {
          print("Reset trạng thái: Mq2 không lớn hơn 1100");
          //isMq2AboveThreshold = false;
          if (mounted) {
            setState(() {
              _log = appProvider.getLog;
              _log1 = appProvider.getLog1;
              isMq2AboveThreshold2 = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _log = appProvider.getLog;
              _log1 = appProvider.getLog1;
              isMq2AboveThreshold2 = false;
            });
          }
        }

        if (mq2Value>1100&&mq2Value1<1100) {
          print("Khói tại cảm biến 1");
          if (!isMq2AboveThreshold) {
            if (mounted) {
              setState(() {
                _log = appProvider.getLog;
                isMq2AboveThreshold = true;
              });
            }
            await FirebaseFirestoreHelper.instance.addLog(_log);
            await Noti.showBigTextNotification(
                title: "Cảnh báo",
                body: "Có phát hiện khói thuốc tại ${_log.Area}",
                fln: flutterLocalNotificationsPlugin);
            playSound();
            _timer1 = Timer.periodic(Duration(seconds: 3), (timer) async {
              playSound();
            });
            await showAlertDialog(context,_log);
            getLogList();
          } else {
            if (mounted) {
              setState(() {
                _log = appProvider.getLog;
                isMq2AboveThreshold = true;
              });
            }
          }
        } else {
          if (isMq2AboveThreshold) {
            print("Reset trạng thái: Mq2 không lớn hơn 1100");
            //isMq2AboveThreshold = false;
            if (mounted) {
              setState(() {
                _log = appProvider.getLog;
                isMq2AboveThreshold = false;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _log = appProvider.getLog;
                isMq2AboveThreshold = false;
              });
            }
          }
        }

        // Khói tại cảm biến 2
        if (mq2Value<1100&&mq2Value1>1100) {
          print("Khói tại cảm biến 2");
          if (!isMq2AboveThreshold1) {
            if (mounted) {
              setState(() {
                _log1 = appProvider.getLog1;
                isMq2AboveThreshold1 = true;
              });
            }
            await FirebaseFirestoreHelper.instance.addLog(_log1);
            await Noti.showBigTextNotification(
                title: "Cảnh báo",
                body: "Có phát hiện khói thuốc tại ${_log1.Area}",
                fln: flutterLocalNotificationsPlugin);
            playSound();
            _timer1 = Timer.periodic(Duration(seconds: 3), (timer) async {
              playSound();
            });
            await showAlertDialog(context,_log1);
            getLogList();
          } else {
            if (mounted) {
              setState(() {
                _log1 = appProvider.getLog1;
                isMq2AboveThreshold1 = true;
              });
            }
          }
        } else {
          if (isMq2AboveThreshold1) {
            print("Reset trạng thái: Mq2 không lớn hơn 1100");
            //isMq2AboveThreshold = false;
            if (mounted) {
              setState(() {
                _log1 = appProvider.getLog1;
                isMq2AboveThreshold1 = false;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _log1 = appProvider.getLog1;
                isMq2AboveThreshold1 = false;
              });
            }
          }
        }
      }

      // Khói tại cảm biến 1

      ///2 cảm biến không hoạt động cùng lúc2 cảm biến không hoạt động cùng lúc2 cảm biến không hoạt động cùng lúc2 cảm biến không hoạt động cùng lúc2 cảm biến không hoạt động cùng lúc2 cảm biến không hoạt động cùng lúc
    }else{
      print("2 cảm biến không hoạt động cùng lúc");
      if(await appProvider.fetchLog()){
        print("cảm biến 1 hoạt động");
        _log = appProvider.getLog;
        int mq2Value = _log.mq2;
        if (mq2Value > 1100) {
          print("Khói tại cảm biến 1");
          if (!isMq2AboveThreshold) {
            if (mounted) {
              setState(() {
                _log = appProvider.getLog;
                isMq2AboveThreshold = true;
              });
            }
            await FirebaseFirestoreHelper.instance.addLog(_log);
            await Noti.showBigTextNotification(
                title: "Cảnh báo",
                body: "Có phát hiện khói thuốc tại ${_log.Area}",
                fln: flutterLocalNotificationsPlugin);
            playSound();
            _timer1 = Timer.periodic(Duration(seconds: 3), (timer) async {
              playSound();
            });
            await showAlertDialog(context,_log);
            getLogList();
          } else {
            if (mounted) {
              setState(() {
                _log = appProvider.getLog;
                isMq2AboveThreshold = true;
              });
            }
          }
        } else {
          if (isMq2AboveThreshold) {
            print("Reset trạng thái: Mq2 không lớn hơn 200");
            //isMq2AboveThreshold = false;
            if (mounted) {
              setState(() {
                _log = appProvider.getLog;
                isMq2AboveThreshold = false;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _log = appProvider.getLog;
                isMq2AboveThreshold = false;
              });
            }
          }
        }
      }else {
        if (mounted) {
            _log = Log(mq2: 0, Area: "");
        print("cảm biến 1 không hoạt động");
        }

      if(await appProvider.fetchLog1()){
        print("cảm biến 2 hoạt động");
        _log1 = appProvider.getLog1;
        int mq2Value = _log1.mq2;
        if (mq2Value > 1100) {
          print("Khói tại cảm biến 2");
          if (!isMq2AboveThreshold1) {
            if (mounted) {
              setState(() {
                _log1 = appProvider.getLog1;
                isMq2AboveThreshold1 = true;
              });
            }
            await FirebaseFirestoreHelper.instance.addLog(_log1);
            await Noti.showBigTextNotification(
                title: "Cảnh báo",
                body: "Có phát hiện khói thuốc tại ${_log1.Area}",
                fln: flutterLocalNotificationsPlugin);
            playSound();
            _timer1 = Timer.periodic(Duration(seconds: 3), (timer) async {
              playSound();
            });
            await showAlertDialog(context,_log1);
            getLogList();
          } else {
            if (mounted) {
              setState(() {
                _log1 = appProvider.getLog1;
                isMq2AboveThreshold1 = true;
              });
            }
          }
        } else {
          if (isMq2AboveThreshold1) {
            print("Reset trạng thái: Mq2 không lớn hơn 200");
            //isMq2AboveThreshold = false;
            if (mounted) {
              setState(() {
                _log1 = appProvider.getLog1;
                isMq2AboveThreshold1 = false;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _log1 = appProvider.getLog1;
                isMq2AboveThreshold1 = false;
              });
            }
          }
        }
      }else {
        print("cảm biến 2 không hoạt động");
      }
    }
    Future.delayed(Duration(seconds: 5), () async {
      if (mounted) {
        setState(() {
        });
      }
      getLog(appProvider);
    });
  }
  // ===========================================================================================

  void playSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('warning.mp3'));
  }

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
              height: 24.0,
            ),
            !isSearched()
                ? const Padding(
                    padding: EdgeInsets.only(top: 12.0, left: 12.0),
                    child: Text(
                      "Dash board",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox.fromSize(),
            SizedBox(
              height: 12,
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "MQ2 Khu vực 1:",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  _log.mq2 != 0
                      ? Text(
                          _log.mq2.toString(),
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        )
                      : const Text(
                          "No Signal",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "MQ2 Khu vực 2:",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  _log1.mq2 != 0
                      ? Text(
                    _log1.mq2.toString(),
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )
                      : const Text(
                    "No Signal",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "History",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            search.text.isNotEmpty && searchList.isEmpty
                ? const Center(
                    child: Text("No History Found"),
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
                                        leading: Icon(Icons.warning_outlined),
                                        title: Text(singleLog.Area),
                                        subtitle: Text(singleLog.createdOn!
                                            .toDate()
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
                            child: Text("History is empty"),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 50),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: warningModelList.length,
                              itemBuilder: (ctx, index) {
                                Log singleLog = warningModelList[index];
                                return Center(
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.warning_outlined),
                                          title: Text(singleLog.Area),
                                          subtitle: Text(singleLog.createdOn!
                                              .toDate()
                                              .toString()),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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

  showAlertDialog(BuildContext context,Log log) {
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
      content: Text("Có phát hiện khói thuốc tại ${log.Area}"),
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

  showAlertDialog2(BuildContext context) {
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
      content: Text("Có phát hiện khói thuốc tại 2 khu vực"),
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
