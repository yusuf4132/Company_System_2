import 'package:company_system_2/api/roomService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../api/employeService.dart';

class MeetingRoomOrganizePages extends StatefulWidget {
  final String email; 
  MeetingRoomOrganizePages({required this.email});
  @override
  State<MeetingRoomOrganizePages> createState() =>
      _MeetingRoomOrganizePagesState();
}

class _MeetingRoomOrganizePagesState extends State<MeetingRoomOrganizePages> {
  String companyName = "a";
  TextEditingController _roomNameController = TextEditingController();
  TextEditingController _roomContensController = TextEditingController();
  late RoomService _roomService;
  late EmployeeService _employeeService;

  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        companyName = employee['company'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _roomService = RoomService();
    _employeeService = EmployeeService();
    _getCompanyName();
  }

  _saveRoom(BuildContext context) async {
    String roomName = _roomNameController.text;
    String roomContents = _roomContensController.text;
    if (roomName.isNotEmpty && roomContents.isNotEmpty) {
      bool roomExists = await _roomService.checkIfRoomExists(roomName);
      if (roomExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bu oda zaten mevcut!')),
        );
      } else {
        await _roomService.addRoom(roomName, companyName, roomContents);
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(textt: "Toplantı Odası Ekle"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _roomNameController,
              decoration: InputDecoration(
                labelText: 'Oda Numarası Gir',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _roomContensController,
              decoration: InputDecoration(
                labelText: 'Oda Açıklaması Gir',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _saveRoom(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lime.shade600),
              child: Text(
                "Odayı Kaydet",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
