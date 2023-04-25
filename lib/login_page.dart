import 'package:dio/dio.dart';
import 'package:dio_ui/data_stored.dart';
import 'package:dio_ui/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loginStatus = false;

  Future<void> fetchData() async {
    try {
      Response url = await Dio().post(
        ('https://spv-dev.dkv.global:8000/api/user/login/'),
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      print(url.statusCode.toString());
      print(url.statusCode);
      if (url.statusCode == 201) {
        final responseBody = (url.data);
        final token = responseBody['token']['access'];
        print('success token $token');
        Fluttertoast.showToast(
          msg: 'Successfully logged in',
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DataStoreScreen(
                token: token,
              ),
            ));
        // as the tost msg was not working so i included this
      } else {
        print("Failed");
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() {
      loginStatus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter Your Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      //obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter Password',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      height: 50,
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () {
                          fetchData();
                        },
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Login in',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        child: const Text(
                          'Click For Sign Up',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
