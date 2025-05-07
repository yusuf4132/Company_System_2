import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  const CustomAppBar({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "$text",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      backgroundColor: Colors.lime.shade600,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
