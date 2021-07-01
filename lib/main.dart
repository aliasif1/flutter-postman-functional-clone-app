import 'package:flutter/material.dart';
import 'package:flutter_postman/providers/body_provider.dart';
import 'package:flutter_postman/providers/headers_provider.dart';
import 'package:flutter_postman/providers/query_params_provider.dart';
import 'package:flutter_postman/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.green,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => QueryParamsProvider()),
          ChangeNotifierProvider(create: (_) => HeadersProvider()),
          ChangeNotifierProvider(create: (_) => BodyProvider()),
        ],
        child:MainScreen(),
      ),
    );
  }
}
