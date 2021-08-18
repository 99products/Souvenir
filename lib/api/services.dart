
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:travel_explorer/common/app_data.dart';
import 'package:travel_explorer/model/souvenir_list.dart';

abstract class SouvenirCollectionRepo {
  Future<List<RegionsData>> getFirebaseRegionsValues();
  Future<List<ItemsData>> getFirebaseItemValues(String strID,LocationData locData);
}

class DashboardServices implements SouvenirCollectionRepo {

  @override
  Future<List<RegionsData>> getFirebaseRegionsValues() async {
    await Firebase.initializeApp();
    List<RegionsData> arrayRegions=[];

    LocationData locData;
    await getLocationData().then((locationData){
      locData = locationData;
    });

    await FirebaseFirestore.instance.collection("collection_regions").get().then((querySnapshot) {
      querySnapshot.docs.forEach((resultRegions) async {
        print(resultRegions);
        RegionsData dataRegions = new RegionsData();
        dataRegions.id = resultRegions.data()['ID'];
        dataRegions.title = resultRegions.data()['Title'];
        dataRegions.description = resultRegions.data()['Description'];
        dataRegions.shortDescription = resultRegions.data()['ShortDescription'];
        dataRegions.imageUrlThumbnail = resultRegions.data()['imageUrlThumbnail'];
        dataRegions.items = await getFirebaseItemValues(resultRegions.data()['ID'],locData);
        arrayRegions.add(dataRegions);
      });
    });
    return arrayRegions;
  }

//Get all Items based on selected regions
  @override
  Future<List<ItemsData>> getFirebaseItemValues(String strID,LocationData locData) async {
    await Firebase.initializeApp();
    List<ItemsData> arrayItems=[];

    await FirebaseFirestore.instance.collection("collection_items").where("ID", isEqualTo:strID).get().then((value) {
      value.docs.forEach((resultItems) {
        //print('resultItems ${resultItems.data()}');
        ItemsData dataItems = new ItemsData();
        dataItems.id = resultItems.data()['ID'];
        dataItems.title = resultItems.data()['Title'];
        dataItems.shortDescription = resultItems.data()['ShortDescription'];
        dataItems.latitude = resultItems.data()['latitude'];
        dataItems.longitude = resultItems.data()['longitude'];
        dataItems.imageUrlThumbnail = resultItems.data()['imageUrlThumbnail'];
        dataItems.imageUrlCapture = resultItems.data()['imageUrlCapture'];
        dataItems.distanceFromUserLocation = calculateDistanceBetweenTwoPoints(locData.latitude,locData.longitude,double.parse(resultItems.data()['latitude']),double.parse(resultItems.data()['longitude'])).toInt();
        arrayItems.add(dataItems);
      });
      print('Items added ${arrayItems.length}');
    });
    return arrayItems;
  }

}

