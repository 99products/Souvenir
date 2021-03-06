import 'package:equatable/equatable.dart';
import 'package:travel_explorer/model/souvenir_list.dart';

abstract class SouvenirState extends Equatable {
  @override
  List<Object> get props => [];
}

class SouvenirInitState extends SouvenirState {}

class SouvenirLoading extends SouvenirState {}

class SouvenirLoaded extends SouvenirState {
  final List<RegionsData> regionData;
  SouvenirLoaded({this.regionData});
}

class LocationLoading extends SouvenirState {}

class LocationLoaded extends SouvenirState {
  final ProfileData profileData;
  LocationLoaded({this.profileData});
}

class SouvenirListError extends SouvenirState {
  final error;
  SouvenirListError({this.error});
}
