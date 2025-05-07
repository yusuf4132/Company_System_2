import 'dart:convert';
import 'package:http/http.dart' as http;
import './configgg.dart';

class ReservationService {

  Future<List<Map<String, dynamic>>> getReservationsByCompany(
      String companyName) async {
    final response = await http
        .get(Uri.parse('$baseUrl/reservations?companyName=$companyName'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    } else {
      throw Exception('Rezervasyonlar alınamadı');
    }
  }

  Future<void> deleteReservation(String reservationId) async {
    final url = Uri.parse('$baseUrl/reservations/$reservationId');
    final response = await http.delete(url);
    int a = response.statusCode;
    print(a);
    if (response.statusCode != 200) {
      throw Exception('Rezervasyon silinemedi');
    }
  }

  Future<bool> checkReservationConflict(
      String roomId, String startTime, String endTime) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservations/check'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'roomId': roomId,
        'startTime': startTime,
        'endTime': endTime,
      }),
    );
    int a = response.statusCode;
    print(a);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['conflict'] as bool;
    } else {
      throw Exception('Çakışma kontrolü başarısız');
    }
  }

  Future<bool> isRoomAvailable(
      String roomId, String startTime, String endTime) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservations/checkavailability'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'roomId': roomId,
        'startTime': startTime,
        'endTime': endTime,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['available'] as bool;
    } else {
      throw Exception('Uygunluk kontrolü başarısız');
    }
  }

  Future<void> addReservation(
    String roomId,
    String startTime,
    String endTime,
    String companyName,
    String owner,
    String? content,
    String? department,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'roomId': roomId,
        'startTime': startTime,
        'endTime': endTime,
        'companyName': companyName,
        'owner': owner,
        'content': content,
        'department': department,
      }),
    );

    if (response.statusCode != 201) {
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Rezervasyon eklenemedi: ${response.body}');
    }
  }
}
