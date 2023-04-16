import 'package:digmart_business/components/constants.dart';
import 'package:flutter/material.dart';

import '../Screens/Login/login_screen.dart';

SnackBar displaySnackbar(text) {
  return SnackBar(
    content: Text(text),
    backgroundColor: (kPrimaryColor),
    behavior: SnackBarBehavior.floating,
  );
}

SnackBar displayErrorSnackbar(text) {
  return SnackBar(
    content: Text(text),
    backgroundColor: (const Color.fromARGB(255, 209, 31, 18)),
    behavior: SnackBarBehavior.floating,
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

SnackBar displayRegisterSnackbar(text, context, page) {
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
              return page;
            },
          ),
        );
      },
    ),
  );
}
