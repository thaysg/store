import 'package:firebase_store/helpers/validators.dart';
import 'package:firebase_store/models/user.dart';
import 'package:firebase_store/models/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.red[900],
          Colors.red[800],
          Colors.redAccent,
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(
                        FontAwesomeIcons.bullseye,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Garcia Store",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 150,
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              icon: const Icon(
                                Icons.keyboard_return,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('/login');
                              })),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                    child: Text(
                      "Criar Conta",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                const BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: [
                              Form(
                                key: formKey,
                                child: Consumer<UserManager>(
                                    builder: (_, userManager, __) {
                                  return SingleChildScrollView(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Image.asset('images/gs.png'),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: 'Nome Completo',
                                            prefixIcon: Icon(Icons.person),
                                          ),
                                          enabled: !userManager.loading,
                                          validator: (name) {
                                            if (name.isEmpty) {
                                              return 'Campo obrigatório';
                                            } else if (name
                                                    .trim()
                                                    .split(' ')
                                                    .length <=
                                                1) {
                                              return 'Preencha seu Nome completo';
                                            }
                                            return null;
                                          },
                                          onSaved: (name) => user.name = name,
                                          autocorrect: false,
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: 'E-mail',
                                            prefixIcon: Icon(Icons.email),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          autocorrect: false,
                                          enabled: !userManager.loading,
                                          validator: (email) {
                                            if (email.isEmpty) {
                                              return 'Campo obrigatório';
                                            } else if (!emailValid(email)) {
                                              return 'E-mail inválido';
                                            }
                                            return null;
                                          },
                                          onSaved: (email) =>
                                              user.email = email,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: 'Senha',
                                            prefixIcon: Icon(
                                              Icons.lock,
                                            ),
                                          ),
                                          enabled: !userManager.loading,
                                          autocorrect: false,
                                          obscureText: true,
                                          validator: (pass) {
                                            if (pass.isEmpty) {
                                              return 'Campo obrigatório';
                                            } else if (pass.length < 6) {
                                              return 'Senha muito curta';
                                            }
                                            return null;
                                          },
                                          onSaved: (pass) =>
                                              user.password = pass,
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: 'Confirmar Senha',
                                            prefixIcon: Icon(
                                              Icons.lock,
                                            ),
                                          ),
                                          autocorrect: false,
                                          obscureText: true,
                                          enabled: !userManager.loading,
                                          validator: (pass) {
                                            if (pass.isEmpty) {
                                              return 'Campo obrigatório';
                                            } else if (pass.length < 6) {
                                              return 'Senha não coincidem';
                                            }
                                            return null;
                                          },
                                          onSaved: (pass) =>
                                              user.confirmPassword = pass,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        SizedBox(
                                          height: 44,
                                          child: RaisedButton(
                                            onPressed: userManager.loading
                                                ? null
                                                : () {
                                                    if (formKey.currentState
                                                        .validate()) {
                                                      formKey.currentState
                                                          .save();

                                                      if (user.password !=
                                                          user.confirmPassword) {
                                                        scaffoldKey.currentState
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                            'Senhas não coincidem!',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ));
                                                        return;
                                                      }

                                                      userManager.signUp(
                                                          user: user,
                                                          onSuccess: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          onFail: (e) {
                                                            scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                'Falha ao cadastrar: $e',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ));
                                                          });
                                                    }
                                                  },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            color: Colors.blue[900],
                                            disabledColor: Theme.of(context)
                                                .primaryColor
                                                .withAlpha(100),
                                            textColor: Colors.white,
                                            child: userManager.loading
                                                ? const CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.red),
                                                  )
                                                : const Text(
                                                    'Criar Conta',
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}