import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool showEyeIcon;

  const FormTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    required this.keyboardType,
    this.obscureText = false,
    this.showEyeIcon = false,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.labelText,
          suffixIcon: widget.showEyeIcon
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  child: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),
        validator: widget.validator,
        obscureText: widget.obscureText && _isObscured,
        keyboardType: widget.keyboardType,
      ),
    );
  }
}
