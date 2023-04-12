import 'package:digmart_business/components/register.dart';
import 'package:digmart_business/components/snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../components/textFieldContainer.dart';
import '../../components/background.dart';
import '../../components/validation.dart';
import '../../constants.dart';

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
              style: TextStyle(fontFamily: 'Roboto', fontSize: 22),
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
  bool isFood = false;
  bool uploadedLogo = false,
      uploadedGST = false,
      uploadedFSSAI = false,
      uploadedBank = false;
  PlatformFile? gstFile, busLogoFile, fssaiFile, bankFile;
  final formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getBusCat();
  }

  getBusCat() async {
    String? busCat = await getBusinessCategory();
    if (busCat == "Food") {
      setState(() {
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
                final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg', 'jpeg']);
                if (result == null) {
                  setState(() {
                    uploadedLogo = false;
                  });
                } else {
                  busLogoFile = result.files.first;
                  setState(() {
                    uploadedLogo = true;
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
          SizedBox(
            width: size.width * 0.8,
            height: 60,
            child: ElevatedButton.icon(
              icon: uploadedBank
                  ? const Icon(
                      Icons.check_box,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.upload_file,
                      color: kPrimaryColor,
                    ),
              style: uploadedBank
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
                final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg', 'jpeg']);
                if (result == null) {
                  setState(() {
                    uploadedBank = false;
                  });
                } else {
                  bankFile = result.files.first;
                  setState(() {
                    uploadedBank = true;
                  });
                }
              },
              label: uploadedBank
                  ? Text(
                      bankFile == null ? "" : bankFile!.name,
                      style: const TextStyle(color: Colors.white),
                    )
                  : const Text(
                      'Upload Bank Proof',
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
                final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['pdf', 'png']);
                if (result == null) {
                  setState(() {
                    uploadedGST = false;
                  });
                } else {
                  setState(() {
                    uploadedGST = true;
                  });
                  gstFile = result.files.first;
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
                      final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'png']);
                      if (result == null) {
                        setState(() {
                          uploadedFSSAI = false;
                        });
                      } else {
                        setState(() {
                          uploadedFSSAI = true;
                        });
                        fssaiFile = result.files.first;
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
          SizedBox(
            width: size.width * 0.8,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              onPressed: () {
                if (formGlobalKey.currentState!.validate()) {
                  formGlobalKey.currentState!.save();
                  if (busLogoFile == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(displaySnackbar("Upload Business Logo"));
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
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

  Future<bool> registerBusiness() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$urlPrefix/seller/register-seller'));
    request.files.add(await http.MultipartFile.fromPath(
        'busGstFile', gstFile?.path as String));

    request.fields["busName"] = (await getBusinessName())!;
    request.fields["busEmail"] = (await getBusinessEmail())!;
    request.fields["busPhone"] = (await getBusinessPhone())!;
    request.fields["busPass"] = (await getBusinessPass())!;
    request.fields["busAddress"] = (await getBusinessAddress())!;
    request.fields["busCity"] = (await getBusinessCity())!;
    request.fields["busState"] = (await getBusinessState())!;
    request.fields["busPin"] = (await getBusinessPin())!;
    request.fields["busType"] = (await getBusinessType())!;
    request.fields["busCat"] = (await getBusinessCategory())!;
    request.fields["bankName"] = (await getBankName())!;
    request.fields["bankAccNo"] = (await getAccountNo())!;
    request.fields["bankIfsc"] = (await getBankIFSC())!;
    request.fields["busGstNo"] = gstNo;
    request.fields["busFssaiNo"] = fssaiNo;

    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
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
