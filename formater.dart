class Formater {
  static String twoDigit(int n) {
    return n.toString().padLeft(2, "0");
  }

  static String calendar(DateTime date) {
    return "${twoDigit(date.day)}.${twoDigit(date.month)}.${date.year}";
  }

  static String clock(DateTime date) {
    return "${twoDigit(date.hour)}:${twoDigit(date.minute)}:${twoDigit(date.second)}";
  }

  static String phone(String phone) {
    if (phone[0] == "+") {
      return phone.substring(1);
    }
    return phone;
  }
}
