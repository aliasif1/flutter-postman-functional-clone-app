import 'package:flutter/material.dart';
import 'package:pretty_json/pretty_json.dart';

class ResponseAlertDialog extends StatefulWidget {
  final data;

  const ResponseAlertDialog({
    Key key,
    this.data
  }) : super(key: key);

  @override
  _ResponseAlertDialogState createState() => _ResponseAlertDialogState();
}

class _ResponseAlertDialogState extends State<ResponseAlertDialog> {

  String getSize(){
    final headerSize = widget.data['headersSize'] ?? 0;
    final bodySize = widget.data['bodySize'] ?? 0;
    var size = (headerSize.toDouble() + bodySize.toDouble())/1000;
    if(size == 0) return '-';
    final bytes = size.toStringAsFixed(2) + ' KB';
    return bytes;
  }

  Widget getObjectData(title, objData){
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            prettyJson(objData, indent: 4),
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        )
      ],
    );
  }

  Widget getTextData(title, text){
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            text,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Response Report'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: StatusSection(label: 'Status',value: widget.data['statusCode'] != null ? widget.data['statusCode'].toString() : '-'),
                  ),
                  VerticalDivider(thickness: 2,),
                  Expanded(
                    child: StatusSection(label: 'Time',value: widget.data['responseTime'] != null ? widget.data['responseTime'].toString() + ' ms' : '-'),
                  ),
                  VerticalDivider(thickness: 2,),
                  Expanded(
                    child: StatusSection(label: 'Size',value: getSize(),),
                  ),
                ],
              ),
            ),
            if(widget.data['body'] != null) getObjectData('Body', widget.data['body']),
            if(widget.data['headers'] != null) getObjectData('Headers', widget.data['headers']),
            if(widget.data['hasError'] == true) getTextData('Error', widget.data['error']),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class StatusSection extends StatelessWidget {
  final String label;
  final String value;

  StatusSection({
    Key key,
    this.label,
    this.value
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.blue
            ),
          ),
        ),
        SizedBox(height: 5,),
        FittedBox(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14
            ),
          ),
        )
      ],
    );
  }
}

