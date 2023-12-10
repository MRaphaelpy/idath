import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:idauth/components/textfilds/custom_textfild.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:idauth/components/custombuttons/custombtn.dart';
import 'package:idauth/controlers/login_controler_func.dart';
import 'package:idauth/providers/login_provider.dart';
import 'package:idauth/pages/registro_usuario.dart';
import 'package:idauth/pages/user_home_page.dart';
import 'package:idauth/service/user_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF212121),
        appBar: AppBar(
          elevation: 0,
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
                _buildTitle(),
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
                _buildLoginButton(),
                _buildRegisterButton(),
                _buildErrorMessage(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    final loginProvider = Provider.of<LoginProvider>(context);
    return loginProvider.isLoading
        ? const CircularProgressIndicator(
            color: Colors.white,
          )
        : GestureDetector(
            onTap: () async {
              await _handleLogin(loginProvider);
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: CustomBtn(
                width: MediaQuery.of(context).size.width,
                text: "Entrar",
                btnColor: const Color(0xFF00E676),
              ),
            ),
          );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
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
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return loginProvider.errorMessage != null
        ? Text(
            loginProvider.errorMessage!,
            style: const TextStyle(color: Colors.red),
          )
        : Container();
  }

  Future<void> _handleLogin(LoginProvider loginProvider) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      var locationPermissionStatus = await Permission.location.request();
      if (locationPermissionStatus.isGranted) {
        if (_formKey.currentState!.validate()) {
          final email = _emailController.text.toLowerCase();
          final password = _passwordController.text;

          loginProvider.setLoading(true);
          loginProvider.setErrorMessage(null);

          Map<String, dynamic> authenticationResult =
              await LoginControllerFunc.loginUser(email, password);

          loginProvider.setLoading(false);

          if (authenticationResult['authenticated']) {
            UserModel authenticatedUser = authenticationResult['user'];
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserHomePage(user: authenticatedUser),
              ),
            );
          } else {
            loginProvider.setErrorMessage('Email, senha ou local incorretos.');
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Ooops! Parece que você não permitiu o acesso à localização. Verifique suas permissões e tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Ooops! Parece que você está sem internet. Verifique sua conexão e tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
