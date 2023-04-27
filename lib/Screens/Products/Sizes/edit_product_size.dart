import 'dart:convert';

import 'package:digmart_business/Screens/Products/Sizes/manage_product_size.dart';
import 'package:digmart_business/components/background.dart';
import 'package:digmart_business/components/constants.dart';
import 'package:digmart_business/components/snackbar.dart';
import 'package:digmart_business/components/textFieldContainer.dart';
import 'package:digmart_business/components/validation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EditProductSize extends StatefulWidget {
  final String slugID;
  String title, qty;

  EditProductSize(
      {super.key,
      required this.slugID,
      required this.title,
      required this.qty});

  @override
  State<EditProductSize> createState() => _AddProductFashionState();
}

class _AddProductFashionState extends State<EditProductSize> {
  final productSizeKey = GlobalKey<FormState>();

  final sizeQtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    sizeQtyController.text = widget.qty;
    return Background(
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: [
              const SizedBox(height: defaultPadding * 1.5),
              Text(
                "Edit Quantity for ${widget.title} Size",
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: defaultPadding * 1.5),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 8,
                child: Form(
                    key: productSizeKey,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: defaultPadding),
                          child: TextFieldContainer(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              cursorColor: kPrimaryColor,
                              controller: sizeQtyController,
                              maxLength: 3,
                              validator: (price) {
                                if (isValidNumber(price!)) {
                                  return null;
                                } else {
                                  return 'Enter valid Quantity';
                                }
                              },
                              decoration: const InputDecoration(
                                  hintText: "Enter Size Quantity",
                                  counterText: '',
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
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              if (productSizeKey.currentState!.validate()) {
                                productSizeKey.currentState!.save();
                                editProductSize();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 40)),
                            label: Text(
                              "Edit Quantity".toUpperCase(),
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                      ],
                    )),
              ),
              const Spacer(),
            ],
          ),
        ],
      )),
    );
  }

  editProductSize() async {
    final url = Uri.parse('$urlPrefix/seller/product/edit-product-size');
    var json = {
      "slugID": widget.slugID,
      "sizeTitle": widget.title,
      "quantity": sizeQtyController.text
    };

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"]) {
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return ManageProductSize(
              slugID: widget.slugID,
            );
          },
        ));
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(displaySnackbar("Something Went Wrong!"));
      }
    }
  }
}
