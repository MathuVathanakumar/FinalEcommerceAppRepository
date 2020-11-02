import 'package:e_commerce_app/constants.dart';
import 'package:e_commerce_app/screens/register_page.dart';
import 'package:e_commerce_app/widgets/custom_btn.dart';
import 'package:e_commerce_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _alertDialogBuilder(String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(error),
            content: Container(
              child: Text("just text"),
            ),
            actions: [
              FlatButton(
                child: Text("Close"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],

          );
        }
    );
  }

  //create new user account
  Future<String> _loginAccount() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail,
          password: _loginPassword
      );
      return null;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch(e){
      return e.toString();
    }
  }

  void _submitForm() async{

    //set the form to loading state
    setState(() {
      _loginFormLoading=true;
    });

    //run the create account method
    String _loginFeedback= await _loginAccount();

    //if the string is not ull, we got error while create account
    if(_loginFeedback != null){
      _alertDialogBuilder(_loginFeedback);

      //set the form to regular state[not loading]
      setState(() {
        _loginFormLoading=false;
      });
    }
  }

  //Default Form Loading state
  bool _loginFormLoading=false;

  //Form input field values
  String _loginEmail="";
  String _loginPassword="";

  //focus note for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode=FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
              padding: EdgeInsets.only(
                top:25.0,
              ),
              child: Text(
                "Welcome !\n Login to your account",
                 textAlign: TextAlign.center,
                 style: Constantants.boldHeading,
              ),
              ),
            Column(
                children: [
                  CustomInput(
                    hintText: "Email...",
                    onChanged: (value){
                      _loginEmail=value;
                    },
                    onSubmitted:(value){
                      _passwordFocusNode.requestFocus();
                    } ,
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: "Password..",
                    onChanged: (value){
                      _loginPassword=value;
                    },
                    focusNode:_passwordFocusNode ,
                    isPasswordField: true,
                    onSubmitted: (value){
                      _submitForm();
                    },
                  ),
                  CustomButton(
                    text: "Login",
                    onPressed: (){
                      _submitForm();
                    },
                    isLoading:_loginFormLoading,
                  )
                ],
              ),
             Padding(
               padding: const EdgeInsets.only(
                 bottom: 16.0,
               ),
               child: CustomButton(
                 text: "Create New Account",
                 onPressed: (){
                   Navigator.push(context,
                       MaterialPageRoute(
                         builder: (context) =>RegisterPage()
                       ),
                   );
                 },
                 outlineBtn: true,
               ),
             ),
            ],
          ),
        ),
      ),
    );
  }
}
