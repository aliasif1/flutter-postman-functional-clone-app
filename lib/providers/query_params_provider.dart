import 'package:flutter/material.dart';

class QueryParamsProvider with ChangeNotifier{
  List<Map> _queryParams = [];

  List<Map> get queryParams{
    return [..._queryParams];
  }

  void setQueryParams(params){
    _queryParams = params;
    notifyListeners();
  }

}