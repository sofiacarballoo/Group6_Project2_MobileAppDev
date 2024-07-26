import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project2/utils/colors.dart';
import 'package:project2/utils/global_variables.dart';


class   MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key:key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose;
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
            color: _page == 0? blueColor : Colors.grey[850],
            ),
            label: '', 
            backgroundColor: Colors.grey[850],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
            color: _page == 1? blueColor : Colors.grey[850],
            ),
            label: '', 
            backgroundColor: Colors.grey[850],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline,
            color: _page == 2? blueColor : Colors.grey[850],
            ),
            label: '', 
            backgroundColor: Colors.grey[850],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications,
            color: _page == 3? blueColor : Colors.grey[850],
            ),
            label: '', 
            backgroundColor: Colors.grey[850],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets, 
            color: _page == 4? blueColor : Colors.grey[850],
            ),
            label: '', 
            backgroundColor: Colors.grey[850],
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  } 
}