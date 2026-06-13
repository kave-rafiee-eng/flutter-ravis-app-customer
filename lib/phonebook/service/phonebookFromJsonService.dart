import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_application_1/phonebook/model/phonebook_model.dart';
import 'package:path_provider/path_provider.dart';

class Phonebookfromjsonservice {
  Future<List<PhonebookType>> loadData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/phonebook.json');
    String jsonString;

    if (await file.exists()) {
      jsonString = await file.readAsString();
    } else {
      jsonString = await rootBundle.loadString('assets/data/phonebook.json');
    }

    final dynamic jsonData = jsonDecode(jsonString);

    if (jsonData is List) {
      return jsonData.map((item) => PhonebookType.fromJson(item)).toList();
    } else {
      return [PhonebookType.fromJson(jsonData)];
    }
  }
}
