import 'package:company_system_2/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../api/announcementService.dart';
import '../api/employeService.dart';

class AnnouncementAddPages extends StatefulWidget {
  final String email;
  AnnouncementAddPages({
    required this.email,
  });

  @override
  State<AnnouncementAddPages> createState() => _AnnouncementAddPagesState();
}

class _AnnouncementAddPagesState extends State<AnnouncementAddPages> {
  TextEditingController _announcementController = TextEditingController();
  late AnnouncementService _announcementtService;
  late EmployeeService _employeeService;
  String _userNameRole = "";
  String _companyName = "";
  String? _departmentId;
  String word= "";

  @override
  void initState() {
    super.initState();
    _announcementtService = AnnouncementService();
    _employeeService = EmployeeService();
    _loadUserRole();
  }

  _loadUserRole() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      if (employee["role"] == "admin") {
        word = "Yönetici";
        setState(() {
          _userNameRole = "$kelime ${employee['name']} ${employee['surname']}";
        });
      } else if (employee["role"] == "department_manager") {
        word = "Departman Şefi";
        setState(() {
          _userNameRole = "$kelime ${employee['name']} ${employee['surname']}";
        });
      }
      setState(() {
        _companyName = employee['company'];
        _departmentId = employee['department_id'];
      });
    } else {
      setState(() {
        _userNameRole = "Kullanıcı bilgisi yüklenemedi";
      });
    }
  }

  _saveAnnouncement(BuildContext context) async {
    if (_announcementController.text.isNotEmpty && _userNameRole != null) {
      await _announcementtService.insertAnnouncement(
        _userNameRole,
        _announcementController.text,
        _companyName,
        _departmentId,
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(textt: "Duyuru Ekleme İşlemi"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userNameRole != null
                ? Text("$_userNameRole",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600))
                : CircularProgressIndicator(),
            TextField(
              maxLines: 10,
              controller: _announcementController,
              decoration: InputDecoration(
                labelText: "Duyurunuzu Girin",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _announcementController.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _saveAnnouncement(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime.shade600),
              child: Text(
                "Duyuruyu Kaydet",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
