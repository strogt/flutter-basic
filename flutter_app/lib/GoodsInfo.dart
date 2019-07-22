import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/common.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class GoodsInfo extends StatefulWidget {
  // 用来储存GoodsLists传递过来的值
  var infoData;   
  GoodsInfo({Key key, @required this.infoData}) : super(key: key);
  
  @override
  _GoodsInfoState createState() => new _GoodsInfoState(infoData: infoData);
}

class _GoodsInfoState extends State<GoodsInfo> {
  // 用来储存GoodsInfo传递过来的值
  var infoData; 
  _GoodsInfoState({Key key, @required this.infoData});

  //页面数据
  String  orderNo;                                        //订单编号
  String _remarks = ' ';                                  //编辑内容
  bool _isEdit;                                           //编辑提示显示 
  bool _isTextChange;                                     //编辑内容是否改变
  String _serviceText;                                    //待服务或者已服务
  List<Widget> _infoImages = [];                          //添加图片List必须加[]
  List<Asset> orderImages = List<Asset>();
  String _error;


  //页面函数
  //初始化
  void initState(){
    super.initState();
    orderNo = infoData['orderNo'];
    _remarks = infoData['remarks'];
    infoData['orderState'] == null? _serviceText ='待服务' :  _serviceText =infoData['orderState'];
    if(infoData['img_list']!= null){
      for(var item in infoData['img_list']){
        _infoImages.add(
          new Image.network('https:'+item,width: 120.0,height: 160.0,fit: BoxFit.cover,)
        );
      }
    }
  
    if(_serviceText == '待服务'){
      _isEdit =  false;
      _isTextChange = true;
    }else if(_serviceText == '已服务'){
      _isEdit = true;
      _isTextChange = false;
    }
  }

  //多图片选择器
  Widget imgListView() {
    List<Widget> contentList = [];
    Widget content;
    //订单图片
    for (var item in _infoImages) {
      contentList.add(item);
    }
    // 选择的图片
    for (var item in orderImages) {
      Asset asset = item;
      var asssetWidget = AssetThumb(
        asset: asset,
        width: 120,
        height: 160,
      );
      contentList.add(asssetWidget);
    }
    contentList.add(new GestureDetector(onTap:loadAssets,child: new Image.asset('images/add_img.png',fit: BoxFit.none,width: 120.0,height: 160.0,),));
    content = new Wrap(
      spacing: 2.0,
      runSpacing: 2.0,
      children: contentList, 
    );
    return content;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: false,
      );
      
    } on PlatformException catch (e) {
      error = e.message;
    }

    if (!mounted) return;

    setState(() {
      for(var item in resultList){
        orderImages.add(item);
      }
      if (error == null) _error = 'No Error Dectected';
    });
  }

  Widget goodsInfoWidget(){
    List<Widget> contentList = [];
    Widget content;
    for (var item in infoData['goods_list']) {
      if(item['goodsName']!=null && item['goodsVolume']!=null && item['goodsAmount'] !=null ){
        contentList.add(
          new Text(item['goodsName']+' （'+item['goodsVolume']+'㎡/'+item['goodsAmount']+'件）')
        );
      }else if(item['goodsName']!=null && item['goodsVolume']!=null){
        contentList.add(
          new Text(item['goodsName']+' （'+item['goodsVolume']+'㎡/'+'）')
        );
      }else if(item['goodsName']!=null){
        contentList.add(
          new Text(item['goodsName'])
        );
      }else{
        contentList.add(
          new Text('')
        );
      }
    }
    content = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentList,
    );
    return content;
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:new PreferredSize(
        child: new AppBar(
          centerTitle: true,
          title: new Text("订单详情",style: TextStyle(color: Colors.black,fontSize: 16.0,),),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        preferredSize: Size.fromHeight(45.0),
      ), 
      
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new ListView(
              children: <Widget>[
                //订单状态
                new Container(
                  color: ThemeColor,
                  padding: EdgeInsets.fromLTRB(10.0,14.0, 10.0, 14.0),
                  child: new Row(
                    children: <Widget>[
                      new Icon(Icons.query_builder,color: Colors.white,),
                      new Container(child: new Text(_serviceText,style: TextStyle(color: Colors.white,fontSize: TitleSize),),margin: EdgeInsets.only(left: 10.0))
                    ],
                  ),
                ),

                //基本信息
                new Container(
                  child:new Card(
                    child:new Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 18.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(infoData['orderNo'] !=null ? "订单编号："+ infoData['orderNo']:'订单编号：'),
                          new Text(infoData['bookingDate'] !=null ? "预约时间："+ infoData['bookingDate']:'预约时间：'),
                        ],
                      ),
                    ) 
                  ) 
                ),

                //订单信息
                new Container(
                  margin: EdgeInsets.only(top: TopDistance),
                  child:new Card(
                    child:new Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 18.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Icon(Icons.calendar_view_day,),
                              new Container(child: new Text("订单信息",style: TextStyle(fontSize: TitleSize,),),margin: EdgeInsets.only(left: 10.0))
                            ],
                          ),
                          new Divider(),
                          new Text(infoData['toCustomerName'] !=null ? "收货人："+ infoData['toCustomerName']:'收货人：'),
                          new Text(infoData['toCustomerPhone'] !=null ? "联系电话："+ infoData['toCustomerPhone']:'联系电话：'),
                          new Text(infoData['toCustomerAddr'] !=null ? "收货地址："+ infoData['toCustomerAddr']:'收货地址：'),
                          new Text(infoData['remarks'] !=null ? "收货信息备注："+ infoData['remarks']:'收货信息备注：'),
                        ],
                      ),
                    ) 
                  ) 
                ),

                //商品信息
                new Container(
                  margin: EdgeInsets.only(top: TopDistance),
                  child:new Card(
                    child:new Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 18.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Icon(Icons.list,),
                              new Container(child: new Text("商品信息",style: TextStyle(fontSize: TitleSize,),),margin: EdgeInsets.only(left: 10.0))
                            ],
                          ),
                          new Divider(),
                          goodsInfoWidget(),
                        ],
                      ),
                    ) 
                  ) 
                ),
                
                //备注
                new Container(
                  margin: EdgeInsets.only(top: TopDistance),
                  child:new Card(
                    child:new Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 18.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            child: new Stack(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Icon(Icons.comment,),
                                    new Container(child: new Text("备注",style: TextStyle(fontSize: TitleSize,),),margin: EdgeInsets.only(left: 10.0))
                                  ],
                                ), 
                                new Positioned(
                                  right: 0,
                                  child: Offstage(
                                    offstage: _isEdit,
                                    //GestureDetector点击功能组件
                                    child: new GestureDetector(
                                      child: new Text('点击下方空白区域编辑',style: TextStyle(color: Colors.blue),),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          new Divider(),
                          new TextField(
                            maxLines: 3,  //高度显示多少行
                            controller: TextEditingController.fromValue(TextEditingValue(
                                // 设置内容
                                text: _remarks !=null?_remarks:'',
                                // 保持光标在最后
                                selection: TextSelection.fromPosition(TextPosition(
                                  // affinity: TextAffinity.downstream,
                                  offset:_remarks !=null?_remarks.length:0,
                                  )
                                )
                              )
                            ),
                            onChanged: (value){
                              if(value.length<0){
                                _remarks = ' ';
                              }else{
                                _remarks =value;
                              }
                            },
                            //光标颜色
                            cursorColor: Color.fromARGB(255, 239, 96, 62),
                            // 默认设置
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: '异常反馈：提货，原因：提货时商品破损（2019-06-06）',
                              hintStyle: new TextStyle(
                                fontSize: 14.0, 
                                color: UnCurColor,
                              )
                            ),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 51, 51, 51),
                            ),
                            //是否禁用
                            enabled: _isTextChange,
                          ),
                        ],
                      ),
                    ) 
                  ) 
                ),

                
                //签收单信息
                new Container(
                  margin: EdgeInsets.only(top: TopDistance),
                  child:new Card(
                    child:new Container(
                      margin: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 18.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Icon(Icons.collections,),
                              new Container(child: new Text("签收单信息",style: TextStyle(fontSize: TitleSize,),),margin: EdgeInsets.only(left: 10.0))
                            ],
                          ),
                          new Divider(),
                          imgListView(),
                        ],
                      ),
                    ) 
                  ) 
                ),

                //保存
                new Container(
                  margin: EdgeInsets.only(top: 18.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child:  new MaterialButton(
                          padding: EdgeInsets.all(10.0),
                          color:ThemeColor,
                          child: new Text("保存",style: TextStyle(fontSize: 18.0,color: Colors.white),),
                          onPressed: (){
                            //相片处理
                            addImage(orderNo,orderImages).then((res){
                              print(res);
                              postPhoto(orderNo,res).then((res){
                                print(res);
                              });
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )

              ],
            ),
          ),
          
        ],
      )
    );
  }
}