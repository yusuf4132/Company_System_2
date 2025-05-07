import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../api/DepartmentService.dart';

class PersonelAddPages extends StatefulWidget {
  final String email;
  PersonelAddPages({
    required this.email,
  });
  @override
  State<PersonelAddPages> createState() => _PersonelAddPagesState();
}

class _PersonelAddPagesState extends State<PersonelAddPages> {
  String companyName = "";
  String? _gender = '';
  late DepartmentService _departmentService;
  late EmployeeService _employeeService;
  String? selectedValue;
  String? selectedValue1;
  bool showExpertiseField = false;
  bool showDepartmentField = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _departmentService = DepartmentService();
    _employeeService = EmployeeService();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        companyName = employee['company'];
        String role = employee['role'];

        if (role == 'admin') {
          showExpertiseField = false;
          showDepartmentField = true;
        } else if (role == 'department_manager') {
          showExpertiseField = true;
          showDepartmentField = false;
        }
      });
    }
  }

  Future<void> _saveEmployee() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String phone = _phoneController.text;
    double? salary = double.tryParse(_salaryController.text) ?? 0.0;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String gender = _gender ?? '';
    String? expertise =
        _expertiseController.text.isEmpty ? null : _expertiseController.text;

    if (password != confirmPassword) {
      // If the passwords don't match, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifreler uyuşmuyor!')),
      );
      return; // Exit the function early, preventing further execution
    }
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geçerli bir e-posta adresi girin!')),
      );
      return;
    }
    bool emailExists = await _employeeService.checkIfEmailExists(email);
    if (emailExists) {
      // If the email already exists, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bu e-posta adresi zaten kayıtlı!')),
      );
      return; // Exit the function early
    }
    String role = showExpertiseField
        ? 'staff'
        : 'department_manager'; // Based on the current user role
    String? departmentId;
    if (selectedValue != null) {
      departmentId = await _getDepartmentId(selectedValue!);
    } else {
      departmentId =
          await _getDefaultDepartmentId();
    }

    if (name.isNotEmpty &&
        surname.isNotEmpty &&
        phone.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        departmentId != null) {
      await _employeeService.insertEmployee({
        'name': name,
        'surname': surname,
        'phone': phone,
        'company': companyNamee,
        'salary': salary,
        'email': email,
        'password': password,
        'gender': gender,
        'role': role,
        'department_id': departmentId,
        'expertise': expertise,
      });

      // Navigate back or show success message
      Navigator.pop(context, true);
    }
  }

  Future<String?> _getDefaultDepartmentId() async {
    var departments = await _departmentService.getDepartments(companyNamee);
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null && employee['role'] == 'department_manager') {
      return employee['department_id'];
    } 
  }

  Future<String?> _getDepartmentId(String departmentName) async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null && employee['role'] == 'department_manager') {
      return employee[
          'department_id'];
    } else {
      var department =
          await _departmentService.getDepartmentsByCompany(companyName);
      return department
          .firstWhere((dept) => dept['name'] == departmentName)['_id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(textt: "Personel Ekleme Sayfası"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Ad',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                labelText: 'Soyad',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [phoneFormatter],
              decoration: InputDecoration(
                labelText: 'Telefon Numarası',
                hintText: '+90 (555) 123-4567',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Maaş',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-posta Adresi',
                hintText: 'example@domain.com',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                hintText: 'Şifrenizi girin',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Şifre Tekrarı',
                hintText: 'Şifrenizi girin',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Cinsiyet Seçimi:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Radio<String>(
                  value: 'Erkek',
                  groupValue: _gender,
                  onChanged: (String? value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  activeColor: Colors.black,
                ),
                Text('Erkek'),
                Radio<String>(
                  value: 'Kadın',
                  groupValue: _gender,
                  onChanged: (String? value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  activeColor: Colors.black,
                ),
                Text('Kadın'),
              ],
            ),
            SizedBox(height: 10),
            if (showDepartmentField)
              Row(
                children: [
                  Text("Departmanı Seçiniz:     "),
                  Container(
                    width: 230,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _departmentService.getDepartments(companyName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); 
                        }
                        if (snapshot.hasError) {
                          return Text('Hata: ${snapshot.error}'); 
                        }
                        final departments = snapshot.data ?? [];

                        if (departments.isEmpty) {
                          return Text('Departman bulunamadı');
                        }
                        if (selectedValue == null && departments.isNotEmpty) {
                          selectedValue = departments.first['name'];
                        }
                        return DropdownButton<String>(
                          isExpanded: true,
                          value: selectedValue ??
                              (departments.isNotEmpty
                                  ? departments.first['name']
                                  : null), // null check
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue;
                            });
                          },
                          items: departments
                              .map<DropdownMenuItem<String>>((department) {
                            return DropdownMenuItem<String>(
                              value: department['name'],
                              child: Text(department['name']),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            if (showExpertiseField)
              TextField(
                controller: _expertiseController,
                decoration: InputDecoration(
                  labelText: 'Uzmanlık Alanı Girin',
                  hintText: 'Uzmanlık Alanı Giriniz',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveEmployee,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime.shade600),
              child: Text("Personeli Kaydet",
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  var phoneFormatter = MaskTextInputFormatter(
    mask: '+90 (###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  bool _isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(email);
  }
}
