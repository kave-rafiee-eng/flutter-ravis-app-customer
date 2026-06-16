import 'package:flutter/material.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/lcd_simulation/Renderes/RenderMultiGroup.dart';
import 'package:flutter_application_1/lcd_simulation/Renderes/RenderMultiSelect.dart';
import 'package:flutter_application_1/lcd_simulation/Renderes/RenderSetOneSelect.dart';
import 'package:flutter_application_1/lcd_simulation/Renderes/RenderSetOneParameter.dart';
import 'package:flutter_application_1/lcd_simulation/Renderes/RenderSubMenu.dart';
import 'package:flutter_application_1/lcd_simulation/mainLcd.dart';
import 'package:flutter_application_1/lcd_simulation/models/menu_model.dart';

class Rendermanager extends StatefulWidget {
  const Rendermanager({
    super.key,
    required this.menus,
    required this.language,
    required this.board,
  });

  final BoardEnum board;
  final List<MenuType> menus;
  final LanguageEnum language;

  @override
  State<Rendermanager> createState() => _RendermanagerState();
}

List<ParanetIdLableType> findParents(List<MenuType> allMenus, MenuType menu) {
  List<ParanetIdLableType> Parents = [];
  for (var m in allMenus) {
    for (var parentId in m.parentId) {
      if (parentId.id == menu.id) {
        Parents.add(ParanetIdLableType(id: m.id, label: parentId.label));
      }
    }
  }
  return Parents;
}

List<SubMenuVisualValues> findSubMenuVisual(
  List<MenuType> allMenus,
  MenuType menu,
) {
  List<SubMenuVisualValues> result = [];
  for (var m in allMenus) {
    for (var parentId in m.parentId) {
      if (parentId.id == menu.id) {
        DescriptionType description = DescriptionType(
          arabic: '',
          persian: '',
          english: '',
          german: '',
          russian: '',
          turkish: '',
        );
        if (m.type == TypeMenuEnum.settingOnParameter) {
          description = m.data.settingOneParameter!.description;
        } else if (m.type == TypeMenuEnum.settingOnSelect) {
          description = m.data.settingOneSelect!.description;
        } else if (m.type == TypeMenuEnum.settingMultySelect) {
          description = m.data.settingMultySelect!.description;
        } else if (m.type == TypeMenuEnum.submenu) {
          description = m.description;
        } else if (m.type == TypeMenuEnum.settingMultyGroup) {
          description = m.description;
        }
        result.add(
          SubMenuVisualValues(
            id: m.id,
            label: parentId.label,
            description: description,
          ),
        );
      }
    }
  }
  return result;
}

class _RendermanagerState extends State<Rendermanager> {
  String _activeId = '0';

  List<ParanetIdLableType> navList = [];

  @override
  void initState() {
    super.initState();

    final founded = widget.menus.firstWhere(
      (menu) => menu.lable?.toLowerCase() == 'main',
      orElse: () => widget.menus.firstWhere(
        (menu) => menu.parentId.isEmpty,
        orElse: () => widget.menus.first,
      ),
    );

    _activeId = founded.id;
    navList.add(
      ParanetIdLableType(id: founded.id, label: founded.lable ?? 'main'),
    );
  }

  void oneBack() {
    setState(() {
      if (navList.length > 1) {
        navList.removeLast();
        _activeId = navList[navList.length - 1].id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MenuType menuSelected = widget.menus.firstWhere((m) => m.id == _activeId);
    Widget activeWidget = Center(child: Text('not founded.'));

    if (menuSelected.type == TypeMenuEnum.submenu) {
      activeWidget = RenderSubMenu(
        language: widget.language,
        inputData: RendererSubMenuData(
          topBar: menuSelected.lable!,
          description: menuSelected.description,
          handleSelect: (id, name) {
            setState(() {
              _activeId = id;
              navList.add(ParanetIdLableType(id: id, label: name));
            });
          },
          onBack: oneBack,
          submenu: findSubMenuVisual(widget.menus, menuSelected),
        ),
      );
    }

    if (menuSelected.type == TypeMenuEnum.settingOnParameter &&
        menuSelected.data.settingOneParameter != null) {
      activeWidget = RenderSettingOneParameter(
        language: widget.language,
        inputData: RendererSettingOneParameterData(
          topBar: menuSelected.lable!,
          onBack: oneBack,
          item: menuSelected.data.settingOneParameter!,
        ),
      );
    }

    if (menuSelected.type == TypeMenuEnum.settingOnSelect &&
        menuSelected.data.settingOneSelect != null) {
      activeWidget = RenderSettingOneSelect(
        language: widget.language,
        inputData: RendererSettingOneSelectData(
          onBack: oneBack,
          item: menuSelected.data.settingOneSelect!,
        ),
      );
    }

    if (menuSelected.type == TypeMenuEnum.settingMultySelect &&
        menuSelected.data.settingMultySelect != null) {
      activeWidget = RenderSettingMultiSelect(
        language: widget.language,
        inputData: RendererSettingMultiSelectData(
          onBack: oneBack,
          item: menuSelected.data.settingMultySelect!,
        ),
      );
    }

    if (menuSelected.type == TypeMenuEnum.settingMultyGroup &&
        menuSelected.data.settingMultyGroup != null) {
      activeWidget = RenderSettingMultiGroup(
        language: widget.language,
        inputData: RendererSettingMultiGroupData(
          description: menuSelected.description,
          onBack: oneBack,
          items: menuSelected.data.settingMultyGroup!,
          // description: menuSelected.description,
        ),
      );
    }
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          child: Wrap(
            spacing: 4.0,
            // runSpacing: 2.0,
            alignment: WrapAlignment.start,
            children: [
              for (int index = 0; index < navList.length; index++)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      // horizontal: 2,
                      // vertical: 2,
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
                  child: Text(navList[index].label),
                ),
            ],
          ),
        ),
        // const SizedBox(height: 5),
        // Container(
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: Colors.amber,
        //     borderRadius: BorderRadiusGeometry.circular(14),
        //   ),
        //   child: Text(
        //     menuSelected.lable!,
        //     style: TextStyle(fontSize: 24),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        const SizedBox(height: 20),
        Expanded(child: activeWidget),
      ],
    );

    // return activeWidget;
  }
}
