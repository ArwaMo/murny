import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:murny_final_project/bloc/map_bloc/map_bloc.dart';
import 'package:murny_final_project/bloc/token_bloc/check_token_cubit.dart';
import 'package:murny_final_project/screens/home.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:murny_final_project/screens/splash_screen/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'bloc/profile_bloc/profile_bloc.dart';
import 'local_storage/shared_prefrences.dart';

SharedPref pref = SharedPref();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await dotenv.load(fileName: ".env");

  await pref.initializePref();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MultiBlocProvider(
          providers: [
            BlocProvider<MapBloc>(
                create: (context) =>
                    MapBloc()..add(MapGetCurrentLocationEvent())),
            BlocProvider<CheckTokenCubit>(
                create: (context) => CheckTokenCubit()),
            BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
          ],

          child: const MaterialApp(
            locale: Locale('ar'),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('ar'), // Arabic
            ],
            debugShowCheckedModeBanner: false,

            home: SignUpScreen(),

          ));
    });
  }
}
