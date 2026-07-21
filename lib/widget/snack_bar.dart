import 'package:flutter/material.dart';

class FlushbarHelper {
  static void show(
    BuildContext context, {
    dynamic body,
    Color bgColor = Colors.greenAccent,
    String status = 'success',
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          body?.toString() ?? '',
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
