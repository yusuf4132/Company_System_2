import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:company_system_2/elevated_button.dart';
import 'package:flutter/material.dart';

class SelectionPages extends StatefulWidget {
  final Function(int) changePage;
  final String email;
  SelectionPages({required this.changePage, required this.email});

  @override
  State<SelectionPages> createState() => _SelectionPagesState();
}

class _SelectionPagesState extends State<SelectionPages> {
  String role1 = "";
  String name = "";

  late EmployeeService _employeeService;

  Future<void> _getRoleName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        role1 = employee['role'];
        name = employee['name'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _employeeService = EmployeeService();
    _getRoleName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "İşlemler"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (role1 == 'admin') ...[
              ElevatedButtonPages(
                  textt: "Duyuru İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 3,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "Personel İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 5,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "Departman İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 20,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "Toplantı Odası İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 16,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "İş Atama İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 7,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "Raporlama",
                  changePagee: widget.changePage,
                  page_indexx: 21,
                  context: context),
            ]
            else if (role1 == 'department_manager') ...[
              ElevatedButtonPages(
                  textt: "Duyuru İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 3,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "Personel İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 5,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "Toplantı Odası İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 16,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "İş Atama İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 7,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "Raporlama",
                  changePagee: widget.changePage,
                  page_indexx: 21,
                  context: context),
            ]
            else if (role1 == 'staff') ...[
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "Toplantı Odası İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 16,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "İş Atama İşlemleri",
                  changePagee: widget.changePage,
                  page_indexx: 7,
                  context: context),
              SizedBox(height: 10),
              ElevatedButtonPages(
                  textt: "Raporlama",
                  changePagee: widget.changePage,
                  page_indexx: 21,
                  context: context),
            ]
            else ...[
              Center(
                child: Text("Rolünüz bulunamadı."),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
