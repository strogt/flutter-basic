import 'package:flutter/material.dart';
import 'package:flutter_app/GoodsLists.dart';
import 'package:flutter_app/MyHome.dart';
 
// class MainPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//         debugShowCheckedModeBanner: false, home: new MainPageWidget());
//   }
// }
 
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() =>_MainPageState();
}
 
class _MainPageState extends State<MainPage> {
  //底部导航
  final _iconSize = 20.0;       //图标大小
  final _iconTextSize = 12.0;   //文字大小
  int _selectedIndex = 0;       //起始位置
  var _pageList;                //导航页面
 
  //导航跳转函数
  void initData() {           
    // 三个子界面
    _pageList = [
      new GoodsLists(),
      new MyHome(),
    ];
  }
 
  @override
  Widget build(BuildContext context) {
    //初始化数据
    initData();
    return new Scaffold(
      body: _pageList[_selectedIndex],
      bottomNavigationBar:new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.reorder),
            title: new Text("订单",style: TextStyle(fontSize: _iconTextSize),),
          ),
          // new BottomNavigationBarItem(
          //   icon: new Icon(Icons.camera_enhance),
          //   title: new Text("扫码",style: TextStyle(fontSize: _iconTextSize),),
          // ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.perm_identity),
            title: new Text("我的",style: TextStyle(fontSize: _iconTextSize),),
          ),
        ],
        iconSize: _iconSize,
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 239, 96, 62),
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}