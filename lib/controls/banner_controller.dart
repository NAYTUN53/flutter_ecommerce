import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_variables.dart';
import '../models/banner_model.dart';

class BannerController {
  Future<List<BannerModel>> loadBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/banner"),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();
        return banners;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Failed to load Banners");
      }
    } catch (e) {
      throw Exception("Failed to load banners $e");
    }
  }
}
