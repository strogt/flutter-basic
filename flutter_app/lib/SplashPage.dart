import 'package:flutter/material.dart';
import 'package:flutter_app/common.dart';
import 'package:flutter_app/MainPage.dart';
import 'package:flutter_app/LoginTab.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer _timer;
  int _countdownTime = 0;
  bool _isJump = true;

  @override
  //初始化
  void initState(){
    super.initState();
    getString('uid').then((res){
      uid = res;
      getString('token').then((res){
        token = res;
        setState(() {
          _isJump = false;
          _countdownTime = 5;
          startCountdownTimer();
        });
      });
    });
  }

  //取消定时器
  void dispose(){
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
      setState(() {
        if (_countdownTime <= 1) {
           _timer.cancel();
          //跳入页面
          if(uid !=null || token != null){
            Navigator.push(context,new MaterialPageRoute(
              builder: (context)=> new MainPage()
            ));
          }else{
            Navigator.push(context,new MaterialPageRoute(
              builder: (context)=> new LoginTab()
            ));
          }
        } else { 
          _countdownTime = _countdownTime - 1; 
        } 
      }) 
    }; 
    _timer = Timer.periodic(oneSec, callback); 
  }

  void _goGoodsList(){
    if (_timer != null) {
      _timer.cancel();
    }
    //跳入判断
    if(uid !=null || token != null){
      Navigator.push(context,new MaterialPageRoute(
        builder: (context)=> new MainPage()
      ));
    }else{
      Navigator.push(context,new MaterialPageRoute(
        builder: (context)=> new LoginTab()
      ));
    }
  }

  @override
  Widget build(BuildContext context){
    return new Material(
      child: new Stack(
        children: <Widget>[
          new Image.asset('images/start_bg.jpg',fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
          new Positioned(
            right: 20.0,
            bottom: 20.0,
            child:new Offstage(
              offstage: _isJump,
              child: new InkWell(
                onTap: (){
                  _goGoodsList();
                },
                child: new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new Text('跳过 $_countdownTime',style: new TextStyle(fontSize: 14.0,color: Colors.white),),
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(60, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}