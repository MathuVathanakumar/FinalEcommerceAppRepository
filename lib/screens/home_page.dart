import 'package:e_commerce_app/constants.dart';
import 'package:e_commerce_app/services/firebase_services.dart';
import 'package:e_commerce_app/tabs/home_tab.dart';
import 'package:e_commerce_app/tabs/save_tab.dart';
import 'package:e_commerce_app/tabs/search_tab.dart';
import 'package:e_commerce_app/widgets/bottom_tabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseServices _firebaseServices=FirebaseServices();

  PageController _tabPageController;
  int _selectedTab=0;

  @override
  void initState() {
    _tabPageController=PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Expanded(
              child: PageView(
                controller: _tabPageController,
                onPageChanged: (num){
                  setState(() {
                    _selectedTab=num;
                  });
                },
                children: [
                   HomeTab(),
                  SearchTab(),
                  SaveTab()
                ],
              ),
            ),
          ),
          BottomTabs(
            selectedTab: _selectedTab,
            tabPressed: (num){
              _tabPageController.animateToPage(num,
                  duration: Duration(microseconds: 300),
                  curve: Curves.easeOutCubic
              );
            },
          ),
        ],
      ),
    );
  }
}
