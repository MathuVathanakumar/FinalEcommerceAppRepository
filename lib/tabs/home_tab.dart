import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/constants.dart';
import 'package:e_commerce_app/screens/product_page.dart';
import 'package:e_commerce_app/widgets/custom_action_bar.dart';
import 'package:e_commerce_app/widgets/product_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
final CollectionReference _productReference=
FirebaseFirestore.instance.collection("Ecommerce Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productReference.get(),
            builder: (context,snapshot){
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("This is your error:${snapshot.error}"),
                  ),
                );
              }

              //Collection data readt to display
              if(snapshot.connectionState==ConnectionState.done){
                //Display the data inside a list view
                return ListView(
                  padding: EdgeInsets.only(
                    top: 100.0,
                    bottom: 12.0,
                  ),

                  children: snapshot.data.docs.map((document){
                    return ProductCard(
                      title: document.data()['name'],
                      imageUrl: document.data()['images'][0],
                      price: "\$${document.data()['price']}",
                      productId: document.id,
                    );
                  }
                  ).toList(),
                );
              }

              //Loading state
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            title: "Home",
            hasBackArrow: false,
          ),
        ],
      ),
    );
  }
}
