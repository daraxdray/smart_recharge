import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:learning_text_recognition/learning_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      home: const MyHomePage(title: 'Smart Cam Recharge'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  int _counter = 0;
  final picker = ImagePicker();
  String imageText = "";
  String _network = "mtn";
  TextEditingController initials = TextEditingController();
  late AnimationController animationController;
  TextRecognition textRecognition = TextRecognition(
      options: TextRecognitionOptions.Default
  );
  RecognizedText? result;
  late Iterable<RegExpMatch> match;
  void processImage()  async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera,imageQuality: 15);
    InputImage image = InputImage.fromFilePath(pickedFile?.path ??"/");
      result = await textRecognition.process(image);
    var pattern = RegExp(r'.?(\d{4}-\d{4}-\d{4}-\d+)');
     imageText = result?.text ?? "";
    match = pattern.allMatches(imageText);

    if(match.isNotEmpty){
      String inits = '';
      switch(_network){
        case 'mtn':  inits = '*555*';
        break;
        case 'airtel': inits = '*126*';
        break;
        case '9mobile': inits = '*222*';
        break;
        case 'glo': inits = '*123*';
        break;
        default:
          inits = initials.text;
      }
      imageText = "$inits${match.first.group(0)}#".replaceAll("-", "").replaceAll(" ", "");
      await FlutterPhoneDirectCaller.callNumber(imageText);
    }else{
      imageText = "No match found";
    }
    setState((){
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  selectNetwork(network){
    setState(() {
      _network = network;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Text("Smartly Recharge Your Airtime Using Camera"),
              Image.asset("assets/mobile-user.png"),
              const SizedBox(height: 10,),
              Text(
                "Select Network",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                _network.toUpperCase(),
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(onTap:()=> selectNetwork("mtn"),
                  child: Stack(
                    children: [
                      Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            boxShadow:[BoxShadow(color: Colors.black26,offset: Offset(2, 3))],
                            borderRadius: BorderRadius.circular(30),image: DecorationImage(image: AssetImage("assets/mtn2.jpg"))),


                      ),
                     if(_network == 'mtn') Positioned(child:
                      Container(
                        width: 10,height: 10,color: Colors.white,),
                        bottom: 0,right: 20,top: 30,)
                    ],
                  ),),
                  InkWell(onTap:()=> selectNetwork("airtel"),
                  child: Stack(
                    children: [

                      Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            boxShadow:[BoxShadow(color: Colors.black26,offset: Offset(2, 3))],
                            borderRadius: BorderRadius.circular(30),image: DecorationImage(image: AssetImage("assets/airtel.jpg"))),


                      ),
                      if(_network == 'airtel')Positioned(child:
                      Container(
                        width: 10,height: 10,color: Colors.white,),
                        bottom: 0,right: 20,top: 30,)
                    ],
                  ),),
                  InkWell(onTap: ()=>selectNetwork("9mobile"),
                  child: Stack(
                    children: [

                      Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            boxShadow:[BoxShadow(color: Colors.black26,offset: Offset(2, 3))],
                            borderRadius: BorderRadius.circular(30),image: DecorationImage(
                            image: AssetImage("assets/9mobile.png"),fit: BoxFit.cover)),


                      ),
                      if(_network == '9mobile') Positioned(child:
                      Container(
                        width: 10,height: 10,color: Colors.white,),
                        bottom: 0,right: 20,top: 30,)
                    ],
                  ),),
                  InkWell(onTap:()=> selectNetwork("glo"),
                  child: Stack(
                    children: [

                      Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            boxShadow:[BoxShadow(color: Colors.black26,offset: Offset(2, 3))],
                            borderRadius: BorderRadius.circular(30),image: const DecorationImage(image: AssetImage("assets/glo.jpg"),fit: BoxFit.cover)),


                      ),
                      if(_network == 'glo')  Positioned(child:
                      Container(
                        width: 10,height: 10,color: Colors.white,),
                        bottom: 0,right: 20,top: 30,)
                    ],
                  ),),
                  InkWell(onTap:()=> selectNetwork("custom"),
                  child: Stack(
                    children: [

                      Container(
                        height: 40,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            boxShadow:[BoxShadow(color: Colors.black26,offset: Offset(2, 3))],
                            borderRadius: BorderRadius.circular(30),image: DecorationImage(image: AssetImage("assets/question.png"))),


                      ),
                      if(_network == 'custom')  Positioned(child:
                      Container(
                        width: 10,height: 10,color: Colors.white,),
                        bottom: 0,right: 20,top: 30,)
                    ],
                  ),),

                ],
              ),
           if(_network == 'custom') TextFormField(
              controller: initials,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                label: Text("Initials"),
                hintText: "*123*",
              ),
            ),
            SizedBox(height: 10),
              Text("$imageText",style: AppTheme.title,)
            ],
          ),
          minimum: EdgeInsets.all(20),
        )
      ),

      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(7),
        decoration:const BoxDecoration(
            color: Color.fromARGB(255, 234, 234, 234),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
            boxShadow:[BoxShadow(color: Colors.black26,offset: Offset(2, -1),blurRadius: 3),BoxShadow(color: Colors.black26,offset: Offset(2,-3),blurRadius: 4)]
        ),
        child: InkWell(onTap: processImage,
        child: Container(
          height: 50,
          decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, colors: [Colors.purple,Colors.purpleAccent,],end: Alignment.centerRight,stops: [0.2,3,]),
              shape: BoxShape.circle,
              boxShadow:[BoxShadow(color: Colors.black26,offset: Offset(2, 3))]
          ),
          child: const Center(child: Icon(Icons.camera_alt_outlined,color: Colors.white,),),
        ),)
      )
    );
  }


  
}


