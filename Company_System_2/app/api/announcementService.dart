import 'dart:convert';

import 'package:http/http.dart' as http;

import './configgg.dart';

class AnnouncementService {
  Future<void> insertAnnouncement(
    String announcer,
    String content,
    String company,
    String? departmentId,
  ) async {
    final announcement = {
      'announcer': announcer,
      'content': content,
      'company': company,
      'departmentid': departmentId,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/announcements'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(announcement), 
    );

    if (response.statusCode == 201) {
      print('Duyuru başarıyla eklendi.');
    } else {
      throw Exception('Failed to insert announcement');
    }
  }

  Future<void> updateAnnouncement(
      String announceId, String announcer, String content) async {
    final response = await http.put(
      Uri.parse('$baseUrl/announcements/$announceId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'announcer': announcer,
        'content': content,
      }),
    );

    if (response.statusCode == 200) {
      print('Duyuru başarıyla güncellendi.');
    } else {
      throw Exception('Failed to update announcement');
    }
  }

  // 3. Duyuru Silme
  Future<void> deleteAnnouncement(String announceId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/announcements/$announceId'), 
    );

    if (response.statusCode == 200) {
      print('Duyuru başarıyla silindi.');
    } else {
      throw Exception('Failed to delete announcement');
    }
  }

  Future<List<Map<String, dynamic>>> getAnnouncementsByCompany(
      String companyName, String? dep_Id) async {
    String url =
        '$baseUrl/announcements?companyName=$companyName&dep_id=$dep_Id';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(responseBody);
    } else {
      throw Exception('Failed to load announcements');
    }
  }
}
