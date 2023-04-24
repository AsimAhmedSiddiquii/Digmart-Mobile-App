import 'package:flutter/material.dart';

import '../../components/constants.dart';
import '../Products/add_product_fashion.dart';
import '../Products/products.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final String title;
  const AppBackground({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text(title)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddProductFashion();
          }));
        },
      ),
      body: child,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.analytics_outlined,
                size: 32,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.storefront_outlined,
                size: 32,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ShowProductsScreen();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}
