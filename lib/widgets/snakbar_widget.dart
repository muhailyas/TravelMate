import 'package:flutter/material.dart';
import 'package:travelmate/Widgets/Text.dart';

void showCustomSnackbar({
  required BuildContext context,
  required Color backgroundColor,
  int second = 2,
  required String message,
  required Icon icon,
}) {
  final snackbar = SnackBar(
    content: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: icon,
        ),
         SizedBox(width: MediaQuery.of(context).size.width*0.015),
        Expanded(
          child: Text(message,
              style: googleFontStyle(
                  fontsize: 16,
                  fontweight: FontWeight.w600,
                  color: Colors.white)),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: second),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 4,
    animation: CurvedAnimation(
      parent: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: ScaffoldMessenger.of(context),
      )..forward(),
      curve: Curves.bounceIn,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
