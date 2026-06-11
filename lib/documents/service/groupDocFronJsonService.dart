import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_application_1/documents/models/groupDoc_model.dart';

class GroupDocTypeServiceJosn {
  Future<List<GroupDocType>> loadData() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/documents.json',
    );

    final dynamic jsonData = jsonDecode(jsonString);

    if (jsonData is List) {
      return jsonData.map((item) => GroupDocType.fromJson(item)).toList();
    } else {
      return [GroupDocType.fromJson(jsonData)];
    }
  }
}
