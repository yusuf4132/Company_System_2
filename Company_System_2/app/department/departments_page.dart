import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'api/DepartmentService.dart';

class DepartmentPages extends StatefulWidget {
  final String email;
  DepartmentPages({required this.email});

  @override
  _DepartmentPagesState createState() => _DepartmentPagesState();
}

class _DepartmentPagesState extends State<DepartmentPages> {
  late DepartmentService _departmentService;
  late EmployeeService _employeeService;
  String companyName = "";
  List<Map<String, dynamic>> departments = [];
  late Future<List<Map<String, dynamic>>>? depler;

  @override
  void initState() {
    super.initState();
    _departmentService = DepartmentService();
    _employeeService = EmployeeService();
    _getCompanyName().then((_) {
      setState(() {
        _departmentService = DepartmentService();
        _loadDepartments();
      });
    });
  }
  Future<void> _loadDepartments() async {
    final departmentsData =
        await _departmentService.getDepartmentsByCompany(companyName);
    setState(() {
      departments = departmentsData;
    });
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String departmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Silmek istediğinizden emin misiniz?'),
          content: Text('Bu departman kalıcı olarak sileceksiniz.'),
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
                await _departmentService.deleteDepartment(departmentId);
                setState(() {
                  _loadDepartments();
                });
              },
              child: Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        companyNamee = employee['company'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(textt: "Departman İşlemleri"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), 
                ),
                backgroundColor: Colors.lime.shade600,
                padding: EdgeInsets.symmetric(vertical: 16), 
              ),
              onPressed: _showAddDepartmentDialog, 
              child: Text(
                '   Departman Ekle   ',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(departments[index]['name']),
                    subtitle: Text(
                        'Şirket: ${departments[index]['company']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(
                            context, departments[index]['_id']);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDepartmentDialog() {
    final TextEditingController departmentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Departman Ekle'),
          content: TextField(
            controller: departmentController,
            decoration: InputDecoration(hintText: 'Departman adı girin'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                String departmentName = departmentController.text;

                if (departmentName.isNotEmpty) {
                  bool departmentExists = await _departmentService
                      .checkIfDepartmentExists(departmentName, companyName);

                  if (departmentExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bu departman zaten mevcut!')),
                    );
                  } else {
                    await _departmentService.addDepartment(
                      departmentName,
                      companyName,
                    );
                    departmentController.clear();
                    Navigator.of(context).pop();
                    _loadDepartments();
                  }
                }
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }
}
