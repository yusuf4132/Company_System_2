import 'dart:convert';

import 'package:http/http.dart' as http;

import './configgg.dart';

class DepartmentService {
  
  Future<void> addDepartment(String departmentName, String companyName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/departments'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'departmentName': departmentName,
        'companyName': companyName,
      }),
    );

    if (response.statusCode == 201) {
      print('Departman başarıyla eklendi!');
    } else {
      throw Exception('Departman eklenirken bir hata oluştu: ${response.body}');
    }
  }

  Future<bool> checkIfDepartmentExists(
      String departmentName, String companyName) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/departments/check?departmentName=$departmentName&companyName=$companyName'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['exists'] ?? false;
    } else {
      throw Exception(
          'Departman kontrol edilirken bir hata oluştu: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getDepartmentsByCompany(
      String companyName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/departments?companyName=$companyName'),
    );

    if (response.statusCode == 200) {
      List<dynamic> departments = json.decode(response.body);
      return List<Map<String, dynamic>>.from(departments);
    } else {
      throw Exception(
          'Departmanlar alınırken bir hata oluştu: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getDepartments(String companyName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/departments?companyName=$companyName'),
    );

    if (response.statusCode == 200) {
      List<dynamic> departments = json.decode(response.body);
      return List<Map<String, dynamic>>.from(departments);
    } else {
      throw Exception(
          'Departmanlar alınırken bir hata oluştu: ${response.body}');
    }
  }

  Future<List<String>> getDepartments1(String companyName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/departments/unique?companyName=$companyName'),
    );

    if (response.statusCode == 200) {
      List<dynamic> departments = json.decode(response.body);
      return List<String>.from(departments);
    } else {
      throw Exception(
          'Benzersiz departmanlar alınırken bir hata oluştu: ${response.body}');
    }
  }

  Future<void> deleteDepartment(String departmentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/departments/$departmentId'),
    );

    if (response.statusCode == 200) {
      print('Departman başarıyla silindi!');
    } else {
      throw Exception('Departman silinirken bir hata oluştu: ${response.body}');
    }
  }

  Future<String> getDepartmentNameById(String? departmentId) async {
    print(departmentId);
    final response = await http.get(
      Uri.parse('$baseUrl/departments/name?id=$departmentId'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['name'] ?? 'Bilinmiyor';
    } else {
      throw Exception(
          'Departman adı alınırken bir hata oluştu: ${response.body}');
    }
  }
}
