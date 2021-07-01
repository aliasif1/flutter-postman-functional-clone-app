import 'package:flutter/material.dart';
import 'package:flutter_postman/providers/headers_provider.dart';
import 'package:flutter_postman/providers/query_params_provider.dart';
import 'package:provider/provider.dart';

class ParamsSection extends StatefulWidget {
  final title;
  ParamsSection({
    Key key,
    this.title
  }) : super(key: key);
  @override
  _ParamsSectionState createState() => _ParamsSectionState();
}

class _ParamsSectionState extends State<ParamsSection> {
  bool _isInit = true;
  List<Map> _data = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_isInit){
      switch(widget.title){
        case('Query Params'):
          _data = Provider.of<QueryParamsProvider>(context, listen: false).queryParams;
          break;
        case('Headers'):
          _data = Provider.of<HeadersProvider>(context, listen: false).headers;
          break;
      }
      _data.add({'key':'', 'value':'', 'id': DateTime.now().millisecondsSinceEpoch.toString()});
      _isInit = false;
    }
  }

  void _onParamChanged(index, type, text){
    setState(() {
      _data[index][type] = text;
    });
    _updateProvider();
  }

  void _updateProvider(){
    final data = _data.where((param) => param['key'] != '' && param['value'] != '').toList();
    switch(widget.title){
      case('Query Params'):
        Provider.of<QueryParamsProvider>(context, listen: false).setQueryParams(data);
        break;
      case('Headers'):
        Provider.of<HeadersProvider>(context, listen: false).setHeaders(data);
        break;
    }
  }

  void _addParam(){
    setState(() {
      _data.add({'key':'', 'value':'', 'id': DateTime.now().millisecondsSinceEpoch.toString()});
    });
  }

  void _deleteParam(index){
    setState(() {
      _data.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set ${widget.title}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8,),
            Column(
              children: _data.asMap().entries.map((entry){
                int index = entry.key;
                String key = entry.value['key'];
                String value = entry.value['value'];
                String id = entry.value['id'];
                bool valid = key != '' && value != '';
                return Row(
                  key: ValueKey(id),
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: key,
                        onChanged: (text) => _onParamChanged(index,'key', text),
                        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          hintText: 'Key',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey
                            )
                          )
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: value,
                        onChanged: (text) => _onParamChanged(index, 'value', text),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            hintText: 'Value',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey
                                )
                            )
                        ),
                      ),
                    ),
                    if(index == _data.length -1) IconButton(
                      onPressed: valid ? _addParam : null,
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: valid ? Colors.blue: Colors.grey,
                      ),
                    ),
                    if(index != _data.length -1) IconButton(
                      onPressed: () =>_deleteParam(index),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    )
                  ],
                );
              }).toList()
            ),
          ],
        ),
      ),
    );
  }
}
