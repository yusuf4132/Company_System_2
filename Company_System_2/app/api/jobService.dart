import 'dart:convert';
import 'package:http/http.dart' as http;
import './configgg.dart';

class JobService {

  Future<List<Map<String, dynamic>>> getJobsByCompany(
      String companyName, String role, String id) async {
    final url = Uri.parse('$baseUrl/jobs/by/$companyName/$role/$id');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('İşler alınamadı.');
    }
  }

  Future<void> deleteJob(String jobId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/jobs/$jobId'),
    );

    if (response.statusCode != 200) {
      throw Exception('İş silinemedi.');
    }
  }

  Future<List<Map<String, dynamic>>> getJobsy(
      String companyName, String? depName) async {
    String url = '$baseUrl/jobs/byy?companyName=$companyName&depName=$depName';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('İşler alınamadı.');
    }
  }

  Future<void> insertJob(Map<String, dynamic> jobb) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jobs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jobb),
    );

    if (response.statusCode != 201) {
      throw Exception('İş eklenemedi.');
    }
  }


  Future<void> updateJob(
      String id, String subject, String explanation, String date) async {
    final response = await http.put(
      Uri.parse('$baseUrl/jobs/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'subject': subject,
        'explanation':explanation,
        'deadline': date,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('İş güncellenemedi.');
    }
  }

  Future<List<Map<String, dynamic>>> parentJobIdSearch(String jobId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/subj/$jobId'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Alt işler alınamadı.');
    }
  }

  Future<void> updateJobProgressInDatabase(
      String parentjobId, int averageProgress) async {
    final response = await http.put(
      Uri.parse('$baseUrl/jobs/progress'),
      headers: {'Content-Type': 'application/json'},
      body:
          jsonEncode({'parentjobId': parentjobId, 'averageProgress': averageProgress}),
    );

    if (response.statusCode != 200) {
      throw Exception('İlerleme güncellenemedi.');
    }
  }

  Future<void> updateMainJobProgress(String jobId, int value) async {
    final response = await http.put(
      Uri.parse('$baseUrl/jobs/mainj'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'jobId': jobId, 'value': value}),
    );
    int a = response.statusCode;
    if (response.statusCode != 200) {
      throw Exception('Ana iş ilerlemesi güncellenemedi.');
    }
  }
}
