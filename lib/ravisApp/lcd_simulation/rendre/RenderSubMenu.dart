import 'package:flutter/material.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/enum.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/lcd_functions.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/cardDescription.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/show_rendered.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/textSelector.dart';
import 'package:flutter_application_1/ravisApp/models/menu_model.dart';

class SubMenuVisualValues {
  final String id;
  final String label;
  final DescriptionType description;

  SubMenuVisualValues({
    required this.id,
    required this.label,
    required this.description,
  });
}

class RendererSubMenuData {
  final String topBar;
  final List<SubMenuVisualValues> submenu;
  final void Function(String id, String name) handleSelect;
  final void Function() onBack;
  final DescriptionType description;
  late int menuIndex;
  late int menuOffset;

  RendererSubMenuData({
    required this.topBar,
    required this.onBack,
    required this.handleSelect,
    required this.submenu,
    required this.description,
  }) {
    menuIndex = 0;
    menuOffset = 0;
  }

  List<SubMenuVisualValues> get getSubmenuList => submenu;
}

void _renderLcd(LcdFunctions lcd, RendererSubMenuData data) {
  const menuVisibleItems = 3;

  if (data.menuIndex == data.submenu.length) {
    data.menuIndex = data.submenu.length - 1;
  }

  if (data.menuIndex > (data.menuOffset + menuVisibleItems - 1)) {
    data.menuOffset++;
  }
  if (data.menuIndex < data.menuOffset) {
    data.menuOffset--;
  }

  lcd.fillRect(0, 13, X_PIXELS, Y_PIXELS, false);

  lcd.drawLine(0, 13, X_PIXELS, 13, true);

  for (int i = 0; i < menuVisibleItems && i < data.submenu.length; i++) {
    int y = i * 17 + 17;

    String text = data.submenu[data.menuOffset + i].label;

    if (data.menuOffset + i == data.menuIndex) {
      lcd.fillRoundRect(0, y - 1, 90, 16, 5, true);
      lcd.print12x15(3, y, text, false);
    } else {
      lcd.print12x15(3, y, text, true);
    }
  }

  lcd.drawScrollBar(data.menuOffset, data.submenu.length, menuVisibleItems);

  lcd.fillRect(0, 0, X_PIXELS, 12, false);
  lcd.lcdPrint(3, 3, true, data.topBar, 1);
}

class RenderSubMenu extends StatefulWidget {
  final RendererSubMenuData inputData;
  final double cellSize;
  final LanguageEnum language;

  const RenderSubMenu({
    super.key,
    required this.inputData,
    this.cellSize = 2.2,
    required this.language,
  });

  @override
  State<RenderSubMenu> createState() => _RenderSubMenuState();
}

class _RenderSubMenuState extends State<RenderSubMenu> {
  late final LcdFunctions _lcdFunctions;

  @override
  void initState() {
    super.initState();
    _lcdFunctions = LcdFunctions();
  }

  void _render() {
    _renderLcd(_lcdFunctions, widget.inputData);
  }

  void _changeValue(int delta) {
    final data = widget.inputData;
    final next = (data.menuIndex + delta).clamp(0, data.submenu.length - 1);
    if (next == data.menuIndex) return;
    setState(() {
      widget.inputData.menuIndex = next;
      _render();
    });
  }

  @override
  Widget build(BuildContext context) {
    _render();
    final data = widget.inputData;

    final buffer = _lcdFunctions.getBuffer();

    String titleMain = 'توضیح منو';
    String contentMain = extranctDescription(
      widget.language,
      widget.inputData.description,
    );

    String titleSelectedMenu = data.submenu[data.menuIndex].label;
    String contentSelectedMenu = extranctDescription(
      widget.language,
      data.submenu[data.menuIndex].description,
    );

    return Column(
      children: [
        ShowRendered(
          buffer: buffer,
          cellSize: widget.cellSize,
          onAdd: (_) => _changeValue(-1),
          onRemove: (_) => _changeValue(1),
          onDone: (_) {
            widget.inputData.handleSelect(
              widget.inputData.submenu[widget.inputData.menuIndex].id,
              widget.inputData.submenu[widget.inputData.menuIndex].label,
            );
          },
          onBack: (_) => widget.inputData.onBack(),
        ),

        Expanded(
          child: TextCarousel(
            items: [
              CarouselItem(title: titleMain, content: contentMain),
              CarouselItem(
                title: titleSelectedMenu,
                content: contentSelectedMenu,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
