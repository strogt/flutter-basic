import 'package:flutter/material.dart';
import 'package:flutter_app/GoodsInfo.dart';
import 'package:flutter_app/common.dart';

class GoodsLists extends StatefulWidget {
  @override
  _GoodsListsState createState() => new _GoodsListsState();
}

class _GoodsListsState extends  State<GoodsLists>{
  //页面参数                                          
  ScrollController _scrollController = ScrollController(); //listview的控制器
  // bool _allCur =true;                                      //全部
  bool _cur = false;                                       //已服务
  bool _unCur = true;                                      //未服务 
  bool isLoading = true;                                   //是否正在加载数据
  String _keyWord;                                         //搜索关键字
  int _type = 1;                                           //服务类型  1：待服务 2：已服务
  int _page = 1;                                           //页数 
  int _pageNum = 20;                                       //每页数量
  bool _isEnd =false;                                      //是否结束
  List list;                                               //视图数据
  var _userData;                                           //用户信息

  // 页面初始化
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==_scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
    //获取用户信息
    getUserInfo().then((res){
      setState(() {
        _userData =res;
      });
    });
    
    //数据获取
    getLists(_type,_page,_pageNum).then(
      (res){ 
        setState(() {
          _isEnd = res['is_end'];
          _isEnd ? isLoading =false : isLoading =true; 
          list = res['list'];
        });
      },
    );
  }                      

  //页面方法
  //全部
  // void _allCurTabDate(){
  //   print("全部");
  // }

  //待服务
  void _unCurTabDate(){
    print("待服务");
    _type = 1;
    _page = 1;
    getLists(_type,_page,_pageNum).then(
      (res){ 
        setState(() {
          _unCur = true;
          _cur = false;
          _isEnd = res['is_end']; 
          _isEnd ? isLoading =false : isLoading =true; 
          list =res['list'];
        });
      }
    );
  }

  //已服务
  void _curTabDate(){
    print("已服务");
    _type = 2;
    _page = 1;
    getLists(_type,_page,_pageNum).then(
      (res){ 
        setState(() {
          _unCur = false;
          _cur = true;
          _isEnd = res['is_end']; 
          _isEnd ? isLoading =false : isLoading =true; 
          list =res['list'];
        });
      }
    );
  }

  //返回顶部
  // void backTop(){
  //   _scrollController.animateTo(
  //     0.0,
  //     duration: new Duration(milliseconds: 300),
  //     curve: Curves.bounceIn
  //   );
  // }

  //下拉刷新
  Future<Null> _onRefresh () async{
    await Future.delayed(Duration(seconds: 1),(){
      _page = 1;
      getLists(_type,_page,_pageNum).then(
        (res){ 
          setState(() {
            _isEnd = res['is_end']; 
            _isEnd ? isLoading =false : isLoading =true; 
            list =res['list'];
          });
        }
      );
    });
  }

  // 上拉加载
  Future _getMore() async {
    if ( isLoading) {
      await Future.delayed(Duration(seconds: 1), () {
        getLists(_type,_page,_pageNum).then(
          (res){ 
            setState(() {
              _page += 1;
              _isEnd = res['is_end'];
              for(var item in res['list']){
                list.add(item);
              }
              _isEnd ? isLoading =false : isLoading =true; 
            });
          }
        );
      });
    }
  }

  //页面widget
  //搜索Widget
  Widget searchWidget(){
    return Theme(
      data: new ThemeData(primaryColor: Color.fromARGB(100, 255, 255, 255),),
      child: new Center(
        child: new Stack(
          children: <Widget>[
            new TextField(
              onChanged: (value){
                _keyWord = value;
                print(_keyWord);
              },
              //光标颜色
              cursorColor: Color.fromARGB(255, 239, 96, 62),
              // 默认设置
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                fillColor: Color.fromARGB(100, 255, 255, 255),
                filled: true,
                border: InputBorder.none,
                prefixIcon: new Icon(Icons.search,color: Color.fromARGB(255, 255, 255, 255),),
                hintText: "请输入订单号搜索",
                hintStyle: new TextStyle(
                  fontSize: 16.0, 
                  color: Colors.white,
                )
              ),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            new Positioned(
              right: 0.0,
              bottom: 2.0,
              child: new MaterialButton(
                textColor: Colors.white,
                child: new Text("搜索",style: TextStyle(fontSize: 16.0),),
                onPressed: (){print("搜索");},
              ),
            )
          ],
        ),
      ),
    );
  }

  //师傅widget
  Widget shifuWidget(){
    return new Center(
      child: new Stack(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new CircleAvatar(
                radius: 40.0,
                backgroundColor: ThemeColor,
                backgroundImage: new NetworkImage('https://img.hejiaju.com/mobile/themes/default/images/goods/user-photo.png'),
              ),
              new Container(
                margin: EdgeInsets.only(left: 18.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(_userData != null ? _userData['name'] :'',style: TextStyle(color: Colors.white),),
                    new Text(_userData != null ? "电话："+_userData['phone'] :'',style: TextStyle(color: Colors.white),),
                  ],
                ),
              )
            ],
          ),
          new Positioned(
            right: 0.0,
            top: 25.0,
            child: new MaterialButton(
                color:Color.fromARGB(255, 255, 255, 255),
                child: new Text("联系客服",style: TextStyle(fontSize: 16.0),),
                onPressed: (){print("联系客服");},
              ),
          )
        ],
      ),
    );
  }

  //订单widget
  Widget listWidget(){
    List<Widget> contentList = [];
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    if(list != null){
      for (var item in list){
        //商品列表处理
        List _goodslist = item['goods_list'];
        Widget _goodsListWidget(){
          List<Widget> goodsList = [];
          Widget goodscontent;
          for(var goodsItem in _goodslist){
            goodsList.add(
              new Text(goodsItem['goodsName'],style: TextStyle(fontSize: ContentSize),)
            );
          }
          goodscontent = new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: goodsList,
          );
          return goodscontent;
        }

        //数据循环
        contentList.add(
          new Container(
            margin: EdgeInsets.only(top: TopDistance),
              child: new Card(
                child: new ListTile(
                  onTap: (){
                    getGoodsInfo(item['orderNo']).then((res){
                      Navigator.push(context,new MaterialPageRoute(
                        builder: (context)=> new GoodsInfo(infoData: res)
                      ));
                    });
                  },
                  title:  new Column(
                  children: <Widget>[
                  //订单头部
                  new Row(
                    children: <Widget>[
                      new Icon(Icons.build,size: TitleSize,),
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: new Text("配装订单:"+item['orderNo'],style: TextStyle(fontSize: TitleSize,color: ThemeColor),),
                        ),
                      ),
                      new Text(_type == 1?'待服务':'已服务',style: TextStyle(fontSize: TitleSize),),
                    ],
                  ),
                  new Divider(),
                  new Container(
                    width:  400.0,
                    margin: EdgeInsets.fromLTRB(38.0, 10.0, 0.0, 10.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          
                          new Container(
                            child:Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text("商品：",style: TextStyle(fontSize: ContentSize),),
                                _goodsListWidget()
                              ],
                            ),
                          ),
                          new Text("收货人："+item['toCustomerName'],style: TextStyle(fontSize: ContentSize),),
                          new Text("联系号码："+item['toCustomerPhone'],style: TextStyle(fontSize: ContentSize),),
                          new Text("收货地址："+item['toCustomerAddr'],style: TextStyle(fontSize: ContentSize),),
                          new Text("预约时间："+item['bookingDate'],style: TextStyle(fontSize: ContentSize),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
      //必须生成一个widget返回出去，直接把生成的tiles放在<Widget>[]中是会报一个类型不匹配的错误，把<Widget>[]删了就可以了
      content = new Column(
        children: contentList, 
      );
      return content;
    }else{
      return new Container();
    }
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar:new PreferredSize(
        child: new AppBar(
          title: new Text("商品列表"),
          // bottom: ,
        ),
        preferredSize: Size.fromHeight(0.0),
      ), 
      
      body: new Column(
        children: <Widget>[
          //搜索框+师傅信息
          new Container(
            color: ThemeColor,
            child:new Container(
              margin: const EdgeInsets.all(10.0),
              child: new Column(
                children: <Widget>[
                  searchWidget(),
                  new Container(
                    margin: EdgeInsets.only(top: 18.0),
                    child: shifuWidget(),
                  )
                ],
              ),
            ),
          ),

          //菜单栏
          new Container(
            height: 40.0,
            decoration: new BoxDecoration(
              color: Colors.white70,
              border: Border(bottom: BorderSide(width: 0.5,color: Colors.black)),
            ),
            child: new Row(
              children: <Widget>[
                // new  Expanded(
                //   child:new MaterialButton(
                //     child: new Text("全部",style: TextStyle(fontSize:TitleSize,color: _allCur?ThemeColor:UnCurColor),),
                //     onPressed: _allCurTabDate,
                //   ),
                // ),
                new  Expanded(
                  child:new MaterialButton(
                    child: new Text("待服务",style: TextStyle(fontSize:TitleSize,color: _unCur?ThemeColor:UnCurColor),),
                    onPressed: _unCurTabDate,
                  ),
                ),
                new  Expanded(
                  child:new MaterialButton(
                    child: new Text("已服务",style: TextStyle(fontSize:TitleSize,color: _cur?ThemeColor:UnCurColor),),
                    onPressed: _curTabDate,
                  ),
                ),
              ],
            ),
          ),
          

          //订单视图
          new Expanded(
            child: new RefreshIndicator(
              onRefresh: _onRefresh,
              child: new ListView(
                controller: _scrollController,
                children: <Widget>[
                  listWidget(),
                  new Offstage(
                    offstage: _isEnd,
                    child: new Center(
                     child: new Text("上拉加载",style: TextStyle(fontSize: ContentSize),),
                    ),
                  ),
                  new Offstage(
                    offstage: !_isEnd,
                    child: new Center(
                     child: new Text("暂无更多数据",style: TextStyle(fontSize: ContentSize),),
                    ),
                  ),
                ],
              ),
            ) 
            
          ),

        ],
      ),
    );
  }
}