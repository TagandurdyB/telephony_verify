import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<bool> sendPhone(String phone, bool isRecover) async {
    final url = Uri.parse("http://95.85.126.113:8080/api/v1/account/verify");
    print("phone:=+$phone");
    print("request:=${{
      "phone": "+$phone",
      "statpass": "x0777y45Sd",
      "recover": isRecover
    }}");
    return await http
        .post(
      url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "charset": "utf-8"
      },
      body: json.encode(
          {"phone": "+$phone", "statpass": "x0777y45Sd", "recover": isRecover}),
    )
        .then((response) {
      // if (response.statusCode == 200) {
      //   return json.decode(response.body)["status"];
      // } else {
      //   print("Error! statusCode:${response.statusCode} ");
      //   print("Error! :${response.body} ");
      //   return json.decode(response.body)["status"];
      // }
      final res = json.decode(response.body);
      final status = res["status"];
      print("responser :=$res");
      if (response.statusCode == 200) {
        print("here 1");
        print("Success $status");
      } else {
        print("here 2");
        print("error!!!!!!!!!!!!!!!!!!!");
      }
      return status;
    });
  }
}
