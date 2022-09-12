import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              label: Text('Email address'),
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              label: Text('Password'),
              // hintText: 'Enter your password',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await showErrorDialog(
                      context, 'No user found for that email.', 'Log in error');
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(context,
                      'Wrong password provided for that user.', 'Log in error');
                } else {
                  await showErrorDialog(
                      context, e.message.toString(), 'Log in error');
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Register'))
        ],
      ),
    );
  }
}

Future<void> showErrorDialog(BuildContext context, String msg,
    [String title = ""]) {
  return showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok')),
        ],
      );
    }),
  );
}
