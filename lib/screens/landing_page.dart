import 'package:e_commerce_app/constants.dart';
import 'package:e_commerce_app/screens/home_page.dart';
import 'package:e_commerce_app/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //if snapshot has error want to do this
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("This is your error:${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          //streambuilder can  check the login live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,streamsnapshot){
              if (streamsnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("This is your error:${streamsnapshot.error}"),
                  ),
                );
              }

              //if Connection state is active do the user login check inside
              if(streamsnapshot.connectionState== ConnectionState.active){
                //Get the user
                User _user=streamsnapshot.data;

                //if user is null then user not logged in
                if( _user==null){

                  //user not logged in ,head to login
                  return LoginPage();
                }
                else{
                  //user is logged in,head to homepage
                  return HomePage();
                }
              }


            // for checking the auth state -loading
              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking the authendication",
                    style: Constantants.regularHeading,
                  ),
                ),
              );
            },
          );
        }

        //Connectiong to Firebase-loading
        return Scaffold(
          body: Center(
            child: Text(
              "Initialization Ecommerce App ..",
              style: Constantants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}

