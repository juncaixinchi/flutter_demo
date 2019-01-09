import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wifi/wifi.dart';
import 'package:connectivity/connectivity.dart';

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

    // var result = await Wifi.connection('ssid', 'password');
    // print(result);
    // only work on Android.
    List ssidList = await Wifi.list('Wisnuc'); // this key is used to filter
    print('ssidList: $ssidList');
    return ssidList;
  }

  Future getWifiName() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    }
    var name = await (new Connectivity().getWifiName());
    return name;
  }

  var _wifiName = 'Press To Get Wifi Name';

  void _incrementCounter() {
    getWifiName().then((name) {
      print('get wifi name: $name');
      setState(() {
      _wifiName = name;
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
              'Wifi Name:',
            ),
            new Text(
              '$_wifiName',
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