import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/api/reservationService.dart';
import 'package:company_system_2/api/roomService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:company_system_2/meetingroom/meeting_room_organize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationPages extends StatefulWidget {
  final String email;
  final Function(int) changePage;
  ReservationPages({required this.changePage, required this.email});

  @override
  State<ReservationPages> createState() => _ReservationPagesState();
}

class _ReservationPagesState extends State<ReservationPages> {
  String companyName = "";
  String? department_id;
  String? _word;
  String _userNameRole = "";
  List<Map<String, dynamic>> rooms = [];
  late RoomService _roomService;
  late ReservationService _reservationService;
  late EmployeeService _employeeService;
  TextEditingController reservationDetailsController = TextEditingController();
  TextEditingController reservationDetailsController1 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _roomService = RoomService();
    _reservationService = ReservationService();
    _employeeService = EmployeeService();
    _getCompanyName().then((_) {
      _loadUserRole();
      setState(() {
        _roomService = RoomService();
        _reservationService = ReservationService();
        _employeeService = EmployeeService();
        _loadRooms();
      });
    }); 
  }

  @override
  void dispose() {
    reservationDetailsController.dispose();
    super.dispose();
  }

  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        companyName = employee['company'] ?? "";
        department_id = employee["department_id"] ?? null;
      });
      _loadRooms();
    }
  }

  _loadUserRole() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      if (employee["role"] == "admin") {
        _word = "Yönetici";
        setState(() {
          _userNameRole = "$_word ${employee['name']} ${employee['surname']}";
        });
      } else if (employee["role"] == "department_manager") {
        _word = "Departman Şefi";
        setState(() {
          _userNameRole = "$_word ${employee['name']} ${employee['surname']}";
        });
      }
    } else {
      setState(() {
        _userNameRole = "Kullanıcı bilgisi yüklenemedi";
      });
    }
  }

  Future<void> _loadRooms() async {
    final roomList = await _roomService.getRoomsByCompany(
        companyName);
    setState(() {
      rooms = roomList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(textt: "Rezervasyon İşlemleri"),
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
                        child: Text('Oda Seçiniz',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Oda Açıklaması',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Sil",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Rezervasyon",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                for (var room in rooms)
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(room['name']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(room['contens']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Silmek istediğinizden emin misiniz?(Oda Üzerinde Randevu Varsa Dikkat Edin!)'),
                                    content: Text('Bu işlem geri alınamaz.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Hayır'),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); 
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Evet'),
                                        onPressed: () async {
                                          await _roomService
                                              .deleteRoom(room['_id']);
                                          final roomList = await _roomService
                                              .getRoomsByCompany(companyName);
                                          setState(() {
                                            rooms =
                                                roomList;
                                          });

                                          Navigator.of(context)
                                              .pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  String? reservationContent;
                                  TimeOfDay? startTime;
                                  TimeOfDay? endTime;
                                  DateTime? startDate; 
                                  DateTime? endDate;

                                  return AlertDialog(
                                    title: Text('Toplantı Bilgileri'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Toplantı İçeriği',
                                          ),
                                          onChanged: (value) {
                                            reservationContent = value;
                                          },
                                        ),
                                        ListTile(
                                          title: Text(startTime == null
                                              ? 'Başlangıç Tarihi ve Saatini Seçin'
                                              : '${startDate != null ? startDate.toLocal().toString().split(' ')[0] : ''} ${_formatTime(startTime!)}'),
                                          onTap: () async {
                                            DateTime? selectedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  startDate ?? DateTime.now(),
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2101),
                                            );
                                            if (selectedDate != null) {
                                              setState(() {
                                                startDate = selectedDate;
                                              });
                                              startTime = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              setState(() {
                                                reservationDetailsController
                                                        .text =
                                                    '${startDate!.toLocal().toString().split(' ')[0]} ${_formatTime(startTime!)}';
                                              });
                                            }
                                          },
                                        ),
                                        ListTile(
                                          title: Text(endTime == null
                                              ? 'Bitiş Tarihi ve Saatini Seçin'
                                              : '${endDate != null ? endDate.toLocal().toString().split(' ')[0] : ''} ${_formatTime(endTime!)}'),
                                          onTap: () async {
                                            DateTime? selectedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  endDate ?? DateTime.now(),
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2101),
                                            );
                                            if (selectedDate != null) {
                                              setState(() {
                                                endDate = selectedDate;
                                              });
                                              endTime = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              setState(() {
                                                reservationDetailsController1
                                                        .text =
                                                    '${endDate!.toLocal().toString().split(' ')[0]} ${_formatTime(endTime!)}';
                                              });
                                            }
                                          },
                                        ),
                                        TextField(
                                          controller:
                                              reservationDetailsController,
                                          readOnly:
                                              true,
                                          decoration: InputDecoration(
                                            labelText: "Başlangıç Tarihi",
                                            hintText:
                                                "Başlangıç ve Bitiş Tarihi ve Saatini Seçin",
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        TextField(
                                          controller:
                                              reservationDetailsController1,
                                          readOnly:
                                              true,
                                          decoration: InputDecoration(
                                            labelText: "Bitiş Tarihi",
                                            hintText:
                                                "Başlangıç ve Bitiş Tarihi ve Saatini Seçin",
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('İptal'),
                                        onPressed: () {
                                          reservationDetailsController.clear();
                                          reservationDetailsController1.clear();
                                          Navigator.of(context)
                                              .pop(); 
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Rezervasyonu Yap'),
                                        onPressed: () async {
                                          if (startTime != null &&
                                              endTime != null &&
                                              reservationContent != null &&
                                              startDate != null &&
                                              endDate != null) {
                                            String startDateTime =
                                                formatDateTime(
                                                    startDate!, startTime!);
                                            String endDateTime = formatDateTime(
                                                endDate!, endTime!);
                                            if (startDate!.isAfter(endDate!) ||
                                                (startDate!.isAtSameMomentAs(
                                                        endDate!) &&
                                                    startTime!.hour >=
                                                        endTime!.hour &&
                                                    startTime!.minute >=
                                                        endTime!.minute)) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Başlangıç saati bitiş saatinden önce olmalıdır.')),
                                              );
                                            } else {
                                              DateTime startDateTime1 =
                                                  DateTime(
                                                startDate!.year,
                                                startDate!.month,
                                                startDate!.day,
                                                startTime!.hour,
                                                startTime!.minute,
                                              );

                                              DateTime endDateTime1 = DateTime(
                                                endDate!.year,
                                                endDate!.month,
                                                endDate!.day,
                                                endTime!.hour,
                                                endTime!.minute,
                                              );
                                              bool isConflict =
                                                  await _reservationService
                                                      .checkReservationConflict(
                                                room['_id'],
                                                startDateTime1
                                                    .toIso8601String(),
                                                endDateTime1.toIso8601String(),
                                              );

                                              if (isConflict) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'O odada o saatle çakışan bir toplantı mevcut!')),
                                                );
                                              } else {
                                                await _reservationService
                                                    .addReservation(
                                                  room['_id'],
                                                  reservationDetailsController
                                                      .text,
                                                  reservationDetailsController1
                                                      .text,
                                                  companyName,
                                                  _userNameRole,
                                                  reservationContent!,
                                                  department_id,
                                                );
                                                reservationDetailsController1
                                                    .clear();
                                                reservationDetailsController
                                                    .clear(); 
                                                Navigator.pop(context,
                                                    true); 
                                                Navigator.pop(context, true);
                                              }
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
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
                      builder: (context) => MeetingRoomOrganizePages(
                        email: widget.email,
                      ),
                    ),
                  ).then((result) {
                    if (result != null && result == true) {
                      loadRoomsIfNeeded();
                    }
                  });
                },
                child: Text("    Toplantı Odası Ekle     ",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadRoomsIfNeeded() async {
    final roomList = await _roomService.getRoomsByCompany(
        companyName);
    setState(() {
      rooms = roomList;
    });
  }
  String formatDateTime(DateTime date, TimeOfDay time) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final formattedTime = _formatTime(time);
    return '$formattedDate $formattedTime'; 
  }
  String _formatTime(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
