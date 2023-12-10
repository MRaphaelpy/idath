import 'package:flutter/material.dart';
import 'package:idauth/components/textfilds/textformfild_component.dart';
import 'package:idauth/providers/registro_provider.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';
import '../validates/confirpassvalidate.dart';

class RegistroPage extends StatelessWidget {
  const RegistroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: const Color(0xFF212121),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: context.read<RegistroProvider>().formKey,
                  child: Column(
                    children: [
                      FormTextField(
                        keyboardType: TextInputType.name,
                        controller:
                            context.read<RegistroProvider>().nomeController,
                        labelText: "Nome",
                        validator: Validatorless.multiple([
                          Validatorless.required("Nome é necessário"),
                          Validatorless.min(3, "Nome muito curto"),
                          Validatorless.max(50, "Máximo de 50 caracteres")
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormTextField(
                        keyboardType: TextInputType.name,
                        controller:
                            context.read<RegistroProvider>().emailController,
                        labelText: "E-mail",
                        validator: Validatorless.multiple([
                          Validatorless.required("E-mail é necessário"),
                          Validatorless.email("E-mail inválido"),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormTextField(
                        showEyeIcon: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller:
                            context.read<RegistroProvider>().senhaController,
                        obscureText:
                            !context.watch<RegistroProvider>().showPassword,
                        labelText: "Senha",
                        validator: Validatorless.multiple([
                          Validatorless.required("Senha é necessária"),
                          Validatorless.min(6, "Senha muito pequena"),
                          Validatorless.max(20, "Máximo de 20 caracteres"),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormTextField(
                        showEyeIcon: true,
                        obscureText:
                            !context.watch<RegistroProvider>().showPassword,
                        controller: context
                            .read<RegistroProvider>()
                            .confirmaSenhaController,
                        labelText: "Confirmar Senha",
                        keyboardType: TextInputType.visiblePassword,
                        validator: Validatorless.multiple([
                          Validatorless.required(
                              "Confirmar Senha é necessária"),
                          Validators.compare(
                              context.read<RegistroProvider>().senhaController,
                              "Senha não confere")
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormTextField(
                        keyboardType: TextInputType.text,
                        controller:
                            context.read<RegistroProvider>().enderecoController,
                        labelText: "Endereço",
                        validator: Validatorless.multiple([
                          Validatorless.required("Endereço é necessário"),
                          Validatorless.min(5, "Endereço muito curto"),
                          Validatorless.max(100, "Máximo de 100 caracteres")
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormTextField(
                        keyboardType: TextInputType.number,
                        controller:
                            context.read<RegistroProvider>().cepController,
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
                          await context
                              .read<RegistroProvider>()
                              .register(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            "Registrar-se",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      if (context
                          .watch<RegistroProvider>()
                          .errorMessage
                          .isNotEmpty)
                        Text(
                          context.watch<RegistroProvider>().errorMessage,
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
