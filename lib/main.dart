import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travel_explorer/api/exceptions.dart';

import 'api/services.dart';
import 'bloc/souvenir_bloc.dart';
import 'screens/souvenir_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (FileNotFoundError) {
    throw EnviromentFileException('.env file is missing');
  }
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
