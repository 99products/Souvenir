import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/bloc/albums/souvenir_bloc.dart';
import 'package:travel_explorer/bloc/albums/souvenir_events.dart';
import 'package:travel_explorer/bloc/albums/souvenir_states.dart';
import 'package:travel_explorer/model/souvenir_list.dart';
import 'package:travel_explorer/widgets/collection_row.dart';
import 'package:travel_explorer/widgets/error.dart';
import 'package:travel_explorer/widgets/loading.dart';
import 'package:travel_explorer/widgets/txt.dart';

class SouvenirScreen extends StatefulWidget {
  @override
  _SouvenirScreenState createState() => _SouvenirScreenState();
}

class _SouvenirScreenState extends State<SouvenirScreen> {
  //

  @override
  void initState() {
    super.initState();
    _loadAlbums();
  }

  _loadAlbums() async {
    context.bloc<SouvenirBloc>().add(SouvenirEvents.fetchSouvenirCollections);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Txt(text: 'Souvenir'),
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
              onTap: _loadAlbums,
            );
          }
          if (state is SouvenirLoaded) {
            List<RegionsData> albums = state.regionData;
            return _list(albums);
          }
          return Loading();
        }),
      ],
    );
  }

  Widget _list(List<RegionsData> regionData) {
    return Expanded(
      child: ListView.builder(
        itemCount: regionData.length,
        itemBuilder: (_, index) {
          RegionsData objRegionData = regionData[index];
          return CollectionRow(regionData: objRegionData);
        },
      ),
    );
  }
}
