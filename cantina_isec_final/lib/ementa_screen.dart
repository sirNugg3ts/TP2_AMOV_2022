import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cantina_isec/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String url_menu = 'http://10.0.2.2:8080/menu';
const String url_image = 'http://10.0.2.2:8080/images/';

class EmentaClass {
  EmentaClass({required this.original, required this.update});

  /* EmentaClass.fromJson(Map<String, dynamic> json)
      : original = FoodClass.fromJson(json['original']),
        update = FoodClass.fromJson(json['update']) ?? null;
        */

  final FoodClass original;
  final FoodClass update;

  factory EmentaClass.fromJson(Map<String, dynamic> json) => EmentaClass(
      original: FoodClass.fromJson(json['original']),
      update: json['update'] == null
          ? FoodClass()
          : FoodClass.fromJson(json['update']));
}

class FoodClass {
  String img;
  String weekDay;
  String soup;
  String fish;
  String meat;
  String vegetarian;
  String desert;

  FoodClass({
    this.img = '',
    this.weekDay = '',
    this.soup = '',
    this.fish = '',
    this.meat = '',
    this.vegetarian = '',
    this.desert = '',
  });

  FoodClass.fromJson(Map<String, dynamic> json)
      : img = json['img'] ?? "empty",
        weekDay = json['weekDay'],
        soup = json['soup'],
        fish = json['fish'],
        meat = json['meat'],
        vegetarian = json['vegetarian'],
        desert = json['desert'];

  Map<String, dynamic> toJson() => {
        'img': img,
        'weekDay': weekDay,
        'soup': soup,
        'fish': fish,
        'meat': meat,
        'vegetarian': vegetarian,
        'desert': 'uvas frescas',
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodClass &&
          img == other.img &&
          weekDay == other.weekDay &&
          soup == other.soup &&
          fish == other.fish &&
          meat == other.meat &&
          vegetarian == other.vegetarian &&
          desert == other.desert;
}

class EmentaScreen extends StatefulWidget {
  const EmentaScreen({Key? key}) : super(key: key);
  static const String routeName = '/EmentaScreen';

  @override
  State<EmentaScreen> createState() => _EmentaScreenState();
}

class _EmentaScreenState extends State<EmentaScreen> {
  List<FoodClass> list = <FoodClass>[];
  List<EmentaClass> ementas = <EmentaClass>[];
  List<FoodClass> listUpdated = <FoodClass>[];
  final List<String> DAYS = [
    "MONDAY",
    "TUESDAY",
    "WEDNESDAY",
    "THURSDAY",
    "FRIDAY"
  ];
  bool _fetchingData = false;

  @override
  initState() {
    super.initState();
    _fetchCantinaEmentas();
  }

  Image _getImage(String img) {
    return Image.network(
      url_image + img,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Image.asset('assets/images/placeholder.jpg');
      },
    );
  }

  Future<void> _fetchCantinaEmentas() async {
    list.clear();
    ementas.clear();
    listUpdated.clear();


    debugPrint(DateTime.now().weekday.toString());
    try {
      setState(() => _fetchingData = true);
      http.Response response = await http.get(Uri.parse(url_menu));
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        //final Map<String,dynamic> content = json.decode(response.body);
        final Map<String, dynamic> content =
            jsonDecode(utf8.decode(response.bodyBytes));

        for (int i = 0; i < 5; i++) {
          //list.add(EmentaClass.fromJson(content[DAYS[i]]));
        }
        int weekday = DateTime.now().weekday;
        int i = (weekday > 5 ? 1 : weekday);
        while (ementas.length < 5) {
          ementas.add(EmentaClass.fromJson(content[DAYS[i - 1]]));

          if ((++i) > 5) i = 1;
        }
        if (DateTime.now().weekday <= 5) {}
        //debugPrint(list[i].original.meat);

        for (int i = 0; i < 5; i++) {
          list.add(ementas[i].original);
          listUpdated.add(ementas[i].update);
        }

        //ementa = (content as List).map((e) => EmentaClass.fromJson(e)).toList();
      }
    } catch (ex) {
      debugPrint('Something went wrong: $ex');
    } finally {
      setState(() => _fetchingData = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ementa Semanal"),
        ),
        backgroundColor: Colors.white70,
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(height: 15),
          const Text("Ementas Semanais   ",
              textScaleFactor: 1.7, textAlign: TextAlign.start),
          const SizedBox(height: 15),
          const Divider(thickness: 20.0, color: Colors.grey),
          const SizedBox(height: 15),
          if (_fetchingData) const CircularProgressIndicator(),
          if (!_fetchingData && list != null && list.isNotEmpty)
            Container(
                      child: ListView.separated(
                        itemCount: list.length,
                        scrollDirection: Axis.vertical,
                        controller: ScrollController(),
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const Divider(
                          thickness: 20.0,
                          color: Colors.grey,
                        ),
                        itemBuilder: (BuildContext context, int index) => ListTile(
                          title: Column(
                            children: [
                              Text(
                                list[index].weekDay,
                                textAlign: TextAlign.start,
                                textScaleFactor: 1,
                              )
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              const SizedBox(height: 13),
                              Text("Sopa: ${list[index].soup}",
                                  textAlign: TextAlign.start),
                              const SizedBox(height: 13),
                              Text("Prato de Peixe: ${list[index].fish}"),
                              const SizedBox(height: 13),
                              Text("Prato de Carne: ${list[index].meat}"),
                              const SizedBox(height: 13),
                              Text(
                                  "Prato Vegetariano: ${list[index].vegetarian}"),
                              const SizedBox(height: 13),
                              Text("Sobremesa: ${list[index].desert}"),
                              const SizedBox(height: 13)
                            ],
                          ),
                          onLongPress: () {
                            Navigator.of(context).pushNamed(EditScreen.routeName,
                                arguments: list[index]);


                          },
                          trailing:
                              _getImage(list[index].img),
                        ),
                      )),
              const Divider(thickness: 20.0, color: Colors.yellow),

              const SizedBox(height: 15),



              const Text("Ementas Semanais Atualizadas!  ",
                  textScaleFactor: 1.7, textAlign: TextAlign.start),
              const SizedBox(height: 15),
              const Divider(thickness: 20.0, color: Colors.yellow),
              const SizedBox(height: 15),
              Container(
                  child: ListView.separated(
                    itemCount: list.length,
                    scrollDirection: Axis.vertical,
                    controller: ScrollController(),
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const Divider(
                      thickness: 20.0,
                      color: Colors.grey,
                    ),
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      title: Column(
                        children: [
                          Text(
                            list[index].weekDay,
                            textAlign: TextAlign.start,
                            textScaleFactor: 1,
                          )
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          const SizedBox(height: 13),
                          Text("Sopa: ${listUpdated[index].soup}",
                              textAlign: TextAlign.start),
                          const SizedBox(height: 13),
                          Text("Prato de Peixe: ${listUpdated[index].fish}"),
                          const SizedBox(height: 13),
                          Text("Prato de Carne: ${listUpdated[index].meat}"),
                          const SizedBox(height: 13),
                          Text(
                              "Prato Vegetariano: ${listUpdated[index].vegetarian}"),
                          const SizedBox(height: 13),
                          Text("Sobremesa: ${listUpdated[index].desert}"),
                          const SizedBox(height: 13)
                        ],
                      ),
                      onLongPress: () {
                        Navigator.of(context).pushNamed(EditScreen.routeName,
                            arguments: listUpdated[index]);
                      },
                      trailing:
                      _getImage(listUpdated[index].img),
                    ),
                  )),
                ],
              ),
            ),
        floatingActionButton: FloatingActionButton(
          onPressed: _fetchCantinaEmentas,
          tooltip: 'Increment',
          child: const Icon(Icons.refresh),
        ));
  }
}
