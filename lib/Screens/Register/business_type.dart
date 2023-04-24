import 'dart:convert';
import 'dart:io';

import 'package:digmart_business/Screens/Register/business_bank_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../components/sessionData.dart';
import '../../components/snackbar.dart';
import '../../components/textFieldContainer.dart';
import '../../components/background.dart';
import '../../components/constants.dart';

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
  String type = "", busTypeStr = "";
  String category = "", email = "", busTypeFileURL = "";
  bool selected = false, uploaded = false, uploading = false;
  PlatformFile? file;
  final typeFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: typeFormKey,
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
                "Limited Liability Partnership (LLP)",
                "Private Limited Company"
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
                setState(() {
                  type = newValue!;
                  selected = true;
                  busTypeStr = getUploadButtonString(type);
                });
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
                    allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf']);
                if (result == null) {
                  setState(() {
                    uploaded = false;
                    uploading = false;
                  });
                } else {
                  file = result.files.first;
                  final filePath = File(file!.path!);
                  var ref =
                      firebaseStorage.ref().child('seller/$email-busTypeProof');
                  uploadTask = ref.putFile(filePath);
                  final snapshot = await uploadTask.whenComplete(() {});
                  busTypeFileURL = await snapshot.ref.getDownloadURL();
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
                  : Text(
                      'Upload $busTypeStr',
                      style: const TextStyle(color: kPrimaryColor),
                    ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          uploading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                )
              : SizedBox(
                  width: size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      if (typeFormKey.currentState!.validate()) {
                        typeFormKey.currentState!.save();
                        if (file == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              displaySnackbar(
                                  "Please, Upload Requested Document"));
                        } else {
                          saveTypeDetails();
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
    String? busType = await getBusinessType();
    String? busCat = await getBusinessCategory();
    String? busEmail = await getBusinessEmail();
    setState(() {
      type = busType ?? "";
      category = busCat ?? "";
      email = busEmail ?? "";
      busTypeStr = getUploadButtonString(busType ?? "");
    });
  }

  saveTypeDetails() async {
    final url = Uri.parse('$urlPrefix/seller/register/type-details');
    var json = {
      "busEmail": await getBusinessEmail(),
      "busType": type,
      "busCat": category,
      "busTypeProof": busTypeFileURL,
    };

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"]) {
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const BusinessBankDetails();
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

  getUploadButtonString(type) {
    if (type == "Sole Proprietorship") {
      return "Proprietor's PAN Card";
    }
    if (type == "Partnership") {
      return "Partnership Deed";
    }
    if (type == "Limited Liability Partnership (LLP)") {
      return "LLP Formation Document";
    }
    if (type == "Private Limited Company") {
      return "Company's PAN Card";
    }
  }
}
