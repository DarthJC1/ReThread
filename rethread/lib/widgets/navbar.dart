import 'package:flutter/material.dart';
import 'package:rethread/common/colors.dart';
import 'package:rethread/pages/LandingPage.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {

  return Container(
      height: 90,
      color: navbarBlack,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribusi merata
        children: [
          Container(
            width: 70,
            height: 70,
            // color: Colors.red, 
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
              foregroundColor: Colors.white,
              backgroundColor: navbarBlack,
              elevation: 0,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.home_outlined, size: 35,),
                Text("Home"),
              ],
              ),
            ),// Contoh
          ),
          Container(
            width: 70,
            height: 70,
            // color: Colors.red, 
            child: FloatingActionButton(
              onPressed: () {
                  LandingPage();
                },
              foregroundColor: Colors.white,
              backgroundColor: navbarBlack,
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.folder_outlined , size: 35,),
                Text("History"),
              ],
              ),
            ),// Contoh
          ),
          Container(
            width: 70,
            height: 70,
            // color: Colors.red, 
            child: FloatingActionButton(
              onPressed: () {
                  LandingPage();
                },
              foregroundColor: Colors.white,
              backgroundColor: navbarBlack,
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.logout_outlined, size: 35,),
                Text("Exit", textAlign: TextAlign.center,),
              ],
              ),
            ),// Contoh
          ),
        ],
      ),
    );
  }
}