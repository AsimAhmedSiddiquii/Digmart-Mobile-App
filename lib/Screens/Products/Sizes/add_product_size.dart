import 'dart:convert';

import 'package:digmart_business/Screens/Products/Sizes/manage_product_size.dart';
import 'package:digmart_business/components/background.dart';
import 'package:digmart_business/components/constants.dart';
import 'package:digmart_business/components/snackbar.dart';
import 'package:digmart_business/components/textFieldContainer.dart';
import 'package:digmart_business/components/validation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProductSize extends StatefulWidget {
  final String slugID;

  const AddProductSize({super.key, required this.slugID});

  @override
  State<AddProductSize> createState() => _AddProductFashionState();
}

class _AddProductFashionState extends State<AddProductSize> {
  String title = "";
  final productSizeKey = GlobalKey<FormState>();

  final sizeQtyController = TextEditingController();

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
              SizedBox(height: defaultPadding * 1.5),
              Text(
                "Add Product Size",
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
                child: Form(
                    key: productSizeKey,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: defaultPadding),
                          child: TextFieldContainer(
                              child: DropdownButtonFormField(
                            value: title == "" ? null : title,
                            validator: (value) {
                              if (value == null) {
                                return "Select Size Title";
                              } else {
                                return null;
                              }
                            },
                            items: [
                              "XS",
                              "S",
                              "M",
                              "L",
                              "XL",
                              "2XL",
                              "3XL",
                              "4XL",
                              "28",
                              "30",
                              "32",
                              "34",
                              "36",
                              "38",
                              "40",
                              "42",
                              "44",
                              "46"
                            ].map((String title) {
                              return DropdownMenuItem(
                                  value: title,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        title,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() => title = newValue!);
                            },
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 20, 10, 20),
                                filled: true,
                                fillColor: kPrimaryLightColor,
                                hintText: "Size Title",
                                border: InputBorder.none),
                          )),
                        ),
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
                          child: ElevatedButton(
                            onPressed: () async {
                              if (productSizeKey.currentState!.validate()) {
                                productSizeKey.currentState!.save();
                                addProductSize();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 40)),
                            child: Text(
                              "Add Size".toUpperCase(),
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

  addProductSize() async {
    final url = Uri.parse('$urlPrefix/seller/product/add-product-size');
    var json = {
      "slugID": widget.slugID,
      "sizeTitle": title,
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
            .showSnackBar(displaySnackbar("Size Already Exists!"));
      }
    }
  }
}
