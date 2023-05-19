import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tflite_text_classification_platform_interface.dart';

/// An implementation of [TfliteTextClassificationPlatform] that uses method channels.
class MethodChannelTfliteTextClassification
    extends TfliteTextClassificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tflite_text_classification');

  @override
  Future<ClassificationResult?> classifyText(
      {TextClassifierParams? params}) async {
    final Map? result = await methodChannel.invokeMethod<Map?>(
        'classifyText', params?.toJson());

    result?.cast<String, dynamic>();

    // Extract the list of categories and the inference time from the final map.
    List<dynamic> categoryList = result?['categories'];
    int inferenceTime = result?['inferenceTime'];

    // Convert the list of maps to a list of category objects.
    List<Category> categories = categoryList.map((categoryMap) {
      return Category(
        label: categoryMap['label'],
        displayName: categoryMap['displayName'],
        score: categoryMap['score'],
        index: categoryMap['index'],
      );
    }).toList();

    // Set the method call handler to null to prevent memory leaks.
    methodChannel.setMethodCallHandler(null);

    // Return the category and inference time as ClassificationResult.
    return ClassificationResult(
      categories: categories,
      inferenceTime: inferenceTime,
    );
  }
}

enum ModelType { wordVec, mobileBert }

/// Parameters for the [classifyText] method.
class TextClassifierParams {
  /// Provide text to be classified.
  final String text;

  /// Provide the type of model.
  final ModelType modelType;

  /// Provide the model to be used for classification.
  final String modelPath;

  /// Provide the delegate to be used for classification.
  /// 0: CPU
  /// 1: GPU
  final int delegate;

  /// Create parameters for the [classifyText] method.
  const TextClassifierParams(
      {required this.text,
      required this.modelType,
      required this.modelPath,
      required this.delegate})
      : assert(text.length > 1, 'text length should at least be 2');

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'text': text,
      'modelType': modelType.toString(),
      'modelPath': modelPath,
      'delegate': delegate,
    };
  }
}

/// A list of categories returned by the text classification model.
/// This class also contains the inference time.
class ClassificationResult {
  final List<Category> categories;
  final int inferenceTime;

  /// Defining [ClassificationResult] constructor.
  ClassificationResult({
    required this.categories,
    required this.inferenceTime,
  });

  /// Overriding [ClassificationResult] toString to make it easier to see
  /// information when using the print statement.
  @override
  String toString() {
    return 'ClassificationResult{'
        'categories: $categories, '
        'inferenceTime: $inferenceTime'
        '}';
  }
}

/// A category returned by the text classification model.
class Category {
  final String label;
  final String displayName;
  final double score;
  final int index;

  /// Defining [Category] constructor.
  Category({
    required this.label,
    required this.displayName,
    required this.score,
    required this.index,
  });

  /// Overriding [Category] toString to make it easier to see
  /// information when using the print statement.
  @override
  String toString() {
    return 'Category{'
        'label: $label, '
        'displayName: $displayName, '
        'score: $score, '
        'index: $index'
        '}';
  }
}
