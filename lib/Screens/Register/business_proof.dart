import 'dart:convert';
import 'dart:io';

import 'package:digmart_business/Screens/Login/login_screen.dart';
import 'package:digmart_business/components/dialog.dart';
import 'package:digmart_business/components/sessionData.dart';
import 'package:digmart_business/components/snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import '../../components/textFieldContainer.dart';
import '../../components/background.dart';
import '../../components/validation.dart';
import '../../components/constants.dart';

class BusinessProofScreen extends StatelessWidget {
  const BusinessProofScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
        child: SingleChildScrollView(
      child: BusProofScreen(),
    ));
  }
}

class BusProofScreen extends StatelessWidget {
  const BusProofScreen({
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
              "Business Proof",
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: defaultPadding * 1.25),
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
  String gstNo = "";
  String fssaiNo = "";
  String email = "";
  String gstURL = "", fssaiURL = "", logoURL = "";
  bool isFood = false, uploading = false;
  bool uploadedLogo = false, uploadedGST = false, uploadedFSSAI = false;
  PlatformFile? gstFile, busLogoFile, fssaiFile;
  final formGlobalKey = GlobalKey<FormState>();
  final firebaseStorage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    getBusCat();
  }

  getBusCat() async {
    String? busCat = await getBusinessCategory();
    String? busEmail = await getBusinessEmail();
    if (busCat == "Food") {
      setState(() {
        email = busEmail ?? "";
        isFood = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: formGlobalKey,
      child: Column(
        children: [
          SizedBox(
            width: size.width * 0.8,
            height: 60,
            child: ElevatedButton.icon(
              icon: uploadedLogo
                  ? const Icon(
                      Icons.check_box,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.upload_file,
                      color: kPrimaryColor,
                    ),
              style: uploadedLogo
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
                final UploadTask? uploadTask;
                final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg', 'jpeg']);
                if (result == null) {
                  setState(() {
                    uploadedLogo = false;
                    uploading = false;
                  });
                } else {
                  busLogoFile = result.files.first;
                  final filePath = File(busLogoFile!.path!);
                  var ref =
                      firebaseStorage.ref().child('seller/$email-busTypeProof');
                  uploadTask = ref.putFile(filePath);
                  final snapshot = await uploadTask.whenComplete(() {});
                  logoURL = await snapshot.ref.getDownloadURL();
                  setState(() {
                    uploadedLogo = true;
                    uploading = false;
                  });
                }
              },
              label: uploadedLogo
                  ? Text(
                      busLogoFile == null ? "" : busLogoFile!.name,
                      style: const TextStyle(color: Colors.white),
                    )
                  : const Text(
                      'Upload Business Logo',
                      style: TextStyle(color: kPrimaryColor),
                    ),
            ),
          ),
          const SizedBox(height: defaultPadding * 1.25),
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding * 1.25),
            child: TextFieldContainer(
              child: TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                cursorColor: kPrimaryColor,
                maxLength: 15,
                inputFormatters: [UpperCaseTextFormatter()],
                onSaved: (value) {
                  gstNo = value!;
                },
                validator: (gst) {
                  if (isValidGST(gst!)) {
                    return null;
                  } else {
                    return 'Enter a valid GST Number';
                  }
                },
                decoration: const InputDecoration(
                    hintText: "GST Number",
                    counterText: "",
                    icon: Icon(
                      Icons.numbers,
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
              icon: uploadedGST
                  ? const Icon(
                      Icons.check_box,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.upload_file,
                      color: kPrimaryColor,
                    ),
              style: uploadedGST
                  ? ElevatedButton.styleFrom(
                      elevation: 0,
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
                final UploadTask? uploadTask;
                final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['pdf', 'png']);
                if (result == null) {
                  setState(() {
                    uploadedGST = false;
                    uploading = false;
                  });
                } else {
                  gstFile = result.files.first;
                  final filePath = File(gstFile!.path!);
                  var ref =
                      firebaseStorage.ref().child('seller/$email-busGSTProof');
                  uploadTask = ref.putFile(filePath);
                  final snapshot = await uploadTask.whenComplete(() {});
                  gstURL = await snapshot.ref.getDownloadURL();
                  setState(() {
                    uploadedGST = true;
                    uploading = false;
                  });
                }
              },
              label: uploadedGST
                  ? Text(
                      gstFile!.name,
                      style: const TextStyle(color: Colors.white),
                    )
                  : const Text(
                      'Upload GST Certificate',
                      style: TextStyle(color: kPrimaryColor),
                    ),
            ),
          ),
          isFood
              ? const SizedBox(height: defaultPadding * 1.25)
              : const SizedBox(height: 0),
          isFood
              ? Padding(
                  padding: const EdgeInsets.only(bottom: defaultPadding * 1.25),
                  child: TextFieldContainer(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      cursorColor: kPrimaryColor,
                      maxLength: 14,
                      onSaved: (value) {
                        fssaiNo = value!;
                      },
                      validator: (fssai) {
                        if (isValidFSSAI(fssai!)) {
                          return null;
                        } else {
                          return 'Enter a valid FSSAI Registration';
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: "FSSAI Number",
                          counterText: "",
                          icon: Icon(
                            Icons.numbers,
                            color: kPrimaryColor,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                )
              : Container(),
          isFood
              ? SizedBox(
                  width: size.width * 0.8,
                  height: 60,
                  child: ElevatedButton.icon(
                    icon: uploadedFSSAI
                        ? const Icon(
                            Icons.check_box,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.upload_file,
                            color: kPrimaryColor,
                          ),
                    style: uploadedFSSAI
                        ? ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40))
                        : ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                side: BorderSide(color: kPrimaryColor)),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40)),
                    onPressed: () async {
                      setState(() {
                        uploading = true;
                      });
                      final UploadTask? uploadTask;
                      final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'png']);
                      if (result == null) {
                        setState(() {
                          uploadedFSSAI = false;
                          uploading = false;
                        });
                      } else {
                        fssaiFile = result.files.first;
                        final filePath = File(fssaiFile!.path!);
                        var ref = firebaseStorage
                            .ref()
                            .child('seller/$email-busFssaiProof');
                        uploadTask = ref.putFile(filePath);
                        final snapshot = await uploadTask.whenComplete(() {});
                        fssaiURL = await snapshot.ref.getDownloadURL();
                        setState(() {
                          uploadedFSSAI = true;
                          uploading = false;
                        });
                      }
                    },
                    label: uploadedFSSAI
                        ? Text(
                            fssaiFile!.name,
                            style: const TextStyle(color: Colors.white),
                          )
                        : const Text(
                            'Upload FSSAI Certificate',
                            style: TextStyle(color: kPrimaryColor),
                          ),
                  ),
                )
              : const SizedBox(height: 0),
          const SizedBox(height: defaultPadding * 2),
          uploading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                )
              : SizedBox(
                  width: size.width * 0.8,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    onPressed: () {
                      if (formGlobalKey.currentState!.validate()) {
                        formGlobalKey.currentState!.save();
                        if (busLogoFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              displaySnackbar("Upload Business Logo"));
                        } else if (gstFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              displaySnackbar("Upload GST Certificate !"));
                        } else if (isFood && fssaiFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              displaySnackbar("Upload FSSAI Certificate"));
                        } else {
                          registerBusiness();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 40)),
                    label: const Text(
                      "Submit Application",
                    ),
                  ),
                ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }

  registerBusiness() async {
    final url = Uri.parse('$urlPrefix/seller/register/seller');
    var json = {
      "busEmail": await getBusinessEmail(),
      "busGstNo": gstNo,
      "busGstFile": gstURL,
      "busFssaiNo": fssaiNo,
      "busFssaiFile": fssaiURL,
      "busLogo": logoURL,
    };

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"]) {
      if (context.mounted) {
        clearSessionData();
        showDialog(
            context: context,
            builder: (BuildContext context) => const CustomDialog(
                  title: "Registration Successful",
                  description:
                      "Your Business Details have been recorded and sent for verification. Please, check your mail for further communications!",
                  buttonText: "Done",
                  icon: Icons.check,
                  bgColor: kPrimaryColor,
                  navigateTo: LoginScreen(),
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
