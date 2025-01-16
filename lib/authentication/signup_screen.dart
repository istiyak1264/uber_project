import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/methods/common_methods.dart';
import 'package:users_app/pages/home_page.dart';
import 'package:users_app/widgets/loading_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController usernametextEditingController = TextEditingController();
  TextEditingController userphonetextEditingController =
      TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();

  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signUpFormValidation();
  }

  signUpFormValidation() {
    if (usernametextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "Your name must be at least 5 or more characters", context);
    } else if (userphonetextEditingController.text.trim().length != 11) {
      cMethods.displaySnackBar("Your phone number must be 11 digits", context);
    } else if (!emailtextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Please enter a valid email", context);
    } else if (passwordtextEditingController.text.trim().length < 6) {
      cMethods.displaySnackBar(
          "Your password must be at least 6 or more characters", context);
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Preparing your account..."),
    );

    // ignore: unused_local_variable
    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
      email: emailtextEditingController.text.trim(),
      password: passwordtextEditingController.text.trim(),
    )
            .catchError((errorMsg) {
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      cMethods.displaySnackBar(errorMsg.toString(), context);
    }))
        .user;
    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap = {
      "name": usernametextEditingController.text.trim(),
      "email": emailtextEditingController.text.trim(),
      "phone": userphonetextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };
    usersRef.set(userDataMap);
    Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                  "/home/istiyak/Desktop/Flutter/users_app/assets/images/logo.png"),
              Text(
                "Create a User\'s Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: usernametextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "username",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: userphonetextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "phone no",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: emailtextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "user email",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: passwordtextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "user password",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkIsAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text("SignUp"),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (c) => LoginScreen()));
                      },
                      child: const Text(
                        "Already have an account? Login here",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
