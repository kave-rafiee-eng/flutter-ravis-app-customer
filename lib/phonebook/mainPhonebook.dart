import 'package:flutter/material.dart';
import 'package:flutter_application_1/phonebook/model/phonebook_model.dart';
import 'package:flutter_application_1/phonebook/screen/phoneBookList.dart';
import 'package:flutter_application_1/phonebook/service/phonebookFromJsonService.dart';
import 'package:flutter_application_1/widgets/LoadingView.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadDataPhonebook extends ConsumerWidget {
  final Phonebookfromjsonservice _service = Phonebookfromjsonservice();

  LoadDataPhonebook({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final errorLoad = ref.watch(errorPrivider);

    return FutureBuilder<List<PhonebookType>>(
      future: _service.loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingView();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<PhonebookType> listPhoneBook = snapshot.data!;

        return Phonebooklist(listPhoneBook: listPhoneBook);
      },
    );
  }
}
