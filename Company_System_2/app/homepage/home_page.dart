import 'dart:async';
import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/api/jobService.dart';
import 'package:company_system_2/api/reservationService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'api/announcementService.dart';

class HomePages extends StatefulWidget {
  final Function(int) changePage;
  final String email;
  HomePages({required this.email, required this.changePage});
  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  String companyName = "";
  String? department_id;
  String role = "";
  String id = "";
  Future<List<Map<String, dynamic>>>? announcements;
  Future<List<Map<String, dynamic>>>? jobs;
  Future<List<Map<String, dynamic>>>? reservations;
  late AnnouncementService _announcementtService;
  late ReservationService _reservationService;
  late EmployeeService _employeeService;
  late JobService _jobService;

  @override
  void initState() {
    super.initState();
    _announcementtService = AnnouncementService();
    _reservationService = ReservationService();
    _employeeService = EmployeeService();
    _jobService = JobService();
    _getCompanyName().then((_) {
      setState(() {
        _loadData();
      });
    });
  }

  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        companyName = employee['company'];
        department_id = employee["department_id"];
        role = employee['role'];
        id = employee['_id'];
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      print('depidd $department_id');
      announcements = _announcementtService.getAnnouncementsByCompany(
          companyName, department_id);
      jobs = _jobService.getJobsByCompany(companyName, role, id);
      reservations = _reservationService.getReservationsByCompany(companyName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "Company System"),
      body: RefreshIndicator(
        onRefresh:
            _loadData,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: ListView(
            children: [
              _buildBox(
                context,
                title: "Duyurular",
                content: FutureBuilder<List<Map<String, dynamic>>>(
                  future: announcements,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while data is being fetched
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text(
                        "Hiçbir Duyuru Mevcut Değil.",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      );
                    } else {
                      // Build a list of announcements
                      List<Map<String, dynamic>> announcements = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: announcements.map((announcement) {
                          return Text(
                            '# (${announcement['announcer']}) ${announcement['content']}' ??
                                "No content", // Use the appropriate key from your data
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                color: Colors.blueAccent,
              ),
              SizedBox(height: 16),
              _buildBox(
                context,
                title: "İşler",
                content: FutureBuilder<List<Map<String, dynamic>>>(
                  future: jobs,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while data is being fetched
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text("Hiçbir İş Mevcut Değil.",
                          style: TextStyle(fontWeight: FontWeight.w600));
                    } else {
                      // Build a list of jobs
                      List<Map<String, dynamic>> jobs = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: jobs.map((job) {
                          return Text(
                            '# Konu : ${job['subject']} *** İçerik : ${job['explanation']} *** Son Tarih : ${job['deadline']}' ??
                                "No content", // Use the appropriate key from your data
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                color: Colors.orangeAccent,
              ),
              SizedBox(height: 16),
              _buildBox(
                context,
                title: "Toplantı",
                content: FutureBuilder<List<Map<String, dynamic>>>(
                  future: reservations,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while data is being fetched
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text("Hiçbir Toplantı Mevcut Değil.",
                          style: TextStyle(fontWeight: FontWeight.w600));
                    } else {
                      // Build a list of reservations
                      List<Map<String, dynamic>> reservations = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: reservations.map((reserve) {
                          return Text(
                            '# Rezervasyon Sahibi : ${reserve['booker']} *** Toplantı İçeriği : ${reserve['contens']} *** Oda : ${reserve['room_id']['name']} *** Zaman : ${reserve['start_time']}|||${reserve['end_time']}' ??
                                "No content", // Use the appropriate key from your data
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
                color: Colors.greenAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildBox(
  BuildContext context, {
  required String title,
  required Widget content,
  required Color color,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          SizedBox(height: 8),
          content,
        ],
      ),
    ),
  );
}
