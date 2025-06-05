import 'package:agora_task/app/modules/home/views/home_view.dart';
import 'package:agora_task/app/modules/invitation/views/invitation_view.dart';
import 'package:agora_task/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';


class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({super.key});

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeView(),
    InvitationView(),
    ProfileView(),

  ];

  void _onTabTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          // Slide transition for page switching
          final inFromRight = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation);

          final outToLeft = Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ).animate(animation);

          return SlideTransition(
            position: animation.status == AnimationStatus.reverse
                ? outToLeft
                : inFromRight,
            child: child,
          );
        },
        child: _pages[_selectedIndex],
        layoutBuilder: (currentChild, previousChildren) => currentChild!,
      ),
      bottomNavigationBar: _buildCustomNavBar(),
    );
  }

  Widget _buildCustomNavBar() {
    final items = [
      _NavBarItem(icon: Icons.home),
      _NavBarItem(icon: Icons.insert_invitation_rounded),
      // _NavBarItem(icon: Icons.favorite, label: 'Favorites'),
      _NavBarItem(icon: Icons.person),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final selected = _selectedIndex == index;
          return GestureDetector(
            onTap: () => _onTabTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(horizontal: selected ? 20 : 12, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? Colors.blue.shade50 : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    items[index].icon,
                    color: selected ? Colors.blue : Colors.grey,
                  ),
                  // if (selected)
                  //   Padding(
                  //     padding: const EdgeInsets.only(left: 8.0),
                  //     child: Text(
                  //       items[index].label,
                  //       style: TextStyle(
                  //         color: Colors.blue,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavBarItem {
  final IconData icon;
  // final String label;
  _NavBarItem({required this.icon});
}
