import 'package:flutter/material.dart';
import 'package:yug_foundation_app/widgets/logo_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfffcf7dd).withOpacity(1.0),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CustomPaint(
                size: Size(width, (width*0.9329608938547487).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                painter: RPSCustomPainter(),
              ),
              Text("YUG",style: TextStyle(fontSize: 100,fontWeight: FontWeight.w900,height: 0.77),textAlign: TextAlign.center),
              Text("FOUNDATION",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w800,height: 0.77),textAlign: TextAlign.center,),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 28.0),
                child: Text("We at YUG Foundation work towards bringing to life and meaning to our motto Sahyog, Seva, Samarpan. ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,height: 0.77),textAlign: TextAlign.center,),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 30),
              height: 44.0,
              width: width*0.9,
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xff9e1b11), Color(0xffFBCDB2)]),borderRadius: BorderRadius.circular(16)),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent,foregroundColor: Color(0xfffcf7dd)),
                child: Text('Get Started',style: TextStyle(fontSize: 22),),
              ),
            ),
          )
        ],
      ),
    );
  }
}

