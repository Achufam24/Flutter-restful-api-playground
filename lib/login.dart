import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void login(String email, String password) async {
    try {
      Response response = await post(Uri.parse("https://reqres.in/api/login"),
          body: {"email": email, "password": password});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['token']);
        print(response);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login Sucessful!')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Unable to login')));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Your Email");
                    }
                    // reg expression for email validation
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please Enter a valid email");
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  autofocus: false,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return ("Password is required for login");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter Valid Password(Min. 6 Character)");
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      login(emailController.text.toString(),
                          passwordController.text.toString());
                      print('Form Validated suceesfully');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                    child: Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
