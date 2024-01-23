import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuktraapp/models/feed_model.dart';
import 'package:tuktraapp/models/pedia_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tuktraapp/services/pedia_service.dart';
import 'package:tuktraapp/utils/recommendation_config.dart';

class RecommendationService {
  late BuildContext context;
  String dataset = ""; // Replace Dataset enum with a String

  final Map<int, PediaModel> candidatesPedia = {};
  final Map<int, Map<String, dynamic>> candidatesFeed = {};
  Interpreter? tflite;

  Future<void> initializeInterpreter(dynamic model) async {
  try {
    tflite?.close();


    // Initialize the TFLite interpreter
    tflite = Interpreter.fromFile(model.file);

    print('Model loaded for dataset: $dataset');
  } catch (e) {
    print('Error initializing interpreter: $e');
  }
}

  /* Future<void> loadLocalModel() async {
    try {
      String modelPath;
      switch (dataset) {
        case 'PEDIA':
          modelPath = RecommendationConfig().modelPathPedia;
          break;
        case 'FEED':
          modelPath = RecommendationConfig().modelPathFeed;
          break;
        default:
          throw Exception('Invalid dataset: $dataset');
      }
      final buffer = await FileUtils.loadModelFile(modelPath);
      initializeInterpreter(buffer);
      print('Model loaded for dataset: $dataset');
    } catch (ioException) {
      print(ioException);
    }
  } */

  Future<void> loadCandidateList() async {
    final QuerySnapshot<Map<String, dynamic>> feedsSnapshot =
        await FirebaseFirestore.instance.collection('feeds').get();

    List<Map<String, dynamic>> feeds = feedsSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> document) {
      return document.data();
    }).toList();

    feeds.forEach((item) {
      int index = feeds.indexOf(item);
      candidatesFeed[index] = item;
    });

    print('Candidate list loaded.');
  }

  Future<void> load(BuildContext context) async {
    this.context = context;
    await downloadRemoteModel();
    // await loadLocalModel();
    await loadCandidateList();
  }

  void unload() {
    tflite?.close();
    candidatesFeed.clear();
  }

  Future<List<Result>> recommend(List<Map<String, dynamic>> likeFeed) async {
    final inputs = [await preprocess(likeFeed)];

    final outputIds = List.filled(RecommendationConfig().outputLength, 0);
    final confidences = List.filled(RecommendationConfig().outputLength, 0.0);
    final outputs = {
      RecommendationConfig().outputIdsIndex: outputIds,
      RecommendationConfig().outputScoresIndex: confidences,
    };

    print(confidences);

    try {
      tflite?.runForMultipleInputs(inputs, outputs);
      return postprocess(outputIds, confidences, likeFeed);
    } catch (e) {
      print('Error running inference: $e');
      return [];
    }
  }

  Future<List<int>> preprocess(List<Map<String, dynamic>> likeFeed) async {
    final inputContext = List.filled(RecommendationConfig().inputLength, 0);

    for (var i = 0; i < RecommendationConfig().inputLength; i++) {
      if (i < likeFeed.length) {
        final id = i;
        inputContext[i] = id;
      } else {
        inputContext[i] = RecommendationConfig().pad;
      }
    }

    return inputContext;
  }

  Future<List<Result>> postprocess(List<int> outputIds,
      List<double> confidences, List<Map<String, dynamic>> likeFeed) async {
    final results = <Result>[];

    for (var i = 0; i < outputIds.length; i++) {
      if (results.length >= RecommendationConfig().topK) {
        print(
            'Selected top K: ${RecommendationConfig().topK}. Ignore the rest.');
        break;
      }

      final id = outputIds[i];
      final item = candidatesFeed[id];

      if (item == null) {
        print('Inference output[$i]. Id: $id is null');
        continue;
      }

      if (likeFeed.contains(item)) {
        print('Inference output[$i]. Id: $id is contained');
        continue;
      }

      final result = Result(
        id: id,
        item: item,
        confidence: confidences[i],
      );
      results.add(result);
      print('Inference output[$i]. Result: $result');
    }

    return results;
  }

  Future<void> downloadRemoteModel() async {
    await downloadModel('feed_recommendations');
  }

  Future<void> downloadModel(String modelName) async {
    final conditions = FirebaseModelDownloadConditions(
      androidWifiRequired: true,
    );

    try {
      final model = await FirebaseModelDownloader.instance.getModel(
          modelName, FirebaseModelDownloadType.localModel, conditions);

      showToast(context, 'Downloaded remote model: $modelName');
      await initializeInterpreter(model);
    } catch (e) {
      print(e);
    }
  }

  static const String TAG = 'RecommendationClient';
}

class Result {
  final int id;
  final Map<String, dynamic> item;
  final double confidence;

  Result({
    required this.id,
    required this.item,
    required this.confidence,
  });

  @override
  String toString() {
    return '[$id] confidence: $confidence, item: $item';
  }
}

class FileUtils {
  static Future<Uint8List> loadModelFile(String modelPath) async {
    // Implementation of loading the model file, use rootBundle.load for assets
    // Example:
    // final ByteData data = await rootBundle.load(modelPath);
    // return data.buffer.asUint8List();
    return Uint8List.fromList([]);
  }
}

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
