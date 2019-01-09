import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class PhotoList extends StatefulWidget {
  final List<AssetEntity> photos;

  PhotoList({this.photos});

  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  ScrollController myScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    // return GridView.builder(
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 3,
    //     childAspectRatio: 1.0,
    //   ),
    //   itemBuilder: _buildItem,
    //   itemCount: widget.photos.length,
    // );
    return DraggableScrollbar.semicircle(
      controller: myScrollController,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        controller: myScrollController,
        padding: EdgeInsets.zero,
        // itemBuilder: _buildItem,
        itemCount: widget.photos.length,
        // itemCount: 1000,
        itemBuilder: (context, index) {
          if (index > 16000) return _buildItem(context, index);
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(2.0),
            color: Colors.grey[300],
            child: Center(
              child: Text(index.toString()),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    AssetEntity entity = widget.photos[index];
    // print("request index = $index , image id = ${entity.id} type = ${entity.type}");

    Future<Uint8List> thumbDataWithSize =
        entity.thumbDataWithSize(200, 200); // get thumb with width and height.
    Future<Uint8List> thumbData =
        entity.thumbData; // the method will get thumbData is size 64*64.
    Future<Uint8List> imageFullData = entity.fullData; // get the origin data.
    Future<File> file = entity.file; // get file
    Future<Duration> length = entity.videoDuration;
    length.then((v) {
      print("duration = $v");
    });

    return FutureBuilder<Uint8List>(
      future: thumbDataWithSize,
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return InkWell(
            onTap: () => showInfo(entity),
            child: Stack(
              children: <Widget>[
                Image.memory(
                  snapshot.data,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                IgnorePointer(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '${entity.type}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: Text('$index'),
        );
      },
    );
  }

  showInfo(AssetEntity entity) async {
    if (entity.type == AssetType.video) {
      var file = await entity.file;
      var length = file.lengthSync();
      print("${entity.id} length = $length");
    }
  }
}
