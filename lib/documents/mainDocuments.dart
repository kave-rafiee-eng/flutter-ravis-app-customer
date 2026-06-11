import 'package:flutter/material.dart';
import 'package:flutter_application_1/documents/models/groupDoc_model.dart';
import 'package:flutter_application_1/documents/screen/selectGroup.dart';
import 'package:flutter_application_1/documents/service/groupDocFronJsonService.dart';
import 'package:flutter_application_1/widgets/LoadingView.dart';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyScrollBehavior(),
      debugShowCheckedModeBanner: false,

      home: LoadDataGroupDocs(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class LoadDataGroupDocs extends ConsumerWidget {
  final GroupDocTypeServiceJosn _service = GroupDocTypeServiceJosn();

  LoadDataGroupDocs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final errorLoad = ref.watch(errorPrivider);

    return FutureBuilder<List<GroupDocType>>(
      future: _service.loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingView();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<GroupDocType> listGroupDoc = snapshot.data!;

        // return Text(listGroupDoc[0].files[0].name.english);
        return Selectgroup(listGroupDoc: listGroupDoc);
      },
    );
  }
}
