import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    super.key,
    required this.width,
    required this.text,
    this.btnColor,
    this.textColor,
  });
  final double width;
  final String text;
  final Color? btnColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width *.8,
     
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
