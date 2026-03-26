import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Model/gamelobby_Model.dart';

class GamelobbyController extends GetxController {
  var isLoading = true.obs;
  var isMoreLoading = false.obs;
  var gameList = <GamelobbyModel>[].obs;

  int currentPage = 1;
  bool hasMoreData = true;

  @override
  void onInit() {
    fetchGames();
    super.onInit();
  }

  Future<void> fetchGames({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (isMoreLoading.value || !hasMoreData) return;
      isMoreLoading(true);
    } else {
      isLoading(true);
      currentPage = 1;
      hasMoreData = true;
    }

    try {
      // Logic: Adjust your API URL to accept a page parameter
      final response = await http.get(Uri.parse('https://cdn.coinbet91.com/P65/gamelist/allgames_v2.json'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<GamelobbyModel> newItems = data.map((e) => GamelobbyModel.fromJson(e)).toList();

        if (isLoadMore) {
          gameList.addAll(newItems);
        } else {
          gameList.assignAll(newItems);
        }

        // If the API returns fewer items than a full page (e.g., 10), stop pagination
        if (newItems.length < 10) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Could not load games");
    } finally {
      isLoading(false);
      isMoreLoading(false);
    }
  }
}