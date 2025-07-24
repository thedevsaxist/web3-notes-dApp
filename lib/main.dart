import 'package:flutter/material.dart';


void main() {
  runApp(const Web3Demo());
}

class Web3Demo extends StatelessWidget {
  const Web3Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web3 Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const HomePage(),
    ); 
  }
}
