import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_text_classification/tflite_text_classification.dart';

/// Note: This example uses the two provided models in the assets folder.
/// The provided model does Hinglish(Common language in India) Text Emotion
/// Classification and are generated using the Tensorflow Lite Model Maker but
/// they are not very accurate and are only here for demonstration purposes.
///
/// Replace provided model with your own models.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String testMessage = 'Unknown';
  String? predictedEmotion;
  final _tfliteTextClassificationPlugin = TfliteTextClassification();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    ClassificationResult? result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      TextClassifierParams params = TextClassifierParams(
        text: 'aaj me bahut khush hu',
        modelPath:
            await copyAssetFileToCacheDirectory('assets/mobilebert.tflite'),
        modelType: ModelType.mobileBert,
        delegate: 0,
      );

      result =
          await _tfliteTextClassificationPlugin.classifyText(params: params);
    } on PlatformException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (result != null) {
        predictedEmotion = getPredictedEmotion(result);
        log(predictedEmotion.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
      ),
    );
  }
}

/// Helper function to get the highest score emotion from the result.
String? getPredictedEmotion(ClassificationResult result) {
  String? predictedEmotion;

  double maxScore = 0.0;
  for (var category in result.categories) {
    if (category.score > maxScore) {
      maxScore = category.score;
      predictedEmotion = category.label;
    }
  }

  return predictedEmotion;
}

/// Helper function to copy the asset file to the cache directory for use in
/// the native code.
Future<String> copyAssetFileToCacheDirectory(String assetPath) async {
  // Get the cache directory path.
  Directory cacheDir = await getTemporaryDirectory();

  // Create a new file in the cache directory with the same name.
  String fileName = assetPath.split('/').last;
  File cacheFile = File('${cacheDir.path}/$fileName');

  // Copy the asset file to the cache directory.
  ByteData assetData = await rootBundle.load(assetPath);
  await cacheFile.writeAsBytes(assetData.buffer.asUint8List());

  return cacheFile.path;
}
