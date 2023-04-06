import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegWidget extends StatefulWidget {
  const RegWidget({super.key});

  @override
  State<RegWidget> createState() => _RegWidgetState();
}

class _RegWidgetState extends State<RegWidget> {
  late FocusNode loginNode;
  late FocusNode passwordNode;
  late FocusNode btn_contNode;
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final _loginformKey = GlobalKey<FormState>();
  final _passwordformKey = GlobalKey<FormState>();
  final _fokformKey = GlobalKey<FormState>();

  @override
  void initState() {
    loginNode = FocusNode();
    passwordNode = FocusNode();
    btn_contNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    loginNode.dispose();
    passwordNode.dispose();
    btn_contNode.dispose();

    loginController.dispose();
    passwordController.dispose();

    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 60,
            child: TextFormField(
              key: _loginformKey,
              controller: loginController,
              onEditingComplete: () => passwordNode.nextFocus(),
              focusNode: loginNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                focusColor: Colors.brown,
                prefixIcon: Icon(
                  Icons.account_circle_outlined,
                ),
                hintText: 'Почта',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.centerLeft,
            height: 60,
            child: TextFormField(
              key: _passwordformKey,
              controller: passwordController,
              obscureText: true,
              focusNode: passwordNode,
              onEditingComplete: () => btn_contNode.nextFocus(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.lock_outline,
                ),
                hintText: 'Пароль',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ButtonTheme(
              child: OutlinedButton(
                onPressed: () async {
                  signUp();
                },
                focusNode: btn_contNode,
                child: const Text('Зарегистрироваться'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ButtonTheme(
              child: OutlinedButton(
                onPressed: () async {
                  signIn();
                },
                focusNode: btn_contNode,
                child: const Text('Войти'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: loginController.text.trim(),
        password: passwordController.text.trim());
  }

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginController.text.trim(),
        password: passwordController.text.trim());
  }
}
