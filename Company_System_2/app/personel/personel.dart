import 'dart:async';

import 'package:company_system_2/personel/personel_add.dart';
import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../api/DepartmentService.dart';

class PersonelPages extends StatefulWidget {
  final Function(int) changePage;
  final String email;
  PersonelPages({required this.changePage, required this.email});
  @override
  State<PersonelPages> createState() => _PersonelPagesState();
}

class _PersonelPagesState extends State<PersonelPages> {
  String companyName = "";
  String role = "";
  String? departmentId;
  String? searchQuery;
  Future<List<Map<String, dynamic>>>? employees;
  late DepartmentService _departmentService;
  late EmployeeService _employeeService;
  TextEditingController _textController = TextEditingController();

  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        companyName = employee['company'];
        role = employee['role'];
        departmentId = employee['department_id'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _departmentService = DepartmentService();
    _employeeService = EmployeeService();
    _getCompanyName().then((_) {
      setState(() {
        _loadEmployees();
      });
    });
  }
  void _loadEmployees() {
    setState(() {
      employees = _employeeService.getEmployeesBySearch(
          companyName, role, departmentId, searchQuery);
    });
  }
  _searchEmployees(query) {
    searchQuery = query;
    _loadEmployees();
  }

  void _showDeleteConfirmationDialog(BuildContext context, String employeeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Silmek istediğinizden emin misiniz?'),
          content: Text('Bu personel kaydını kalıcı olarak sileceksiniz.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Hayır'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Proceed with deletion
                await _employeeService.deleteEmployee(employeeId);
                setState(() {
                  employees = _employeeService.getEmployeesByRoleAndCompany(
                      companyName, role, departmentId);
                });
              },
              child: Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog2(
      BuildContext context, Map<String, dynamic> employee) async {
    String? departmentName = await _departmentService
        .getDepartmentNameById(employee['department_id']);

    String roleDisplay;

    if (employee['role'] == 'staff') {
      roleDisplay = 'Personel';
    } else if (employee['role'] == 'admin') {
      roleDisplay = 'Yönetici';
    } else {
      roleDisplay = 'Departman Şefi';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Personel Bilgileri'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ad Soyad: ${employee['name']} ${employee['surname']}'),
              const SizedBox(height: 10),
              Text('Telefon: ${employee['phone']}'),
              const SizedBox(height: 10),
              Text('E-posta: ${employee['email']}'),
              const SizedBox(height: 10),
              Text('Cinsiyet: ${employee['gender']}'),
              const SizedBox(height: 10),
              Text('Maaş: ${employee['salary']}'),
              const SizedBox(height: 10),
              Text('Şirket İsmi: ${employee['company']}'),
              const SizedBox(height: 10),
              Text('Departman: $departmentName'),
              const SizedBox(height: 10),
              Text('Rol: $roleDisplay'),
              const SizedBox(height: 10),
              Text('Alanı: ${employee["expertise"] ?? "-"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Kapat'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(
      BuildContext context, Map<String, dynamic> employee) async {
    TextEditingController nameController =
        TextEditingController(text: employee['name']);
    TextEditingController surnameController =
        TextEditingController(text: employee['surname']);
    TextEditingController phoneController =
        TextEditingController(text: employee['phone']);
    TextEditingController emailController =
        TextEditingController(text: employee['email']);
    TextEditingController companyController =
        TextEditingController(text: employee['company']);
    TextEditingController salaryController =
        TextEditingController(text: employee['salary'].toString());
    TextEditingController expertiseController =
        TextEditingController(text: employee['expertise'] ?? "");
    TextEditingController departmentController = TextEditingController();

    String gender = employee['gender'];
    String rolee = employee['role'];
    String departmentName = await _departmentService
        .getDepartmentNameById(employee['department_id']);
    departmentController.text = departmentName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Personel Güncelle'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Name Field
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Ad'),
                    ),
                    // Surname Field
                    TextField(
                      controller: surnameController,
                      decoration: const InputDecoration(labelText: 'Soyad'),
                    ),
                    // Phone Field
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Telefon'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'E-mail'),
                    ),
                    TextField(
                      controller: companyController,
                      decoration: const InputDecoration(labelText: 'Şirket'),
                    ),
                    // Salary Field
                    TextField(
                      controller: salaryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Maaş'),
                    ),
                    // Expertise Field
                    TextField(
                      controller: expertiseController,
                      decoration: const InputDecoration(labelText: 'Alanı'),
                    ),
                    TextField(
                      enabled: false,
                      controller: departmentController,
                      decoration:
                          const InputDecoration(labelText: 'Departmanı'),
                    ),
                    // Gender Field
                    DropdownButton<String>(
                      value: gender,
                      onChanged: (String? newValue) {
                        setState(() {
                          gender = newValue!;
                        });
                      },
                      items: <String>['Erkek', 'Kadın']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    // Role Field
                    DropdownButton<String>(
                      value: role,
                      onChanged: (String? newValue) {
                        setState(() {
                          role = newValue!;
                        });
                      },
                      items: <String>['admin', 'department_manager', 'staff']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                final updatedData = {
                  'name': nameController.text,
                  'surname': surnameController.text,
                  'phone': phoneController.text,
                  'email': emailController.text,
                  'company': companyController.text,
                  'salary': salaryController.text.isEmpty
                      ? null
                      : double.tryParse(salaryController.text),
                  'expertise': expertiseController.text,
                  'gender': gender,
                  'role': rolee,
                };

                await _employeeService.updateEmployee(
                  employee['_id'],
                  updatedData,
                );
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  employees = _employeeService.getEmployeesByRoleAndCompany(
                      companyName, role, departmentId);
                });
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: "Personel İşlemleri",
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: employees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else {
            var employeeList = snapshot.data ?? [];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                labelText: 'Personel Ara',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              _searchEmployees(_textController.text);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 16,
                          left: 0,
                          right: 1),
                      child: Text(
                        'ID        Ad          Soyad                 Bilgi   Güncelle   Sil ',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (employeeList.isNotEmpty) ...[
                      Column(
                        children: List.generate(
                          employeeList.length,
                          (index) {
                            var employee = employeeList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6.0), 
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey), 
                                  borderRadius: BorderRadius.circular(
                                      8.0),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(8.0), 
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, 
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        width: 30,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                                color: Colors.grey,
                                                width: 1), 
                                          ),
                                        ),
                                        child: Text(
                                          employee['id'].toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        width: 75,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                                color: Colors.grey,
                                                width: 1),
                                          ),
                                        ),
                                        child: Text(
                                          employee['name'] ?? 'Bilinmiyor',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                  color: Colors.grey,
                                                  width:
                                                      1),
                                            ),
                                          ),
                                          child: Text(
                                            employee['surname'] ?? 'İçerik yok',
                                            style: TextStyle(fontSize: 16),
                                            overflow: TextOverflow
                                                .ellipsis,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.info),
                                              onPressed: () {
                                                _showAlertDialog2(
                                                    context, employee);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                _showUpdateDialog(
                                                    context, employee);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                _showDeleteConfirmationDialog(
                                                    context, employee['_id']);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Hiç Personel bulunmamaktadır.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30),
                          ),
                          backgroundColor: Colors.lime.shade600,
                          padding: EdgeInsets.symmetric(
                              vertical: 16), 
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonelAddPages(
                                email: widget.email,
                              ),
                            ),
                          ).then((result) {
                            if (result != null && result == true) {
                              setState(() {
                                employeeList =
                                    _employeeService.getEmployeesBySearch(
                                        companyName,
                                        role,
                                        departmentId,
                                        searchQuery);
                              });
                            }
                          });
                        },
                        child: Text("    Personel Ekle     ",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
