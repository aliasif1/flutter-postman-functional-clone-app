import 'package:flutter/material.dart';

class BodyProvider with ChangeNotifier{
  String _body = '';

  String get body{
    return _body;
  }

  void setBody(data){
    _body = data;
    notifyListeners();
  }

}