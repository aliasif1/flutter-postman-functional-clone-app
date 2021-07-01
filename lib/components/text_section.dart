import 'package:flutter/material.dart';
import 'package:flutter_postman/providers/body_provider.dart';
import 'package:provider/provider.dart';

class TextSection extends StatefulWidget {
  final title;
  TextSection({
    Key key,
    this.title
  }) : super(key: key);
  @override
  _TextSectionState createState() => _TextSectionState();
}

class _TextSectionState extends State<TextSection> {
  bool _isInit = true;
  String _data = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_isInit){
      _data = Provider.of<BodyProvider>(context, listen: false).body;
      _isInit = false;
    }
  }

  void _onTextChanged(text){
    setState(() {
      _data = text;
    });
    _updateProvider();
  }

  void _updateProvider(){
    Provider.of<BodyProvider>(context, listen: false).setBody(_data);
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
            TextFormField(
              initialValue: _data,
              onChanged: _onTextChanged,
              keyboardType: TextInputType.multiline,
              minLines: 20,
              maxLines: 20,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Json String......',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey
                  )
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
