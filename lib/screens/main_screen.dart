import 'package:flutter/material.dart';
import 'package:flutter_postman/components/params_section.dart';
import 'package:flutter_postman/components/response_alert_dialog.dart';
import 'package:flutter_postman/components/text_section.dart';
import 'package:flutter_postman/providers/body_provider.dart';
import 'package:flutter_postman/providers/headers_provider.dart';
import 'package:flutter_postman/providers/query_params_provider.dart';
import 'package:flutter_postman/services/http_service.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const List<String> REQUESTS = ['get', 'post', 'put', 'patch', 'delete'];
  static const List<Map> REQUESTS_TAB = [
    {"id":0, "label": "Query Params"},
    {"id":1, "label": "Headers"},
    {"id":2, "label": "Body"},
  ];
  bool _showRequest;
  String _url;
  String _request;
  int _requestIndex;

  @override
  void initState() {
    super.initState();
    _showRequest = true;
    _requestIndex = 0;
    _url = '';
    _request = 'get';
  }

  Widget _getRequestSection(){
    switch(_requestIndex){
      case 0:
        return ParamsSection(title: REQUESTS_TAB[0]['label'], key: ValueKey(REQUESTS_TAB[0]['label']),);
      case 1:
        return ParamsSection(title: REQUESTS_TAB[1]['label'], key: ValueKey(REQUESTS_TAB[1]['label']),);
      case 2:
        return TextSection(title: REQUESTS_TAB[2]['label'],);
    }
  }

  void _onUrlChanged(text){
    setState(() {
      _url = text;
    });
  }

  bool checkUrlValidity(){
    bool _valid = isURL(_url);
    return _valid;
  }

  Future<void> _sendRequest() async{
    if(!checkUrlValidity()){
      return;
    }
    //    get all the data
    final List<Map> queryParamsList = Provider.of<QueryParamsProvider>(context, listen: false).queryParams;
    final List<Map> headersList = Provider.of<HeadersProvider>(context, listen: false).headers;
    final String bodyString = Provider.of<BodyProvider>(context, listen: false).body;

    final response = await HttpService.sendRequest(_request, _url, queryParamsList, headersList, bodyString);

    showDialog(context: context, builder: (BuildContext context){
      return ResponseAlertDialog(data: response,);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Postman'
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _request,
              icon: const Icon(Icons.arrow_drop_down),
              style: TextStyle(color: Theme.of(context).primaryColor),
              underline: Container(
                height: 2,
                color: Theme.of(context).primaryColor,
              ),
              onChanged: (value){
                setState(() {
                  _request = value;
                });
              },
              items: REQUESTS.map((request) => DropdownMenuItem(
                value: request,
                child: Text(
                  request.toUpperCase(),
                ),
              )
              ).toList(),
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: _onUrlChanged,
                    decoration: InputDecoration(
                        hintText: 'https://www.example.com'
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                FlatButton(
                  onPressed: _sendRequest,
                  color: checkUrlValidity() ? Colors.blue: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                      'Go',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: REQUESTS_TAB.map((tab){
                  return Expanded(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          _requestIndex = tab['id'];
                        });
                      },
                      highlightColor: Colors.grey,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        color: tab['id'] == _requestIndex ? Colors.blue[100] : Colors.white,
                        child: Text(
                          tab['label'],
                          style: TextStyle(
                            fontWeight: tab['id'] == _requestIndex ? FontWeight.bold: FontWeight.normal,
                            decoration: tab['id'] == _requestIndex ? TextDecoration.underline: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: _getRequestSection(),
            )
          ],
        ),
      ),
    );
  }
}


