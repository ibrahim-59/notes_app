import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/ui/theme.dart';

class InputField extends StatelessWidget {
  final String title, hint;
  final TextEditingController? textEditingController;
  final Widget? widget;
  const InputField({
    super.key,
    required this.title,
    required this.hint,
    this.textEditingController,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Text(
          title,
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          readOnly: widget == null ? false : true,
          autofocus: false,
          cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
          controller: textEditingController,
          style: subTitleStyle,
          decoration: InputDecoration(
            suffixIcon: widget,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
