import 'package:flutter/material.dart';
import 'package:idauth/service/services.dart';

class RegistroProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmaSenhaController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController cepController = TextEditingController();

  bool showPassword = false;
  String errorMessage = "";
  bool isLoading = false;

  Future<void> register(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      errorMessage = "";

      final result = await Services.addUser(
        name: nomeController.text,
        email: emailController.text.toLowerCase(),
        password: senhaController.text,
        cep: cepController.text,
        endereco: enderecoController.text,
        qrcode: "",
        autenticado: "0",
      );

      isLoading = false;

      if (result == "success") {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Sucesso"),
              content: const Text("Usuário registrado com sucesso!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        errorMessage = "Erro ao registrar usuário: Email já registrado";

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              opacity: errorMessage.isNotEmpty ? 1 : 0,
              child: AlertDialog(
                title: const Text("Erro"),
                content: Text(errorMessage),
                actions: [
                  TextButton(
                    onPressed: () {
                      errorMessage = "";
                      Navigator.pop(context);
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          },
        );
      }
    }
  }

  void toggleShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }
}
