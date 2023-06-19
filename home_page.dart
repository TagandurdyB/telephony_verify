import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:telephony/telephony.dart';
// import 'package:telphony_incoming/hive_service.dart';

import 'formater.dart';
import 'http_service.dart';

void _saveToHive(SmsMessage message) async {
  print("*****************Saving to hive!!!");
  await Hive.initFlutter();
  await Hive.openBox("Auths");
  print("here 0");

  final myBase = Hive.box("Auths");
  print("here 1");
  final phone = message.address;
  print("here 02");

  final date = Formater.calendar(DateTime.now());
  print("here 03");

  final time = Formater.clock(DateTime.now());
  print("here 04");

  final bool status =
      await HttpService.sendPhone(Formater.phone(message.address!));
  if (status) {
    print("status ok!");
  } else {
    print("status no!");
  }
  print("here 5");

  myBase.add([phone, date, time, status]);
  print("sdjkasdnas jdhasn d  $phone  $date  $time  $status");
}

onBackgroundMessage(SmsMessage message) {
  debugPrint("Custom onBackgroundMessage called :${message.address}");
  _saveToHive(message);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myBase = Hive.box("Auths");
  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    // HiveService.fillBase();
    //  myBase.add(["+asdassdsd", "12.12.12344", "23:23:45", false]);
    // for (var element in myBase.values) {
    //   print("::::::::: $element}");
    // }
    initPlatformState();
    refresher();
  }

  onMessage(SmsMessage message) async {
    print("Custom onMessage!!!");
    _saveToHive(message);
  }

  int raund = 0;

  void refresher() {
    Future.delayed(const Duration(seconds: 5)).then((value) {
      if (raund < 11) {
        debugPrint("Refresh");
        _onRefresh();
        refresher();
      } else {
        raund = 0;
        debugPrint("Restart");
        _restart();
      }
      raund++;
    });
  }

  Future<void> initPlatformState() async {
    // final bool status = await HttpService.sendPhone("99365168618");
    // if (status) {
    //   print("status ok!");
    // } else {
    //   print("status no!");
    // }
    // HttpService.sendPhone("+99361123016");
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      print("Listening!!!");
      telephony.listenIncomingSms(
        onNewMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
      );
    }

    if (!mounted) return;
  }

  void _restart() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const HomePage()));

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: _restart, icon: const Icon(Icons.restart_alt)),
        centerTitle: true,
        title: const Text('SMS Verificator'),
      ),
      body: RefreshIndicator(
        edgeOffset: 50,
        color: Colors.red,
        onRefresh: _onRefresh,
        // child: const SizedBox()
        child: ListView.separated(
          reverse: true,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.white),
          itemCount: myBase.values.length,
          itemBuilder: (context, index) {
            final base = myBase.values.toList()[index];
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
        ),
      ),
    );
  }

  Future _onRefresh() async {
    setState(() {});
  }
}
