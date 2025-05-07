import 'package:company_system_2/job/job_assignment.dart';
import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/api/jobService.dart';
import 'package:company_system_2/api/progressService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/DepartmentService.dart';
import '../custom_app_bar.dart';

class JobsPages extends StatefulWidget {
  final Function(int) changePage;
  final String email;

  JobsPages({required this.changePage, required this.email});

  @override
  State<JobsPages> createState() => _JobsPagesState();
}

class _JobsPagesState extends State<JobsPages> {
  Color textColor = Colors.black;
  String companyName = "";
  String role = "";
  String id = "";
  List<Map<String, dynamic>> jobs = [];
  late DepartmentService _departmentService;
  late EmployeeService _employeeService;
  late JobService _jobService;
  late ProgressService _progressService;
  int selectedProgress = -1;
  @override
  void initState() {
    super.initState();
    _departmentService = DepartmentService();
    _employeeService = EmployeeService();
    _jobService = JobService();
    _progressService = ProgressService();
    _getCompanyName().then((_) {
      setState(() {
        _loadJob();
      });
    });
  }

  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        companyName = employee['company'];
        rolee = employee['role'];
        idd = employee['_id'];
      });
    }
  }

  Future<void> _loadJob() async {
    jobs = await _jobService.getJobsByCompany(
        companyName, rolee, idd); 
  }

  void showProgressUpdateDialog(BuildContext context, String jobid) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('İlerlemeyi Güncelle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: selectedProgress == 0,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedProgress = 0; 
                        });
                      },
                    ),
                    Text('0%'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: selectedProgress == 25,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedProgress = 25;
                        });
                      },
                    ),
                    Text('25%'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: selectedProgress == 50,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedProgress = 50; 
                        });
                      },
                    ),
                    Text('50%'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: selectedProgress == 75,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedProgress = 75; 
                        });
                      },
                    ),
                    Text('75%'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: selectedProgress == 100,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedProgress = 100; 
                        });
                      },
                    ),
                    Text('100%'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (selectedProgress == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Lütfen bir ilerleme değeri seçin')),
                    );
                  } else {
                    updateProgress(selectedProgress, context, jobid);
                    Navigator.of(context).pop(); 
                  }
                },
                child: const Text(
                  'Kaydet',
                  style: TextStyle(color: Colors.black),
                ),
              ),
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
            ],
          );
        },
      ),
    );
  }

  void _showAlertDialogJob(
      BuildContext context, Map<String, dynamic> jobe) async {
    String departmentName =
        await _departmentService.getDepartmentNameById(jobe['departman_id']);
    String creatorName =
        await _employeeService.getEmployeeNameById(jobe["creator_id"]);
    String assignedName =
        await _employeeService.getEmployeeNameById(jobe["assigned_id"]);
    String roleDisplay;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('İş Bilgileri'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('İş ID: ${jobe['id']}'),
              const SizedBox(height: 10),
              Text('Konu: ${jobe['subject']}'),
              const SizedBox(height: 10),
              Text('Açıklama: ${jobe['explanation']}'),
              const SizedBox(height: 10),
              Text('İşi Oluşturan: $creatorName'),
              const SizedBox(height: 10),
              Text('İşin Atandığı: $assignedName'),
              const SizedBox(height: 10),
              Text('Departman: $departmentName'),
              const SizedBox(height: 10),
              Text('Son Tarih: ${jobe['deadline']}'),
              const SizedBox(height: 10),
              Text('Üst İş IDsi: ${jobe["parentjob_id"] ?? "-"}'),
              const SizedBox(height: 10),
              Text('Proje Aşaması: ${jobe["progress"].toString()}'),
              const SizedBox(height: 10),
              Text('Oluşturma Tarihi: ${jobe["creation_date"]}'),
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

  void _navigateToJobAssignmentPage(String jobId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobAssignmentPages(
          email: widget.email,
          changePage: widget.changePage,
          jobId: jobId,
        ),
      ),
    ).then((result) async {
      if (result != null && result == true) {
        await _loadJob(); 
        setState(() {}); 
      }
    });
  }

  void _showDeleteConfirmationDialogg(
      BuildContext context, String jobId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Silmek istediğinizden emin misiniz?'),
          content: Text('Bu İş kalıcı olarak sileceksiniz.'),
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
                await _jobService.deleteJob(jobId);
                await _loadJob();
                setState(() {});
              },
              child: Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateAlertDialog(BuildContext context, Map<String, dynamic> job) {
    final TextEditingController subjectController =
        TextEditingController(text: job['subject']);
    final TextEditingController expalanationController =
        TextEditingController(text: job['expalanation']);
    final TextEditingController deadlineController =
        TextEditingController(text: job['deadline']);
    DateTime? _selectedDate;
    Future<void> _selectDate(BuildContext context) async {
      final DateTime initialDate =
          _selectedDate ?? DateFormat('yyyy-MM-dd').parse(job['son_tarih']);
      final DateTime firstDate = DateTime(2000);
      final DateTime lastDate = DateTime(2101);

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      if (picked != null && picked != _selectedDate) {
        _selectedDate = picked;
        deadlineController.text = DateFormat('yyyy-MM-dd')
            .format(picked);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('İş Atama Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'İş Konusu',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: explanationController,
                decoration: const InputDecoration(
                  labelText: 'İş Açıklaması',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: deadlineController,
                decoration: const InputDecoration(
                  labelText: 'Son Tarih',
                ),
                readOnly: true, 
                onTap: () => _selectDate(
                    context),
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
                if (_selectedDate == null && deadlineController.text.isNotEmpty) {
                  _selectedDate =
                      DateFormat('yyyy-MM-dd').parse(deadlineController.text);
                }

                if (_selectedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(_selectedDate!);
                  await _jobService.updateJob(
                    job['_id'],
                    subjectController.text,
                    explanationController.text,
                    formattedDate,
                  );
                  Navigator.of(context).pop(); 
                  await _loadJob();
                  setState(() {
                  });
                } else {
                  print('Lütfen önce bir tarih seçin');
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

  void updateProgress(
      int progressValue, BuildContext context, String job_id) async {
    var userId = id; 
    var jobId = job_id;
    var timestamp = DateTime.now().toString();
    await _progressService.addProgress(
        jobId, userId, progressValue, timestamp, companyName);
    try {
      await _jobService.updateMainJobProgress(jobId, progressValue);
    } catch (e) {
      print("Ana iş ilerlemesi hatası: $e");
    }
    await _loadJob();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 50));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(textt: "İş Atama İşlemleri"),
      body: RefreshIndicator(
        onRefresh: _loadJob,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: ListView(
            children: [
              Table(
                columnWidths: {
                  0: FixedColumnWidth(30), 
                  1: FixedColumnWidth(100), 
                  2: FixedColumnWidth(60), 
                  3: FixedColumnWidth(35), 
                  4: FixedColumnWidth(40), 
                  5: FixedColumnWidth(40), 
                  6: FixedColumnWidth(40),
                },
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('ID',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('Konu',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("İş Sahibi",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("İlerleme",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("Güncelle",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("Sil",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("İşi Ata",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  for (var jobe in isler)
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: InkWell(
                              onTap: () {
                                _showAlertDialogJob(context, jobe);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(
                                      4), 
                                ),
                                child: Text(
                                  jobe['id'].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(jobe['subject']),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FutureBuilder<String>(
                              future: _employeeService.getEmployeeNameById(
                                  jobe["creator_id"]), 
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); 
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Hata: ${snapshot.error}'); 
                                } else if (snapshot.hasData) {
                                  return Text(snapshot.data ??
                                      'Bilinmiyor'); 
                                } else {
                                  return Text(
                                      'Bilinmiyor'); 
                                }
                              },
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('% ${jobe['progress'].toString()}'),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: IconButton(
                              icon: Icon(Icons.update, color: Colors.red),
                              onPressed: () {
                                if (role == 'staff') {
                                  showProgressUpdateDialog(
                                      context, jobe['_id']);
                                } else {
                                  _showUpdateAlertDialog(context, jobe);
                                }
                              },
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: role == 'admin' ||
                                    (role == 'department_manager' &&
                                        jobe['creator_id'] == id)
                                ? IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      String? jobbId = jobe['parentjob_id'];

                                      if (jobbId != null) {
                                        _showDeleteConfirmationDialogg(
                                          context,
                                          jobe['_id'],
                                        );
                                      } else {
                                        final relatedJobs = await _jobService
                                            .parentJobIdSearch(jobe['_id']);

                                        if (relatedJobs.isEmpty) {
                                          _showDeleteConfirmationDialogg(
                                            context,
                                            jobe['_id'],
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Bu işin alt işleri olduğundan dolayı silinemez.'),
                                          ));
                                        }
                                      }
                                    },
                                  )
                                : Container(), 
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: jobe['parentjob_id'] ==
                                    null 
                                ? IconButton(
                                    icon: Icon(
                                        Icons.arrow_circle_right_outlined,
                                        color: Colors.red),
                                    onPressed: () {
                                      String jobId = jobe[
                                          '_id'];
                                      _navigateToJobAssignmentPage(jobId);
                                    },
                                  )
                                : Container(), 
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: role !=
                        'staff' 
                    ? ElevatedButton(
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
                                builder: (context) => JobAssignmentPages(
                                    changePage: widget.changePage,
                                    email: widget.email)),
                          ).then((result) async {
                            if (result != null && result == true) {
                              await _loadJob(); 
                              setState(() {}); 
                            }
                          });
                        },
                        child: Text("    İş Atama Ekle     ",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      )
                    : Container(),
              ),
              Text(
                  "             Not : İş Detayına Ulaşmak İçin ID'ye Tıklayınız.")
            ],
          ),
        ),
      ),
    );
  }
}
