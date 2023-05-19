// import 'package:flutter_test/flutter_test.dart';
// import 'package:tflite_text_classification/tflite_text_classification.dart';
// import 'package:tflite_text_classification/src/tflite_text_classification_platform_interface.dart';
// import 'package:tflite_text_classification/src/tflite_text_classification_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockTfliteTextClassificationPlatform
//     with MockPlatformInterfaceMixin
//     implements TfliteTextClassificationPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final TfliteTextClassificationPlatform initialPlatform = TfliteTextClassificationPlatform.instance;
//
//   test('$MethodChannelTfliteTextClassification is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelTfliteTextClassification>());
//   });
//
//   test('getPlatformVersion', () async {
//     TfliteTextClassification tfliteTextClassificationPlugin = TfliteTextClassification();
//     MockTfliteTextClassificationPlatform fakePlatform = MockTfliteTextClassificationPlatform();
//     TfliteTextClassificationPlatform.instance = fakePlatform;
//
//     expect(await tfliteTextClassificationPlugin.getPlatformVersion(), '42');
//   });
// }
