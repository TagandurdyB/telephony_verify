import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<bool> sendPhone(String phone) async {
    
    final url = Uri.parse("http://it.net.tm:8888/activatesms");
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
      },
      body: jsonEncode({"phone": phone, "statpass": "x0777y"}),
    ).then((response) {
      // if (response.statusCode == 200) {
      //   return json.decode(response.body)["status"];
      // } else {
      //   print("Error! statusCode:${response.statusCode} ");
      //   print("Error! :${response.body} ");
      //   return json.decode(response.body)["status"];
      // }
      print("here 0");
      if (response.statusCode == 200) {
         print("here 1");
        print("Success ${json.decode(response.body)["status"]}");
      } else {
         print("here 2");
        print("error!!!!!!!!!!!!!!!!!!!");
      }
      final status = json.decode(response.body)["status"]=="true";
      return status;
    });
  }
}
