import 'package:absensi/pages/home/profile.dart';
import 'package:absensi/pages/home/riwayat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dashboard.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  static Route route() {
    return CupertinoPageRoute<void>(
      builder: (_) => const Navbar(),
    );
  }

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> body = const [
    DashboardPage(),
    RiwayatPage(),
    ProfilePage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/House.svg',
              height: 26,
              width: 26,
              color: Colors.grey,
            ),
            label: 'Dashboard',
            activeIcon: SvgPicture.asset(
              'assets/svg/House.svg',
              height: 26,
              width: 26,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/Newspaper.svg',
              height: 26,
              width: 26,
              color: Colors.grey,
            ),
            label: 'Riwayat',
            activeIcon: SvgPicture.asset(
              'assets/svg/Newspaper.svg',
              height: 26,
              width: 26,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svg/account.svg',
              height: 26,
              width: 26,
              color: Colors.grey,
            ),
            label: 'Profile',
            activeIcon: SvgPicture.asset(
              'assets/svg/account.svg',
              height: 26,
              width: 26,
            ),
          ),
        ],
        onTap: onItemTapped,
        iconSize: 26,
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
        selectedLabelStyle: const TextStyle(
            fontFamily: 'Roboto', fontWeight: FontWeight.w600, fontSize: 10),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
