import 'dart:convert';
import 'dart:io';

import 'package:digmart_business/Screens/Products/Sizes/manage_product_size.dart';
import 'package:digmart_business/components/background.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../components/constants.dart';
import '../../../components/snackbar.dart';

class AddProductImages extends StatefulWidget {
  final String slugID;
  const AddProductImages({super.key, required this.slugID});

  @override
  State<AddProductImages> createState() => _AddProductFashionState();
}

class _AddProductFashionState extends State<AddProductImages> {
  bool uploadedFront = false,
      uploadedBack = false,
      uploaded1Side = false,
      uploaded2Side = false,
      uploadedOther = false,
      uploading = false;
  var images = ["", "", "", "", ""];
  final firebaseStorage = FirebaseStorage.instance;
  PlatformFile? frontImg, backImg, side1Img, side2Img, otherImg;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: const [
              Text(
                "Product Images",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: defaultPadding * 1.5),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      height: 60,
                      child: ElevatedButton.icon(
                        icon: uploadedFront
                            ? const Icon(
                                Icons.check_box,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.upload_file,
                                color: kPrimaryColor,
                              ),
                        style: uploadedFront
                            ? ElevatedButton.styleFrom(
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
                              allowedExtensions: ['png', 'jpg', 'jpeg']);
                          if (result == null) {
                            images[0] = "";
                            setState(() {
                              uploadedFront = false;
                              uploading = false;
                            });
                          } else {
                            frontImg = result.files.first;
                            final filePath = File(frontImg!.path!);
                            var ref = firebaseStorage
                                .ref()
                                .child('products/${widget.slugID}/front');
                            uploadTask = ref.putFile(filePath);
                            final snapshot =
                                await uploadTask.whenComplete(() {});
                            images[0] = await snapshot.ref.getDownloadURL();
                            setState(() {
                              uploadedFront = true;
                              uploading = false;
                            });
                          }
                        },
                        label: uploadedFront
                            ? Text(
                                frontImg == null
                                    ? "Edit Image"
                                    : frontImg!.name,
                                style: const TextStyle(color: Colors.white),
                              )
                            : const Text(
                                'Upload Product (Front) *',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    SizedBox(
                      width: size.width * 0.8,
                      height: 60,
                      child: ElevatedButton.icon(
                        icon: uploadedBack
                            ? const Icon(
                                Icons.check_box,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.upload_file,
                                color: kPrimaryColor,
                              ),
                        style: uploadedBack
                            ? ElevatedButton.styleFrom(
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
                              allowedExtensions: ['png', 'jpg', 'jpeg']);
                          if (result == null) {
                            images[1] = "";
                            setState(() {
                              uploadedBack = false;
                              uploading = false;
                            });
                          } else {
                            backImg = result.files.first;
                            final filePath = File(backImg!.path!);
                            var ref = firebaseStorage
                                .ref()
                                .child('products/${widget.slugID}/back');
                            uploadTask = ref.putFile(filePath);
                            final snapshot =
                                await uploadTask.whenComplete(() {});
                            images[1] = await snapshot.ref.getDownloadURL();
                            setState(() {
                              uploadedBack = true;
                              uploading = false;
                            });
                          }
                        },
                        label: uploadedBack
                            ? Text(
                                backImg == null ? "Edit Image" : backImg!.name,
                                style: const TextStyle(color: Colors.white),
                              )
                            : const Text(
                                'Upload Product (Back) *',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    SizedBox(
                      width: size.width * 0.8,
                      height: 60,
                      child: ElevatedButton.icon(
                        icon: uploaded1Side
                            ? const Icon(
                                Icons.check_box,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.upload_file,
                                color: kPrimaryColor,
                              ),
                        style: uploaded1Side
                            ? ElevatedButton.styleFrom(
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
                              allowedExtensions: ['png', 'jpg', 'jpeg']);
                          if (result == null) {
                            images[2] = "";
                            setState(() {
                              uploaded1Side = false;
                              uploading = false;
                            });
                          } else {
                            side1Img = result.files.first;
                            final filePath = File(side1Img!.path!);
                            var ref = firebaseStorage
                                .ref()
                                .child('products/${widget.slugID}/back');
                            uploadTask = ref.putFile(filePath);
                            final snapshot =
                                await uploadTask.whenComplete(() {});
                            images[2] = await snapshot.ref.getDownloadURL();
                            setState(() {
                              uploaded1Side = true;
                              uploading = false;
                            });
                          }
                        },
                        label: uploaded1Side
                            ? Text(
                                side1Img == null
                                    ? "Edit Image"
                                    : side1Img!.name,
                                style: const TextStyle(color: Colors.white),
                              )
                            : const Text(
                                'Upload Product (Side)',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    SizedBox(
                      width: size.width * 0.8,
                      height: 60,
                      child: ElevatedButton.icon(
                        icon: uploaded2Side
                            ? const Icon(
                                Icons.check_box,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.upload_file,
                                color: kPrimaryColor,
                              ),
                        style: uploaded2Side
                            ? ElevatedButton.styleFrom(
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
                              allowedExtensions: ['png', 'jpg', 'jpeg']);
                          if (result == null) {
                            images[3] = "";
                            setState(() {
                              uploaded2Side = false;
                              uploading = false;
                            });
                          } else {
                            side2Img = result.files.first;
                            final filePath = File(side2Img!.path!);
                            var ref = firebaseStorage
                                .ref()
                                .child('products/${widget.slugID}/back');
                            uploadTask = ref.putFile(filePath);
                            final snapshot =
                                await uploadTask.whenComplete(() {});
                            images[3] = await snapshot.ref.getDownloadURL();
                            setState(() {
                              uploaded2Side = true;
                              uploading = false;
                            });
                          }
                        },
                        label: uploaded2Side
                            ? Text(
                                side2Img == null
                                    ? "Edit Image"
                                    : side2Img!.name,
                                style: const TextStyle(color: Colors.white),
                              )
                            : const Text(
                                'Upload Product (Side)',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    SizedBox(
                      width: size.width * 0.8,
                      height: 60,
                      child: ElevatedButton.icon(
                        icon: uploadedOther
                            ? const Icon(
                                Icons.check_box,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.upload_file,
                                color: kPrimaryColor,
                              ),
                        style: uploadedOther
                            ? ElevatedButton.styleFrom(
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
                              allowedExtensions: ['png', 'jpg', 'jpeg']);
                          if (result == null) {
                            images[4] = "";
                            setState(() {
                              uploadedOther = false;
                              uploading = false;
                            });
                          } else {
                            otherImg = result.files.first;
                            final filePath = File(side2Img!.path!);
                            var ref = firebaseStorage
                                .ref()
                                .child('products/${widget.slugID}/back');
                            uploadTask = ref.putFile(filePath);
                            final snapshot =
                                await uploadTask.whenComplete(() {});
                            images[4] = await snapshot.ref.getDownloadURL();
                            setState(() {
                              uploadedOther = true;
                              uploading = false;
                            });
                          }
                        },
                        label: uploadedOther
                            ? Text(
                                otherImg == null
                                    ? "Edit Image"
                                    : otherImg!.name,
                                style: const TextStyle(color: Colors.white),
                              )
                            : const Text(
                                'Upload Product (Additional)',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    uploading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          )
                        : SizedBox(
                            width: size.width * 0.8,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (images[0] != "") {
                                  if (images[1] != "") {
                                    saveProductImages();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        displaySnackbar(
                                            "Upload Product Back Image!"));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      displaySnackbar(
                                          "Upload Product Front Image!"));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 40)),
                              child: Text(
                                "Save Images".toUpperCase(),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      )),
    );
  }

  saveProductImages() async {
    final url = Uri.parse('$urlPrefix/seller/product/add-product-images');
    var prodImages = jsonEncode(images);
    var json = {"slugID": widget.slugID, "images": prodImages};

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"]) {
      if (context.mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ManageProductSize(
            slugID: widget.slugID,
          );
        }));
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            displayErrorSnackbar("Something Went Wrong, Contact Support!"));
      }
    }
  }
}
