import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:web3demo/app/core/service_locator.dart';
import 'package:web3demo/app/provider/home_screen_provider.dart';
import 'package:web3demo/app/service/notes_service.dart';
import 'package:web3demo/app/ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  serviceLocator();

  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => sl<IHomeScreenProvider>()),
        ChangeNotifierProvider(create: (context) => sl<INotesService>()),
      ],
      child: const Web3Demo(),
    ),
  );
}

class Web3Demo extends StatelessWidget {
  const Web3Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web3 Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const HomeScreen(),
    );
  }
}
