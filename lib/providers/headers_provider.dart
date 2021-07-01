import 'package:flutter/material.dart';

class HeadersProvider with ChangeNotifier{
  List<Map> _headers = [];

  List<Map> get headers{
    return [..._headers];
  }

  void setHeaders(params){
    _headers = params;
    notifyListeners();
  }

}