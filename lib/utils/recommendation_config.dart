class RecommendationConfig {
  String modelPathPedia = 'pedia_recommendations';
  String modelPathFeed = 'feed_model_recommendations';
  int inputLength = 10;
  int pad = 0;
  int outputLength = 100;
  int topK = 10;
  int outputIdsIndex = 1;
  int outputScoresIndex = 0;
}