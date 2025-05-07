import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:company_system_2/loginpage/login_page.dart';
import 'package:flutter/material.dart';
import 'api/DepartmentService.dart';

class ProfilePages extends StatefulWidget {
  final String email;
  ProfilePages({required this.email});
  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> {
  bool _isTableVisible = false;
  bool _isTableVisible1 = false;
  String name = "";
  String surname = "";
  String phone = "";
  String company = "";
  int? salary;
  String? expertise;
  String role = "";
  String dep_name = "";
  String email = "";
  String? dep_id;
  late DepartmentService _departmentService;
  late EmployeeService _employeeService;
  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        company = employee['company'];
        name = employee["name"];
        role = employee['role'];
        dep_id = employee['department_id'];
        surname = employee["surname"];
        phone = employee["phone"];
        salary = employee["salary"];
        expertise = employee["expertise"];
        email = employee["email"];
      });
      if (dep_id != null) {
        dep_name = await _departmentService.getDepartmentNameById(dep_id!);
      } else {
        dep_name = "-";
      }
      if (salary != null) {
        saalry = salary;
      } else {
        salary = 0;
      }
      if (expertise != null) {
        expertise = expertise;
      } else {
        expertise = "-";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _employeeService = EmployeeService();
    _departmentService = DepartmentService();
    _getCompanyName();
  }

  void _toggleTableVisibility() {
    setState(() {
      _isTableVisible = !_isTableVisible;
    });
  }

  void _toggleTableVisibility1() {
    setState(() {
      _isTableVisible1 = !_isTableVisible1;
    });
  }

  void _showAlertDialog(BuildContext context) {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController newPasswordConfirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Şifre Değiştirme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mevcut Şifre',
                  hintText: 'Mevcut şifreyi yazın...',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Yeni Şifre',
                  hintText: 'Yeni şifre yazın...',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordConfirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Yeni şifre tekrarı',
                  hintText: 'Yeni şifreyi tekrar yazın...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'İptal',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;
                String newPasswordConfirm = newPasswordConfirmController.text;

                var user = await _employeeService.getUserByEmail(widget.email);

                if (user != null) {
                  String storedPassword = user[
                      'password'];
                  if (currentPassword == storedPassword) {
                    if (newPassword == newPasswordConfirm) {
                      bool success = await _employeeService.updatePassword(
                          widget.email, newPassword);

                      if (success) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Şifreniz başarıyla değiştirildi!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Şifre güncellenirken bir hata oluştu.')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Yeni şifreler eşleşmiyor.')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mevcut şifre hatalı.')),
                    );
                  }
                }
              },
              child: const Text(
                'Kaydet',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(textt: "Profiliniz"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.black12,
              child: TextButton(
                onPressed: _toggleTableVisibility,
                child: Text(
                  'Kişisel Bilgileri Göster/Gizle',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 10),
            if (_isTableVisible)
              Table(
                border: TableBorder.all(color: Colors.black, width: 1),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Ad Soyad:', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('$name $surname', textAlign: TextAlign.center),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Telefon:', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('$phone', textAlign: TextAlign.center),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Mail:', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('$email', textAlign: TextAlign.center),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Şirket:', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('$company', textAlign: TextAlign.center),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Departman:', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('$dep_name', textAlign: TextAlign.center),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Rol:', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('$role', textAlign: TextAlign.center),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Alan:', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('$expertise', textAlign: TextAlign.center),
                    ),
                  ]),
                ],
              ),
            Container(
              width: double.infinity,
              color: Colors.black12,
              child: TextButton(
                onPressed: _toggleTableVisibility1,
                child: const Text(
                  'Maaş Bilgileri Göster/Gizle',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_isTableVisible1)
              Table(
                border: TableBorder.all(color: Colors.black, width: 1),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Maaş:', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('$salary', textAlign: TextAlign.center),
                    ),
                  ]),
                ],
              ),
            Container(
              width: double.infinity,
              color: Colors.black12,
              child: TextButton(
                onPressed: () => _showAlertDialog(context),
                child: const Text(
                  'Şifre İşlemleri               >',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              color: Colors.black12,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPages()),
                  );
                },
                child: const Text(
                  'Çıkış Yap               X',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
