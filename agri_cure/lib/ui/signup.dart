import 'package:agri_cure/constants.dart';
import 'package:agri_cure/ui/login.dart';
import 'package:agri_cure/ui/values/app_colors.dart';
import 'package:agri_cure/ui/values/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as globals;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _handleSignup() {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    signUp(username, password, confirmPassword);
  }

  Future<void> signUp(
      //     String username, String password, String confirmPassword) async {
      //   final String baseUrl = 'http://192.168.56.1:3000';

      //   try {
      //     final response = await http.post(
      //       Uri.parse('$baseUrl/signup'),
      //       headers: <String, String>{'Content-Type': 'application/json'},
      //       body: jsonEncode(<String, String>{
      //         'username': username,
      //         'password': password,
      //         'confirmPassword': confirmPassword,
      //       }),
      //     );

      //     if (response.statusCode == 201) {
      //       print('User registered successfully');

      //       print('Response Body: ${response.body}');
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (_) => LoginPage(
      //             message: 'Check your email to verify your account',
      //             backgroundColor: Colors.green,
      //           ),
      //         ),
      //       );
      //     } else {
      //       print(
      //           'Registration failed. Status Code: ${response.statusCode}, Body: ${response.body}');
      //       final Map<String, dynamic> responseData = jsonDecode(response.body);
      //       final String errorMessage = responseData['message'] ?? 'Unknown error';
      //       showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return AlertDialog(
      //             title: Text('Signup Failed'),
      //             content: Text(errorMessage),
      //             actions: [
      //               TextButton(
      //                 onPressed: () {
      //                   Navigator.of(context).pop();
      //                 },
      //                 child: Text('OK'),
      //               ),
      //             ],
      //           );
      //         },
      //       );
      //     }
      //   } catch (e) {
      //     print('Exception during signup: $e');
      //   }
      // }
      String username,
      String password,
      String confirmPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${globals.baseUrl}/signup'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        print('User registered successfully');
        print('Response Body: ${response.body}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginPage(
              message: 'Check your email to verify your account',
              backgroundColor: Colors.green,
            ),
          ),
        );
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String errorMessage = responseData['message'] ?? 'Unknown error';
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Signup Failed'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle other error cases
        print(
            'Registration failed. Status Code: ${response.statusCode}, Body: ${response.body}');
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String errorMessage = responseData['message'] ?? 'Unknown error';
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Signup Failed'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Exception during signup: $e');
    }
  }

  bool isObscure = true;
  bool isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              height: size.height * 0.24,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Constants.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        'Create your account',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'username',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _formKey.currentState?.validate();
                      }
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
                      labelText: 'password',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Focus(
                          descendantsAreFocusable: false,
                          child: IconButton(
                            onPressed: () => setState(() {
                              isObscure = !isObscure;
                            }),
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
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => _formKey.currentState?.validate(),
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Please, Enter Password'
                          : AppConstants.passwordRegex.hasMatch(value)
                              ? null
                              : 'Invalid Password';
                    },
                    obscureText: isObscure,
                    controller: _passwordController,
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: 'confirmPassword',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Focus(
                            descendantsAreFocusable: false,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordObscure =
                                      !isConfirmPasswordObscure;
                                });
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                  const Size(48, 48),
                                ),
                              ),
                              icon: Icon(
                                isConfirmPasswordObscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.black,
                              ),
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
                            ? 'Please, Re-Enter Password'
                            : AppConstants.passwordRegex.hasMatch(value)
                                ? _passwordController.text ==
                                        _confirmPasswordController.text
                                    ? null
                                    : 'Password not matched!'
                                : 'Invalid Password!';
                      },
                      obscureText: isConfirmPasswordObscure,
                      controller: _confirmPasswordController),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _handleSignup();
                      }
                    },
                    style: const ButtonStyle().copyWith(
                      backgroundColor: MaterialStateProperty.all(
                        _formKey.currentState?.validate() ?? false
                            ? null
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I have an account?',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => LoginPage()));
                    },
                    style: Theme.of(context).textButtonTheme.style,
                    child: Text(
                      'Login',
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
    );
  }
}
