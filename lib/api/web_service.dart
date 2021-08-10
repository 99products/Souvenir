import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:travel_explorer/api/services.dart';
import 'package:travel_explorer/common/app_data.dart';
import 'package:travel_explorer/model/souvenir_list.dart';

class WebServices {
  ApiListener mApiListener;


  final JsonDecoder _decoder = new JsonDecoder();

  WebServices(this.mApiListener);

  //This Function executed after any Success call of API
  void _onSuccessResponse(Object mObject) {
    mApiListener.onApiSuccess(mObject);
  }

  // This Function executed after any failure call of API

  void _onFailureResponse(Object mThrowable) {
    // Call on failure method of ApiListener Interface
    //mApiListener.onApiFailure("Failed");
  }

  // This Function executed when internet connection is not available
  void _onNoInternetConnection() {
    mApiListener.onNoInternetConnection("Internet is not connected.");
  }

  void fetchSouvenirCollections(BuildContext context) async {

    await Firebase.initializeApp();
    List<RegionsData> arrayRegions=[];
    ProfileData profileData = new ProfileData();

    LocationData locData;
    await getLocationData().then((locationData){
      locData = locationData;

      getLocationAddress(locationData).then((strAddress){
          profileData.userLocation = strAddress;
          profileData.name='Jhon Smith';
      });

    });

    await FirebaseFirestore.instance.collection("collection_regions").get().then((querySnapshot) {
      querySnapshot.docs.forEach((resultRegions) async {
        print(resultRegions);
        RegionsData dataRegions = new RegionsData();
        dataRegions.id = resultRegions.data()['ID'];
        dataRegions.title = resultRegions.data()['Title'];
        dataRegions.description = resultRegions.data()['Description'];
        dataRegions.shortDescription = resultRegions.data()['ShortDescription'];
        dataRegions.items = await getFirebaseItemValues(resultRegions.data()['ID'],locData);
        dataRegions.dataProfile = profileData;
        arrayRegions.add(dataRegions);

         if(arrayRegions.length==2)
         _onSuccessResponse(arrayRegions);
      });

    });


    // if(listRegion.length>0)
    // _onSuccessResponse(listRegion);
    // else
    //   _onFailureResponse(new Exception("No Data Available"));

  }

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
        dataRegions.items = await getFirebaseItemValues(resultRegions.data()['ID'],locData);
        arrayRegions.add(dataRegions);
      });
    });
    return arrayRegions;
  }

//Get all Items based on selected regions
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
        dataItems.distanceFromUserLocation = calculateDistanceBetweenTwoPoints(locData.latitude,locData.longitude,double.parse(resultItems.data()['latitude']),double.parse(resultItems.data()['longitude'])).toInt();
        arrayItems.add(dataItems);
      });
      print('Items added ${arrayItems.length}');
    });
    return arrayItems;
  }
}

abstract class ApiListener{
  void onApiSuccess(Object mObject);
  void onApiFailure(Object mObject);
  void onNoInternetConnection(Object mObject);
}