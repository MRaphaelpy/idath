import 'package:flutter/material.dart';
import 'package:idauth/qrcode/qr_code_genarator_widget.dart';
import 'package:idauth/service/user_model.dart';

class UserHomePage extends StatefulWidget {
  final UserModel user;

  const UserHomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Future<bool> _onWillPop() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Tem certeza de que deseja sair?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Perfil',
              style: TextStyle(color: Colors.black, fontSize: 25)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
            ),
            onPressed: () async {
              final isConfirmed = await _onWillPop();
              if (isConfirmed) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Center(
              child: CircleAvatar(
                radius: 90,
                backgroundColor: Colors.blue, // Cor de fundo do avatar
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 90,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                widget.user.name.toString(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 400,
              child: Center(
                child: QRCodeGeneratorScreen(
                  userAutenticated: widget.user,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
