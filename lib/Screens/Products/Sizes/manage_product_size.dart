import 'dart:convert';

import 'package:digmart_business/Screens/Products/Sizes/add_product_size.dart';
import 'package:digmart_business/Screens/Products/Sizes/edit_product_size.dart';
import 'package:digmart_business/Screens/Products/products.dart';
import 'package:digmart_business/components/background.dart';
import 'package:digmart_business/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ManageProductSize extends StatefulWidget {
  final String slugID;
  const ManageProductSize({super.key, required this.slugID});

  @override
  State<ManageProductSize> createState() => _AddProductFashionState();
}

class _AddProductFashionState extends State<ManageProductSize> {
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
                "Manage Product Sizes",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: defaultPadding),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    FutureBuilder(
                        future: getProductSizes(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ));
                          } else {
                            var product = snapshot.data;
                            var sizes = product["sizes"];
                            return ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: sizes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 12, 8, 12),
                                    child: Container(
                                      width: double.infinity,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 4,
                                            color: Color(0x320E151B),
                                            offset: Offset(0, 1),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 8, 0, 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: CircleAvatar(
                                                  radius: 34,
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  child: Center(
                                                    child: Text(
                                                      sizes[index]["sizeTitle"],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: CircleAvatar(
                                                  radius: 34,
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  child: Center(
                                                    child: Text(
                                                      sizes[index]["quantity"],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    ),
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12),
                                                    constraints:
                                                        const BoxConstraints(),
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.blue,
                                                      size: 22,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return EditProductSize(
                                                          slugID:
                                                              product["slugID"],
                                                          title: sizes[index]
                                                              ["sizeTitle"],
                                                          qty: sizes[index]
                                                              ["quantity"],
                                                        );
                                                      }));
                                                    },
                                                  ),
                                                  IconButton(
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        const BoxConstraints(),
                                                    icon: const Icon(
                                                      Icons
                                                          .delete_outline_rounded,
                                                      color: Colors.red,
                                                      size: 22,
                                                    ),
                                                    onPressed: () {
                                                      removeSize(index);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                        }),
                    const SizedBox(height: defaultPadding),
                    SizedBox(
                      width: size.width * 0.75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return AddProductSize(
                                    slugID: widget.slugID,
                                  );
                                },
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade100,
                                side: const BorderSide(
                                    color: kPrimaryColor, width: 2),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20)),
                            label: Text(
                              "Add Size".toUpperCase(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const ShowProductsScreen();
                                },
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20)),
                            label: Text(
                              "Complete".toUpperCase(),
                            ),
                          ),
                        ],
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

  getProductSizes() async {
    final url = Uri.parse('$urlPrefix/seller/product/get-product');
    var json = {"slugID": widget.slugID};

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    return result["product"];
  }

  removeSize(index) async {
    final url = Uri.parse('$urlPrefix/seller/product/remove-product-size');
    var json = {"slugID": widget.slugID, "index": index.toString()};

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
    }
  }
}
