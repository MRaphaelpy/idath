// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, empty_catches

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idauth/service/services.dart';
import 'package:idauth/service/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGeneratorScreen extends StatefulWidget {
  final UserModel userAutenticated;

  const QRCodeGeneratorScreen({Key? key, required this.userAutenticated})
      : super(key: key);

  @override
  _QRCodeGeneratorScreenState createState() => _QRCodeGeneratorScreenState();
}

class _QRCodeGeneratorScreenState extends State<QRCodeGeneratorScreen> {
  String _qrCodeData = '';
  double _progressValue = 0.0;
  Timer? _timer;
  final double maxProgressValue =
      0.9; // Defina o limite máximo de progresso aqui

  @override
  void initState() {
    super.initState();
    _generateAndSendQRCode();
    _startTimer();
  }

  void _startTimer() {
    const interval = Duration(seconds: 1);
    const totalDuration = Duration(seconds: 30);

    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        _progressValue = timer.tick / totalDuration.inSeconds;
      });

      if (timer.tick >= totalDuration.inSeconds) {
        timer.cancel();
        _generateAndSendQRCode();
        _checkAuthentication();
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
  }

  void _checkAuthentication() async {
    try {
      String autenticado = await Services.getAutenticadoId(
          widget.userAutenticated.id.toString());
      if (autenticado == "1") {
        _setUserNotAuthenticated();

        Navigator.pop(context);
      } else if (autenticado == "0") {}
    } catch (e) {}
  }

  void _setUserNotAuthenticated() async {
    try {
      await Services.updateAutenticadoId(
          widget.userAutenticated.id.toString(), "0");
    } catch (e) {}
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
            child: Container(
              alignment: Alignment.center,
              child: LinearProgressIndicator(
                value: _progressValue > maxProgressValue
                    ? maxProgressValue
                    : _progressValue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
