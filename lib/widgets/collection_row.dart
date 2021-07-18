import 'package:flutter/material.dart';
import 'package:travel_explorer/model/souvenir_list.dart';
import 'package:travel_explorer/widgets/txt.dart';

class CollectionRow extends StatelessWidget {

  final RegionsData regionData;
  CollectionRow({this.regionData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(regionData.title,style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 28)),
                Text(regionData.shortDescription,style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.normal,
                    fontSize: 14))
              ]),
          Icon(Icons.compare_arrows_sharp,color: Colors.orangeAccent, size: 40.0),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('${regionData.items.length}',style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.normal,
                    fontSize: 26)),
                Icon(Icons.collections_bookmark_sharp,color: Colors.blueGrey, size: 22.0),

              ]),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('${regionData.items.length}k',style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.normal,
                    fontSize: 26)),
                Icon(Icons.favorite_sharp,color: Colors.blueGrey, size: 22.0),

              ]),

        ],
      ),
    );
  }
}
