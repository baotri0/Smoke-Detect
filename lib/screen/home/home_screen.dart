import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constaints/notification.dart';
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
  bool isLoading = false;
  late List<Log> dataListView=[];

  @override
  void initState() {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getLog(appProvider);
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
  }


  // ===========================================================================================
  void getLog(AppProvider appProvider) async {
    List<Log> dataList = await appProvider.fetchLog();
    setState(() {
      dataListView = dataList;
    });
    for (Log data in dataList) {
      if (data.mq2 > 400 && data.isSave == false) {
        await FirebaseFirestoreHelper.instance.addLog(data);
        await Noti.showBigTextNotification(
            title: "Cảnh báo",
            body: "Có phát hiện khói thuốc tại ${data.Area}",
            fln: flutterLocalNotificationsPlugin);
      }

    }
    Future.delayed(const Duration(seconds: 5), () {
      getLog(appProvider);
    });
  }

  TextEditingController search = TextEditingController();
  List<Log> searchList = [];
  void searchProducts(String value) {
    searchList = dataListView
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
            const SizedBox(
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
                                        leading: const Icon(Icons.warning_outlined),
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
                    : dataListView.isEmpty
                        ? const Center(
                            child: Text("History is empty"),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 50),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: dataListView.length,
                              itemBuilder: (ctx, index) {
                                Log singleLog = dataListView[index];
                                return Center(
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.warning_outlined),
                                          title: Text(singleLog.Area),
                                          subtitle: Text("Value: ${singleLog.mq2.toString()}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
            const SizedBox(
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
}
