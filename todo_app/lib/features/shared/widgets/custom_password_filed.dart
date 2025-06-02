import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    required this.passwordController,
    required this.hint,
  });

  final TextEditingController passwordController;
  final String hint;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: hidePassword,
      controller: widget.passwordController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.grey[250], fontSize: 13),
        fillColor: Colors.grey[100],
        filled: true,
        border: InputBorder.none,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
          icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
