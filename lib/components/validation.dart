bool isValidName(String name) {
  RegExp regex = RegExp('[a-zA-Z ]');
  return regex.hasMatch(name);
}

bool isValidEmail(String email) {
  RegExp regex = RegExp('[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]');
  return regex.hasMatch(email);
}

bool isValidPhone(String phone) {
  RegExp regex = RegExp('[789][0-9]{9}');
  return regex.hasMatch(phone);
}

bool isValidPassword(String pass) {
  RegExp regex =
      RegExp('(?=.*[A-Za-z])(?=.*[0-9])(?=.*[@!%*#?&])[A-Za-z0-9@!%*#?&]{8,}');
  return regex.hasMatch(pass);
}

bool isValidStreetAddress(String street) {
  RegExp regex = RegExp('[a-zA-Z0-9 ,.-]{10,}');
  return regex.hasMatch(street);
}

bool isValidPincode(String pin) {
  RegExp regex = RegExp('[1-9]{1}[0-9]{2}[0-9]{3}');
  return regex.hasMatch(pin);
}

bool isValidGST(String gst) {
  RegExp regex =
      RegExp('[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}');
  return regex.hasMatch(gst);
}

bool isValidFSSAI(String fssai) {
  RegExp regex = RegExp('[0-9]{14}');
  return regex.hasMatch(fssai);
}

bool isValidOTP(String otp) {
  RegExp regex = RegExp('[0-9]{6}');
  return regex.hasMatch(otp);
}

bool isValidIFSC(String ifsc) {
  RegExp regex = RegExp('[A-Z]{4}0[A-Z0-9]{6}');
  return regex.hasMatch(ifsc);
}

bool isValidAccountNo(String phone) {
  RegExp regex = RegExp('[0-9]');
  return regex.hasMatch(phone);
}

bool isValidBankName(String name) {
  RegExp regex = RegExp('[a-zA-Z ]');
  return regex.hasMatch(name);
}

bool isValidNumber(String phone) {
  RegExp regex = RegExp('[0-9]');
  return regex.hasMatch(phone);
}

bool isValidDiscount(String phone) {
  RegExp regex = RegExp('[0-9]{2}');
  return regex.hasMatch(phone);
}
