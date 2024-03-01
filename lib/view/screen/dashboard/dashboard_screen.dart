import 'package:flutter/material.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/view/screen/account/account_screen.dart';
import 'package:nurserygardenapp/view/screen/customization/customization_screen.dart';
import 'package:nurserygardenapp/view/screen/plant/plant_screen.dart';
import 'package:nurserygardenapp/view/screen/product/product_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({Key? key, required this.pageIndex}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  late List<Widget> _screen;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screen = [
      PlantScreen(),
      ProductScreen(),
      CustomizationScreen(),
      AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!mounted) return false;
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: ColorResources.COLOR_GREY,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            _barItem(
                this._pageIndex == 0
                    ? Icons.local_florist
                    : Icons.local_florist_outlined,
                'Plant',
                0),
            _barItem(
                this._pageIndex == 1 ? Icons.widgets : Icons.widgets_outlined,
                'Product',
                1),
            _barItem(
                this._pageIndex == 2
                    ? Icons.insights_rounded
                    : Icons.insights_outlined,
                'Customization',
                2),
            _barItem(
                this._pageIndex == 3
                    ? Icons.manage_accounts
                    : Icons.manage_accounts_outlined,
                'Account',
                3),
          ],
          onTap: (int index) {
            if (!mounted) return;
            _setPage(index);
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screen.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screen[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon,
              color: index == _pageIndex
                  ? Theme.of(context).primaryColor
                  : ColorResources.COLOR_GREY,
              size: 25),
        ],
      ),
      label: label,
    );
  }

  void _setPage(int index) {
    if (!mounted) return;
    setState(() {
      _pageController.jumpToPage(index);
      _pageIndex = index;
    });
  }
}
