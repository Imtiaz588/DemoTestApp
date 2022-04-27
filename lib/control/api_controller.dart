import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movies_dashbord/model/api_data_model.dart';

class ApiController {

  Future<ApiDataModel> getApiData() async {
    const apiUrl =
        'https://api.themoviedb.org/3/search/company?api_key=93adf2f46c9055080f4690b7b3bdd363&query=%20super';
    late ApiDataModel dataModel;
    try {
      http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        dataModel = ApiDataModel.fromJson(jsonMap);
      }
    } on Exception {
      debugPrint("Failed to load data");
    }
    return dataModel;
  }

}