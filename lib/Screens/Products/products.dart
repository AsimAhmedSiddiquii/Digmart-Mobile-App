import 'dart:convert';

import 'package:digmart_business/Screens/Layouts/Background.dart';
import 'package:digmart_business/Screens/Products/Images/edit_product_images.dart';
import 'package:digmart_business/Screens/Products/Sizes/edit_product_size.dart';
import 'package:digmart_business/Screens/Products/Sizes/manage_product_size.dart';
import 'package:digmart_business/Screens/Products/Images/add_product_images.dart';
import 'package:digmart_business/Screens/Products/Details/edit_product_fashion.dart';
import 'package:digmart_business/components/constants.dart';
import 'package:digmart_business/components/dialog.dart';
import 'package:digmart_business/components/snackbar.dart';
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
                    return const SizedBox();
                  } else {
                    var products = snapshot.data;
                    return products.length != 0
                        ? ExpansionTile(
                            initiallyExpanded: true,
                            childrenPadding: const EdgeInsets.only(bottom: 12),
                            title: Text(
                              "Pending Images (${products.length})",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            children: <Widget>[
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: products.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 8, 16, 0),
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 8, 12, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Hero(
                                                  tag: 'PendingImage$index',
                                                  transitionOnUserGestures:
                                                      true,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.asset(
                                                        'assets/images/main-logo.png'),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            12, 0, 2, 0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  0, 0, 0, 8),
                                                          child: Text(
                                                            products[index]
                                                                ["productName"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(
                                                            '₹${products[index]["finalPrice"]}'),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  0, 8, 0, 0),
                                                          child: Text(
                                                            '${products[index]["section"]} | ${products[index]["category"]["catName"]} | ${products[index]["subcategory"]}',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.add_a_photo,
                                                        color: Colors.blue,
                                                        size: 24,
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
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        color:
                                                            Color(0xFFE86969),
                                                        size: 24,
                                                      ),
                                                      onPressed: () {
                                                        removeProduct(
                                                            context,
                                                            products[index]
                                                                ["slugID"]);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                              ])
                        : const SizedBox();
                  }
                }),
            FutureBuilder(
                future: getSellerProducts("Pending Sizes"),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    var products = snapshot.data;
                    return products.length != 0
                        ? ExpansionTile(
                            initiallyExpanded: true,
                            childrenPadding: const EdgeInsets.only(bottom: 12),
                            title: Text(
                              "Pending Sizes (${products.length})",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            children: <Widget>[
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: products.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 8, 16, 0),
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 8, 12, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Hero(
                                                  tag: 'SizesImage$index',
                                                  transitionOnUserGestures:
                                                      true,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        products[index]
                                                            ["images"][0],
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.fitWidth,
                                                      )),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            12, 0, 2, 0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  0, 0, 0, 8),
                                                          child: Text(
                                                            products[index]
                                                                ["productName"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(
                                                            '₹${products[index]["finalPrice"]}'),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  0, 8, 0, 0),
                                                          child: Text(
                                                            '${products[index]["section"]} | ${products[index]["category"]["catName"]} | ${products[index]["subcategory"]}',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.add_chart,
                                                        color: Colors.blue,
                                                        size: 24,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return ManageProductSize(
                                                              slugID: products[
                                                                      index]
                                                                  ["slugID"]);
                                                        }));
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .delete_outline_rounded,
                                                        color:
                                                            Color(0xFFE86969),
                                                        size: 24,
                                                      ),
                                                      onPressed: () {
                                                        removeProduct(
                                                            context,
                                                            products[index]
                                                                ["slugID"]);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                              ])
                        : const SizedBox();
                  }
                }),
            FutureBuilder(
                future: getSellerProducts("Verification"),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ));
                  } else {
                    var products = snapshot.data;
                    return products.length != 0
                        ? ExpansionTile(
                            childrenPadding: const EdgeInsets.only(bottom: 12),
                            title: Text(
                              "Under Verification (${products.length})",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            children: <Widget>[
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: products.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 8, 16, 0),
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 8, 12, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Hero(
                                                  tag:
                                                      'VerificationImage$index',
                                                  transitionOnUserGestures:
                                                      true,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        products[index]
                                                            ["images"][0],
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.fitWidth,
                                                      )),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            12, 0, 2, 0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  0, 0, 0, 8),
                                                          child: Text(
                                                            products[index]
                                                                ["productName"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(
                                                            '₹${products[index]["finalPrice"]}'),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  0, 8, 0, 0),
                                                          child: Text(
                                                            '${products[index]["section"]} | ${products[index]["category"]["catName"]} | ${products[index]["subcategory"]}',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      constraints:
                                                          const BoxConstraints(),
                                                      icon: const Icon(
                                                        Icons.add_a_photo,
                                                        color: Colors.blue,
                                                        size: 24,
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
                                                    ),
                                                    IconButton(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      constraints:
                                                          const BoxConstraints(),
                                                      icon: const Icon(
                                                        Icons.add_chart,
                                                        color: Colors.blue,
                                                        size: 24,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return ManageProductSize(
                                                              slugID: products[
                                                                      index]
                                                                  ["slugID"]);
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
                                                        color:
                                                            Color(0xFFE86969),
                                                        size: 24,
                                                      ),
                                                      onPressed: () {
                                                        removeProduct(
                                                            context,
                                                            products[index]
                                                                ["slugID"]);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                              ])
                        : const SizedBox();
                  }
                }),
            FutureBuilder(
                future: getSellerProducts("Live"),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    var products = snapshot.data;
                    return products.length != 0
                        ? ExpansionTile(
                            initiallyExpanded: true,
                            childrenPadding: const EdgeInsets.only(bottom: 12),
                            title: Text(
                              "Live Products (${products.length})",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            children: <Widget>[
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: products.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 8, 16, 0),
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 8, 12, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Hero(
                                                      tag: 'LiveImage$index',
                                                      transitionOnUserGestures:
                                                          true,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Image.network(
                                                            products[index]
                                                                ["images"][0],
                                                            width: 80,
                                                            height: 80,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          )),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      left: 0,
                                                      top: 0,
                                                      child: IconButton(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8),
                                                        constraints:
                                                            const BoxConstraints(),
                                                        icon: const Icon(
                                                          Icons.edit_square,
                                                          color:
                                                              kDefaultIconLightColor,
                                                          size: 24,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return EditProductImages(
                                                                slugID: products[
                                                                        index]
                                                                    ["slugID"]);
                                                          }));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            12, 0, 2, 0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  0, 0, 0, 8),
                                                          child: Text(
                                                            products[index]
                                                                ["productName"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(
                                                            '₹${products[index]["finalPrice"]}'),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  0, 8, 0, 0),
                                                          child: Text(
                                                            '${products[index]["section"]} | ${products[index]["category"]["catName"]} | ${products[index]["subcategory"]}',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      constraints:
                                                          const BoxConstraints(),
                                                      icon: const Icon(
                                                        Icons.edit_document,
                                                        color: Colors.blue,
                                                        size: 24,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return EditProductFashion(
                                                              slugID: products[
                                                                      index]
                                                                  ["slugID"]);
                                                        }));
                                                      },
                                                    ),
                                                    IconButton(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      constraints:
                                                          const BoxConstraints(),
                                                      icon: const Icon(
                                                        Icons.add_chart,
                                                        color: kPrimaryColor,
                                                        size: 24,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return ManageProductSize(
                                                              slugID: products[
                                                                      index]
                                                                  ["slugID"]);
                                                        }));
                                                      },
                                                    ),
                                                    IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      icon: const Icon(
                                                        Icons.disabled_visible,
                                                        color:
                                                            Color(0xFFE86969),
                                                        size: 24,
                                                      ),
                                                      onPressed: () {
                                                        disableProduct(
                                                            context,
                                                            products[index]
                                                                ["slugID"]);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                              ])
                        : const SizedBox();
                  }
                }),
            FutureBuilder(
                future: getSellerProducts("Disabled"),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    var products = snapshot.data;
                    return products.length != 0
                        ? ExpansionTile(
                            childrenPadding: const EdgeInsets.only(bottom: 12),
                            title: Text(
                              "Disabled Products (${products.length})",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            children: <Widget>[
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: products.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 8, 16, 0),
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 8, 12, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Hero(
                                                  tag: 'DisableImage$index',
                                                  transitionOnUserGestures:
                                                      true,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        products[index]
                                                            ["images"][0],
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.fitWidth,
                                                      )),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            12, 0, 2, 0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  0, 0, 0, 8),
                                                          child: Text(
                                                            products[index]
                                                                ["productName"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Text(
                                                            '₹${products[index]["finalPrice"]}'),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                  0, 8, 0, 0),
                                                          child: Text(
                                                            '${products[index]["section"]} | ${products[index]["category"]["catName"]} | ${products[index]["subcategory"]}',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      icon: const Icon(
                                                        Icons
                                                            .disabled_by_default,
                                                        color: Colors.blue,
                                                        size: 24,
                                                      ),
                                                      onPressed: () {
                                                        enableProduct(
                                                            context,
                                                            products[index]
                                                                ["slugID"]);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                              ])
                        : const SizedBox();
                  }
                }),
          ]),
    );
  }

  Future<List> getSellerProducts(status) async {
    String? sellerID = await getSellerID();
    final url = Uri.parse('$urlPrefix/seller/product/get-seller-products');
    var json = {"sellerID": sellerID, "status": status};

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    return result["products"];
  }

  removeProduct(context, slugID) async {
    final url = Uri.parse('$urlPrefix/seller/product/remove-product');
    var json = {"slugID": slugID};

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"]) {
      ScaffoldMessenger.of(context).showSnackBar(displayGeneralSnackbar(
          "Refresh",
          "Product Removed Successfully!",
          context,
          const ShowProductsScreen()));
    }
  }

  enableProduct(context, slugID) async {
    final url = Uri.parse('$urlPrefix/seller/product/enable-product');
    var json = {"slugID": slugID};

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"]) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const CustomDialog(
                title: "Enabled",
                description: "Product has been enabled!",
                buttonText: "Refresh",
                icon: Icons.check,
                bgColor: kPrimaryColor,
                navigateTo: ShowProductsScreen(),
              ));
    }
  }

  disableProduct(context, slugID) async {
    final url = Uri.parse('$urlPrefix/seller/product/disable-product');
    var json = {"slugID": slugID};

    final response = await post(url, body: json);
    var result = jsonDecode(response.body);
    if (result["status"]) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const CustomDialog(
                title: "Disabled",
                description: "Product has been disabled successfully!",
                buttonText: "Refresh",
                icon: Icons.disabled_visible,
                bgColor: Colors.red,
                navigateTo: ShowProductsScreen(),
              ));
    }
  }
}
