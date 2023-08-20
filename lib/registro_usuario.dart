import 'package:flutter/material.dart';
import 'package:idauth/components/textformfild_component.dart';
import 'package:idauth/service/services.dart';
import 'package:validatorless/validatorless.dart';
import 'validates/confirpassvalidate.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({Key? key}) : super(key: key);

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cepController = TextEditingController();
  bool showPassword = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.grey.shade300,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Registro',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      FormTextField(
                        keyboratType: TextInputType.name,
                        controller: _nomeController,
                        labelText: "Nome",
                        validator: Validatorless.multiple([
                          Validatorless.required("Nome é necessário"),
                          Validatorless.min(3, "Nome muito curto"),
                          Validatorless.max(50, "Máximo de 50 caracteres")
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormTextField(
                        keyboratType: TextInputType.emailAddress,
                        controller: _emailController,
                        labelText: "E-mail",
                        validator: Validatorless.multiple([
                          Validatorless.required("E-mail é necessário"),
                          Validatorless.email("E-mail inválido"),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormTextField(
                        keyboratType: TextInputType.visiblePassword,
                        controller: _senhaController,
                        obscureText: !showPassword,
                        labelText: "Senha",
                        validator: Validatorless.multiple([
                          Validatorless.required("Senha é necessária"),
                          Validatorless.min(6, "Senha muito pequena"),
                          Validatorless.max(20, "Máximo de 20 caracteres"),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormTextField(
                        obscureText: !showPassword,
                        controller: _confirmaSenhaController,
                        labelText: "Confirmar Senha",
                        keyboratType: TextInputType.visiblePassword,
                        validator: Validatorless.multiple([
                          Validatorless.required(
                              "Confirmar Senha é necessária"),
                          Validators.compare(
                              _senhaController, "Senha não confere")
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormTextField(
                        keyboratType: TextInputType.streetAddress,
                        controller: _enderecoController,
                        labelText: "Endereço",
                        validator: Validatorless.multiple([
                          Validatorless.required("Endereço é necessário"),
                          Validatorless.min(5, "Endereço muito curto"),
                          Validatorless.max(100, "Máximo de 100 caracteres")
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormTextField(
                        controller: _cepController,
                        keyboratType: TextInputType.number,
                        labelText: "CEP",
                        validator: Validatorless.multiple([
                          Validatorless.required("CEP é necessário"),
                          Validatorless.min(8, "CEP inválido"),
                          Validatorless.max(8, "CEP inválido"),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          if (formKey.currentState?.validate() == true) {
                            print("Formulário Válido");
                            final result = await Services.addUser(
                              name: _nomeController.text,
                              email: _emailController.text,
                              password: _senhaController.text,
                              cep: _cepController.text,
                              endereco: _enderecoController.text,
                              qrcode: "",
                              autenticado: "0",
                            );

                            if (result == "success") {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Sucesso"),
                                    content: const Text(
                                        "Usuário registrado com sucesso!"),
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
                              print(result);
                              setState(() {
                                errorMessage =
                                    "Erro ao registrar usuário: Email já registrado";
                              });

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
                                            setState(() {
                                              errorMessage = "";
                                            });
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
                          } else {
                            print("Formulário Inválido teste");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            "Registrar",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (errorMessage.isNotEmpty)
                        Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
