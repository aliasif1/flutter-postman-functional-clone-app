import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService{
  static Future<Object> sendRequest(String type, String url, List<Map> queryParams, List<Map> headers, String body) async {
    var statusCode = null;
    var responseHeaders = null;
    var responseBody = null;
    bool hasError = false;
    var errorData = null;
    var responseTime = null;
    var headersSize = null;
    var bodySize = null;
    try{
      final _queryParams = HttpService.extractMapFromList(queryParams);
      final _headers = HttpService.extractMapFromList(headers);
      final _body = HttpService.extractMapFromString(body);
      String queryString = Uri(queryParameters: _queryParams).query;
      String requestUrl = url + '?' + queryString;
      var res;
      final startTime = DateTime.now();
      switch(type){
        case('get'):
          res = await http.get(Uri.parse(requestUrl), headers: _headers);
          break;
        case('post'):
          res = await http.post(Uri.parse(requestUrl), headers: _headers, body: _body);
          break;
        case('patch'):
          res = await http.patch(Uri.parse(requestUrl), headers: _headers, body: _body);
          break;
        case('put'):
          res = await http.put(Uri.parse(requestUrl), headers: _headers, body: _body);
          break;
        case('delete'):
          res = await http.delete(Uri.parse(requestUrl), headers: _headers);
          break;
      }
      final endTime = DateTime.now();
      responseTime = endTime.difference(startTime).inMilliseconds;
      statusCode = res.statusCode;
      responseHeaders = res.headers;
      headersSize = json.encode(responseHeaders).length;
      responseBody = json.decode(res.body);
      bodySize = json.encode(responseBody).length;
      if(statusCode >= 400){
        throw('Error: Bad Request');
      }
    }
    catch(err){
      hasError = true;
      errorData = err.toString();
    }
    finally{
      return {
        "statusCode" : statusCode,
        "headers": responseHeaders,
        "body": responseBody,
        "hasError": hasError,
        "error": errorData,
        "responseTime": responseTime,
        "headersSize": headersSize,
        "bodySize": bodySize,
      };
    }

  }

  static Map<String, String> extractMapFromList(List<Map> data){
    Map<String, String> map = {};
    data.forEach((element){
      map[element['key']] = element['value'];
    });
    return map;
  }

  static Map extractMapFromString(String data){
    if(data == '' || data == null){
      return {};
    }
    return json.decode(data);
  }
}