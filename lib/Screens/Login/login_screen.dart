import 'dart:convert';

import 'package:digmart_business/Screens/Register/business_address.dart';
import 'package:digmart_business/components/register.dart';
import 'package:digmart_business/components/snackbar.dart';
import 'package:digmart_business/components/validation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../components/textFieldContainer.dart';
import '../../components/background.dart';
import '../../constants.dart';
import '../Register/business_details.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
        child: SingleChildScrollView(
      child: MobileLoginScreen(),
    ));
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: [
            const Text(
              "Welcome Back, Login!",
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: defaultPadding * 2),
            Row(
              children: [
                const Spacer(),
                SizedBox(
                    width: size.width * 0.4,
                    child: Image.asset('assets/images/main-logo.png')),
                const Spacer(),
              ],
            ),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final busEmailController = TextEditingController();
  final busPassController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          TextFieldContainer(
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              cursorColor: kPrimaryColor,
              controller: busEmailController,
              validator: (email) {
                if (isValidEmail(email!)) {
                  return null;
                } else {
                  return "Enter valid Email Address";
                }
              },
              decoration: const InputDecoration(
                  hintText: "Business Email Address",
                  icon: Icon(
                    Icons.mail,
                    color: kPrimaryColor,
                  ),
                  border: InputBorder.none),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFieldContainer(
              child: TextFormField(
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                obscureText: true,
                controller: busPassController,
                cursorColor: kPrimaryColor,
                validator: (password) {
                  if (isValidPassword(password!)) {
                    return null;
                  } else {
                    return 'Min 8 chars, 1 letter, 1 number, 1 special';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Business Password",
                    icon: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          SizedBox(
            width: size.width * 0.8,
            child: ElevatedButton(
              onPressed: () {
                if (loginFormKey.currentState!.validate()) {
                  loginFormKey.currentState!.save();
                  loginSeller();
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const RegisterScreen();
                },
              ),
            ),
            child: const Text(
              "Don’t have an account? Register!",
              style: TextStyle(color: kPrimaryColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  loginSeller() async {
    final url = Uri.parse('$urlPrefix/seller/login-seller');
    var json = {
      "busEmail": busEmailController.text,
      "busPass": busPassController.text
    };
    setBusinessEmail(busEmailController.text);
    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"] == "New") {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(displayRegisterSnackbar(
            "Complete your registration process!",
            context,
            const RegisterScreen()));
      }
    } else if (result["status"] == "Authenticated") {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(displayRegisterSnackbar(
            "Complete your registration process!",
            context,
            const BusinessAddressScreen()));
      }
    } else if (result["status"] == "Not Found") {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(displayRegisterSnackbar(
            "No seller with Email Found", context, const RegisterScreen()));
      }
    } else if (result["status"] == "Incorrect") {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(displayErrorSnackbar("Incorrect Email or Password"));
      }
    }
  }
}
