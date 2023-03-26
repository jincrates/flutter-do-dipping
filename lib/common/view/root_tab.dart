import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  int index = 0;


  @override
  void initState() {
    super.initState();
    
    controller = TabController(length: 4, vsync: this);

    // 컨트롤러가 변경될때 동작
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '진크 딜리버리',
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),  //좌우 스크롤이 멈춤
        controller: controller,
        children: [
          RestaurantScreen(),
          Center(child: Container(child: Text('음식'))),
          Center(child: Container(child: Text('주문'))),
          Center(child: Container(child: Text('프로필'))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
         controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
