import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rsforms/Screens/analytics.dart';
import 'package:rsforms/Screens/calendar.dart';
import 'package:rsforms/Screens/company_editor.dart';
import 'package:rsforms/Screens/settings.dart';
import 'package:rsforms/Screens/uncompleted_jobs.dart';
import 'package:rsforms/Screens/job_editor.dart';

class PageviewControll extends StatefulWidget {
  const PageviewControll({super.key});

  @override
  State<PageviewControll> createState() => _PageviewControllState();
}

class _PageviewControllState extends State<PageviewControll> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  bool _inPageSwitchAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xff31384d),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: GNav(
              duration: Duration(milliseconds: 400),
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                _onTappedTile(index);
              },
              haptic: true,
              tabs: const [
                GButton(
                  icon: Icons.calendar_month,
                  text: 'Home',
                  iconActiveColor: Colors.black,
                  iconColor: Colors.white,
                ),
                GButton(
                  icon: Icons.access_time,
                  text: 'Awaiting',
                  iconActiveColor: Colors.black,
                  iconColor: Colors.white,
                ),
                GButton(
                  icon: Icons.bar_chart,
                  text: 'Statistics',
                  iconActiveColor: Colors.black,
                  iconColor: Colors.white,
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                  iconActiveColor: Colors.black,
                  iconColor: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (_inPageSwitchAnimation == false) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        children: [
          Calendar(),
          const uncompletedJobs(),
          const Analytics(),
          const Settings(),
        ],
      ),
    );
  }

  void _onTappedTile(int index) async {
    if (_selectedIndex == index) {
      return;
    }

    _inPageSwitchAnimation = true;
    await _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: ((_selectedIndex - index).abs()) * 175),
      curve: Curves.ease,
    );
    setState(() {
      _selectedIndex = index;
    });
    _inPageSwitchAnimation = false;
  }
}
