import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.nameController,
    required this.hint,
  });
  final TextEditingController nameController;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[250], fontSize: 13),
        fillColor: Colors.grey[100],
        filled: true,
        border: InputBorder.none,
      ),
    );
  }
}
