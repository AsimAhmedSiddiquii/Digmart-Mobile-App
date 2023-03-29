import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getBusinessName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('busName');
}

void setBusinessName(String busName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('busName', busName);
}

Future<String?> getBusinessEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('busEmail');
}

void setBusinessEmail(String busEmail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('busEmail', busEmail);
}

Future<String?> getBusinessPhone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('busPhone');
}

void setBusinessPhone(String busPhone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('busPhone', busPhone);
}

Future<String?> getBusinessPass() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('busPass');
}

void setBusinessPass(String busPass) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('busPass', busPass);
}

Future<String?> getBusinessAddress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('busAddress');
}

void setBusinessAddress(String busAddress) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('busAddress', busAddress);
}

Future<String?> getBusinessCity() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('busCity');
}

void setBusinessCity(String busCity) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('busCity', busCity);
}

Future<String?> getBusinessState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('busState');
}

void setBusinessState(String busState) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('busState', busState);
}

Future<String?> getBusinessPin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('busPin');
}

void setBusinessPin(String busPin) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('busPin', busPin);
}

Future<String?> getBusinessType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('busType');
}

void setBusinessType(String busType) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('busType', busType);
}

Future<String?> getBusinessCategory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('busCat');
}

void setBusinessCategory(String busCat) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('busCat', busCat);
}

void clearRegisterStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
