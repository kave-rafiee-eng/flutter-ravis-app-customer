import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/menu_model.dart';

class MenuService {
  Future<List<MenuType>> loadMenus() async {
    String jsonString;

    // final directory = await getApplicationDocumentsDirectory();
    // final file = File('${directory.path}/menu_terse.json');
    // if (await file.exists()) {
    //   jsonString = await file.readAsString();
    // } else {
    //   jsonString = await rootBundle.loadString('assets/data/menu_terse.json');
    // }

    jsonString = await rootBundle.loadString('assets/data/menu_terse.json');

    final dynamic jsonData = jsonDecode(jsonString);

    if (jsonData is List) {
      return jsonData.map((item) => MenuType.fromJson(item)).toList();
    } else {
      return [MenuType.fromJson(jsonData)];
    }
  }
}
