import 'package:digmart_business/Screens/Register/business_details.dart';
import 'package:digmart_business/constants.dart';
import 'package:flutter/material.dart';

import '../Screens/Login/login_screen.dart';

SnackBar displaySnackbar(text) {
  return SnackBar(
    content: Text(text),
    backgroundColor: (kPrimaryColor),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Okay',
      textColor: kPrimaryLightColor,
      onPressed: () {
        //Do whatever you want
      },
    ),
  );
}

SnackBar displayErrorSnackbar(text) {
  return SnackBar(
    content: Text(text),
    backgroundColor: (Colors.red),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Okay',
      textColor: kPrimaryLightColor,
      onPressed: () {},
    ),
  );
}

SnackBar displayLoginSnackbar(text, context) {
  return SnackBar(
    content: Text(text),
    backgroundColor: (kPrimaryColor),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Login',
      textColor: kPrimaryLightColor,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ),
        );
      },
    ),
  );
}

SnackBar displayRegisterSnackbar(text, context) {
  return SnackBar(
    content: Text(text),
    backgroundColor: (kPrimaryColor),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Register',
      textColor: kPrimaryLightColor,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const RegisterScreen();
            },
          ),
        );
      },
    ),
  );
}
