import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tuktraapp/services/user_service.dart';
import 'package:tuktraapp/utils/alert.dart';
import 'package:tuktraapp/utils/recommendation_config.dart';
import 'package:collection/collection.dart';

class RecommendationService {
  late BuildContext context;
  String dataset = ""; // Replace Dataset enum with a String

  final Map<int, Map<String, dynamic>> candidatesFeed = {};

  Map<int, Map<String, dynamic>> tagsData = {};

  Interpreter? tflite;

  Future<void> load(BuildContext context) async {
    this.context = context;
    await downloadRemoteModel();
    // await loadLocalModel();
    await loadCandidateList();
    await loadTagsDataset();
  }

  Future<void> downloadRemoteModel() async {
    await downloadModel(RecommendationConfig().modelPath);
  }

  Future<void> downloadModel(String modelName) async {
    final conditions = FirebaseModelDownloadConditions(
      androidWifiRequired: true,
      iosAllowsCellularAccess: true,
    );

    try {
      final model = await FirebaseModelDownloader.instance.getModel(
          modelName, FirebaseModelDownloadType.localModel, conditions);

      await initializeInterpreter(model);
    } catch (e) {
      if (context.mounted) {
        Alert.alertValidation(
            "Gagal Mendapatkan Rekomendasi Feeds Untuk Kamu, Harap cek Koneksi internetmu ya.",
            context);
      }
    }
  }

  Future<void> loadCandidateList() async {
    final QuerySnapshot<Map<String, dynamic>> feedsSnapshot =
        await FirebaseFirestore.instance.collection('feeds').get();

    List<Map<String, dynamic>> feeds = feedsSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> document) {
      return document.data();
    }).toList();

    for (var item in feeds) {
      int index = feeds.indexOf(item);
      candidatesFeed[index] = item;
    }

    // print('tes $candidatesFeed');

    print('Candidate list loaded.');
  }

  Future<void> initializeInterpreter(dynamic model) async {
    try {
      tflite?.close();

      // Initialize the TFLite interpreter
      tflite = Interpreter.fromFile(model.file);

      print('Model loaded for dataset: $dataset');
      print('tflite is $tflite');
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

  Future<void> loadTagsDataset() async {
    final contents = await DefaultAssetBundle.of(context)
        .loadString('asset/data/tags_dataset.csv');
    var csvData = const CsvToListConverter().convert(contents);

    if (csvData.isNotEmpty) {
      csvData = csvData.sublist(1);
    }

    // Populate the map with data from the CSV
    for (var row in csvData) {
      int placeId = row[0];
      List<String> tags =
          (row[2] as String).split(',').map((tag) => tag.trim()).toList();
      String city = row[3];
      double rating = double.tryParse(row[4].toString())!;
      Map<String, dynamic> rowData = {
        'placeName': row[1],
        'tags': tags,
        'city': city,
        'rating': rating,
      };
      tagsData[placeId] = rowData;
    }
  }

  Future<Map<String, int>> countTags(
      List<Map<String, dynamic>> likeFeed) async {
    // Initialize a map to store tag counts
    Map<String, int> tagCounts = {};

    // Get user interest tags asynchronously
    List<String> userInterestTags = await UserService().getUserPreference();

    // Iterate through each item in the likeFeed
    likeFeed.forEach((feed) {
      // Extract the tags from the current item
      List<String> tags = List<String>.from(feed['tags']);

      // Update the tagCounts map with the occurrences of each tag
      tags.forEach((tag) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      });
    });

    // Iterate through userInterestTags and update the tagCounts map
    userInterestTags.forEach((tag) {
      tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
    });

    // Sort the tagCounts map in descending order based on the count
    var sortedTagCounts = Map.fromEntries(
        tagCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)));

    return sortedTagCounts;
  }

  List<int> findDataMatchingTags(Map<String, int> sortedCountTags) {
    // Convert sortedCountTags keys to uppercase
    final uppercaseSortedCountTags =
        sortedCountTags.map((key, value) => MapEntry(key.toUpperCase(), value));

    // Initialize a map to store the occurrence count of tags in each entry
    Map<int, int> entryOccurrenceCounts = {};

    // Iterate over tagsData and find entries matching sortedCountTags
    tagsData.forEach((placeId, entry) {
      List<String> entryTags = (entry['tags'] as List<dynamic>)
          .map((tag) => tag.toString().toUpperCase())
          .toList();

      bool containsAnyTag = uppercaseSortedCountTags.entries.any((entry) {
        return entryTags.contains(entry.key.toUpperCase());
      });

      // Check if the entry contains any tag from uppercaseSortedCountTags
      if (containsAnyTag) {
        // Calculate the occurrence count of tags from sortedCountTags in the entry
        int occurrenceCount = sortedCountTags.entries
            .fold(0, (count, entry) => count + entry.value);

        // Store the occurrence count of tags in the entry
        entryOccurrenceCounts[placeId] = occurrenceCount;
      }
    });

    // Sort entries based on the occurrence count of tags
    var sortedEntries = entryOccurrenceCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Get the top 10 entries
    var top10Entries = sortedEntries.take(10);

    List<int> dataToPredict = [];

    // Print or process the top 10 entries
    top10Entries.forEach((entry) {
      dataToPredict.add(entry.key);
    });

    return dataToPredict;
  }

  Future<List<int>> recommend(List<Map<String, dynamic>> likeFeed) async {
    try {
      if(likeFeed.isNotEmpty) {
      Map<String, int> tagCount = await countTags(likeFeed);

      List<int> inputRaw = findDataMatchingTags(tagCount);

      // Preprocess the input data
      final inputs = [await preprocess(inputRaw)];

      // Initialize lists for output results
      final outputIds = List.filled(RecommendationConfig().outputLength, 0);
      final confidences = List.filled(RecommendationConfig().outputLength, 0.0);
      final outputs = {
        RecommendationConfig().outputIdsIndex: outputIds,
        RecommendationConfig().outputScoresIndex: confidences,
      };

      // Print information about input tensors before running inference
      // print('Before results: ${inputs}');

      // Run inference with TensorFlow Lite
      tflite?.runForMultipleInputs(inputs, outputs);

      // Debugging: Print intermediate values for further inspection
      // print('Intermediate values - outputIds: $outputIds, confidences: $confidences');

      // Print the results of the inference
      // print('Inference results: $outputs');

      // Postprocess the results and return them

      var result = await postprocess(outputIds, confidences, likeFeed);

      result.sort((a, b) => b.confidence.compareTo(a.confidence));

      print(result);

      return result.map((r) => r.id).toList();
      } else {
        return [];
      }
    } catch (e) {
      // Handle errors during inference
      print('Error running inference: $e');
      return [];
    }
  }

  Future<List<int>> preprocess(List<int> likeFeed) async {
    final inputContext = List.filled(RecommendationConfig().inputLength, 0);

    for (var i = 0; i < RecommendationConfig().inputLength; i++) {
      if (i < likeFeed.length) {
        final id = likeFeed[i];
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
        // print('Selected top K: ${RecommendationConfig().topK}. Ignore the rest.');
        break;
      }

      final id = outputIds[i];
      final item = candidatesFeed[id];

      if (item == null) {
        // print('Inference output[$i]. Id: $id is null');
        continue;
      }

      print('ini id $id');

      // Check if the item is in likeFeed based on its contents
      final containsItem = likeFeed.any((likedItem) {
        // Compare map contents instead of references

        print('ini like -> ${likedItem["docId"].runtimeType}');
        print('ini hasil ${likedItem["docId"] == id.toString()}');
        return likedItem["docId"] == id.toString();
      });

      if (containsItem) {
        print('Inference output[$i]. Id: $id is contained');
        continue;
      }

      final result = Result(
        id: id,
        item: item,
        confidence: confidences[i],
      );
      results.add(result);
      // print('Inference output[$i]. Result: $result');
    }

    results.forEach((element) {
      print(element.id);
    });

    return results;
  }

  void unload() {
    tflite?.close();
    candidatesFeed.clear();
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
