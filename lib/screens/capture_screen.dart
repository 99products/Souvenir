import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travel_explorer/model/souvenir_list.dart';

class ItemDetailScreen extends StatefulWidget {

  final ItemsData selectedItemData;

  ItemDetailScreen({Key key, @required this.selectedItemData}) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => ItemDetailState(objSelectedItemData: this.selectedItemData);
}

class ItemDetailState extends State<ItemDetailScreen> with TickerProviderStateMixin {

  ItemsData objSelectedItemData;

  ItemDetailState({this.objSelectedItemData});

  AnimationController _controller;
  Animation<double> _animation;

  double _angleArrow = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,

    )..repeat(reverse:true);
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn
    );

    Future.delayed(const Duration(milliseconds: 500), () {

      print("Delay Binding");
      setState(() {
        _angleArrow = 50;
      });

    });

    Future.delayed(const Duration(milliseconds: 1500), () {

      print("Delay Binding");
      setState(() {
        _angleArrow = 120;
      });

    });

    Future.delayed(const Duration(milliseconds: 2500), () {

      print("Delay Binding");
      setState(() {
        _angleArrow = 200;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explorer App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightGreen,
      ),
      home: Scaffold(
          body: Column(
            children: <Widget>[
          Container(
          color: Colors.white,
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network("https://static4.depositphotos.com/1000441/322/i/600/depositphotos_3226927-stock-photo-eiffel-tower-in-paris.jpg"),
                ],
              ),
            ),
          ),
              Expanded(
                  child:Container(
                    height: 200,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('${objSelectedItemData.distanceFromUserLocation}', style: TextStyle(fontSize: 100, color: Colors.lightBlue,fontWeight: FontWeight.bold)),
                                Text(' km', style: TextStyle(fontSize: 50,color: Colors.lightBlue,fontWeight: FontWeight.normal))
                              ]),
                  )),
              Container(
                height: 200,
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.all(25),
                color: Colors.white,
                child:_loadBottomActionWidget(),
              ),
            ],
          )),);
  }

  Widget _loadBottomActionWidget() {
    if(objSelectedItemData.distanceFromUserLocation>10)
      {
        return Text('You have to be there around 1 km radius from the destination', style: TextStyle(fontSize: 18,color: Colors.blueGrey,fontWeight: FontWeight.bold));
      }
    else {
      return MaterialButton(
        onPressed: () {},
        shape: const StadiumBorder(),
        minWidth: 200,
        height: 80,
        textColor: Colors.white,
        color: Colors.lightBlue,
        splashColor: Colors.blue[900],
        disabledColor: Colors.grey,
        disabledTextColor: Colors.white,
        child: Text('Capture'),
      );
    }
  }
}