import 'dart:convert';
import 'package:http/http.dart' as http;
import './configgg.dart';

class ProgressService {
  
  Future<void> addProgress(String jobId, String userId, int progressValue,
      String timestamp, String companyName) async {
    final progressData = {
      'task_id': jobId,
      'user_id': userId,
      'progress': progressValue,
      'registration_date': timestamp,
      'company': companyName,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/progress'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(progressData),
    );

    if (response.statusCode == 201) {
      print('İlerleme başarıyla eklendi.');
    } else {
      throw Exception('İlerleme eklenemedi: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getProgressByJobId(String jobId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/progress/$jobId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('İlerleme verileri alınamadı: ${response.body}');
    }
  }
}
