import 'package:flutter/material.dart';
import 'package:idauth/components/custombtn.dart';
import 'package:idauth/login_page_state.dart';
import 'package:idauth/registro_usuario.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF212121),
        // ignore: sized_box_for_whitespace
        body: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bem vindo ao IDAuth",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  )),
              SizedBox(height: height * .05),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: CustomBtn(
                  width: width,
                  text: "Login",
                  btnColor: Colors.white,
                  textColor: Colors.black,
                ),
              ),
              SizedBox(height: height * .02),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistroPage(),
                    ),
                  );
                },
                child: CustomBtn(
                  width: width,
                  text: "Registrar-se",
                  btnColor: const Color(0xFF00E676),
                  textColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
