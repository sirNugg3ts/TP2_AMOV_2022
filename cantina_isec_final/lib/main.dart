import 'package:cantina_isec/creditos_screen.dart';
import 'package:cantina_isec/edit_screen.dart';
import 'package:cantina_isec/ementa_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cantina ISEC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MyHomePage.routeName,
      routes: {
        MyHomePage.routeName : (context) => const MyHomePage(),
        EmentaScreen.routeName : (context) => const EmentaScreen(),
        CreditosScreen.routeName : (context) => const CreditosScreen(),
        EditScreen.routeName : (context) => const EditScreen()
      },
//      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  static const String routeName = '/';


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Cantina ISEC"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Image.asset('assets/images/canteenIcon.png'),
              width: 400,
              height: 200,
            ),
            const SizedBox(height: 40),
            const Hero(tag: 'CenterTitleText',
              child: Text(
                'Bem vindo à nossa aplicação!',
                textScaleFactor: 2.0,
              ),
            ),
          const SizedBox(
            height: 20
          ),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(
                      EmentaScreen.routeName,
                  );
                },

                child: const Text("Ementa",textScaleFactor: 1.8,),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                ),
              ),
            ),
            SizedBox(height: 25,),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(
                      CreditosScreen.routeName
                  );
                },

                child: const Text("Creditos",textScaleFactor: 1.8,),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
