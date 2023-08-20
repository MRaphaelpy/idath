import 'package:flutter/material.dart';
import 'package:idauth/qr_code_genarator_widget.dart';
import 'package:idauth/service/user_model.dart';

class UserHomePage extends StatefulWidget {
  final UserModel user;

  const UserHomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Home'),
      ),
      body: Center(
        child: QRCodeGeneratorScreen(
          userAutenticated: widget.user,
        ),
      ),
    );
  }
}
