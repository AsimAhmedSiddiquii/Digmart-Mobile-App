import 'package:digmart_business/Screens/Register/business_proof.dart';
import 'package:flutter/material.dart';

import '../../components/textFieldContainer.dart';
import '../../components/background.dart';
import '../../components/validation.dart';
import '../../components/register.dart';
import '../../constants.dart';

class BusinessBankDetails extends StatelessWidget {
  const BusinessBankDetails({Key? key}) : super(key: key);

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
              "Bank Details",
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
              child: BusinessBankDetailForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

class BusinessBankDetailForm extends StatefulWidget {
  const BusinessBankDetailForm({super.key});

  @override
  State<BusinessBankDetailForm> createState() => _BusinessDetailFormState();
}

class _BusinessDetailFormState extends State<BusinessBankDetailForm> {
  final detailsFormKey = GlobalKey<FormState>();

  final bankNameController = TextEditingController();
  final accountNameController = TextEditingController();
  final bankAccountController = TextEditingController();
  final bankIFSCController = TextEditingController();

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
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                controller: bankNameController,
                onSaved: (value) {
                  setBankName(value!);
                },
                validator: (name) {
                  if (isValidBankName(name!)) {
                    return null;
                  } else {
                    return 'Enter a valid Bank Name';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Bank Name",
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
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                controller: accountNameController,
                cursorColor: kPrimaryColor,
                onSaved: (value) {
                  setBankAccountName(value!);
                },
                validator: (account) {
                  if (isValidBankName(account!)) {
                    return null;
                  } else {
                    return 'Enter a valid Bank Account Name';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Bank Account Name",
                    icon: Icon(
                      Icons.business_center,
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
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: bankAccountController,
                cursorColor: kPrimaryColor,
                maxLength: 10,
                onSaved: (value) {
                  setAccountNo(value!);
                },
                validator: (accNo) {
                  if (isValidAccountNo(accNo!)) {
                    return null;
                  } else {
                    return 'Enter a valid Bank Account No';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Bank Account Number",
                    icon: Icon(
                      Icons.pin,
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
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                controller: bankIFSCController,
                cursorColor: kPrimaryColor,
                onSaved: (value) {
                  setBankIFSC(value!);
                },
                validator: (ifsc) {
                  if (isValidIFSC(ifsc!)) {
                    return null;
                  } else {
                    return 'Enter valid Bank IFSC';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "Bank IFSC",
                    icon: Icon(
                      Icons.closed_caption,
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
                if (detailsFormKey.currentState!.validate()) {
                  detailsFormKey.currentState!.save();
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
    String? bankName = await getBankName();
    bankNameController.text = bankName ?? "";

    String? accountName = await getBankAccountName();
    accountNameController.text = accountName ?? "";

    String? bankIFSC = await getBankIFSC();
    bankIFSCController.text = bankIFSC ?? "";

    String? bankAccNo = await getAccountNo();
    bankAccountController.text = bankAccNo ?? "";
  }
}
