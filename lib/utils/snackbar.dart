import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String message,
    {Color backgroundColor = const Color.fromARGB(255, 236, 111, 102),
    Duration duration = const Duration(seconds: 3)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}

void showSuccessSnackbar(BuildContext context, String message,
    {Color backgroundColor = const Color.fromARGB(255, 104, 210, 108),
    Duration duration = const Duration(seconds: 3)}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}
