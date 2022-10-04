import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RemoteData {
  BuildContext context;
  RemoteData({required this.context});
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  // getter for product from firebase firestore
  CollectionReference get products => _products;

  // add method
  Future<void> _addProduct(String productName, String productPrice) async {
    final String name = productName;
    final double? price = double.tryParse(productPrice);
    if (price != null && name != null) {
      await _products.add({"name": name, "price": price});
      _nameController.text = '';
      _priceController.text = '';
      Navigator.of(context).pop();
    } else {
      showMySnackBar(context, 'Enter a price or Name of product to be added');
    }
  }

  // update method
  Future<void> _updateProduct(DocumentSnapshot data) async {
    final String name = _nameController.text;
    final double? price = double.tryParse(_priceController.text);
    if (price != null && name != null) {
      await _products.doc(data.id).update({"name": name, "price": price});
      _nameController.text = '';
      _priceController.text = '';
      Navigator.of(context).pop();
    }
  }

  // delete method
  Future<void> deleteProduct(
    BuildContext context,
    DocumentSnapshot data,
  ) async {
    await _products.doc(data.id).delete();
    // showMySnackBar(context, 'You have successfully deleted a product');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have successfully edited a product'),
      ),
    );
  }

// /////////////////////////////////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////////////////////////////
  // show alert box add buttom
  void showSheetAddButton(BuildContext context) async {
    await showDialog(
      // isScrollControlled: true,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: Container(
          width: 376,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () async {
                        await _addProduct(
                            _nameController.text, _priceController.text);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // show  alert box for update button
  void showSheetUpdateButton(
      BuildContext context, DocumentSnapshot data) async {
    if (data != null) {
      _nameController.text = data['name'];
      _priceController.text = data['price'].toString();
    } else {
      showMySnackBar(context, 'No product to edit');
    }
    await showDialog(
      // isScrollControlled: true,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: Container(
          width: 376,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () async {
                        await _updateProduct(data);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('You have successfully edited a product'),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // show Snackbar
  void showMySnackBar(BuildContext context, String message) {
    BuildContext newcontext = scaffoldKey.currentContext!;
    ScaffoldMessenger.of(newcontext).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
