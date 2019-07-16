import 'package:flutter/material.dart';
import 'package:flutter_app/AboutAnxin.dart';
// import 'package:flutter_app/ChangePassword.dart'; //修改密码
import 'package:flutter_app/LoginTab.dart';
import 'package:flutter_app/common.dart';

class MyHome extends StatefulWidget{
  @override
  _MyHomeState  createState() => new _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var _userData;

  @override
  //初始化
  void initState(){
    super.initState();
    //用户信息
    getUserInfo().then((res){
      setState(() {
        _userData =res;
      });
    });
  }

  //退出登录
  void outLogin(context){
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
      title: new Text("提示",style: TextStyle(color: ThemeColor),),
      content: new Text('您确定要退出？'),
      actions:<Widget>[
        new FlatButton(child:new Text("取消",textAlign: TextAlign.center,), onPressed: (){
            Navigator.of(context).pop();
        },),
        new FlatButton(child:new Text("确定",textAlign: TextAlign.center,), onPressed: (){
            removeString('uid').then((res)=>{
              removeString('token').then((res)=>{
                Navigator.push(context,new MaterialPageRoute(
                  builder: (context)=> new LoginTab()
                ))
              })
            });
        },),
      ]
    ));
  }

  //头像信息widget
  Widget portraitWidget(){
    return new Container(
      color: ThemeColor,
      child: new Container(
        margin: EdgeInsets.fromLTRB(0, 10.0, 0, 18.0),
        child:new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: new CircleAvatar(
                  radius: 40.0,
                  backgroundColor: ThemeColor,
                  backgroundImage: new NetworkImage('https://img.hejiaju.com/mobile/themes/default/images/goods/user-photo.png'),
                ),
              ),
              new Text(_userData != null ? _userData['name'] :'',style: TextStyle(color: Colors.white),),
              new Text(_userData != null ? "电话："+_userData['phone'] :'',style: TextStyle(color: Colors.white),),
            ],
          ),  
        ), 
      ) 
    );
  }

  //用户信息widget
  Widget userWdget(){
    return new Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Card(
        child: new Column(
          children: <Widget>[
            new ListTile(
              title:new Text("账号"),
              trailing: new Text(_userData != null ? _userData['phone'] :''),
            ),
            new Divider(),
            // new ListTile(
            //   title:new Text("修改密码"),
            //   trailing: new Icon(Icons.navigate_next),
            //   onTap: (){
            //     Navigator.push(context, new MaterialPageRoute(
            //       builder: (context) => ChangePassword()
            //     ));
            //   },
            // ),
            // new Divider(),
            new ListTile(
              title:new Text("关于安心装"),
              trailing: new Icon(Icons.navigate_next),
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context)=>new AboutAnxin()
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  //退出登录widget
  Widget logOut(context){
    return new Container(
      margin: EdgeInsets.only(top: 10.0),
      child: new Card(
        child: new Column(
          children: <Widget>[
            new ListTile(
              title:new Text("退出登录"),
              onTap: (){
                outLogin(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  //客服电话widget
  Widget kefu(){
    return new Container(
      margin: EdgeInsets.only(top: 10.0),
      child: new Card(
        child: new Column(
          children: <Widget>[
            new ListTile(
              title:new Text("客服电话: 400-822-63156"),
              onTap: (){print('客服电话: 400-822-63156');},
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar:new PreferredSize(
        child: new AppBar(
          title: new Text("用户信息"),
          // bottom: ,
        ),
        preferredSize: Size.fromHeight(0.0),
      ),
      backgroundColor: Colors.grey.shade200,
      body: new ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              portraitWidget(),
              userWdget(),
              logOut(context),
              kefu(),
            ],
          ),
        ],
      ),
    );
  }
}