import 'dart:convert';
import 'package:http/http.dart' as http;

class BitrixApiService {
  static const String baseUrl = 'https://bitrix.rsotomotivgrubu.com/rest/5/rzlhpc35jnun7co7/';
  static const String clientId = 'nsuyjbvdegae7kr3kn36hdg025z78o70';
  static const String apiToken = "1s4hb3rvcluzd9k2olxkzzn5a6bfqoov";
  final Map<String, String> headers = {"Authorization": "Bearer $apiToken"};

  Future<dynamic> shareMessage(String dialogId, String messageId) async {
    final url = Uri.parse('$baseUrl/im.message.share.json?BOT_ID=724&CLIENT_ID=$clientId&DIALOG_ID=$dialogId&MESSAGE_ID=$messageId');
    final response = await http.post(url, headers: headers);
    
    
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Bilinmeyen Hata!. Hata Kodu:${response.statusCode}');
    }
  }

  Future<dynamic> sendMessage(String dialogId, String message) async {
    final url = Uri.parse('$baseUrl/imbot.message.add.json?BOT_ID=724&CLIENT_ID=$clientId&DIALOG_ID=$dialogId&MESSAGE=$message');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final dateStart = responseData['time']['date_start'];
      print(dateStart);
      return responseData;
    } else {
      throw Exception('Bilinmeyen Hata!. Hata Kodu:${response.statusCode}');
    }
  }

  Future<dynamic> getDialogMessages(String dialogId) async {
    final url = Uri.parse('$baseUrl/im.dialog.messages.get.json?DIALOG_ID=$dialogId');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      return responseData;
    } else {
      throw Exception('Bilinmeyen Hata!. Hata Kodu: ${response.statusCode}');
    }
  }

  Future<dynamic> getDialogDetails(String dialogId) async {
    final url = Uri.parse('$baseUrl/im.dialog.get.json?DIALOG_ID=$dialogId');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Bilinmeyen Hata!. Hata Kodu: ${response.statusCode}');
    }
  }
}
