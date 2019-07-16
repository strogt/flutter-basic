import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

//用户变量
String uid;
String token;

//APP常量
const ThemeColor = Color.fromARGB(255, 239, 96, 62);    //主题颜色
const UnCurColor = Color.fromARGB(255, 51, 51, 51);     //未选中颜色#333
const TopDistance = 10.0;                               //container距top的margin 
const TitleSize = 16.0;                                 //标题
const ContentSize = 14.0;                               //内容

//弹出层
void showHintDialog(BuildContext context,content) {
  showDialog(
    context: context,
    builder: (context) => new AlertDialog(
        title: new Text("提示",style: TextStyle(color: Color.fromARGB(255, 239, 96, 62)),),
        content: new Text(content),
        actions:<Widget>[
          new FlatButton(child:new Text("确定",textAlign: TextAlign.center,), onPressed: (){
            Navigator.of(context).pop();
          },),
        ]
  ));
}

//手机正则
RegExp mobileExp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

//利用SharedPreferences存储数据
Future saveString(key,data) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(key, data);
  return false;
}

//获取存在SharedPreferences中的数据
Future getString(key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var data = sharedPreferences.get(key);
  return data;
}

//删除存在SharedPreferences中的数据
Future removeString(key) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove(key);
  return false;
}

//用户信息接口
Future  getUserInfo() async{
  var url = '';
  var params = Map<String, dynamic>();
      params["userId"] = uid;
      params["token"] = token;

  var res = await http.post(url,body: params)
    .then((http.Response response){
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData['code']==0){
        return responseData['data'];
      }else{
        return responseData['msg'];
      }
  });

  return res;
}

//订单列表接口
Future  getLists(_type,_page,_pageNum) async{
  var url = '';
  var params = Map<String, dynamic>();
      params["userId"] = uid;
      params["token"] = token;
      params["type"] = _type.toString();
      params["page"] = _page.toString();
      params["page_num"] = _pageNum.toString();

  var res = await http.post(url,body: params)
    .then((http.Response response){
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData['code']==0){
        return {'is_end':responseData['is_end'],'list':responseData['list']};
      }else{
        return responseData['msg'];
      }
  });
  
  return res;
}

//订单详情接口
Future  getGoodsInfo(orderNo) async{
  var url = '';
  var params = Map<String, dynamic>();
      params["userId"] = uid;
      params["token"] = token;
      params["orderNo"] = orderNo;

  var res = await http.post(url,body: params)
    .then((http.Response response){
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData['code']==0){
        return responseData['data'];
      }else{
        return responseData['msg'];
      }
  });
  
  return res;
}

//订单详情接口
Future editRemarks(orderNo,_remarks) async{
  var url = '';
  var params = Map<String, dynamic>();
      params["userId"] = uid;
      params["token"] = token;
      params["orderNo"] = orderNo;
      params["remarks"] = _remarks;

  var res = await http.post(url,body: params)
    .then((http.Response response){
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData['code']==0){
         return responseData;
      }else{
        return responseData['msg'];
      }
  });
  return res;
}

//相片上传
Future postPhoto(image) async{
  String path = image.path;
  var name = path.substring(path.lastIndexOf("/") + 1, path.length);
  FormData formData = new FormData.from({
    "file": new UploadFileInfo(new File(path), name),
    "userId": uid,
    "token": token
  });
  return formData;
  // Response response;
  // Dio dio =new Dio();
  // response =await dio.post('后端接口',data: formData);
  // if(response.statusCode == 200){
  //   return response.data;
  // }else{
  //   throw Exception('后端接口异常');
  // }
}