import 'dart:io';

import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/api/jobService.dart';
import 'package:company_system_2/api/progressService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../api/DepartmentService.dart';

class RaporPages extends StatefulWidget {
  final Function(int) changepage;
  final String email;
  RaporPages({required this.changepage, required this.email});

  @override
  State<RaporPages> createState() => _RaporPagesState();
}

class _RaporPagesState extends State<RaporPages> {
  String? id;
  String companyName = "";
  String? selectedValue;
  late DepartmentService _departmentService;
  late EmployeeService _employeeService;
  late JobService _jobService;
  late ProgressService _progressService;
  Future<List<Map<String, dynamic>>>? isRapor;
  Future<List<Map<String, dynamic>>>? progressRapor;

  @override
  void initState() {
    super.initState();
    _departmentService = DepartmentService();
    _employeeService = EmployeeService();
    _jobService = JobService();
    _progressService = ProgressService();
    _getCompanyName().then((_) {
      setState(() {
        isRapor = _jobService.getJobsy(companyName, selectedValue);
      });
    });
  }

  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        id = employee['department_id'];
        companyName = employee['company'];
      });
    }
  }

  Future<List<Map<String, dynamic>>> _getProgress(String subJobId) async {
    var progressData = await _progressService.getProgressByJobId(subJobId);
    return progressData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(textt: "Raporlama İşlemleri"),
      body: Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text("Departmanı Seçiniz:     "),
                Container(
                  width: 230,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _departmentService.getDepartments(companyName),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Hata: ${snapshot.error}');
                      }

                      final departments = snapshot.data ?? [];

                      if (departments.isEmpty) {
                        return Text('Departman bulunamadı');
                      }
                      if (selectedValue == null && departments.isNotEmpty) {
                        selectedValue = null;
                      }

                      return DropdownButton<String>(
                        isExpanded: true,
                        value: selectedValue,
                        hint: Text("Departman seçiniz"),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue;
                            isRapor = _jobService.getJobsy(
                                companyName, selectedValue);
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child:
                                Text("Hepsi"),
                          ),
                          ...departments
                              .map<DropdownMenuItem<String>>((department) {
                            return DropdownMenuItem<String>(
                              value: department['name'],
                              child: Text(department['name']),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: isRapor,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Veri bulunamadı.'));
                } else {
                  List<Map<String, dynamic>> data = snapshot.data!;
                  var mainJobs =
                      data.where((item) => item['parentjob_id'] == null).toList();
                  var subJobs =
                      data.where((item) => item['parentjob_id'] != null).toList();

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: mainJobs.length,
                          itemBuilder: (context, index) {
                            var mainJob = mainJobs[index];
                            var relatedSubJobs = subJobs
                                .where((subJob) =>
                                    subJob['parentjob_id'] == mainJob['_id'])
                                .toList();
                            return FutureBuilder<List<String>>(
                              future: Future.wait([
                                _employeeService
                                    .getEmployeeIdById(mainJob['creator_id']),
                                _employeeService
                                    .getEmployeeIdById(mainJob['assigned_id']),
                              ]),
                              builder: (context, empSnapshot) {
                                if (empSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (empSnapshot.hasError) {
                                  return Text('Hata: ${empSnapshot.error}');
                                } else if (!empSnapshot.hasData) {
                                  return Text('Veri yok');
                                }
                                var creator = empSnapshot.data![0];
                                var assigned = empSnapshot.data![1];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(mainJob['subject']),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'ID: ${mainJob['_id']} || Açıklama: ${mainJob['explanation']} || Oluşturan ID: ${mainJob['creator_id']} || Atanan ID: ${mainJob['assigned_id']} || Üst ID: ${mainJob['parentjob_id']} || Departman ID: ${mainJob['departman_id']} || İlerleme: ${mainJob['progress']} || Son Tarih: ${mainJob['deadline']} || Oluşturma Tarihi: ${mainJob['creation_date']}'),
                                          Text(''),
                                        ],
                                      ),
                                    ),
                                    for (var subJob in relatedSubJobs)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 50.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              title: Text(subJob['subject']),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '# ID: ${subJob['_id']} || Açıklama: ${subJob['explanation']} || Oluşturan ID: ${subJob['creator_id']} || Atanan ID: ${subJob['assigned_id']} || Üst ID: ${subJob['parentjob_id']} || Departman ID: ${subJob['departman_id']} || İlerleme: ${subJob['progress']} || Son Tarih: ${subJob['deadline']} || Oluşturma Tarihi: ${subJob['creation_date']}'),
                                                  Text(''),
                                                ],
                                              ),
                                            ),
                                            FutureBuilder<
                                                List<Map<String, dynamic>>>(
                                              future:
                                                  _getProgress(subJob['_id']),
                                              builder:
                                                  (context, progressSnapshot) {
                                                if (progressSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 100.0),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else if (progressSnapshot
                                                    .hasError) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 100),
                                                    child: Text(
                                                        'İlerleme verisi alınamadı'),
                                                  );
                                                } else if (!progressSnapshot
                                                        .hasData ||
                                                    progressSnapshot
                                                        .data!.isEmpty) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 100),
                                                    child: Text(
                                                        'İlerleme verisi yok'),
                                                  );
                                                } else {
                                                  var progressData =
                                                      progressSnapshot.data!;
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 100),
                                                    child: Column(
                                                      children: [
                                                        for (var progress
                                                            in progressData)
                                                          Text(
                                                              '# İd: ${progress['_id']} || Görev İd: ${progress['task_id']} || Kullanıcı İd: ${progress['user_id']} || Kaydedilen İlerleme: ${progress["progress"]} || Kayıt Tarihi: ${progress['registration_date']}'),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await _exportToCSV(mainJobs, subJobs);
                        },
                        child: Text('CSV Olarak Dışa Aktar'),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportToCSV(List<Map<String, dynamic>> mainJobs,
      List<Map<String, dynamic>> subJobs) async {
    List<List<String>> csvData = [];

    for (var mainJob in mainJobs) {
      csvData.add([" "]);
      csvData.add([
        "İş ID||"
            "Konu||"
            "Açıklama||"
            "Oluşturan ID||"
            "Atanan ID||"
            "Üst ID||"
            "Departman ID||"
            "İlerleme||"
            "Son Tarih||"
            "Oluşturma Tarihi"
      ]);
      csvData.add([
        mainJob['_id'].toString() +
            "|" +
            mainJob['subject'] +
            "|" +
            mainJob['explanation'] +
            "|" +
            mainJob['creator_id'].toString() +
            "|" +
            mainJob['assigned_id'].toString() +
            "|" +
            mainJob['parentjob_id'].toString() +
            "|" +
            mainJob['departman_id'].toString() +
            "|" +
            mainJob['progress'].toString() +
            "|" +
            mainJob['deadline'] +
            "|" +
            mainJob['creation_date']
      ]);
      var relatedSubJobs = subJobs
          .where((subJob) => subJob['parentjob_id'] == mainJob['_id'])
          .toList();
      for (var subJob in relatedSubJobs) {
        csvData.add([
          ' '
              ' '
              ' ' 
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              "İş ID||"
              "Konu||"
              "Açıklama||"
              "Oluşturan ID||"
              "Atanan ID||"
              "Üst ID||"
              "Departman ID||"
              "İlerleme||"
              "Son Tarih||"
              "Oluşturma Tarihi"
        ]);
        csvData.add([
          ' ' 
                  ' '
                  ' '
                  ' '
                  ' '
                  ' '
                  ' '
                  ' '
                  ' '
                  ' ' 
                  ' ' + 
              subJob['subject'] +
              "|" +
              subJob['explanation'] +
              "|" +
              subJob['creator_id'].toString() +
              "|" +
              subJob['assigned_id'].toString() +
              "|" +
              subJob['parentjob_id'].toString() +
              "|" +
              subJob['departman_id'].toString() +
              "|" +
              subJob['progress'].toString() +
              "|" +
              subJob['deadline'] +
              "|" +
              subJob['creation_date']
        ]);
        var progressData = await _getProgress(subJob['_id']);
        csvData.add([
          ' ' 
              ' ' 
              ' ' 
              ' ' 
              ' ' 
              ' ' 
              ' ' 
              ' '
              ' '
              ' '
              ' '
              ' ' 
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              ' '
              "İd||"
              "GörevId||"
              "KullanıcıId||"
              "İlerleme||"
              "Oluşturma Tarihi"
        ]);
        for (var progress in progressData) {
          csvData.add([
            ' ' 
                    ' ' 
                    ' ' 
                    ' ' 
                    ' ' 
                    ' ' 
                    ' ' 
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' '
                    ' ' 
                    ' ' + 
                progress['_id'].toString() +
                "|" +
                progress['task_id'].toString() +
                "|" +
                progress['user_id'].toString() +
                "|" +
                progress['progress'].toString() +
                "|" +
                progress['registration_date']
          ]);
        }
      }
    }
    String csv = const ListToCsvConverter().convert(csvData);
    try {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory?.path}/rapor.csv');
      await file.writeAsString(csv);
      print('CSV dosyası başarıyla kaydedildi: ${file.path}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV dosyası başarıyla kaydedildi!')),
      );
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }
}
