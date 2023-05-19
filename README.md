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
