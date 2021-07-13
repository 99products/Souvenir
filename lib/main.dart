import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api/services.dart';
import 'bloc/albums/souvenir_bloc.dart';
import 'screens/souvenir_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Preferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
          return MaterialApp(
            title: 'Souvenir',
            debugShowCheckedModeBanner: false,
            home: BlocProvider(
              create: (context) => SouvenirBloc(collectionsRepo: DashboardServices()),
              child: SouvenirScreen(),
            ),
          );
  }
}
