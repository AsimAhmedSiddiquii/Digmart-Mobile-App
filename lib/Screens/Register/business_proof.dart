import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
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
  String gstNo = "";
  bool uploadedLogo = false, uploadedGST = false;
  PlatformFile? gstFile, busLogoFile;
  final formGlobalKey = GlobalKey<FormState>();

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
          const SizedBox(height: defaultPadding * 2),
          SizedBox(
            width: size.width * 0.8,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              onPressed: () {
                if (formGlobalKey.currentState!.validate()) {
                  formGlobalKey.currentState!.save();
                  print("Done");
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
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
