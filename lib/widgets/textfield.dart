import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.hint,
      required this.label,
      this.controller,
      this.isPassword = false});

  final String hint;
  final String label;
  final bool isPassword;
  final TextEditingController? controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true; // Tracks whether the password is hidden.

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword; // Initialize based on isPassword value.
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        color: Colors.white,
      ),
      obscureText: widget.isPassword && _isObscured, // Conditionally obscure text
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        label: Text(widget.label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 255, 254, 254),
            width: 1,
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: _toggleVisibility, // Toggle password visibility
              )
            : null, // No suffix icon for non-password fields
      ),
    );
  }
}
