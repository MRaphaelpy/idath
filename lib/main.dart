import 'package:flutter/material.dart';
import 'package:idauth/providers/login_provider.dart';
import 'package:idauth/providers/registro_provider.dart';
import 'package:provider/provider.dart';

import 'package:idauth/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RegistroProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    ),
  );
}
