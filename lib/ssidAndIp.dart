import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wifi/wifi.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  Future getWifi() async {
    String ssid = await Wifi.ssid;
    print('ssid: $ssid');

    String ip = await Wifi.ip;
    print('ip: $ip');
    var res = { 'ip': ip, 'ssid': ssid };
    return res;
  }

  var _ssid = '';
  var _ip = '';

  void _incrementCounter() {
    setState(() {
      _ip = '--';
      _ssid = '--';
    });
    getWifi().then((res) {
      print('get wifi finished');
      setState(() {
        _ip = res['ip'];
        _ssid = res['ssid'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Press Button to Get Wifi Info',
            ),
            new Text(
              '$_ssid',
              style: Theme.of(context).textTheme.display1,
            ),
            new Text(
              '$_ip',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}