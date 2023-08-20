import 'package:flutter/material.dart';
import 'package:idauth/components/custom_button.dart';
import 'package:idauth/components/custom_textfild.dart';

import 'package:idauth/controlers/login_users_controller.dart';
import 'package:idauth/service/user_model.dart';
import 'package:idauth/user_home_page.dart';

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

  String? _errorMessage;
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      Map<String, dynamic> authenticationResult =
          await LoginControllerUser.authenticate(email, password);

      setState(() {
        _isLoading = false;

        if (authenticationResult['authenticated']) {
          _errorMessage = null;
          UserModel authenticatedUser = authenticationResult['user'];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserHomePage(user: authenticatedUser),
            ),
          );
        } else {
          _errorMessage = 'Email ou senha incorretos.';
          print('Login Failed');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                    ),
                  ),
                ),
                CustomTextField(
                  obscureText: false,
                  controller: _emailController,
                  labelText: "Email",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  obscureText: true,
                  controller: _passwordController,
                  labelText: "Senha",
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const CircularProgressIndicator() // Indicador de carregamento
                else
                  CustomButton(
                    onTap: _login,
                    child: const Center(
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
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
