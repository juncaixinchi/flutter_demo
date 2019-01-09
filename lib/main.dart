import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'photos.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

void main() => runApp(MaterialApp(
      home: new MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var pathList = <AssetPathEntity>[];
  ScrollController myScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Plugin example app'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_applications),
            onPressed: _openSetting,
          ),
        ],
      ),
      // body: new ListView.builder(
      //   itemBuilder: _buildItem,
      //   itemCount: pathList.length,
      // ),
      body: DraggableScrollbar.semicircle(
        controller: myScrollController,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          controller: myScrollController,
          padding: EdgeInsets.zero,
          itemBuilder: _buildItem,
          itemCount: pathList.length,
          // itemCount: 1000,
          // itemBuilder: (context, index) {
          //   return Container(
          //     alignment: Alignment.center,
          //     margin: EdgeInsets.all(2.0),
          //     color: Colors.grey[300],
          //   );
          // },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () async {
          var result = await PhotoManager.requestPermission();
          if (!(result == true)) {
            print("未授予权限");
            return;
          }

          print("wait scan");
          List<AssetPathEntity> list =
              await PhotoManager.getAssetPathList(hasVideo: true);

          pathList.clear();
          pathList.addAll(list);
          setState(() {});

          // var r = await ImagePicker.pickImages(source: ImageSource.gallery, numberOfItems: 10);
          // print(r);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    var data = pathList[index];
    return _buildWithData(data);
  }

  Widget _buildWithData(AssetPathEntity data) {
    return GestureDetector(
      child: ListTile(
        title: Text(data.name),
      ),
      onTap: () async {
        var list = await data.assetList;
        print("开启的相册为:${data.name} , 数量为 : ${list.length}");
        List<AssetEntity> virtualList = List.from(list);
        for (var i = 0; i < 10; i++) {
          virtualList.addAll(list);
        }
        var page = PhotoPage(
          pathEntity: data,
          photos: virtualList,
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => page));
      },
    );
  }

  // This is an example of how to build album preview.
  Widget _buildHasPreviewItem(BuildContext context, int index) {
    var data = pathList[index];
    Widget widget = FutureBuilder<List<AssetEntity>>(
      future: data.assetList,
      builder:
          (BuildContext context, AsyncSnapshot<List<AssetEntity>> snapshot) {
        var assetList = snapshot.data;
        if (assetList == null || assetList.isEmpty) {
          return Container(
            child: Text('$index'),
          );
        }
        AssetEntity asset = assetList[0];
        return _buildPreview(asset);
      },
    );
    return widget;
  }

  Widget _buildPreview(AssetEntity asset) {
    return FutureBuilder<Uint8List>(
      future: asset.thumbDataWithSize(200, 200),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.data != null) {
          return Image.memory(snapshot.data);
        }
        return Container();
      },
    );
  }

  void _openSetting() {
    PhotoManager.openSetting();
  }
}

class SemicircleDemo extends StatelessWidget {
  static int numItems = 1000;

  final ScrollController controller;

  const SemicircleDemo({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollbar.semicircle(
      labelTextBuilder: (offset) {
        final int currentItem = controller.hasClients
            ? (controller.offset /
                    controller.position.maxScrollExtent *
                    numItems)
                .floor()
            : 0;

        return Text("$currentItem");
      },
      labelConstraints: BoxConstraints.tightFor(width: 80.0, height: 30.0),
      controller: controller,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        controller: controller,
        padding: EdgeInsets.zero,
        itemCount: numItems,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(2.0),
            color: Colors.grey[300],
          );
        },
      ),
    );
  }
}
