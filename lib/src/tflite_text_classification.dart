import 'package:tflite_text_classification/tflite_text_classification.dart';
import 'tflite_text_classification_platform_interface.dart';

class TfliteTextClassification {
  /// Classify text using the model.
  ///
  /// Returns the classification result as a string.
  /// Throws exception on error.
  Future<ClassificationResult?> classifyText({TextClassifierParams? params}) {
    return TfliteTextClassificationPlatform.instance
        .classifyText(params: params);
  }
}
