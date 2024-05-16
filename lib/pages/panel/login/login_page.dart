import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();

  final userControler = TextEditingController();

  final passControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(50),
            child: Image.asset('assets/imgs/INGLES-PARA-DEVS_logo.png'),
          )),
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _keyForm,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: userControler,
                            decoration: textFieldDecoration("usuario"),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "complete el compo";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: passControler,
                            obscureText: true,
                            decoration: textFieldDecoration("contraseña"),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "complete el compo";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 50),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(0, 31, 94, 1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 15),
                            ),
                            onPressed: login,
                            child: Text(
                              "Login",
                              style: GoogleFonts.getFont(
                                'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void login() {
    if (_keyForm.currentState!.validate()) {
      if (userControler.text == "admin" && passControler.text == "admin123") {
        final box = Hive.box("sesion");
        box.putAll({'user': userControler.text, 'pass': passControler.text});
        context.replace("/panel");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Usuario no valido",
            style: GoogleFonts.getFont(
              'Poppins',
              // color: const Color.fromRGBO(0, 31, 94, 1),
              // fontSize: [0, 1].contains(sizeScreen.index) ? 24 : 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 20,
              left: 20),
        ));
      }
    }
  }

  InputDecoration textFieldDecoration(String name) {
    return InputDecoration(
      labelText: name,
      hintText: name,
      filled: true,
      fillColor: const Color.fromRGBO(255, 255, 255, 1),
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(0, 31, 94, 1),
        ),
      ),
    );
  }
}
