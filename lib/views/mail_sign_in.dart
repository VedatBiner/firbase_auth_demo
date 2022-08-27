import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

enum FormStatus { signIn, register, reset }

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  State<EmailSignInPage> createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  // değişkenin değerine göre forma bağlanacak
  FormStatus _formStatus = FormStatus.signIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _formStatus == FormStatus.signIn
            ? buildSignInForm()
            : _formStatus == FormStatus.register
                ? buildRegisterForm()
                : buildResetForm(),
      ),
    );
  }

  Widget buildSignInForm() {
    final _signInFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Lütfen Giriş Yapınız",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return "lütfen geçerli bir adres giriniz";
                } else {
                  return null; // her şey yolunda
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.email),
                hintText: "e-mail",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value!.length < 6) {
                  print(value);
                  return "Şifre, altı (6) karakterden az olamaz";
                } else {
                  return null; // her şey yolunda
                }
              },
              obscureText: true, // Şifreyi gizleyerek yazma
              decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.lock),
                hintText: "Password",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_signInFormKey.currentState!.validate()) {
                  final user = await Provider.of<Auth>(context, listen: false)
                      .signInWithEmailAndPassword(
                          _emailController.text, _passwordController.text);
                  // user 'ın emali verify oldu mu?
                  if (!user!.emailVerified) {
                    await _showMyDialog();
                    await Provider.of<Auth>(context, listen: false).signOut();
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text("Giriş"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.register;
                });
              },
              child: const Text("Yeni Kayıt için tıklayınız"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.reset;
                });
              },
              child: const Text("Şifremi unuttum"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResetForm() {
    final _resetFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _resetFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Şifre Yenileme",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return "lütfen geçerli bir adres giriniz";
                } else {
                  return null; // her şey yolunda
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.email),
                hintText: "e-mail",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_resetFormKey.currentState!.validate()) {
                  await Provider.of<Auth>(context, listen: false)
                      .sendPasswordResetEmail(_emailController.text);
                  await _showResetPasswordDialog();
                  Navigator.pop(context);
                }
              },
              child: const Text("Gönder"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRegisterForm() {
    final _registerFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordConfirmController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Kayıt Formu",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return "lütfen geçerli bir adres giriniz";
                } else {
                  return null; // her şey yolunda
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.email),
                hintText: "e-mail",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value!.length < 6) {
                  print(value);
                  return "Şifre, altı (6) karakterden az olamaz";
                } else {
                  return null; // her şey yolunda
                }
              },
              obscureText: true, // Şifreyi gizleyerek yazma
              decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.lock),
                hintText: "Password",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordConfirmController,
              validator: (value) {
                if (value != _passwordController.text) {
                  return "Şifreler uyuşmuyor";
                } else {
                  return null;
                }
              },
              obscureText: true, // Şifreyi gizleyerek yazma
              decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.lock),
                hintText: "Password again",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_registerFormKey.currentState!.validate()) {
                    final user = await Provider.of<Auth>(context, listen: false)
                        .createUserWithEmailAndPassword(
                        _emailController.text, _passwordController.text);
                    if (!user!.emailVerified) {
                      await user.sendEmailVerification();
                    }
                    await _showMyDialog();
                    await Provider.of<Auth>(context, listen: false).signOut();
                    setState(() {
                      _formStatus = FormStatus.signIn;
                    });
                  }
                }
                on FirebaseAuthException catch(e){
                  print("Kayıt formu içinde hata yakalandı, ${e.message}");
                }

              },
              child: const Text("Kayıt"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.signIn;
                });
              },
              child: const Text("Zaten üye misiniz? Tıklayınız"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Onay Gerekiyor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Merhaba, lütfen mailinizi kontrol ediniz'),
                Text('Onay linkini tıklayıp, tekrar giriş yapınız'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Anladım'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Şifre Yenileme'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Merhaba, lütfen mailinizi kontrol ediniz'),
                Text('Linki tıklayarak şifrenizi yenileyiniz'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Anladım'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
