import 'package:flutter/material.dart';
import 'package:notes_app/ui/theme.dart';

class Button extends StatelessWidget {
  final void Function()? onpressed;
  final String title;
  const Button({super.key, required this.title, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: primaryClr,
        ),
        onPressed: onpressed,
        child: Text(title),
      ),
    );
  }
}
