import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboratType;

  const FormTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    required this.keyboratType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          labelText: labelText,
        ),
        validator: validator,
        obscureText: obscureText,
      ),
    );
  }
}
