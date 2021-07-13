import 'package:flutter/material.dart';
import 'package:travel_explorer/model/souvenir_list.dart';
import 'package:travel_explorer/widgets/txt.dart';

class CollectionRow extends StatelessWidget {
  //
  final RegionsData regionData;
  CollectionRow({this.regionData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt(text: regionData.title),
          Divider(),
        ],
      ),
    );
  }
}
