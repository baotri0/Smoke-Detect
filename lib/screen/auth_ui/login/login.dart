import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constaints/constants.dart';
import '../../../constaints/routes.dart';
import '../../../constaints/top_titles.dart';
import '../../../custom_bottom_bar/custom_bottom_bar.dart';
import '../../../firebase_helper/firebase_auth.dart';
import '../sign_up/sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isShowPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Text("Log in",style: TextStyle(fontSize: 30),),
              SizedBox(height: 12,),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: password,
                obscureText: isShowPassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.password_outlined,
                  ),
                  suffixIcon: CupertinoButton(
                    onPressed: () {
                      setState(() {
                        isShowPassword = !isShowPassword;
                      });
                    },
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 36,
              ),
              ElevatedButton(
                child: Text("Log in",style: TextStyle(fontSize: 20),),
                onPressed: () async {
                  bool isValidated = loginVaildation(email.text, password.text);
                  if (isValidated) {
                    bool isLogined = await FirebaseAuthHelper.instance
                        .login(email.text, password.text, context);
                    if (isLogined) {
                      Routes.instance
                          .pushAndRemoveUntil(widget: CustomBottomBar(), context: context);
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "Don't have an account?",
              )),
              Center(
                  child: CupertinoButton(
                onPressed: () {
                  Routes.instance.push(widget: SignUp(), context: context);
                },
                child: Text(
                  "Create an account",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
