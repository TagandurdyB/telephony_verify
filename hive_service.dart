import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static save(String phone, String date, String time, bool status) async {
    await Hive.initFlutter();
    await Hive.openBox("Auths");
    final myBase = Hive.box("Auths");
    List phones = myBase.get(1);
    List dates = myBase.get(2);
    List times = myBase.get(3);
    List statuses = myBase.get(4);
    phones.insert(0, phone);
    dates.insert(0, date);
    times.insert(0, time);
    statuses.insert(0, status);
    myBase.put(1, phones);
    myBase.put(2, dates);
    myBase.put(3, times);
    myBase.put(4, statuses);
  }

  static void fillBase() async {
    print("File base");
    await Hive.initFlutter();
    await Hive.openBox("Auths");
    final myBase = Hive.box("Auths");
    myBase.put(1, []);
    myBase.put(2, []);
    myBase.put(3, []);
    myBase.put(4, []);
    print("!File base");

  }

  static List getAll(int index) {
    final myBase = Hive.box("Auths");
    final result = myBase.getAt(index) ?? [];
    print("Hive result:$result");
    return myBase.getAt(index) ?? [];
  }
}
