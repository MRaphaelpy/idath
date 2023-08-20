import 'package:flutter/material.dart';
import 'package:idauth/components/custom_button.dart';
import 'package:idauth/components/custom_textfild.dart';
import 'package:idauth/controlers/login_controler_func.dart';
import 'package:idauth/providers/login_provider.dart';
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
                  obscureText: false,
                  controller: _passwordController,
                  labelText: "Senha",
                ),
                const SizedBox(height: 16),
                if (loginProvider.isLoading)
                  const CircularProgressIndicator(
                    color: Colors.black,
                  )
                else
                  CustomButton(
                    onTap: () async {
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
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserHomePage(user: authenticatedUser),
                            ),
                          );
                        } else {
                          loginProvider
                              .setErrorMessage('Email ou senha incorretos.');
                          print('Login Failed');
                        }
                      }
                    },
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
