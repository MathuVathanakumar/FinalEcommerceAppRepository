import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/constants.dart';
import 'package:e_commerce_app/services/firebase_services.dart';
import 'package:e_commerce_app/widgets/custom_input.dart';
import 'package:e_commerce_app/widgets/product_cart.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices=FirebaseServices();

  String  _searchString="";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if(_searchString.isEmpty)
            Center(
              child: Container(
                child: Text("Search Results",
                style: Constantants.regularDarkText,
                ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productReference.orderBy("search")
                .startAt([_searchString])
                .endAt(["$_searchString\uf8ff"])
                .get(),
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
                    top: 128.0,
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
          Padding(
            padding: const EdgeInsets.only(
              top: 45.0,
            ),
            child: CustomInput(
              hintText: "Search...",
              onSubmitted: (value){
                setState(() {
                      _searchString=value.toLowerCase();
                    }
                  );
                }
             ),
          ),

        ],
      ),

    );
  }
}
