[![pub package](https://img.shields.io/pub/v/tflite_text_classification.svg)](https://pub.dev/packages/tflite_text_classification) [![wakatime](https://wakatime.com/badge/user/83f3b15d-49de-4c01-b8de-bbc132f11be1/project/18eff6a3-d280-4551-b191-000c008da5a6.svg)](https://wakatime.com/badge/user/83f3b15d-49de-4c01-b8de-bbc132f11be1/project/18eff6a3-d280-4551-b191-000c008da5a6)

## Word from creator

**Hello👋, This package is supports using Tensorflow Lite models for text classifications. I developed this when I wanted to integrate some models I generated from Tensorflow Model Maker in my flutter app.**

**Yes, without a doubt, giving a free 👍 or ⭐ will encourage me to keep this plugin updated.**

## Package description

A flutter plugin for doing text classification using tflite models.

**Note:** This project utilises tensorflow-lite-task-text library to classify the texts through models.

## Features

- Works on Android 5.0 (API level 21) or later.
- Requires 4 line code to get running.

## Getting started

- In pubspec.yaml, add this dependency:

```yaml
tflite_text_classification: 
```

- Add this package to your project:

```dart
import 'package:tflite_text_classification/tflite_text_classification.dart';
```

## Basic Usage

```dart
ClassificationResult? result = await TfliteTextClassification().classifyText(
  params: TextClassifierParams params = TextClassifierParams(
    text: 'aaj me bahut khush hu',
    modelPath:
    'path/mobilebert.tflite',
    modelType: ModelType.mobileBert,
    delegate: 0,
  ),
);
```

## For Example Code

To run the example project, download this below model zips and extract them in the assets folder of the example project. I'm providing these sample models separately because of their size.

[Sample Average Word Vec Model.zip](https://github.com/chaudharydeepanshu/tflite_text_classification/files/11517973/Sample.Average.Word.Vec.Model.zip)

[Sample Mobilebert Model.zip](https://github.com/chaudharydeepanshu/tflite_text_classification/files/11517983/Sample.Mobilebert.Model.zip)

The provided models does Hinglish(Common language in India) Text Emotion Classification and are generated using the Tensorflow Lite Model Maker but they are not very accurate and are only here for demonstration purposes. Replace provided model with your own models.
