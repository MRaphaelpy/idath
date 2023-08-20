import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idauth/service/services.dart';
import 'package:idauth/service/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGeneratorScreen extends StatefulWidget {
  final UserModel userAutenticated;

  const QRCodeGeneratorScreen({super.key, required this.userAutenticated});

  @override
  // ignore: library_private_types_in_public_api
  _QRCodeGeneratorScreenState createState() => _QRCodeGeneratorScreenState();
}

class _QRCodeGeneratorScreenState extends State<QRCodeGeneratorScreen> {
  String _qrCodeData = '';
  double _progressValue = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _generateAndSendQRCode(); // Chama a função para gerar e enviar o QR Code
    _startTimer();
  }

  void _startTimer() {
    const interval = Duration(seconds: 1);
    const totalDuration = Duration(seconds: 5);

    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        _progressValue = timer.tick / totalDuration.inSeconds;
      });

      if (timer.tick >= totalDuration.inSeconds) {
        timer.cancel();
        _generateAndSendQRCode(); // Gera e envia um novo QR Code
        _checkAuthentication(); // Verifica autenticação após o término do timer
        _startTimer();
      }
    });
  }

  void _generateAndSendQRCode() async {
    String newQrcode = widget.userAutenticated.getUpdatedQrcode();
    await Services.updateQrCode(
      id: widget.userAutenticated.id.toString(),
      qrcode: newQrcode,
    );

    setState(() {
      _qrCodeData = newQrcode;
    });

    print('Novo QR Code gerado e enviado: $_qrCodeData');
  }

  void _checkAuthentication() async {
    try {
      String autenticado = await Services.getAutenticadoId(
          widget.userAutenticated.id.toString());
      if (autenticado == "1") {
        print("Usuário autenticado!");
        _setUserNotAuthenticated(); // Define o usuário como não autenticado
        Navigator.pop(context); // Volta para a tela anterior
      } else if (autenticado == "0") {
        print("Usuário não autenticado!");
      }
    } catch (e) {
      print("Erro ao verificar autenticação: $e");
    }
  }

  void _setUserNotAuthenticated() async {
    try {
      await Services.updateAutenticadoId(
          widget.userAutenticated.id.toString(), "0");
      print("Usuário definido como não autenticado!");
    } catch (e) {
      print("Erro ao definir usuário como não autenticado: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: QrImageView(
              data: _qrCodeData,
              version: QrVersions.auto,
              size: 250.0,
            ),
          ),
          Text(_qrCodeData.toString()),
          Container(
            padding: const EdgeInsets.only(left: 50.0, right: 50.0),
            child: LinearProgressIndicator(
              value: _progressValue,
            ),
          ),
        ],
      ),
    );
  }
}
