import 'package:company_system_2/api/employeService.dart';
import 'package:company_system_2/api/jobService.dart';
import 'package:company_system_2/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/DepartmentService.dart';

class JobAssignmentPages extends StatefulWidget {
  final String email;
  final Function(int) changePage;
  final String? jobIdd;
  JobAssignmentPages(
      {required this.changePage, required this.email, this.jobIdd});
  @override
  State<JobAssignmentPages> createState() => _JobAssignmentPagesState();
}

class _JobAssignmentPagesState extends State<JobAssignmentPages> {
  String? jobId;
  TextEditingController _idController = TextEditingController();
  String? selectedEmployeeId;
  DateTime? _selectedDate;
  List<Map<String, dynamic>> employees = [];
  String companyName = "";
  int? assignedId;
  String? assignedReal;
  String? assignedDepartmentId;
  String info = "";
  String? departmentId;
  String? assignToDepartmentId;
  String? enteredId;
  String role = "";
  String? searchQuery; // Search query variable
  Future<List<Map<String, dynamic>>>? employeeFuture;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late DepartmentService _departmentService;
  late EmployeeService _employeeService;
  late JobService _jobService;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _getCompanyName() async {
    var employee = await _employeeService.getUserByEmail(widget.email);
    if (employee != null) {
      setState(() {
        companyName = employee['company'] ?? "";
        role = employee['role'];
        departmentId = employee["department_id"] ?? null;
        enteredId = employee["_id"] ?? null;
      });
      _loadEmployees();
    }
  }

  Future<void> _loadEmployees() async {
    final employeeList = await _employeeService.getEmployeesByAdvancedSearch(
        companyName,
        role,
        departmentId,
        searchQuery); // You should specify the company name here
    setState(() {
      employees = employeeList;
    });
  }

  @override
  void initState() {
    super.initState();
    _departmentService = DepartmentService();
    _employeeService = EmployeeService();
    _jobService = JobService();
    jobId = widget.jobIdd; // Get the incoming jobId
    _getCompanyName().then((_) {
      // Load employees after company name is fetched
      setState(() {
        _loadEmployees();
        employeeFuture = _employeeService.getEmployeesByAdvancedSearch(
            companyName, role, departmentId, searchQuery);
      });
    });
  }

  @override
  void dispose() {
    _idController.dispose(); // Dispose the controller
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query; // Update the search query
    });
  }

  Future<void> _saveJobs() async {
    String title = _titleController.text;
    String detail = _detailController.text;
    String? createdById = enteredId;
    String? assignedIdReal = assignedReal;
    String? assignedDepartmentId = assignedDepartmentId;
    String company = companyName;
    DateTime now = DateTime.now(); // Current date and time
    String formattedCreateDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(now); // Formatting
    if (_selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      if (title.isNotEmpty &&
          detail.isNotEmpty &&
          company.isNotEmpty &&
          formattedDate.isNotEmpty != null) {
        if (jobId == null) {
          // Create a new job record
          await _jobService.insertJob({
            'subject': title,
            'explanation': detail,
            'company': company,
            'creator_id': createdById,
            'assigned_id': assignedIdReal,
            'department_id': assignedDepartmentId,
            'deadline': formattedDate,
            'creation_date': formattedCreateDate,
          });
        } else {
          // Update existing job record
          await _jobService.insertJob({
            'subject': title,
            'explanation': detail,
            'company': company,
            'creator_id': createdById,
            'assigned_id': assignedIdReal,
            'ustis_id': jobId,
            'department_id': assignedDepartmentId,
            'deadline': formattedDate,
            'creation_date': formattedCreateDate,
          });
        }
        // Navigate back or show success message
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: "İş Atama "),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Search Employee",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: _onSearchChanged,
                // Triggered every time the user types
                decoration: InputDecoration(
                  labelText: 'Search Employee...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: employeeFuture, // Load data
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // Loading indicator
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text('An error occurred: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No employees found.'));
                  }

                  // When data is fetched, filter employee information
                  List<Map<String, dynamic>> employees = snapshot.data!;
                  // Running an async function to get department names
                  List<Future<String>> departmentNamesFutures =
                      employees.map((employee) {
                    return _departmentService
                        .getDepartmentNameById(employee['department_id']);
                  }).toList();

                  return FutureBuilder<List<String>>(
                    future: Future.wait(departmentNamesFutures),
                    // Use Future.wait to fetch department names
                    builder: (context, deptNamesSnapshot) {
                      if (deptNamesSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (deptNamesSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${deptNamesSnapshot.error}'));
                      }

                      if (deptNamesSnapshot.hasData) {
                        // Get the data matching the department names
                        List<Map<String, dynamic>> employeesWithDepartments =
                            List.generate(employees.length, (index) {
                          return {
                            'employee': employees[index],
                            'department': deptNamesSnapshot.data![index],
                          };
                        });
                        final query = searchQuery?.toLowerCase() ?? '';
                        // You can search based on department name or expertise here
                        List<Map<String, dynamic>> filteredEmployees =
                            employeesWithDepartments.where((employeeData) {
                          String deptOrExpertise = role == 'admin'
                              ? employeeData['department']
                              : employeeData['employee']['expertise'] ?? '';
                          return deptOrExpertise.toLowerCase().contains(query);
                        }).toList();

                        return Table(
                          border: TableBorder.all(),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Employee Id',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Full Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Info",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Select",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                            for (var employeeData in filteredEmployees)
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                       child: Text(employeeData['employee']
                                              ['id']
                                          .toString()),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          '${employeeData['employee']['name']} ${employeeData['employee']['surname']}'),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FutureBuilder<String>(
                                        future: role == 'admin'
                                            ? _departmentService
                                                .getDepartmentNameById(
                                                    employeeData['employee']
                                                        ['department_id'])
                                            : Future.value(
                                                employeeData["employee"]
                                                        ['expertise'] ?? 'N/A'),
                                        builder: (context, deptSnapshot) {
                                          if (deptSnapshot.connectionState == 
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator(); // Department name is loading.
                                          }

                                          if (deptSnapshot.hasError) {
                                            return Text(
                                                'Error: ${deptSnapshot.error}');
                                          }

                                          if (deptSnapshot.hasData) {
                                            return Text(deptSnapshot
                                                .data!); // Department name or expertise
                                          } else {
                                            return Text('Data not found');
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        icon: Icon(Icons.gpp_good_outlined),
                                        onPressed: () {
                                          assignedId = employeeData['employee']
                                              ['id'];
                                          assignedReal =
                                              employeeData['employee']['_id'];
                                          assignedDepartmentId =
                                              employeeData['employee']
                                                  ['department_id'];
                                          setState(() {
                                            _idController.text =
                                                assignedId.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      }

                      return Center(child: Text('Data could not be loaded.'));
                    },
                  );
                },
              ),
              SizedBox(height: 40),
              Text(
                "Selected User ID",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Assign Job to Employee",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Job Subject',
                  hintText: 'Enter Job Subject',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black38,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black12),
                      onPressed: () => _selectDate(context),
                      child: Text(
                        'Select Date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _selectedDate == null
                          ? 'No date selected yet.'
                          : 'Selected Date: ${_selectedDate!.toLocal()}'
                              .split(' ')[0],
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _detailController,
                decoration: InputDecoration(
                  labelText: 'Job Detail',
                  hintText: 'Enter Job Detail',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveJobs,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lime.shade600),
                child: Text("Assign Job",
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}