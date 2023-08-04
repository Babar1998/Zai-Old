import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:zai_system/View/forgotpassword.dart';
import 'package:zai_system/View/home.dart';
import 'package:zai_system/View/verification_screen.dart';
import 'package:zai_system/model/current_appuser.dart';

import '../Widget/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool passwordVisible=false;

  @override
  void initState(){
    super.initState();
    passwordVisible=false;
  }
  final _auth = FirebaseAuth.instance;
  bool load = false;
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 90),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                          height: 150,
                          width: 150,
                          image: AssetImage('assests/splashScreen/spWhite.png')),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Building the Future with Tech',
                        style: TextStyle(
                            fontSize: 15,
                            color: whitecolor,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Form(
                        key: _formkey,
                        child: Column(children: [
                          Padding(
                            padding: apppaddings,
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'required';
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'EMAIL',
                                hintStyle: const TextStyle(
                                    fontFamily: 'Rubik Medium', fontSize: 16),
                                fillColor: const Color(0xffF8F9FA),
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: iconcolor,
                                ),
                                focusedBorder: fbbutton,
                                enabledBorder: ebbutton,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: apppaddings,
                            child: TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: !passwordVisible,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'required';
                                } else
                                  return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'PASSWORD',
                                hintStyle: const TextStyle(
                                    fontFamily: 'Rubik Medium', fontSize: 16),
                                fillColor: const Color(0xffF8F9FA),
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.lock_outlined,
                                  color: iconcolor,
                                ),
                                suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: Icon(passwordVisible
                                    ? Icons.visibility
                                        : Icons.visibility_off,
                                      color: iconcolor,
                                    ),
                                ),
                                focusedBorder: fbbutton,
                                enabledBorder: ebbutton,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Padding(
                        padding: apppaddings,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Get.to(() => ForgotPScreen());
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: whitecolor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: apppaddings,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: redcolor,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 50,
                              width: 150,
                              child: TextButton(
                                child: Center(
                                  child: Text(
                                    'LOG IN',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'Rubik Medium',
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    await signIn(emailController.text,
                                        passwordController.text);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(fontSize: 15, color: whitecolor),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => const VerificationScr()));
                                  },
                                  child: const Text('Sign up',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 15)))
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn(String email, String password) async {
    print("Validated");

    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                CurrentAppUser.currentUserData
                    .getCurrentUserData(uid.user!.uid),
                Fluttertoast.showToast(msg: "Login Successful"),
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Homescreen())),
              });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";

          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }
}
