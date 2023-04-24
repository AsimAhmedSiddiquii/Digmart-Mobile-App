import 'dart:convert';

import 'package:digmart_business/Screens/Layouts/Background.dart';
import 'package:digmart_business/Screens/Products/add_product_images.dart';
import 'package:digmart_business/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../components/sessionData.dart';

class ShowProductsScreen extends StatelessWidget {
  const ShowProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      title: "Manage Products",
      child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            FutureBuilder(
                future: getSellerProducts("Pending Images"),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ));
                  } else {
                    var products = snapshot.data;
                    return ExpansionTile(
                        title: Text(
                          "Pending Images (${products.length})",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        children: <Widget>[
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 8, 16, 0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 120,
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 8, 8, 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Hero(
                                            tag: 'ControllerImage',
                                            transitionOnUserGestures: true,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.asset(
                                                  'assets/images/main-logo.png'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 8),
                                                  child: Text(
                                                    products[index]
                                                        ["productName"],
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Text(
                                                    '₹${products[index]["finalPrice"]}'),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 8, 0, 0),
                                                  child: Text(
                                                    '${products[index]["section"]} | ${products[index]["category"]["catName"]} | ${products[index]["subcategory"]}',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.add_a_photo,
                                                  color: Colors.blue,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return AddProductImages(
                                                        slugID: products[index]
                                                            ["slugID"]);
                                                  }));
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Color(0xFFE86969),
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  // Remove item
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ]);
                  }
                }),
            const SizedBox(height: 8),
            FutureBuilder(
                future: getSellerProducts("Pending Sizes"),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ));
                  } else {
                    var products = snapshot.data;
                    return ExpansionTile(
                        childrenPadding: const EdgeInsets.only(bottom: 12),
                        title: Text(
                          "Pending Sizes (${products.length})",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        children: <Widget>[
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 8, 16, 0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 120,
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
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 8, 8, 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Hero(
                                            tag: 'ControllerImage',
                                            transitionOnUserGestures: true,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  products[index]["images"][0],
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.fitWidth,
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(12, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 8),
                                                  child: Text(
                                                    products[index]
                                                        ["productName"],
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Text(
                                                    '₹${products[index]["finalPrice"]}'),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 8, 0, 0),
                                                  child: Text(
                                                    '${products[index]["section"]} | ${products[index]["category"]["catName"]} | ${products[index]["subcategory"]}',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              products[index]["images"]
                                                          .length ==
                                                      0
                                                  ? IconButton(
                                                      icon: const Icon(
                                                        Icons.scale,
                                                        color: Colors.blue,
                                                        size: 20,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return AddProductImages(
                                                              slugID: products[
                                                                      index]
                                                                  ["slugID"]);
                                                        }));
                                                      },
                                                    )
                                                  : const SizedBox(),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Color(0xFFE86969),
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  // Remove item
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ]);
                  }
                }),
          ]),
    );
  }
}

Future<List> getSellerProducts(status) async {
  String? sellerID = await getSellerID();
  final url = Uri.parse('$urlPrefix/seller/product/get-seller-products');
  var json = {"sellerID": sellerID, "status": status};

  final response = await post(url, body: json);
  var result = jsonDecode(response.body);
  return result["products"];
}
