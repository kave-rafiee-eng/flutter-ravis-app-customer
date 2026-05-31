import 'package:flutter/material.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/rendre/render_setOneSelect.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/rendre/render_setOneParameter.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/rendre/render_sunMenu.dart';
import 'package:flutter_application_1/ravisApp/models/menu_model.dart';

class Rendermanager extends StatefulWidget {
  const Rendermanager({super.key, required this.menus});

  final List<MenuType> menus;

  @override
  State<Rendermanager> createState() => _RendermanagerState();
}

List<ParanetIdLableType> findParents(List<MenuType> allMenus, MenuType menu) {
  List<ParanetIdLableType> Parents = [];
  allMenus.forEach((m) {
    m.parentId.forEach((parentId) {
      if (parentId.id == menu.id) {
        Parents.add(ParanetIdLableType(id: m.id, label: parentId.label));
      }
    });
  });
  return Parents;
}

class _RendermanagerState extends State<Rendermanager> {
  String _activeId = '0';

  List<ParanetIdLableType> navList = [
    ParanetIdLableType(id: '0', label: 'main'),
  ];

  void oneBack() {
    setState(() {
      navList.removeLast();
      _activeId = navList[navList.length - 1].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    MenuType menuSelected = widget.menus.firstWhere((m) => m.id == _activeId);
    Widget activeWidget = Center(child: Text('not founded.'));

    if (menuSelected.type == TypeMenuEnum.submenu) {
      activeWidget = RenderSubMenu(
        inputData: RendererSubMenuData(
          handleSelect: (id, name) {
            setState(() {
              _activeId = id;
              navList.add(ParanetIdLableType(id: id, label: name));
            });
          },
          onBack: oneBack,
          submenu: findParents(widget.menus, menuSelected),
        ),
      );
    }

    if (menuSelected.type == TypeMenuEnum.settingOnParameter &&
        menuSelected.data.settingOneParameter != null) {
      activeWidget = RenderSettingOneParameter(
        inputData: RendererSettingOneParameterData(
          onBack: oneBack,
          item: menuSelected.data.settingOneParameter!,
          description: menuSelected.description,
        ),
      );
    }

    if (menuSelected.type == TypeMenuEnum.settingOnSelect &&
        menuSelected.data.settingOneSelect != null) {
      activeWidget = RenderSettingOneSelect(
        inputData: RendererSettingOneSelectData(
          onBack: oneBack,
          item: menuSelected.data.settingOneSelect!,
          description: menuSelected.description,
        ),
      );
    }

    if (menuSelected.type == TypeMenuEnum.settingMultySelect) {}
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.start,
            children: [
              for (int index = 0; index < navList.length; index++)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    backgroundColor: _activeId == navList[index].id
                        ? Colors.blue.withValues(alpha: 0.5)
                        : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _activeId = navList[index].id;
                      navList = navList.sublist(0, index + 1);
                    });
                  },
                  child: Text('${navList[index].label} -> '),
                ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadiusGeometry.circular(14),
          ),
          child: Text(
            menuSelected.lable!,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(child: activeWidget),
      ],
    );

    // return activeWidget;
  }
}
