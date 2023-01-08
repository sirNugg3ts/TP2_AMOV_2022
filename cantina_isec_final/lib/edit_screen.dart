import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cantina_isec/ementa_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String url_menu = 'http://10.0.2.2:8080/menu';
const String url_image = 'http://10.0.2.2:8080/images/';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Page')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.file(File(picture.path), fit: BoxFit.cover, width: 250),
          const SizedBox(height: 24),
          Text(picture.name)
        ]),
      ),
    );
  }
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(children: [
            (_cameraController.value.isInitialized)
                ? CameraPreview(_cameraController)
                : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      color: Colors.black),
                  child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 30,
                          icon: Icon(
                              _isRearCameraSelected
                                  ? CupertinoIcons.switch_camera
                                  : CupertinoIcons.switch_camera_solid,
                              color: Colors.white),
                          onPressed: () {
                            setState(
                                    () => _isRearCameraSelected = !_isRearCameraSelected);
                            initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                          },
                        )),
                    Expanded(
                        child: IconButton(
                          onPressed: takePicture,
                          iconSize: 50,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.circle, color: Colors.white),
                        )),
                    const Spacer(),
                  ]),
                )),
          ]),
        ));
  }

  @override
  void initState() {
    super.initState();
    // initialize the rear camera
    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      //Return to previous screen, passing the picture
      Navigator.of(context).pop(picture);
      /*
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                picture: picture,
              )));
      */
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
// create a CameraController
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
// Next, initialize the controller. This returns a Future.
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }
}

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);
  static const String routeName = '/EditScreen';


  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  bool _isVisible = false;

  late final FoodClass _ementa =
      ModalRoute.of(context)!.settings.arguments as FoodClass;

  late Image imagemEmenta;

  late final FoodClass _original = FoodClass(
     img: _ementa.img,
     weekDay: _ementa.weekDay,
    soup : _ementa.soup,
    fish : _ementa.fish,
    meat : _ementa.meat,
    vegetarian : _ementa.vegetarian,
    desert : _ementa.desert
  );

  bool _isNewImage = false;




  Future<void> editDone() async {

    var image;
    if(_isNewImage){
      image = _ementa.img;
    }else{
      image = "null";
    }


    var jsono = jsonEncode(<String, String>{
      'img': image,
      'soup': _ementa.soup,
      'fish': _ementa.fish,
      'meat': _ementa.meat,
      'vegetarian': _ementa.vegetarian,
      'desert': _ementa.desert,
    });
    print(jsono);

    //TODO POR AQUI O ENVIO DO POST ainda nao funciona
    http.Response a =await http.post(
      Uri.parse(url_menu),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'img': image,
        'soup': _ementa.soup,
        'fish': _ementa.fish,
        'meat': _ementa.meat,
        'vegetarian': _ementa.vegetarian,
        'desert': _ementa.desert,
        'weekDay': _ementa.weekDay,
      }),
    );
    print("status ${a.statusCode}");
    Navigator.of(context).pushNamed(EmentaScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(title: const Text("Editar ementa")),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Divider(thickness: 20.0, color: Colors.grey),
              const SizedBox(height: 7),
              Text(
                _original.weekDay,
                textScaleFactor: 2.1,
              ),
              const SizedBox(height: 7),
              const Divider(thickness: 20.0, color: Colors.grey),
              const SizedBox(height: 25),
              SizedBox(
                  width: 300,
                  child: Column(children: [
                    const Text(
                      "Sopa Original",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _original.soup,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.1,
                    ),
                    const SizedBox(height: 12),
                  ])),
              SizedBox(
                width: 300,
                height: 75,
                child: TextField(
                    decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 25),
                        labelText: 'Sopa',
                        hintText: 'Altere a sopa...',
                        border: OutlineInputBorder()),
                    onChanged: (value) {
                      setState(() => {

                              _ementa.soup = value,
                        _isVisible = true

                          });
                    }),
              ),
              SizedBox(
                  width: 300,
                  child: Column(children: [
                    const Text(
                      "Prato Peixe Original",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _original.fish,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.1,
                    ),
                    const SizedBox(height: 12),
                  ])),
              SizedBox(
                width: 300,
                height: 75,
                child: TextField(
                    decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 25),
                        labelText: 'Prato de Peixe',
                        hintText: 'Altere o prato de peixe...',
                        border: OutlineInputBorder()),
                    onChanged: (value) {
                      setState(() => {

                              _ementa.fish = value,
                        _isVisible = true

                          });
                    }),
              ),
              SizedBox(
                  width: 300,
                  child: Column(children: [
                    const Text(
                      "Prato Carne Original",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _original.meat,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.1,
                    ),
                    const SizedBox(height: 8),
                  ])),
              SizedBox(
                width: 300,
                height: 75,
                child: TextField(
                    decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 25),
                        labelText: 'Prato de Carne',
                        hintText: 'Altere o prato de carne...',
                        border: OutlineInputBorder()),
                    onChanged: (value) {
                      setState(() => {

                              _ementa.meat = value,
                        _isVisible = true

                          });
                    }),
              ),
              SizedBox(
                  width: 300,
                  child: Column(children: [
                    const Text(
                      "Prato Vegetariano Original",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _original.vegetarian,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.1,
                    ),
                    const SizedBox(height: 12)
                  ])),
              SizedBox(
                width: 300,
                height: 75,
                child: TextField(
                    decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 25),
                        labelText: 'Prato Vegetariano',
                        hintText: 'Altere o prato vegetariano...',
                        border: OutlineInputBorder()),
                    onChanged: (value) {
                      setState(() => {

                              _ementa.vegetarian = value,
                        _isVisible = true
                          });
                    }),
              ),
              SizedBox(
                  width: 300,
                  child: Column(children: [
                    const Text(
                      "Sobremesa Original",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _original.desert,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.1,
                    ),
                    const SizedBox(height: 12)
                  ])),
              SizedBox(
                width: 300,
                height: 75,
                child: TextField(
                    decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: 25),
                        labelText: 'Sobremesa',
                        hintText: 'Altere a sobremesa...',
                        border: OutlineInputBorder()),
                    onChanged: (value) {
                      setState(() => {
                           _ementa.desert = value,
                        _isVisible = true

                          });
                    }),
              ),
              SizedBox(width: 300, child: _isNewImage ? imagemEmenta : Image.network(url_image + _ementa.img,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const Image(image: AssetImage('assets/images/placeholder.jpg'));
              }
                ,),
              ),
              SizedBox(
                  width: 300,
                  child: Column(children: [
                    ElevatedButton(
                        onPressed:
                      
                      //await for availableCameras, then take picture and update ementa
                      ()  {
                          _getNewEmentaImage(context);

                      },
                        child: const Text("Atualizar foto da ementa")),
                    const SizedBox(height: 12)
                  ])),
            ],
          ),
        )),
        floatingActionButton: Visibility(
          visible: _isVisible,
          child: FloatingActionButton(
              onPressed: editDone,
              tooltip: 'Edit',
              child: const Icon(Icons.edit)),
        ));
  }

  Future<void> _getNewEmentaImage(BuildContext context) async{
    final cameras = await availableCameras();
    var image = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(
          cameras: cameras,
        ),
      ),
    );
    
    if(!mounted) return;

    setState(() {
      _isNewImage = true;
      _isVisible = true;
      imagemEmenta = Image.file(File(image.path));
      List<int> imageBytes = File(image.path).readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      _ementa.img = base64Image;
    });
  }
}
