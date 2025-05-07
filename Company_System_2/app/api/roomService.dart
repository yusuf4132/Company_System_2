import 'dart:convert';
import 'package:http/http.dart' as http;
import './configgg.dart';

class RoomService {

  Future<void> addRoom(String roomName, String company, String contens) async {
    final url = Uri.parse('$baseUrl/rooms');
    final response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'name': roomName,
        'contens': content,
        'company': company,
      }),
    );
    int a = response.statusCode;
    print("$a");
    if (response.statusCode == 201) {
      print('Oda başarıyla eklendi!');
    } else {
      throw Exception('Oda eklenirken bir hata oluştu: ${response.body}');
    }
  }

  Future<void> deleteRoom(String roomId) async {
    final url = Uri.parse('$baseUrl/rooms/$roomId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Oda silinirken hata oluştu. ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getRoomsByCompany(
      String companyName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/rooms?companyName=$companyName'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception(
          'Şirkete ait odalar getirilirken hata oluştu. ${response.body}');
    }
  }

  Future<bool> checkIfRoomExists(String roomName) async {
    final url = Uri.parse(
        '$baseUrl/rooms/check?roomName=$roomName'); 
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['exists'] ?? false;

      Map<String, dynamic> data = json.decode(response.body);
      return data.isNotEmpty; 
    } else {
      throw Exception('Oda kontrolü yapılırken hata oluştu. ${response.body}');
    }
  }
}
