import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constaints/notification.dart';
import '../../firebase_helper/firebase_firestore.dart';
import '../../model/log_model.dart';
import '../../provider/app_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});
  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  List<Log> warningModelList = [];
  @override
  void initState() {
    getLogList();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  void getLogList() async {
    warningModelList = await FirebaseFirestoreHelper.instance.getLog();
    warningModelList.shuffle();
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
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getLogList();
                });
              },
              icon: const Icon(Icons.cached))
        ],
      ),
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
