import 'package:digmart_business/Screens/Register/business_proof.dart';
import 'package:digmart_business/components/Register.dart';
import 'package:flutter/material.dart';

import '../../components/textFieldContainer.dart';
import '../../components/background.dart';
import '../../constants.dart';

class BusinessTypeScreen extends StatelessWidget {
  const BusinessTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
        child: SingleChildScrollView(
      child: BusTypeScreen(),
    ));
  }
}

class BusTypeScreen extends StatelessWidget {
  const BusTypeScreen({
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
              "Business Type",
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
              child: ProofForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

class ProofForm extends StatefulWidget {
  const ProofForm({super.key});

  @override
  State<ProofForm> createState() => _ProofFormState();
}

class _ProofFormState extends State<ProofForm> {
  String type = "";
  String category = "";
  final proofFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: proofFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextFieldContainer(
                child: DropdownButtonFormField(
              value: type == "" ? null : type,
              onSaved: (value) {
                setBusinessType(value!);
              },
              validator: (value) {
                if (value == null) {
                  return "Select Business Type";
                } else {
                  return null;
                }
              },
              items: [
                "Sole Proprietorship",
                "Partnership",
                "Limited Liability Partnership (LLP)"
              ].map((String type) {
                return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: <Widget>[
                        Text(
                          type,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ));
              }).toList(),
              onChanged: (newValue) {
                setState(() => type = newValue!);
              },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  filled: true,
                  fillColor: kPrimaryLightColor,
                  hintText: "Business Type",
                  border: InputBorder.none),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: TextFieldContainer(
                child: DropdownButtonFormField(
              value: category == "" ? null : category,
              onSaved: (value) {
                setBusinessCategory(value!);
              },
              validator: (value) {
                if (value == null) {
                  return "Select Business Category";
                } else {
                  return null;
                }
              },
              items: ["Fashion", "Food"].map((String category) {
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
                setState(() => category = newValue!);
              },
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  filled: true,
                  fillColor: kPrimaryLightColor,
                  hintText: "Business Category",
                  border: InputBorder.none),
            )),
          ),
          const SizedBox(height: defaultPadding),
          SizedBox(
            width: size.width * 0.8,
            child: ElevatedButton(
              onPressed: () {
                if (proofFormKey.currentState!.validate()) {
                  proofFormKey.currentState!.save();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const BusinessProofScreen();
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
        ],
      ),
    );
  }

  getValues() async {
    String? busType = await getBusinessType();
    String? busCat = await getBusinessCategory();

    setState(() {
      type = busType!;
      category = busCat!;
    });
  }
}
