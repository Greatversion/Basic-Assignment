import 'package:basic_internship_assignment/provider/app.providers.dart';
import 'package:basic_internship_assignment/routes/routes.app.dart';
import 'package:basic_internship_assignment/routes/routes.name.dart';
import 'package:basic_internship_assignment/services/authServices/auth.credentials.dart';

import 'package:flutter/material.dart' ;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      anonKey: AuthCredentials.DATABASE_KEY, url: AuthCredentials.DATABASE_URL);

  runApp(const BASIC());
}

class BASIC extends StatelessWidget {
  const BASIC({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: VideoUploadScreen(),
        initialRoute: RoutesName.splashScreen,
        onGenerateRoute: AppRoutes.generatedRoute,
      ),
    );
  }
}

