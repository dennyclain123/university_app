import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:university_searcher/ob/responseOb.dart';
import 'package:university_searcher/ob/uni_ob.dart';
import 'package:university_searcher/pages/home_bloc.dart';
import 'package:university_searcher/widgets/university_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _bloc = HomeBloc();
  var _countryTec = TextEditingController();
  RefreshController _refreshController = RefreshController();
    ResponseOb resOb = ResponseOb();
  @override
  void initState() {
    // TODO: implement initState
    // _bloc.getUniData(_countryTec.text);
    _bloc.getUniStream().listen((event) {
      if(resOb.msgState == MsgState.data){
        _refreshController.refreshCompleted();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("University Search"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _countryTec,
                      decoration: InputDecoration(
                        hintText: "Search Country",
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  FlatButton.icon(
                    label: Text("Search",style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),),
                    color: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)
                    ),
                    onPressed: (){
                      _bloc.getUniData(_countryTec.text);
                    },
                    icon: Icon(Icons.search,color: Colors.white,)
                  )
                ],
              ),
              SizedBox(height: 10,),
              Expanded(
                child: StreamBuilder<ResponseOb>(
                  stream: _bloc.getUniStream(),
                  builder: (BuildContext context, AsyncSnapshot<ResponseOb> snapshot) {
                    if (snapshot.hasData) {
                      ResponseOb resOb = snapshot.data;
                      if (resOb.msgState == MsgState.loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (resOb.msgState == MsgState.data) {
                        List<UniOb> uob = resOb.data;
                        return MainWidget(uob);
                      } else {
                        if (resOb.errState == ErrState.notFoundErr) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("404",style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold
                              ),),
                              Text("Page Not Found!",style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),)
                            ],
                          );
                        } else if (resOb.errState == ErrState.serverErr) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("500",style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold
                              ),),
                              Text("Internal Server Error!",style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),)
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Text("?",style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold
                              ),),
                              Text("Unknown Error, check your internet connection",style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),)
                            ],
                          );
                        }
                      }
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.indigo,
                            size: 50,
                          ),
                          Text(
                            "You can Search Universities Data",
                            style: TextStyle( fontSize: 16),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
  Widget MainWidget(List<UniOb> uob){
    return uob.length==0? Center(child: Text("Invaild Keyword"),)
        : SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      header: WaterDropMaterialHeader(color: Colors.white,backgroundColor: Colors.indigo,),
      onRefresh: (){
        _bloc.getUniData(_countryTec.text);
      },
      child: ListView.builder(
        itemCount: uob.length,
        itemBuilder: (context,index){
          return University(uob[index]);
        },
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.dispose();
    super.dispose();
  }
}
