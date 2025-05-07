import 'package:flutter/material.dart';

class ElevatedButtonPages extends StatelessWidget {
  final Function(int) changePage;
  final String text;
  final int page_index;
  final BuildContext context;
  const ElevatedButtonPages(
      {required this.text,
      required this.changePage,
      required this.page_index,
      required this.context});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        changePage(page_index);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.lime.shade600,
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        "$text",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
