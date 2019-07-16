import 'package:flutter/material.dart';

class AboutAnxin extends StatefulWidget{
  @override
  _AboutAnxinState createState() => _AboutAnxinState();
}

class _AboutAnxinState extends State<AboutAnxin>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar:new PreferredSize(
        child: new AppBar(
          centerTitle: true,
          title: new Text("关于我们",style: TextStyle(color: Colors.black,fontSize: 16.0,),),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        preferredSize: Size.fromHeight(45.0),
      ), 
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(top: 18.0),
              width: 180.0,
              height: 120.0,
              child: new ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: new Image.network('https://img.hejiaju.com/images/201903/designer_img/des_P_1551405004651.jpg'),
              )
            ),
            new Container(
              margin: EdgeInsets.only(top: 10.0),
              child: new Text("版本号：1.0.0"),
            ),
            new Container(
              margin: EdgeInsets.only(top: 10.0),
              child: new Text("检查更新"),
            ),
            new Container(
              margin: EdgeInsets.all(10.0),
              child: new Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar sic tempor. Sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci, sed rhoncus pronin sapien nunc accuan eget."),
            )
          ],
        ),
      ),
    );
  }
}