import 'package:company_system_2/Job/job_assignment.dart';
import 'package:company_system_2/Job/jobs_page.dart';
import 'package:company_system_2/Personel/personel.dart';
import 'package:company_system_2/Personel/personel_add.dart';
import 'package:company_system_2/announcement/announcement_page.dart';
import 'package:company_system_2/announcement/announcement_add.dart';
import 'package:company_system_2/meetingroom/meeting_room.dart';
import 'package:company_system_2/meetingroom/meeting_room_organize.dart';
import 'package:company_system_2/meetingroom/reservation.dart';
import 'package:company_system_2/department/departments_page.dart';
import 'package:company_system_2/profilepage/profile.dart';
import 'package:company_system_2/rapor/rapor.dart';
import 'package:company_system_2/selectionpage/selection.dart';
import 'package:company_system_2/homepage/home_page.dart';
import 'package:flutter/material.dart';

class Frames extends StatefulWidget {
  final String email;
  Frames({required this.email});
  @override
  State<Frames> createState() => _FrameState();
}

class _FrameState extends State<Frames> {
  int activePageIndex = 0;
  List<int> pageHistory = [];

  void changePage(int index) {
    setState(() {
      if (activePageIndex != index) {
        pageHistory.add(activePageIndex);
      }
      activePageIndex = index;
    });
  }

  void goBack() {
    setState(() {
      if (pageHistory.isNotEmpty) {
        activePageIndex = pageHistory.removeLast();
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (pageHistory.isNotEmpty) {
          goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: activePageIndex,
          children: [
            HomePages(changePage: changePage, email: widget.email),
            SelectionPages(changePage: changePage, email: widget.email),
            ProfilePages(email: widget.email),
            AnnouncementPages(changePage: changePage, email: widget.email),
            AnnouncementAddPages(email: widget.email),
            PersonelPages(changePage: changePage, email: widget.email),
            PersonelAddPages(email: widget.email),
            JobsPages(changePage: changePage, email: widget.email),
            JobAssignmentPages(changePage: changePage, email: widget.email),
            AccountingPages(changePage: changePage),
            SalaryPages(),
            IncomePages(changePage: changePage),
            ExpensePages(changePage: changePage),
            GainPages(),
            ExpenseAddPages(),
            IncomeAddPages(),
            MeetingRoomPages(changePage: changePage, email: widget.email),
            ReservationPages(email: widget.email, changePage: changePage),
            PersonelPages(changePage: changePage, email: widget.email),
            MeetingRoomOrganizePages(email: widget.email),
            DepartmentPages(email: widget.email),
            RaporPages(email: widget.email, changepage: changePage),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  BottomAppBar _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.lime.shade600,
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              changePage(0);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: activePageIndex == 0 ? Colors.black54 : Colors.black,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.work,
                  color: Colors.lime.shade600,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              changePage(1);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: activePageIndex == 1 ? Colors.black54 : Colors.black,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.menu,
                  color: Colors.lime.shade600,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              changePage(2);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: activePageIndex == 2 ? Colors.black54 : Colors.black,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.account_circle_sharp,
                  color: Colors.lime.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
