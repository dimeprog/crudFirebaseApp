import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudfirebaseapp/firebase_data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RemoteData _remotedata = RemoteData(context: context);
    return Scaffold(
      key: _remotedata.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xffe2d3f5),
        elevation: 0,
        title: const Text(
          'home',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _remotedata.products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final DocumentSnapshot data = snapshot.data!.docs[index];
                return ProductItem(
                  data: data,
                );
              },
              itemCount: snapshot.data?.docs.length,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(
              child: Text(
                'No Data',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _remotedata.showSheetAddButton(context);
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final DocumentSnapshot data;
  const ProductItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final RemoteData _remotedata = RemoteData(context: context);
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xff023e8a),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.pink,
              size: 40,
            ),
            onPressed: () async {
              await _remotedata.deleteProduct(
                context,
                data,
              );
            },
          ),
          title: Text(
            data['name'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            '\$ ${data['price'].toString()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Container(
            // width: ,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.pink,
                size: 40,
              ),
              onPressed: () {
                _remotedata.showSheetUpdateButton(context, data);
              },
            ),
          ),
        ),
      ),
    );
  }
}
