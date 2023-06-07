import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:telephony/telephony.dart';
// import 'package:telphony_incoming/hive_service.dart';

import 'formater.dart';
import 'http_service.dart';

void _saveToHive(SmsMessage message) async {
  print("*****************Saving to hive!!!");
  // HiveService.save(
  //   message.address!,
  //   Formater.calendar(DateTime.now()),
  //   Formater.clock(DateTime.now()),
  //   await HttpService.sendPhone(message.address!),
  // );
  await Hive.initFlutter();
  await Hive.openBox("Auths");
  print("here 0");

  final myBase = Hive.box("Auths");
  print("here 1");
  final phone = message.address;
  print("here 2");

  final date = Formater.calendar(DateTime.now());
  print("here 3");

  final time = Formater.clock(DateTime.now());
  print("here 4");

  final status = await HttpService.sendPhone(message.address!);
  print("here 5");

  myBase.add([phone, date, time, status]);
  print("sdjkasdnas jdhasn d  $phone  $date  $time  $status");

  // await HiveService.save("phone", message.address!);
  // await HiveService.save("date", Formater.calendar(DateTime.now()));
  // await HiveService.save("time", Formater.clock(DateTime.now()));
  // await HiveService.save(
  //     "status", await HttpService.sendPhone(message.address!));
}

onBackgroundMessage(SmsMessage message) {
  _saveToHive(message);
  debugPrint("onBackgroundMessage called :${message.address}");
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _message = "";
  final myBase = Hive.box("Auths");
  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    // HiveService.fillBase();
    //  myBase.add(["+asdassdsd", "12.12.12344", "23:23:45", false]);
    for (var element in myBase.values) { print("::::::::: $element}");}
    print("sadasdasdasdsssssssssssssssss ${myBase.values.length}");
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    _saveToHive(message);
    print("onMessage!!!");
    setState(() {
      _message = message.address ?? "Error reading message body.";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      print("Listening!!!");
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SMS Verificator'),
      ),
      body: RefreshIndicator(
        edgeOffset: 50,
        color: Colors.red,
        onRefresh: _onRefresh,
        // child: const SizedBox()
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.white),
          itemCount: myBase.values.length,
          itemBuilder: (context, index) {
            // final phone = HiveService.getAll(1)[index];
            // final date = HiveService.getAll(2)[index];
            // final time = HiveService.getAll(3)[index];
            // final status = HiveService.getAll(4)[index];
            final base = myBase.values.toList()[index];
            // final date = myBase.get(2)[index];
            // final time = myBase.get(3)[index];
            // final status = myBase.get(4)[index];
            return ListTile(
              leading: Text(base[0]),
              title: Center(
                child: Column(children: [Text(base[1]), Text(base[2])]),
              ),
              trailing: CircleAvatar(
                backgroundColor: base[3] ? Colors.green : Colors.red,
                child: Text(
                  base[3] ? "OK" : "NO",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
          // myBase.values.map((e) => ListTile(leading: Text("$e"))).toList(),
        ),
      ),
    );
  }

  Future _onRefresh() async {
    setState(() {});
  }
}
