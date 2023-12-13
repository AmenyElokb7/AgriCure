import 'dart:io';
import 'globals.dart' as globals;
import 'package:agri_cure/constants.dart';
import 'package:agri_cure/ui/home.dart';
import 'package:agri_cure/ui/signup.dart';
import 'package:agri_cure/ui/values/app_colors.dart';
import 'package:agri_cure/ui/values/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  final String? message;
  final Color? backgroundColor;

  LoginPage({Key? key, this.message, this.backgroundColor}) : super(key: key);
  static BuildContext? loginContext;
  @override
  _LoginPageState createState() => _LoginPageState();
}

const String baseUrl = 'http://192.168.56.1:3000';

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      bool success = await login(username, password);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged In!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => Home(
                    plantId: 1,
                  )),
        );

        _usernameController.clear();
        _passwordController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Invalid credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // Handle any errors that occur during the login process
      print('Error during login: $error');
    }
  }

  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    LoginPage.loginContext = context;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: size.height * 0.24,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Constants.primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sign in to your\nAccount',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          letterSpacing: 0.5,
                        )),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      'Sign in to your Account',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // Add a widget to display the message
              widget.message != null
                  ? Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ??
                            const Color.fromARGB(255, 112, 181, 114)
                                .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.message!,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : SizedBox.shrink(),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Please, Enter Email Address'
                            : AppConstants.emailRegex.hasMatch(value)
                                ? null
                                : 'Invalid Email Address';
                      },
                      controller: _usernameController,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                const Size(48, 48),
                              ),
                            ),
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                      validator: (value) {
                        return value!.isEmpty
                            ? 'Please, Enter Password'
                            : AppConstants.passwordRegex.hasMatch(value)
                                ? null
                                : 'Invalid Password';
                      },
                      controller: _passwordController,
                      obscureText: isObscure,
                    ),
                    TextButton(
                      onPressed: () {},
                      style: Theme.of(context).textButtonTheme.style,
                      child: Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    FilledButton(
                      onPressed: _formKey.currentState?.validate() ?? false
                          ? () {
                              _handleLogin();
                            }
                          : null,
                      style: const ButtonStyle().copyWith(
                        backgroundColor: MaterialStateProperty.all(
                          _formKey.currentState?.validate() ?? false
                              ? null
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => SignupPage()));
                      },
                      style: Theme.of(context).textButtonTheme.style,
                      child: Text(
                        'Register',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> login(String username, String password) async {
  print(Uri.parse('$baseUrl/login'));
  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    //withCredentials: true,
    headers: <String, String>{'Content-Type': 'application/json'},
    body: jsonEncode(
        <String, String>{'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    // Login successful
    print('Login successful');
    globals.loggedInUsername = username;
    return true;
  } else {
    // Handle error
    print('Error: ${response.statusCode}');
    return false;
  }
}
