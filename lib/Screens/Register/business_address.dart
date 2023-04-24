import 'dart:convert';

import 'package:digmart_business/Screens/Register/business_type.dart';
import 'package:digmart_business/components/sessionData.dart';
import 'package:digmart_business/components/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../components/textFieldContainer.dart';
import '../../components/background.dart';
import '../../components/validation.dart';
import '../../components/constants.dart';

class BusinessAddressScreen extends StatelessWidget {
  const BusinessAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
        child: SingleChildScrollView(
      child: BusAddressScreen(),
    ));
  }
}

class BusAddressScreen extends StatelessWidget {
  const BusAddressScreen({
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
              "Business Address",
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
              child: AddressForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  String city = "";
  String state = "";
  final addressFormKey = GlobalKey<FormState>();

  final busStreetController = TextEditingController();
  final busPincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: addressFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextFieldContainer(
              child: TextFormField(
                keyboardType: TextInputType.streetAddress,
                autofillHints: const [AutofillHints.streetAddressLevel1],
                textInputAction: TextInputAction.done,
                cursorColor: kPrimaryColor,
                controller: busStreetController,
                onSaved: (value) {
                  setBusinessAddress(value!);
                },
                validator: (address) {
                  if (isValidStreetAddress(address!)) {
                    return null;
                  } else {
                    return 'Enter valid Street Address';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Business Address",
                    icon: Icon(
                      Icons.location_on,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextFieldContainer(
                child: DropdownButtonFormField(
              value: city == "" ? null : city,
              onSaved: (value) {
                setBusinessCity(value!);
              },
              validator: (value) {
                if (value == null) {
                  return "Select a City";
                } else {
                  return null;
                }
              },
              items: ["Mumbai"].map((String category) {
                return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: <Widget>[
                        Text(
                          category,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ));
              }).toList(),
              onChanged: (newValue) {
                setState(() => city = newValue!);
              },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  filled: true,
                  fillColor: kPrimaryLightColor,
                  hintText: "Select Business City",
                  icon: Icon(
                    Icons.location_city,
                    color: kPrimaryColor,
                  ),
                  border: InputBorder.none),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextFieldContainer(
                child: DropdownButtonFormField(
              value: state == "" ? null : state,
              onSaved: (value) {
                setBusinessState(value!);
              },
              validator: (value) {
                if (value == null) {
                  return "Select a State";
                } else {
                  return null;
                }
              },
              items: ["Maharashtra"].map((String category) {
                return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: <Widget>[
                        Text(
                          category,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ));
              }).toList(),
              onChanged: (newValue) {
                setState(() => state = newValue!);
              },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  filled: true,
                  fillColor: kPrimaryLightColor,
                  hintText: "Select Business State",
                  icon: Icon(
                    Icons.my_location,
                    color: kPrimaryColor,
                  ),
                  border: InputBorder.none),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextFieldContainer(
              child: TextFormField(
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.postalCode],
                textInputAction: TextInputAction.done,
                cursorColor: kPrimaryColor,
                controller: busPincodeController,
                maxLength: 6,
                onSaved: (value) {
                  setBusinessPin(value!);
                },
                validator: (pincode) {
                  if (isValidPincode(pincode!)) {
                    return null;
                  } else {
                    return 'Enter valid Pincode';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Business Pincode",
                    counterText: "",
                    icon: Icon(
                      Icons.pin,
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
              onPressed: () async {
                if (addressFormKey.currentState!.validate()) {
                  addressFormKey.currentState!.save();
                  saveAddressDetails();
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
        ],
      ),
    );
  }

  getValues() async {
    String? busAddress = await getBusinessAddress();
    busStreetController.text = busAddress ?? "";

    String? busPin = await getBusinessPin();
    busPincodeController.text = busPin ?? "";

    String? busCity = await getBusinessCity();
    String? busState = await getBusinessState();

    setState(() {
      city = busCity ?? "";
      state = busState ?? "";
    });
  }

  saveAddressDetails() async {
    final url = Uri.parse('$urlPrefix/seller/register/address-details');
    var json = {
      "busEmail": await getBusinessEmail(),
      "busAddress": busStreetController.text,
      "busCity": city,
      "busState": state,
      "busPin": busPincodeController.text,
    };

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"]) {
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const BusinessTypeScreen();
          },
        ));
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            displayErrorSnackbar("Something Went Wrong, Contact Support!"));
      }
    }
  }
}
