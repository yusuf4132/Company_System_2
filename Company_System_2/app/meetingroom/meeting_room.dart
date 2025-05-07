import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/api/reservationService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:company_system_2/meetingroom/reservation.dart';
import 'package:flutter/material.dart';

class MeetingRoomPages extends StatefulWidget {
  final Function(int) changePage;
  final String email;

  MeetingRoomPages({required this.changePage, required this.email});

  @override
  State<MeetingRoomPages> createState() => _MeetingRoomPagesState();
}

class _MeetingRoomPagesState extends State<MeetingRoomPages> {
  String companyName = "";
  String? department_id;
  String role = "";
  List<Map<String, dynamic>> reservations = [];
  late ReservationService _reservationService;
  late EmployeeService _employeeService;
  @override
  void initState() {
    super.initState();
    _reservationService = ReservationService();
    _employeeService = EmployeeService();
    _getCompanyName();
    _loadReservation();
  }

  Future<void> _loadReservation() async {
    final reservationList = await _reservationService.getReservationsByCompany(
        companyName); 
    final currentTime = DateTime.now();

    for (var reservation in reservationList) {
      DateTime endTime = DateTime.parse(
          reservation['end_time']);
      if (endTime.isBefore(currentTime)) {
        await _reservationService.deleteReservation(reservation['_id']);
      }
    }
    setState(() {
      reservations = reservationList.where((reservation) {
        DateTime endTime = DateTime.parse(reservation['end_time']);
        return endTime.isAfter(currentTime);
      }).toList();
    });
  }

  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        companyName = employee['company'] ?? "";
        department_id = employee["department_id"] ?? null;
        role = employee["role"];
      });
      _loadReservation();
    }
  }
  Future<void> _deleteeReservation(String reservationId) async {
    await _reservationService.deleteReservation(reservationId);
    await _loadReservation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "Toplantı Odası işlemleri"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Rezervasyonu Yapan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Oda',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Rezervasyon Açıklaması",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Rezervasyon Tarihi",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Silme",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                for (var reservation in reservations)
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(reservation['booker']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(reservation['room_id']['name']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(reservation['contens']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '${reservation['start_time']} ${reservation['end_time']}')),
                      ),
                      TableCell(
                        child: (role == "department_manager" ||
                                role == "staff")
                            ? (reservation['departmentid'] ==
                                    department_id)
                                ? IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Silme Onayı'),
                                            content: Text(
                                                'Bu rezervasyonu silmek istediğinizden emin misiniz?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Hayır'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await _reservationService
                                                      .deleteReservation(
                                                          reservation['_id']);
                                                  final reservationList =
                                                      await _reservationService
                                                          .getReservationsByCompany(
                                                              companyName);
                                                  setState(() {
                                                    reservations =
                                                        reservationList;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Evet'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )
                                : SizedBox.shrink()
                            : IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Silme Onayı'),
                                        content: Text(
                                            'Bu rezervasyonu silmek istediğinizden emin misiniz?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Hayır'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await _reservationService
                                                  .deleteReservation(
                                                      reservation['_id']);
                                              final reservationList =
                                                  await _reservationService
                                                      .getReservationsByCompany(
                                                          companyName);
                                              setState(() {
                                                reservations = reservationList;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Evet'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                      )
                    ],
                  ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30), 
                  ),
                  backgroundColor: Colors.lime.shade600,
                  padding:
                      EdgeInsets.symmetric(vertical: 16), 
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationPages(
                        changePage: widget.changePage,
                        email: widget.email,
                      ),
                    ),
                  ).then((result) {
                    if (result != null && result == true) {
                      setState(() {
                        _loadReservation();
                      });
                    }
                  });
                },
                child: Text("    Rezervasyon Yap     ",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
