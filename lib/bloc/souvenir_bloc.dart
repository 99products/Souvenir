// event, state => new state => update UI.

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/api/exceptions.dart';
import 'package:travel_explorer/api/services.dart';
import 'package:travel_explorer/bloc/souvenir_events.dart';
import 'package:travel_explorer/bloc/souvenir_states.dart';
import 'package:travel_explorer/model/souvenir_list.dart';

class SouvenirBloc extends Bloc<SouvenirEvents, SouvenirState> {
  //
  final SouvenirCollectionRepo collectionsRepo;
  List<RegionsData> listRegion;

  SouvenirBloc({this.collectionsRepo}) : super(SouvenirInitState());

  @override
  Stream<SouvenirState> mapEventToState(SouvenirEvents event) async* {
    switch (event) {
      case SouvenirEvents.fetchSouvenirCollections:
        yield SouvenirLoading();
        try {
          listRegion = await collectionsRepo
              .getFirebaseRegionsValues(); //getSouvenirCollectionList();
          yield SouvenirLoaded(regionData: listRegion);
        } on SocketException {
          yield SouvenirListError(
            error: NoInternetException('No Internet'),
          );
        } on HttpException {
          yield SouvenirListError(
            error: NoServiceFoundException('No Service Found'),
          );
        } on FormatException {
          yield SouvenirListError(
            error: InvalidFormatException('Invalid Response format'),
          );
        } catch (e) {
          yield SouvenirListError(
            error: UnknownException('Unknown Error'),
          );
        }

        break;
    }
  }
}
