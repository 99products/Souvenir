
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:travel_explorer/model/souvenir_list.dart';

abstract class SouvenirCollectionRepo {
  Future<List<RegionsData>> getSouvenirCollectionList();
  Future<List<RegionsData>> getFirebaseRegionsValues();
  Future<List<ItemsData>> getFirebaseItemValues(String strID);
}

class DashboardServices implements SouvenirCollectionRepo {
  //
  static const _baseUrl = 'jsonplaceholder.typicode.com';
  static const String _GET_ALBUMS = '/albums';

  @override
  Future<List<RegionsData>> getSouvenirCollectionList() async {
    Uri uri = Uri.https(_baseUrl, _GET_ALBUMS);
    Response response = await http.get(uri);
    List<RegionsData> albums = regionFromJson(response.body);
    return albums;
  }

  @override
  Future<List<RegionsData>> getFirebaseRegionsValues() async {
    await Firebase.initializeApp();
    List<RegionsData> arrayRegions=[];
    await FirebaseFirestore.instance.collection("collection_regions").get().then((querySnapshot) {
      querySnapshot.docs.forEach((resultRegions) {
        print(resultRegions);
        RegionsData dataRegions = new RegionsData();
        dataRegions.id = resultRegions.data()['ID'];
        dataRegions.title = resultRegions.data()['Title'];
        dataRegions.description = resultRegions.data()['Description'];
        dataRegions.shortDescription = resultRegions.data()['ShortDescription'];
        dataRegions.itemsCount = resultRegions.data()['ItemsCount'];
        dataRegions.geoLocation = resultRegions.data()['GeoLocation'];
        arrayRegions.add(dataRegions);
      });
    });
    return arrayRegions;
  }

//Get all Items based on selected regions
  @override
  Future<List<ItemsData>> getFirebaseItemValues(String strID) async {
    await Firebase.initializeApp();
    List<ItemsData> arrayItems=[];
    await FirebaseFirestore.instance.collection("collection_items").where("ID", isEqualTo:strID).get().then((value) {
      value.docs.forEach((resultItems) {
        //print('resultItems ${resultItems.data()}');
        ItemsData dataItems = new ItemsData();
        dataItems.id = resultItems.data()['ID'];
        dataItems.title = resultItems.data()['Title'];
        dataItems.shortDescription = resultItems.data()['ShortDescription'];
        dataItems.geoLocation = resultItems.data()['GeoLocation'];
        arrayItems.add(dataItems);
      });
      print('Items added ${arrayItems.length}');
    });
    return arrayItems;
  }
}

