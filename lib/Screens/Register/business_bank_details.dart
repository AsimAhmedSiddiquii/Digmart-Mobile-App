import 'dart:convert';
import 'dart:io';

import 'package:digmart_business/Screens/Register/business_proof.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../components/snackbar.dart';
import '../../components/textFieldContainer.dart';
import '../../components/background.dart';
import '../../components/validation.dart';
import '../../components/sessionData.dart';
import '../../components/constants.dart';

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

  bool selected = false, uploaded = false, uploading = false;
  PlatformFile? file;
  String bankFileURL = "", email = "";

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
                inputFormatters: [UpperCaseTextFormatter()],
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
          SizedBox(
            width: size.width * 0.8,
            height: 60,
            child: ElevatedButton.icon(
              icon: uploaded
                  ? const Icon(
                      Icons.check_box,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.upload_file,
                      color: kPrimaryColor,
                    ),
              style: uploaded
                  ? ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40))
                  : ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          side: BorderSide(color: kPrimaryColor)),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40)),
              onPressed: () async {
                setState(() {
                  uploading = true;
                });
                final firebaseStorage = FirebaseStorage.instance;
                final UploadTask? uploadTask;
                final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg', 'jpeg']);
                if (result == null) {
                  setState(() {
                    uploaded = false;
                    uploading = false;
                  });
                } else {
                  file = result.files.first;
                  final filePath = File(file!.path!);
                  var ref =
                      firebaseStorage.ref().child('seller/$email-busBankProof');
                  uploadTask = ref.putFile(filePath);
                  final snapshot = await uploadTask.whenComplete(() {});
                  bankFileURL = await snapshot.ref.getDownloadURL();
                  setState(() {
                    uploaded = true;
                    uploading = false;
                  });
                }
              },
              label: uploaded
                  ? Text(
                      file == null ? "" : file!.name,
                      style: const TextStyle(color: Colors.white),
                    )
                  : const Text(
                      'Upload Bank Proof',
                      style: TextStyle(color: kPrimaryColor),
                    ),
            ),
          ),
          const SizedBox(height: defaultPadding * 1.75),
          uploading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                )
              : SizedBox(
                  width: size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (detailsFormKey.currentState!.validate()) {
                        detailsFormKey.currentState!.save();
                        if (file == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              displaySnackbar(
                                  "Please, Upload Requested Document"));
                        } else {
                          saveBankDetails();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40)),
                    child: Text(
                      "Proceed".toUpperCase(),
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

    String? busEmail = await getBusinessEmail();
    setState(() {
      email = busEmail ?? "";
    });
  }

  saveBankDetails() async {
    final url = Uri.parse('$urlPrefix/seller/register-bank-details');
    var json = {
      "busEmail": await getBusinessEmail(),
      "bankName": bankNameController.text,
      "bankAccNo": bankAccountController.text,
      "bankIfsc": bankIFSCController.text,
      "bankFile": bankFileURL,
    };

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"]) {
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const BusinessProofScreen();
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
