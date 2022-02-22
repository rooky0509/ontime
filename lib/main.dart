import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ontime/providers/time.dart';
import 'package:ontime/widgets/time.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Providerr()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider'),
      ),
      body: Column(
        children: <Widget>[
          ChangeNotifierProvider(
        create: (BuildContext context) => Providerr(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Counter(),
              Counter(),
              Buttons(),
            ],
          ),
        ),
      ),
      ChangeNotifierProvider(
        create: (BuildContext context) => Providerr(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Counter(),
              Buttons(),
            ],
          ),
        ),
      ),
        ],
      )
    );
  }
}