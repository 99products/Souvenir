import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:location/location.dart';
import 'package:travel_explorer/bloc/souvenir_bloc.dart';
import 'package:travel_explorer/bloc/souvenir_events.dart';
import 'package:travel_explorer/bloc/souvenir_states.dart';
import 'package:travel_explorer/common/app_data.dart';
import 'package:travel_explorer/model/souvenir_list.dart';
import 'package:travel_explorer/screens/capture_screen.dart';
import 'package:travel_explorer/widgets/appbar_widget.dart';
import 'package:travel_explorer/widgets/collection_row.dart';
import 'package:travel_explorer/widgets/error.dart';
import 'package:travel_explorer/widgets/item_row.dart';
import 'package:travel_explorer/widgets/loading.dart';
import 'package:travel_explorer/widgets/txt.dart';

class SouvenirScreen extends StatefulWidget {
  @override
  _SouvenirScreenState createState() => _SouvenirScreenState();
}

class _SouvenirScreenState extends State<SouvenirScreen> {
  //
  List<RegionsData> _regionsData = [];

  LocationData userLocationData;
ProfileData objProfileData;
  @override
  void initState() {
    super.initState();


    objProfileData = new ProfileData();
    objProfileData.name= 'Name';
    objProfileData.userLocation= 'Fetching your location details...';

    Future.delayed(const Duration(milliseconds: 500), () {

      print("Delay Binding");
//GetFirebase Values and calculate distance based on the user  location
      _loadUserLocation();
      _loadSouvenirs();

    });
  }

  _loadSouvenirs() async {
    context.bloc<SouvenirBloc>().add(SouvenirEvents.fetchSouvenirCollections);
  }
_loadUserLocation()
{
  //context.bloc<SouvenirBloc>().add(SouvenirEvents.fetchSouvenirCollections);

  getLocationData().then((locationData){
    userLocationData = locationData;
    //To Update Location details
    getLocationAddress(userLocationData).then((strAddress){
      this.setState(() {
        objProfileData.userLocation = strAddress;
      });
    });

  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(180.0),
          child: AppBar(
            automaticallyImplyLeading: false, // hides leading widget
            flexibleSpace: AppBarWidget(profileData:objProfileData),
          )
      ),
      body: Container(
        child: _body(),
      ),
    );
  }

  _body() {
    return Column(
      children: [
        BlocBuilder<SouvenirBloc, SouvenirState>(
            builder: (BuildContext context, SouvenirState state) {
              if (state is SouvenirListError) {
                final error = state.error;
                String message = '${error.message}\nTap to Retry.';
                return ErrorTxt(
                  message: message,
                  onTap: _loadSouvenirs,
                );
              }
              if (state is SouvenirLoaded) {
                //List<MyItinerary> itineraries = state.itineraries;
                _regionsData = state.regionData;
                return _loadList(_regionsData);
              }
              return Loading();
            }),
      ],
    );
  }

  Widget _loadList(List<RegionsData> objListRegionData) {
    return Expanded(child: GroupListView(
      sectionsCount: objListRegionData.length,
      countOfItemInSection: (int section) {
        return objListRegionData[section].items.length;
      },
      itemBuilder: _itemBuilder,
      groupHeaderBuilder: (BuildContext context, int section) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: CollectionRow(regionData: objListRegionData[section]),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10),
      sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    ));
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {
    //String user = _elements.values.toList()[index.section][index.index];
    ItemsData objItems = _regionsData[index.section].items[index.index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 8,
        child:InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetailScreen(selectedItemData:objItems)),);
            },
          child: ItemRow(itemsData: objItems),
        ),
      ),
    );
  }
}