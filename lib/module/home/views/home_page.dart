import 'package:flutter/material.dart';

import '../../album/views/album_view.dart';
import '../../post/views/post_view.dart';
import '../../todo/views/todo_view.dart';
import '../../user/views/user_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static Set<_Nav> _navItems = {
    _Nav(label: 'Users', iconData: Icons.groups, view: User()),
    _Nav(label: 'Todo', iconData: Icons.groups, view: Todo()),
    // _Nav(label: 'Users', iconData: Icons.groups, view: User()),
    // _Nav(label: 'Posts', iconData: Icons.newspaper_rounded, view: Post(userId: userId)),
    // _Nav(label: 'Albums', iconData: Icons.collections, view: Album()),
  };

  // Selected index.
  int _currentIndex = 0;

  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            _navItems.elementAt(_currentIndex).label,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Row(
        children: [
          if (isLargeScreen)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onNavIndexChange,
              labelType: NavigationRailLabelType.all,
              destinations: _navItems
                  .map(
                    (e) => NavigationRailDestination(
                      label: Text(e.label),
                      icon: Icon(e.iconData),
                    ),
                  )
                  .toList(),
            ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _navItems.map((e) => e.view).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isLargeScreen
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onNavIndexChange,
              items: _navItems
                  .map((e) => BottomNavigationBarItem(
                        label: e.label,
                        icon: Icon(e.iconData),
                      ))
                  .toList(),
            ),
    );
  }

  void _onNavIndexChange(int i) {
    setState(() {
      _currentIndex = i;
      _pageController.jumpToPage(i);
    });
  }
}

class _Nav {
  const _Nav({
    required this.label,
    required this.iconData,
    required this.view,
  });

  final String label;
  final IconData iconData;
  final Widget view;
}
