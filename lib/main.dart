import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import "package:speech_to_text/speech_to_text.dart" as stt;
import 'dart:ui' as ui;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Flutter App",
      debugShowCheckedModeBanner: false,


      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  final Map<String,HighlightedWord> _highlights = {
    "help":HighlightedWord(
      onTap: (() {print("help");}),
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.blueAccent,
      )
    )
  };

  bool isListening = false;
  String text = "Press the button and start speaking";
  double confidenceLevel = 1.0;
  late stt.SpeechToText speech;
 
  @override
    void initState() {
      super.initState();
      speech = stt.SpeechToText();
    }
  

  @override
  Widget build(BuildContext context) {

   

   
    return Scaffold(
      appBar: AppBar(
        title: Text("Confidence: ${(confidenceLevel*100).toStringAsFixed(1)}%"),
        centerTitle: true,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


      floatingActionButton: AvatarGlow(
        
        animate: isListening,
        glowColor: Colors.blueAccent,
        endRadius: 70.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,

        child: FloatingActionButton(
          onPressed: _listen,
      
          child: Icon(isListening? Icons.mic : Icons.mic_none),
        ),
      ),


      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30.0, 30, 30, 100.0),
          child: TextHighlight(
            text: text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );

    
    
  }

  void _listen() async {
    if(!isListening){
      bool available = await speech.initialize( onStatus: ((status) => print({status})) , onError:  ((error) => print({error})));
    

      if (available){
        setState(() => isListening = true,);
        speech.listen(

          onResult: (val) => setState(() {
            text = val.recognizedWords;
            if(val.hasConfidenceRating && val.confidence >0){
              confidenceLevel = val.confidence;
            }
          }),
        );
      }
      else{
        print("not available");
      }
    }else {
      setState(() {
        isListening = false;
        speech.stop();
      });
    }


  }

}
