import 'package:flutter/material.dart';
import 'package:travel_explorer/model/souvenir_list.dart';
import 'package:travel_explorer/widgets/txt.dart';

class ItemRow extends StatelessWidget {
  //
  final ItemsData itemsData;
  ItemRow({this.itemsData});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Hero(
            tag: Key("${itemsData.distanceFromUserLocation} https://q-cf.bstatic.com/images/hotel/max1024x768/209/209735787.jpg"),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),//EdgeInsets.all(32.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network("https://q-cf.bstatic.com/images/hotel/max1024x768/209/209735787.jpg"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40,20,40,20),// EdgeInsets.all(40.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.only(top: 100),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: Colors.blueGrey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                              child: Text(
                                'NOT CAPTURED',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${itemsData.distanceFromUserLocation}km',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text(
                      itemsData.title,
                      style: titleTextStyle,
                    ),
                    subtitle: Text(itemsData.shortDescription),
                    trailing: Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue, shape: BoxShape.circle),
                      child: Transform.rotate(
                        angle: 90 * 3.1416 / 180,
                        child: IconButton(
                          icon: Icon(Icons.arrow_upward_sharp),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final TextStyle titleTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
  );
}
