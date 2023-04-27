import 'dart:convert';

import 'package:digmart_business/Screens/Products/Images/add_product_images.dart';
import 'package:digmart_business/Screens/Products/products.dart';
import 'package:digmart_business/components/background.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../components/constants.dart';
import '../../../components/sessionData.dart';
import '../../../components/snackbar.dart';
import '../../../components/textFieldContainer.dart';
import '../../../components/validation.dart';

class EditProductFashion extends StatefulWidget {
  final String slugID;
  const EditProductFashion({super.key, required this.slugID});

  @override
  State<EditProductFashion> createState() => _AddProductFashionState();
}

class _AddProductFashionState extends State<EditProductFashion> {
  String sellerID = "", category = "", section = "", subcategory = "";
  final productDetailsKey = GlobalKey<FormState>();
  bool selectedSection = false;

  final proNameController = TextEditingController();
  final proDescController = TextEditingController();
  final proActualController = TextEditingController();
  final proDiscountController = TextEditingController();
  final proFinalController = TextEditingController();

  Map<String, List<String>> options = {
    "Men": [
      "T-Shirt",
      "Casual Shirt",
      "Formal Shirt",
      "Kurta",
      "Blazers",
      "Ethnic Wear",
      "Trousers",
      "Jeans",
      "Cargos",
      "Pyjama",
      "Innerwear"
    ],
    "Women": [
      "Tops",
      "T-Shirt",
      "Dresses",
      "Kurta",
      "Gowns",
      "Sarees",
      "Jeans"
    ],
    "Boys": ["T-Shirt", "Shirts", "Jeans", "Pants"],
    "Girls": ["Tops", "Dresses", "Jeans"]
  };

  @override
  void initState() {
    super.initState();
    getValues();
  }

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
                "Edit Product",
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
                    key: productDetailsKey,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: defaultPadding),
                          child: TextFieldContainer(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              cursorColor: kPrimaryColor,
                              controller: proNameController,
                              validator: (name) {
                                if (isValidName(name!)) {
                                  return null;
                                } else {
                                  return 'Enter valid Product Name';
                                }
                              },
                              decoration: const InputDecoration(
                                  hintText: "Enter Product Name",
                                  icon: Icon(
                                    Icons.text_format,
                                    color: kPrimaryColor,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: defaultPadding),
                          child: TextFieldContainer(
                              child: DropdownButtonFormField(
                            value: section == "" ? null : section,
                            validator: (value) {
                              if (value == null) {
                                return "Select Product Section";
                              } else {
                                return null;
                              }
                            },
                            items: ["Men", "Women", "Boys", "Girls"]
                                .map((String section) {
                              return DropdownMenuItem(
                                  value: section,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        section,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                section = newValue!;
                                selectedSection = true;
                              });
                            },
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 20, 10, 20),
                                filled: true,
                                fillColor: kPrimaryLightColor,
                                hintText: "Product Section",
                                border: InputBorder.none),
                          )),
                        ),
                        selectedSection
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    bottom: defaultPadding),
                                child: TextFieldContainer(
                                    child: DropdownButtonFormField(
                                  value: subcategory == "" ? null : subcategory,
                                  validator: (value) {
                                    if (value == null) {
                                      return "Select Product Sub-Category";
                                    } else {
                                      return null;
                                    }
                                  },
                                  items: (options[section] ?? [])
                                      .map((String subcategory) {
                                    return DropdownMenuItem(
                                        value: subcategory,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              subcategory,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ));
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() => subcategory = newValue!);
                                  },
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 20, 10, 20),
                                      filled: true,
                                      fillColor: kPrimaryLightColor,
                                      hintText: "Product Sub-Category",
                                      border: InputBorder.none),
                                )),
                              )
                            : const SizedBox(),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: defaultPadding),
                          child: TextFieldContainer(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              cursorColor: kPrimaryColor,
                              controller: proDescController,
                              minLines: 3,
                              maxLines: 5,
                              maxLength: 150,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter Product Description";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  hintText: "Enter Product Description",
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6),
                                decoration: BoxDecoration(
                                    color: kPrimaryLightColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  cursorColor: kPrimaryColor,
                                  controller: proActualController,
                                  maxLength: 6,
                                  validator: (price) {
                                    if (isValidNumber(price!)) {
                                      return null;
                                    } else {
                                      return 'Actual Price';
                                    }
                                  },
                                  onChanged: (value) {
                                    if (proDiscountController.text.isNotEmpty &&
                                        proActualController.text.isNotEmpty) {
                                      var originalPrice = int.parse(value);
                                      if (value.isNotEmpty) {
                                        var discount = double.parse(
                                                proDiscountController.text) /
                                            100;
                                        var newPrice = originalPrice -
                                            (originalPrice * discount);
                                        proFinalController.text =
                                            newPrice.round().toString();
                                      } else {
                                        proFinalController.text =
                                            proActualController.text;
                                      }
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "MRP Price",
                                      counterText: '',
                                      icon: Icon(
                                        Icons.money,
                                        color: kPrimaryColor,
                                      ),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6),
                                decoration: BoxDecoration(
                                    color: kPrimaryLightColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  cursorColor: kPrimaryColor,
                                  controller: proDiscountController,
                                  maxLength: 2,
                                  validator: (price) {
                                    if (isValidNumber(price!)) {
                                      return null;
                                    } else {
                                      return 'Enter valid Discount';
                                    }
                                  },
                                  onChanged: (value) {
                                    if (proActualController.text.isNotEmpty) {
                                      var originalPrice =
                                          int.parse(proActualController.text);
                                      if (value.isNotEmpty) {
                                        var discount =
                                            double.parse(value) / 100;
                                        var newPrice = originalPrice -
                                            (originalPrice * discount);
                                        proFinalController.text =
                                            newPrice.round().toString();
                                      } else {
                                        proFinalController.text =
                                            proActualController.text;
                                      }
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      hintText: "Discount %",
                                      icon: Icon(
                                        Icons.discount,
                                        color: kPrimaryColor,
                                      ),
                                      counterText: "",
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: defaultPadding),
                          child: TextFieldContainer(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              readOnly: true,
                              cursorColor: kPrimaryColor,
                              controller: proFinalController,
                              decoration: const InputDecoration(
                                  hintText: "Final Price",
                                  icon: Icon(
                                    Icons.currency_rupee,
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
                              if (productDetailsKey.currentState!.validate()) {
                                productDetailsKey.currentState!.save();
                                editProductDetails();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 40)),
                            child: Text(
                              "Edit Product".toUpperCase(),
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

  getValues() async {
    String? id = await getSellerID();
    String? busCat = await getBusinessCategory();
    setState(() {
      category = busCat ?? "";
      sellerID = id ?? "";
    });

    final url = Uri.parse('$urlPrefix/seller/product/get-product');
    var json = {
      "slugID": widget.slugID,
    };

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    var product = result["product"];
    if (product.length != 0) {
      setState(() {
        category = product["category"];
        section = product["section"];
        subcategory = product["subcategory"];
        proNameController.text = product["productName"];
        proDescController.text = product["description"];
        proActualController.text = product["actualPrice"];
        proDiscountController.text = product["discount"];
        proFinalController.text = product["finalPrice"];
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            displayErrorSnackbar("Something Went Wrong, Contact Support!"));
      }
    }
  }

  editProductDetails() async {
    final url = Uri.parse('$urlPrefix/seller/product/edit-product');
    var json = {
      "slugID": widget.slugID,
      "category": category,
      "section": section,
      "subcategory": subcategory,
      "productName": proNameController.text,
      "description": proDescController.text,
      "actualPrice": proActualController.text,
      "discount": proDiscountController.text,
      "finalPrice": proFinalController.text,
    };

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"]) {
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return const ShowProductsScreen();
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
