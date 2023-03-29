import 'package:digmart_business/Screens/Login/login_screen.dart';
import 'package:digmart_business/Screens/Register/business_address.dart';
import 'package:flutter/material.dart';

import '../../components/textFieldContainer.dart';
import '../../components/background.dart';
import '../../components/validation.dart';
import '../../components/register.dart';
import '../../constants.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
        child: SingleChildScrollView(
      child: MobileRegisterScreen(),
    ));
  }
}

class MobileRegisterScreen extends StatelessWidget {
  const MobileRegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: const [
            Text(
              "Business Information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(height: defaultPadding * 1.75),
          ],
        ),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: BusinessDetailForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

class BusinessDetailForm extends StatefulWidget {
  const BusinessDetailForm({super.key});

  @override
  State<BusinessDetailForm> createState() => _BusinessDetailFormState();
}

class _BusinessDetailFormState extends State<BusinessDetailForm> {
  final detailsFormKey = GlobalKey<FormState>();

  String busName = "";

  final busNameController = TextEditingController();
  final busPhoneController = TextEditingController();
  final busEmailController = TextEditingController();
  final busPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: detailsFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextFieldContainer(
              child: TextFormField(
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                controller: busNameController,
                onSaved: (value) {
                  setBusinessName(value!);
                },
                validator: (name) {
                  if (isValidName(name!)) {
                    return null;
                  } else {
                    return 'Enter a valid Business Name';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Business Name",
                    icon: Icon(
                      Icons.business,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextFieldContainer(
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                controller: busEmailController,
                cursorColor: kPrimaryColor,
                onSaved: (value) {
                  setBusinessEmail(value!);
                },
                validator: (email) {
                  if (isValidEmail(email!)) {
                    return null;
                  } else {
                    return 'Enter a valid Email Address';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Business Email Address",
                    icon: Icon(
                      Icons.email,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextFieldContainer(
              child: TextFormField(
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumber],
                controller: busPhoneController,
                cursorColor: kPrimaryColor,
                maxLength: 10,
                onSaved: (value) {
                  setBusinessPhone(value!);
                },
                validator: (phone) {
                  if (isValidPhone(phone!)) {
                    return null;
                  } else {
                    return 'Enter a valid Phone Number';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Business Phone",
                    icon: Icon(
                      Icons.phone,
                      color: kPrimaryColor,
                    ),
                    counterText: "",
                    border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextFieldContainer(
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                obscureText: true,
                controller: busPassController,
                cursorColor: kPrimaryColor,
                onSaved: (value) {
                  setBusinessPass(value!);
                },
                validator: (password) {
                  if (isValidPassword(password!)) {
                    return null;
                  } else {
                    return 'Min 8 chars, 1 letter, 1 number, 1 special';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Your password",
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
                if (detailsFormKey.currentState!.validate()) {
                  detailsFormKey.currentState!.save();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const BusinessAddressScreen();
                    },
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
              child: Text(
                "Next".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            child: const Text(
              "Already have an account? Login",
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  getValues() async {
    String? busName = await getBusinessName();
    busNameController.text = busName!;

    String? busEmail = await getBusinessEmail();
    busEmailController.text = busEmail!;

    String? busPhone = await getBusinessPhone();
    busPhoneController.text = busPhone!;

    String? busPass = await getBusinessPass();
    busPassController.text = busPass!;
  }
}
