import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget{
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar:new PreferredSize(
        child: new AppBar(
          centerTitle: true,
          title: new Text("修改密码",style: TextStyle(color: Colors.black,fontSize: 16.0,),),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        preferredSize: Size.fromHeight(45.0),
      ),
      backgroundColor: Colors.white,
      body: new Center(
        child: new Column(
          children: <Widget>[
            new ListTile(
              leading: new SizedBox(
                width: 68.0,
                child: new Text("旧密码",style: new TextStyle(fontSize: 16.0),),
              ),
              title: new TextField(
                //光标颜色
                cursorColor: Color.fromARGB(255, 239, 96, 62),
                // 默认设置
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: InputBorder.none,
                  hintText: "请输入旧密码",
                  hintStyle: new TextStyle(
                    fontSize: 14.0, 
                  )
                ),
                style: TextStyle(
                  color: Color.fromARGB(255, 51, 51, 51),
                ),
                obscureText: true,
              ),
            ),
            new Divider(),
            new ListTile(
              leading: new SizedBox(
                width: 68.0,
                child: new Text("新密码",style: new TextStyle(fontSize: 16.0),),
              ),
              title: new TextField(
                //光标颜色
                cursorColor: Color.fromARGB(255, 239, 96, 62),
                // 默认设置
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: InputBorder.none,
                  hintText: "请输入新密码",
                  hintStyle: new TextStyle(
                    fontSize: 14.0, 
                  )
                ),
                style: TextStyle(
                  color: Color.fromARGB(255, 51, 51, 51),
                ),
                obscureText: true,
              ),
            ),
            new ListTile(
              leading: new SizedBox(
                width: 68.0,
                child: new Text("确认密码",style: new TextStyle(fontSize: 16.0),),
              ),
              title: new TextField(
                //光标颜色
                cursorColor: Color.fromARGB(255, 239, 96, 62),
                // 默认设置
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: InputBorder.none,
                  hintText: "请确认密码",
                  hintStyle: new TextStyle(
                    fontSize: 14.0, 
                  )
                ),
                style: TextStyle(
                  color: Color.fromARGB(255, 51, 51, 51),
                ),
                obscureText: true,
              ),
            ),

            //保存
            new Container(
              margin: EdgeInsets.only(top: 18.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child:  new MaterialButton(
                      padding: EdgeInsets.all(10.0),
                      color:Color.fromARGB(255, 239, 96, 62),
                      child: new Text("保存",style: TextStyle(fontSize: 18.0,color: Colors.white),),
                      onPressed: (){print("保存");},
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}