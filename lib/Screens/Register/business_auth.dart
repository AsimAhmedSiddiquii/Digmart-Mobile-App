import 'dart:convert';

import 'package:digmart_business/Screens/Register/business_address.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../components/background.dart';
import '../../components/snackbar.dart';
import '../../components/constants.dart';

class BusinessVerificationScreen extends StatefulWidget {
  final String busEmail, busPhone;

  const BusinessVerificationScreen(
      {super.key, required this.busEmail, required this.busPhone});

  @override
  State<BusinessVerificationScreen> createState() =>
      _BusinessVerificationScreenState();
}

class _BusinessVerificationScreenState
    extends State<BusinessVerificationScreen> {
  final otpFormKey = GlobalKey<FormState>();

  final TextEditingController _fieldOnePhone = TextEditingController();
  final TextEditingController _fieldTwoPhone = TextEditingController();
  final TextEditingController _fieldThreePhone = TextEditingController();
  final TextEditingController _fieldFourPhone = TextEditingController();
  final TextEditingController _fieldFivePhone = TextEditingController();
  final TextEditingController _fieldSixPhone = TextEditingController();

  final TextEditingController _fieldOneEmail = TextEditingController();
  final TextEditingController _fieldTwoEmail = TextEditingController();
  final TextEditingController _fieldThreeEmail = TextEditingController();
  final TextEditingController _fieldFourEmail = TextEditingController();
  final TextEditingController _fieldFiveEmail = TextEditingController();
  final TextEditingController _fieldSixEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: SingleChildScrollView(
      child: Form(
        key: otpFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: const [
                Text(
                  "OTP Verification",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(height: defaultPadding * 1.25),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Text('Enter OTP sent to ${widget.busPhone}'),
                      const SizedBox(height: defaultPadding * 0.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OtpInput(_fieldOnePhone, true),
                          OtpInput(_fieldTwoPhone, false),
                          OtpInput(_fieldThreePhone, false),
                          OtpInput(_fieldFourPhone, false),
                          OtpInput(_fieldFivePhone, false),
                          OtpInput(_fieldSixPhone, false)
                        ],
                      ),
                      const SizedBox(height: defaultPadding * 1.25),
                      Text('Enter OTP sent to ${widget.busEmail}'),
                      const SizedBox(height: defaultPadding * 0.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OtpInput(_fieldOneEmail, true),
                          OtpInput(_fieldTwoEmail, false),
                          OtpInput(_fieldThreeEmail, false),
                          OtpInput(_fieldFourEmail, false),
                          OtpInput(_fieldFiveEmail, false),
                          OtpInput(_fieldSixEmail, false)
                        ],
                      ),
                      const SizedBox(height: defaultPadding * 1.25),
                      SizedBox(
                        width: size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (otpFormKey.currentState!.validate()) {
                              otpFormKey.currentState!.save();
                              var emailOTP = _fieldOneEmail.text +
                                  _fieldTwoEmail.text +
                                  _fieldThreeEmail.text +
                                  _fieldFourEmail.text +
                                  _fieldFiveEmail.text +
                                  _fieldSixEmail.text;
                              var phoneOTP = _fieldOnePhone.text +
                                  _fieldTwoPhone.text +
                                  _fieldThreePhone.text +
                                  _fieldFourPhone.text +
                                  _fieldFivePhone.text +
                                  _fieldSixPhone.text;
                              verifyOTP(emailOTP, phoneOTP);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 40)),
                          child: Text(
                            "Verify OTP".toUpperCase(),
                          ),
                        ),
                      ),
                      const SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  verifyOTP(emailOTP, phoneOTP) async {
    final url = Uri.parse('$urlPrefix/seller/register/verify-otp');
    var json = {
      "busEmail": widget.busEmail,
      "emailOTP": emailOTP,
      "phoneOTP": phoneOTP,
    };
    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (!result["email"]) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            displayErrorSnackbar('Incorrect Email OTP, re-check!'));
      }
    } else if (!result["phone"]) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            displayErrorSnackbar('Incorrect Phone OTP, re-check!'));
      }
    } else {
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const BusinessAddressScreen();
          },
        ));
      }
    }
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 80,
      width: (size.width * 0.7) / 6,
      child: TextFormField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        validator: (value) {
          if (value!.isEmpty) {
            return "   !";
          }
          return null;
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 22)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
