import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tflite_text_classification_method_channel.dart';

abstract class TfliteTextClassificationPlatform extends PlatformInterface {
  /// Constructs a TfliteTextClassificationPlatform.
  TfliteTextClassificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static TfliteTextClassificationPlatform _instance =
      MethodChannelTfliteTextClassification();

  /// The default instance of [TfliteTextClassificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelTfliteTextClassification].
  static TfliteTextClassificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TfliteTextClassificationPlatform] when
  /// they register themselves.
  static set instance(TfliteTextClassificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<ClassificationResult?> classifyText({TextClassifierParams? params}) {
    throw UnimplementedError('classifyText() has not been implemented.');
  }
}
