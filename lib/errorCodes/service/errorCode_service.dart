import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/errorCode_model.dart';

class ErrorCodeServiceJosn {
  Future<List<ErrorCodeType>> loadMenus() async {
    String jsonString;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/errorCodes.json');
    if (await file.exists()) {
      jsonString = await file.readAsString();
    } else {
      jsonString = await rootBundle.loadString('assets/data/errorCodes.json');
    }

    final dynamic jsonData = jsonDecode(jsonString);

    if (jsonData is List) {
      return jsonData.map((item) => ErrorCodeType.fromJson(item)).toList();
    } else {
      return [ErrorCodeType.fromJson(jsonData)];
    }
  }
}
