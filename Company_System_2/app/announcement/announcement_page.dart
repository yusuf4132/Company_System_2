import 'package:company_system_2/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../api/announcementService.dart';
import '../api/employeService.dart';
import 'announcement_add.dart';

class AnnouncementPages extends StatefulWidget {
  final Function(int) changePage;
  final String email;
  AnnouncementPages({required this.email, required this.changePage});

  @override
  State<AnnouncementPages> createState() => _AnnouncementPagesState();
}

class _AnnouncementPagesState extends State<AnnouncementPages> {
  String companyName = "";
  String? department_id;
  String role = "";
  late AnnouncementService _announcementtService;
  late EmployeeService _employeeService;
  Future<List<Map<String, dynamic>>>? announcements;

  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        companyName = employee['company'];
        department_id = employee["department_id"];
        role = employee['role'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _announcementtService = AnnouncementService();
    _employeeService = EmployeeService();
    _getCompanyName().then((_) {
      setState(() {
        announcements = _announcementtService.getAnnouncementsByCompany(
            companyName, department_id);
      });
    });
  }

  void _showAlertDialog(BuildContext context, Map<String, dynamic> announce) {
    final TextEditingController announcerController =
        TextEditingController(text: announce['announcer']);
    final TextEditingController contentController =
        TextEditingController(text: announce['content']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Duyuru Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Duyuru İçeriği',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: announcerController,
                decoration: const InputDecoration(
                  labelText: 'Kimden',
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); 
              },
              child: const Text(
                'İptal',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _announcementtService.updateAnnouncement(
                  announce['_id'],
                  announcerController.text,
                  contentController.text,
                );
                Navigator.of(context).pop();

                setState(() {
                  announcements = _announcementtService.getAnnouncementsByCompany(
                      companyName,
                      department_id);
                });
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
      appBar: CustomAppBar(text: "Duyuru İşlemleri"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: announcements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else {
            var announcementsList = (snapshot.data ?? []).where((duyuru) {
              if (role == "department_manager") {
                return announce['departmentid'] != null;
              }
              return true;
            }).toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 16,
                          left: 0,
                          right: 1), 
                      child: Text(
                        'ID        Kimden           İçerik           Güncelle        Sil ',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (announcementsList.isNotEmpty) ...[
                      Column(
                        children: List.generate(
                          announcementsList.length,
                          (index) {
                            var announce = announcementsList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0), 
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
                                        width: 50, 
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                                color: Colors.grey,
                                                width: 1), 
                                          ),
                                        ),
                                        child: Text(
                                          announce['id'].toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                                color: Colors.grey,
                                                width: 1), 
                                          ),
                                        ),
                                        child: Text(
                                          announce['announcer'] ??
                                              'Bilinmiyor',
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
                                            announce['content'] ??
                                                'İçerik yok',
                                            style: TextStyle(fontSize: 16),
                                            overflow: TextOverflow
                                                .ellipsis,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                _showAlertDialog(
                                                    context, announce);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Silmek İstediğinizden Emin Misiniz?"),
                                                      content: Text(
                                                          "Bu işlemi geri almanız mümkün değildir."),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text("Hayır"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            _announcementtService
                                                                .deleteAnnouncement(
                                                                    announce[
                                                                        '_id']);
                                                            announcementsList = _announcementtService
                                                                .getAnnouncementsByCompany(
                                                                companyName,
                                                                department_id);
                                                            setState(() {

                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text("Evet"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
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
                          'Hiç duyuru bulunmamaktadır.',
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
                              builder: (context) => AnnouncementAddPages(
                                email: widget.email,
                              ),
                            ),
                          ).then((result) {
                            if (result != null && result == true) {
                              setState(() {
                                announcementsList = _announcementtService
                                    .getAnnouncementsByCompany(
                                        companyName, department_id);
                              });
                            }
                          });
                        },
                        child: Text("    Duyuru Ekle     ",
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
