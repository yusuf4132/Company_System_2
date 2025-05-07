import 'dart:convert';
import 'package:http/http.dart' as http;
import './configgg.dart';

class EmployeeService {
 
  Future<bool> updatePassword(String email, String newPassword) async {
    final response = await http.put(
      Uri.parse('$baseUrl/employees/update-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'newPassword': newPassword}),
    );
    return response.statusCode == 200;
  }

  Future<bool> checkIfEmailExists(String email) async {
    final response =
        await http.get(Uri.parse('$baseUrl/employees/check-email/$email'));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['exists'] ?? false;
    } else {
      throw Exception('E-posta kontrolünde hata: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeesByCompany(
      String companyName) async {
    final response =
        await http.get(Uri.parse('$baseUrl/employees/company/$companyName'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Şirkete göre çalışanlar alınamadı: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeesByRoleAndCompany(
      String companyName, String role, String? departmentId) async {
    final url = Uri.parse(
        '$baseUrl/employees/role/$companyName/$role?departmentId=$departmentId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception(
          'Rol ve şirkete göre çalışanlar alınamadı: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeesBySearch(
    String companyName,
    String role,
    String? departmentId,
    String? searchQuery,
  ) async {
    final uri = Uri.parse(
        '$baseUrl/employees/role2/$companyName/$role?departmentId=$departmentId&searchQuery=$searchQuery');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Aramalı çalışan listesi alınamadı: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeesByAdvancedSearch(
    String companyName,
    String role,
    String? departmentId,
    String? searchQuery,
  ) async {
    final uri = Uri.parse(
        '$baseUrl/employees/role3/$companyName/$role?departmentId=$departmentId&searchQuery=$searchQuery');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Gelişmiş filtreli liste alınamadı: ${response.body}');
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/employees/$employeeId'));
    if (response.statusCode != 200) {
      throw Exception('Çalışan silinemedi: ${response.body}');
    }
  }

  Future<String> getEmployeeNameById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/employees/name/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name'];
    } else {
      return 'Bilinmiyor';
    }
  }

  Future<String> getEmployeeIdById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/employees/bnm/$id'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['id'].toString();
    } else {
      return "Bilinmiyor";
    }
  }

  Future<void> updateEmployee(
      String id, Map<String, dynamic> updatedData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/employees/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedData),
    );
    if (response.statusCode != 200) {
      throw Exception('Çalışan güncellenemedi: ${response.body}');
    }
  }

  Future<void> insertEmployee(Map<String, dynamic> employee) async {
    final response = await http.post(
      Uri.parse('$baseUrl/employees'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee),
    );
    if (response.statusCode != 201) {
      throw Exception('Çalışan eklenemedi: ${response.body}');
    }
  }

  Future<bool> validateUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/employees/validate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['valid'] ?? false;
    } else {
      throw Exception('Kullanıcı doğrulanamadı: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final response =
        await http.get(Uri.parse('$baseUrl/employees/email/$email'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Kullanıcı bulunamadı: ${response.body}');
    }
  }
}
