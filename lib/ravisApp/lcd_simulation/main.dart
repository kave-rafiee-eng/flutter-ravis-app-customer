import 'package:flutter/material.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/rendre/renderManager.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/rendre/render_setOneParameter.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/rendre/render_setOneSelect.dart';
import 'package:flutter_application_1/ravisApp/models/menu_model.dart';
import 'package:flutter_application_1/ravisApp/service/menu_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TestRenderer(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class LoadDataMenu extends StatelessWidget {
  final MenuService _service = MenuService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MenuType>>(
      future: _service.loadMenus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final menus = snapshot.data!;

        return Rendermanager(menus: menus);
      },
    );
  }
}

//---------------------------------------------

// RendererSettingOneSelectData create_RendererSettingOneSelectData() {
//   final description = DescriptionType(
//     english: 'test',
//     persian: '',
//     arabic: '',
//     turkish: '',
//     russian: '',
//     german: '',
//   );
//   final miniDescription = MiniDescriptionType(english: '', persian: '');
//   final item = SettingOneSelectType(
//     address: 0,
//     options: [
//       OptionType(value: 'op1', description: miniDescription),
//       OptionType(value: 'op2', description: miniDescription),
//       OptionType(value: 'op3', description: miniDescription),
//     ],
//     label: 'type',
//     description: description,
//     additional_description_for_ai_assistant: miniDescription,
//   );
//   return RendererSettingOneSelectData(item: item, description: description)
//     ..value = 0;
// }

// RendererSettingOneParameterData createTestInputData() {
//   final description = DescriptionType(
//     english: 'test',
//     persian: '',
//     arabic: '',
//     turkish: '',
//     russian: '',
//     german: '',
//   );
//   final miniDescription = MiniDescriptionType(english: '', persian: '');
//   final item = SettingOneParameterType(
//     address: 0,
//     addition: 0,
//     unit: 'C',
//     factor: 1,
//     minValue: 0,
//     maxValue: 100,
//     label: 'temp',
//     description: description,
//     additional_description_for_ai_assistant: miniDescription,
//   );
//   return RendererSettingOneParameterData(item: item, description: description)
//     ..value = 45;
// }

class TestRenderer extends StatelessWidget {
  const TestRenderer({super.key});

  @override
  Widget build(BuildContext context) {
    // final inputData = createTestInputData();
    // final inputData = create_RendererSettingOneSelectData();

    return Scaffold(
      appBar: AppBar(title: const Text('BoolGridPainter Demo')),
      // body: Center(child: RenderSettingOneParameter(inputData: inputData)),
      // body: Center(child: RenderSettingOneSelect(inputData: inputData)),
      // body: Center(
      //   child: RenderSubMenu(
      //     inputData: RendererSubMenuData(
      //       submenu: [
      //         ParanetIdLableType(id: '0', label: 'general'),
      //         ParanetIdLableType(id: '1', label: 'advance'),
      //         ParanetIdLableType(id: '2', label: 'floor'),
      //         ParanetIdLableType(id: '3', label: 'monitor'),
      //       ],
      //     ),
      //   ),
      // ),
      body: LoadDataMenu(),
    );
  }
}
