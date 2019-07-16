import 'package:flutter/material.dart';
import 'package:flutter_app/UserAgreement.dart';
import 'package:flutter_app/MainPage.dart';
import 'package:flutter_app/common.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//页面数据
String _userName = '';
String _userPawd;
Timer _timer;
int _countdownTime = 0;

//切换视图Widget
class LoginTab extends StatefulWidget{
  @override
  _LoginTabState createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  //页面初始化
  void initState(){
    super.initState();
    _userName = '';
    _userPawd = '';
    _countdownTime = 0;
  }
  //取消定时器
  void dispose(){
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //添加DefaultTabController关联TabBar及TabBarView
      home: new DefaultTabController(
        length: items.length,//传入选项卡数量
        child: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0, //设置阴影辐射范围
            bottom: new TabBar(
              isScrollable : true,  //可滚动
              labelPadding: EdgeInsets.fromLTRB(56.0, 0, 56.0, 0),
              indicatorColor: ThemeColor, //指示器颜色
              indicatorSize: TabBarIndicatorSize.label, //指示器与文字等宽
              labelColor: ThemeColor, //选中的label颜色
              unselectedLabelColor: Color.fromARGB(255, 51, 51, 51),  //未选中的label颜色
              tabs: items.map((ItemView item) {//迭代添加选项卡子项
                return new Tab(
                  text: item.title,
                );
              }).toList(),
            ),
          ),
          //添加选项卡视图
          backgroundColor: Colors.white,
          body: new TabBarView(
              children: items.map((ItemView item) {//迭代显示选项卡视图
              return new Container(
                margin: EdgeInsets.all(40.0),
                child: new SelectedView(item: item),
              );
            }).toList(),
          ),
          resizeToAvoidBottomPadding: false,
        ),
      ),
    );
  }
}

//获取手机号
void uphone(value){
  _userName =value;
}

// 获取密码或者验证码
void upassword(value){
  _userPawd =value;
}

//http获取验证码
void sendCode(context) async{
  
  var url = 'http://360-buy.cn/api/scsms_app.php?act=getSmsCode';
  var params = Map<String, dynamic>();
      params["mobile"] = _userName;

  http.post(url,body: params)
      .then((http.Response response){
         final Map<String, dynamic> responseData = json.decode(response.body);
         if(responseData['code'] == 0 ){
           showHintDialog(context,responseData['msg']);
         }else{
           showHintDialog(context,responseData['msg']);
         }
      });
}

//验证码登录
void codeLogin(context){
  var url = 'http://360-buy.cn/api/scsms_app.php?act=login';
  var params = Map<String, dynamic>();
      params["mobile"] = _userName;
      params["sms_code"] = _userPawd;

  http.post(url,body: params)
      .then((http.Response response){
        final Map<String, dynamic> responseData = json.decode(response.body);

        if(responseData['code'] == 0 ){
          //存储uid
          saveString('uid', responseData['uid']).then((res)=>{
            //存储token
            saveString('token', responseData['token']).then((res)=>{
              //跳转
              Navigator.push(context,new MaterialPageRoute(
                builder: (context)=> new MainPage()
              ))
            })
          });
        }else{
          showHintDialog(context,responseData['msg']);
        }
      });
}

//手机登录
void phoneLogin(){print('手机登录'+'账号'+_userName+'密码'+_userPawd);}

//视图项数据
class ItemView {
  const ItemView({ this.title,this.hintText,this.verifyCode,this.loginFun,this.unameFun,this.upawdFun});//构造方法
  final String title;     //切换的内容
  final String hintText;  //提示内容
  final bool verifyCode;  //是否显示获取验证码按钮
  final loginFun;         //登录方法
  final unameFun;         //获取账号
  final upawdFun;         //获取密码或者验证码
}

//选项卡的类目
const List<ItemView> items = const <ItemView>[
  const ItemView(title: '手机登录',hintText:'请输入验证码',verifyCode: false,loginFun: codeLogin,unameFun: uphone,upawdFun: upassword),
  //暂时取消账号密码登录Tab视图
  //const ItemView(title: '账号登录',hintText:'请输入密码',verifyCode: true,loginFun: phoneLogin,unameFun: uphone,upawdFun: upassword),
];

class SelectedView extends StatefulWidget {
  //接受视图数据
  final ItemView item;
  const SelectedView({ Key key, this.item }) : super(key: key);
  
  @override
  _SelectedViewState createState() => new _SelectedViewState(item:item);
}

//被选中的视图
class _SelectedViewState extends State<SelectedView> {
  // 用来储存SelectedView传递过来的值
  final ItemView item;   
  _SelectedViewState ({Key key, @required this.item});

  //定时器
  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
      setState(
        () {
          if (_countdownTime < 1) { _timer.cancel(); } else { _countdownTime = _countdownTime - 1; } }) 
        }; 
    _timer = Timer.periodic(oneSec, callback); 
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
        children:<Widget>[ 
          new Column(
          children: <Widget>[
            //账号
            new Container(
              child: new ListTile(
                leading:new Icon(Icons.stay_current_portrait,color: ThemeColor,),
                title: new TextField(
                  onChanged: (value){item.unameFun(value);},
                  //光标颜色
                  cursorColor: ThemeColor,
                  // 默认设置
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入手机号',
                    hintStyle: new TextStyle(
                      fontSize: 14.0, 
                    )
                  ),
                  style: TextStyle(
                    color: Color.fromARGB(255, 51, 51, 51),
                  ),
                ),
                trailing: new Offstage(
                  offstage: item.verifyCode,
                  child: new MaterialButton(
                    disabledColor:Colors.grey,  //禁用按钮颜色
                    color:ThemeColor,
                    child: new Text(_countdownTime > 0 ? '$_countdownTime''s后重新获取' : '获取验证码',style: TextStyle(fontSize: 14.0,color: Colors.white),),
                    onPressed: _countdownTime > 0 ? null : (){
                      if(_userName == ''|| _userName==null){
                        showHintDialog(context, "电话号码不能为空");
                      }else if(mobileExp.hasMatch(_userName)==false){
                        showHintDialog(context, "电话号码格式错误");
                      }else{
                        if(_countdownTime == 0){
                          //Http请求发送验证码
                          sendCode(context);
                          setState(() {
                            _countdownTime = 60;
                          });
                          //开始倒计时
                          startCountdownTimer();
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            
            //密码
            new Container(
              child: new ListTile(
                leading:new Icon(Icons.verified_user,color: ThemeColor,),
                title: new TextField(
                  onChanged: (value){item.upawdFun(value);},
                  //光标颜色
                  cursorColor: Color.fromARGB(255, 239, 96, 62),
                  // 默认设置
                  decoration: InputDecoration(
                    // contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    border: InputBorder.none,
                    hintText: item.hintText,
                    hintStyle: new TextStyle(
                      fontSize: 14.0, 
                    )
                  ),
                  style: TextStyle(
                    color: Color.fromARGB(255, 51, 51, 51),
                  ),
                  obscureText: item.verifyCode ? true : false,
                ),
              ),
            ),

            //登录
            new Container(
              margin: EdgeInsets.only(top: 10.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new MaterialButton(
                      color:Color.fromARGB(255, 239, 96, 62),
                      child: new Text("登录",style: TextStyle(fontSize: 16.0,color: Colors.white),),
                      onPressed: (){item.loginFun(context);},
                    ),
                  )
                ],
              ),
            ),
            
            new Offstage(
              offstage: item.verifyCode,
              child: new Container(
                margin: EdgeInsets.only(left: 20.0),
                child: new Row(
                  children: <Widget>[
                    new Text("新用户登录即完成注册，代表同意",style: TextStyle(fontSize: 12.0),),
                    new GestureDetector(
                      onTap: (){
                        Navigator.push(context,new MaterialPageRoute(
                        builder: (context)=> new UserAgreement()
                      ));
                      },
                      child: new Text("《安心装用户协议》",style: TextStyle(fontSize: 12.0,color: Colors.blue),),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ]
    );
  }
}


