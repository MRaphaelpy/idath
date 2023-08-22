// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:idauth/components/custom_textfild.dart';
import 'package:idauth/components/custombtn.dart';
import 'package:idauth/controlers/login_controler_func.dart';
import 'package:idauth/providers/login_provider.dart';
import 'package:idauth/registro_usuario.dart';
import 'package:idauth/user_home_page.dart';
import 'package:idauth/service/user_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF212121),
        appBar: AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: const Color(0xFF212121),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                    ),
                  ),
                ),
                CustomTextField(
                  obscureText: false,
                  showEyeIcon: false,
                  controller: _emailController,
                  labelText: "Email",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  showEyeIcon: true,
                  obscureText: true,
                  controller: _passwordController,
                  labelText: "Senha",
                ),
                const SizedBox(height: 16),
                if (loginProvider.isLoading)
                  const CircularProgressIndicator(
                    color: Colors.white,
                  )
                else
                  GestureDetector(
                    onTap: () async {
                      // Check internet connectivity
                      var connectivityResult =
                          await Connectivity().checkConnectivity();

                      if (connectivityResult != ConnectivityResult.none) {
                        // Request location permission
                        var locationPermissionStatus =
                            await Permission.location.request();

                        if (locationPermissionStatus.isGranted) {
                          if (_formKey.currentState!.validate()) {
                            final email = _emailController.text;
                            final password = _passwordController.text;

                            loginProvider.setLoading(true);
                            loginProvider.setErrorMessage(null);

                            Map<String, dynamic> authenticationResult =
                                await LoginControllerFunc.loginUser(
                                    email, password);

                            loginProvider.setLoading(false);

                            if (authenticationResult['authenticated']) {
                              UserModel authenticatedUser =
                                  authenticationResult['user'];
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserHomePage(user: authenticatedUser),
                                ),
                              );
                            } else {
                              loginProvider.setErrorMessage(
                                  'Email ou senha incorretos.');
                            }
                          }
                        } else {
                          // Handle permission denied or show a message

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Ooops! Parece que você nao permitiu o acesso a localização. Verifique suas permissões e tente novamente.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        // Show no internet connection message
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Ooops! Parece que você está sem internet. Verifique sua conexão e tente novamente.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: CustomBtn(
                      width: MediaQuery.of(context).size.width,
                      text: "Entrar",
                      btnColor: const Color(0xFF00E676),
                    ),
                  ),
                const SizedBox(height: 16),
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
                    width: MediaQuery.of(context).size.width,
                    text: "Registrar-se",
                    btnColor: Colors.white,
                    textColor: Colors.black,
                  ),
                ),
                if (loginProvider.errorMessage != null)
                  Text(
                    loginProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
