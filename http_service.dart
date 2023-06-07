import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  Future<bool> sendPhone(String phone) async {
    // final url = Uri.parse("https://it.net.tm/arzanapi/api/v1/auth/user/login");
    final url = Uri.parse("http://it.net.tm:8888/activatesms");

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
      },
      body: {
        "phone": phone,
        "statpass": "x0777y",
      },
    ).then((response) {
      // if (response.statusCode == 200) {
      //   return json.decode(response.body)["status"];
      // } else {
      //   print("Error! statusCode:${response.statusCode} ");
      //   print("Error! :${response.body} ");
      //   return json.decode(response.body)["status"];
      // }
      print("here 01 $phone");
      if (response.statusCode == 200) {
        print("here 02");
        // print("*** ${json.decode(response.body)}");
        // print("Success ${jsonDecode(response.body)}");
      } else {
        print("here 03");
        print("error!!!!!!!!!!!!!!!!!!!");
      }
      // final status = json.decode(response.body)["status"];
      final status = {"status": "true", "result": "activated", "reply": ""};
      // return status == "true" ? true : false;
      return true;
    });
  }
}
