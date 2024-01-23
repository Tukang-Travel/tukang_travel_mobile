import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuktraapp/models/feed_model.dart';
import 'package:tuktraapp/models/pedia_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class RecommendationClient {
  final BuildContext context;
  final Config config;
  final String dataset; // Replace Dataset enum with a String

  RecommendationClient(this.context, this.config, this.dataset);

  final Map<int, PediaModel> candidatesPedia = {};
  final Map<int, FeedModel> candidatesFeed = {};
  Interpreter? tflite;

  void initializeInterpreter(dynamic model) async {
    tflite?.close();
    if (model is Uint8List) {
      tflite = Interpreter.fromBuffer(model);
    } else if (model is File) {
      final List<int> bytes = await model.readAsBytes();
      tflite = Interpreter.fromBuffer(Uint8List.fromList(bytes));
    } else {
      showToast(context, 'Unexpected model type downloaded.');
    }
    print('Model loaded for dataset: $dataset');
  }

  Future<void> loadLocalModel() async {
  try {
    String modelPath;
    switch (dataset) {
      case 'PEDIA':
        modelPath = config.modelPathPedia;
        break;
      case 'FEED':
        modelPath = config.modelPathFeed;
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
}


  Future<void> loadCandidateList() async {
    final collection = dataset == 'PEDIA'
        ? TuktraRepository.getInstance(context).getContentPedia()
        : TuktraRepository.getInstance(context).getContentFeed();

    if(dataset == 'PEDIA'){
      for (final item in collection) {
        candidatesPedia[item.documentId] = item;
      }
    }
    else{

    }
    print('Candidate list loaded.');
  }

  Future<void> load() async {
    await downloadRemoteModel();
    await loadLocalModel();
    await loadCandidateList();
  }

  void unload() {
    tflite?.close();
    candidatesPedia.clear();
    candidatesFeed.clear();
  }

  Future<List<Result>> recommend(List<Pedia> selectedPedias) async {
    final inputs = [await preprocess(selectedPedias)];

    final outputIds = List.filled(config.outputLength, 0);
    final confidences = List.filled(config.outputLength, 0.0);
    final outputs = {
      config.outputIdsIndex: outputIds,
      config.outputScoresIndex: confidences,
    };

    try {
      tflite?.runForMultipleInputsOutputs(inputs, outputs);
      return postprocess(outputIds, confidences, selectedPedias);
    } catch (e) {
      print('Error running inference: $e');
      return [];
    }
  }

  Future<List<int>> preprocess(List<Pedia> selectedPedias) async {
    final inputContext = List.filled(config.inputLength, 0);

    for (var i = 0; i < config.inputLength; i++) {
      if (i < selectedPedias.length) {
        final id = selectedPedias[i].id;
        inputContext[i] = id;
      } else {
        inputContext[i] = config.pad;
      }
    }

    return inputContext;
  }

  Future<List<Result>> postprocess(
      List<int> outputIds, List<double> confidences, List<Pedia> selectedPedias) async {
    final results = <Result>[];

    for (var i = 0; i < outputIds.length; i++) {
      if (results.length >= config.topK) {
        print('Selected top K: ${config.topK}. Ignore the rest.');
        break;
      }

      final id = outputIds[i];
      final item = candidates[id];

      if (item == null) {
        print('Inference output[$i]. Id: $id is null');
        continue;
      }

      if (selectedPedias.contains(item)) {
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
    await downloadModel(dataset == 'PEDIA'
        ? 'pedia_recommendations'
        : 'feed_recommendations');
  }

  Future<void> downloadModel(String modelName) async {
    final conditions = CustomModelDownloadConditions(
      wifiRequired: true,
    );

    try {
      final model = await FirebaseModelDownloader.instance
          .getModel(modelName, DownloadType.localModel, conditions);

      showToast(context, 'Downloaded remote model: $modelName');
      await initializeInterpreter(model);
    } catch (e) {
      showToast(context,
          'Model download failed for recommendations, please check your connection.');
    }
  }

  static const String TAG = 'RecommendationClient';
}

class Config {
  String modelPathPedia = 'pedia_recommendations';
  String modelPathFeed = 'feed_recommendations';
  int inputLength = 0;
  int pad = 0;
  int outputLength = 0;
  int topK = 0;
  int outputIdsIndex = 0;
  int outputScoresIndex = 0;
}

class Result {
  final int id;
  final Pedia item;
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

class Pedia {
  // Your Pedia class implementation
}

class TuktraRepository {
  static TuktraRepository _instance = TuktraRepository._();

  TuktraRepository._();

  factory TuktraRepository.getInstance(BuildContext context) => _instance;

  List<Pedia> getContentPedia() {
    // Your implementation for getting content for PEDIA dataset
    return [];
  }

  List<Pedia> getContentFeed() {
    // Your implementation for getting content for FEED dataset
    return [];
  }
}

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
