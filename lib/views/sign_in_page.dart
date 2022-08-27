import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../widgets/my_elevated_button.dart';
import '../views/mail_sign_in.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });
    final user =
        await Provider.of<Auth>(context, listen: false).signInAnonymously();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              Provider.of<Auth>(context, listen: false).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign In Page",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            MyElevatedButton(
              color: Colors.orangeAccent,
              onPressed: () => _isLoading ? null : _signInAnonymously,
              child: const Text("Sign In Anonymously"),
            ),
            const SizedBox(height: 10),
            MyElevatedButton(
              color: Colors.yellowAccent,
              child: const Text("Sign In Email/Password"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailSignInPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            MyElevatedButton(
              color: Colors.lightBlueAccent,
              child: const Text("Google Sign In"),
              onPressed: () async {
                final user = await Provider.of<Auth>(context, listen: false)
                    .signInWithGoogle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
