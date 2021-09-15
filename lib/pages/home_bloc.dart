import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:university_searcher/ob/responseOb.dart';
import 'package:university_searcher/ob/uni_ob.dart';
import 'package:university_searcher/utils/app_constants.dart';



class HomeBloc{
  StreamController<ResponseOb> _controller = StreamController.broadcast();
  Stream<ResponseOb> getUniStream() => _controller.stream;
  getUniData(String countryName)async{
    ResponseOb resOb = ResponseOb(msgState: MsgState.loading);
    _controller.sink.add(resOb);
    var response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=$countryName'));
    // print(response.body);
    resOb.msgState = MsgState.data;
    _controller.sink.add(resOb);
    if(response.statusCode==200){
      List<UniOb> uList = [];
      List<dynamic> list = json.decode(response.body);
      list.forEach((data) {
        uList.add(UniOb.fromJson(data));
      });
      resOb.data = uList;
      _controller.sink.add(resOb);
    }
    else if(response.statusCode==404){
      resOb.msgState = MsgState.error;
      resOb.errState = ErrState.notFoundErr;
      _controller.sink.add(resOb);
    }
    else if(response.statusCode==500){
      resOb.msgState = MsgState.error;
      resOb.errState = ErrState.serverErr;
      _controller.sink.add(resOb);
    }else{
      resOb.msgState = MsgState.error;
      resOb.errState = ErrState.unknownErr;
      _controller.sink.add(resOb);
    }
  }

  dispose(){
    _controller.close();
  }
}

