import 'package:flutter/material.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/enum.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/lcd_functions.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/cardDescription.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/show_rendered.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/textSelector.dart';
import 'package:flutter_application_1/ravisApp/models/menu_model.dart';

class RendererSettingMultiSelectData {
  final SettingMultySelectType item;
  final DescriptionType description;
  late List<int> values;
  final void Function() onBack;
  late int menuIndex;
  late int menuOffset;
  late bool selected;

  RendererSettingMultiSelectData({
    required this.onBack,
    required this.item,
    required this.description,
  }) {
    values = List.filled(item.itemLabels.length, 0);
    selected = false;
    menuIndex = 0;
    menuOffset = 0;
  }

  SettingMultySelectType get getItem => item;
}

void _renderLcd(LcdFunctions lcd, RendererSettingMultiSelectData data) {
  const menuVisibleItems = 3;

  SettingMultySelectType item = data.getItem;
  int totalItems = item.itemLabels.length;

  if (data.menuIndex == item.itemLabels.length) {
    data.menuIndex = item.itemLabels.length - 1;
  }
  if (data.menuIndex > (data.menuOffset + menuVisibleItems - 1)) {
    data.menuOffset++;
  }
  if (data.menuIndex < data.menuOffset) {
    data.menuOffset--;
  }
  data.menuOffset = (data.menuOffset < 0) ? 0 : data.menuOffset;

  lcd.fillRect(0, 13, X_PIXELS, Y_PIXELS, false);
  lcd.drawLine(0, 13, X_PIXELS, 13, true);

  for (int i = 0; i < menuVisibleItems && i < totalItems; i++) {
    int y = i * 17 + 19;
    int value = data.values[data.menuOffset + i];

    if (data.menuOffset + i == data.menuIndex) {
      lcd.drawRoundedRect(0, y - 2, 90, 16, 5, true);
      bool color = false;

      if (data.selected) {
        color = false;
        lcd.fillRoundRect(50, y - 2, 40, 16, 5, true);
      } else {
        color = true;
      }

      lcd.print12x15(3, y, item.itemLabels[data.menuOffset + i].value, true);
      lcd.print12x15(60, y, item.options[value].value, color);
    } else {
      lcd.print12x15(3, y, item.itemLabels[data.menuOffset + i].value, true);

      lcd.print12x15(60, y, item.options[value].value, true);
    }
  }

  lcd.drawScrollBar(data.menuOffset, totalItems, menuVisibleItems);
}

class RenderSettingMultiSelect extends StatefulWidget {
  final RendererSettingMultiSelectData inputData;
  final double cellSize;
  final LanguageEnum language;

  const RenderSettingMultiSelect({
    super.key,
    required this.inputData,
    this.cellSize = 2.2,
    required this.language,
  });

  @override
  State<RenderSettingMultiSelect> createState() =>
      _RenderSettingMultiSelectState();
}

class _RenderSettingMultiSelectState extends State<RenderSettingMultiSelect> {
  late final LcdFunctions _lcdFunctions;

  @override
  void initState() {
    super.initState();
    _lcdFunctions = LcdFunctions();
  }

  void _render() {
    _renderLcd(_lcdFunctions, widget.inputData);
  }

  void _swUp() {
    setState(() {
      SettingMultySelectType item = widget.inputData.getItem;
      RendererSettingMultiSelectData data = widget.inputData;

      if (!data.selected) {
        if (data.menuIndex > 0) data.menuIndex--;
      } else {
        int value = data.values[data.menuIndex];
        // Try to find next available option
        int numOfOptions = item.options.length;
        int totalItems = item.itemLabels.length;
        for (int i = 0; i < numOfOptions; i++) {
          value = (value + 1) % numOfOptions;

          bool used = false;
          for (int j = 0; j < totalItems; j++) {
            if (j != data.menuIndex && data.values[j] == value) {
              used = true;
              break;
            }
          }

          if (!used || value == 0) break;
        }

        data.values[data.menuIndex] = value;
      }
    });
  }

  void _swDn() {
    setState(() {
      SettingMultySelectType item = widget.inputData.getItem;
      RendererSettingMultiSelectData data = widget.inputData;

      if (!data.selected) {
        if (data.menuIndex > data.menuIndex - 1) data.menuIndex++;
      } else {
        int value = data.values[data.menuIndex];
        // Try to find next available option
        int numOfOptions = item.options.length;
        int totalItems = item.itemLabels.length;
        for (int i = 0; i < numOfOptions; i++) {
          value = (value == 0) ? numOfOptions - 1 : value - 1;

          bool used = false;
          for (int j = 0; j < totalItems; j++) {
            if (j != data.menuIndex && data.values[j] == value) {
              used = true;
              break;
            }
          }

          if (!used || value == 0) break;
        }

        data.values[data.menuIndex] = 2;
      }
    });
  }

  void _swOk() {
    RendererSettingMultiSelectData data = widget.inputData;

    setState(() {
      data.selected = !data.selected;
    });
  }

  void _swExt() {
    RendererSettingMultiSelectData data = widget.inputData;

    if (data.selected) {
      setState(() {
        data.selected = false;
      });
    } else {
      widget.inputData.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    _render();
    final buffer = _lcdFunctions.getBuffer();

    final data = widget.inputData;

    List<CarouselItem> descriptions = [];

    descriptions.add(
      CarouselItem(
        title: 'توضیح منو',
        content: extranctDescription(
          widget.language,
          widget.inputData.description,
        ),
      ),
    );
    // selcted item
    descriptions.add(
      CarouselItem(
        title: data.item.itemLabels[data.menuIndex].value,
        content: data.item.itemLabels[data.menuIndex].description.persian,
      ),
    );
    // selcted
    descriptions.add(
      CarouselItem(
        title: data.item.options[data.values[data.menuIndex]].value,
        content:
            data.item.options[data.values[data.menuIndex]].description.persian,
      ),
    );

    return Column(
      children: [
        ShowRendered(
          // language: LanguageEnum.english,
          // description: widget.inputData.description,
          buffer: buffer,
          cellSize: widget.cellSize,
          onAdd: (_) {
            _swUp();
          },
          onRemove: (_) {
            _swDn();
          },
          onDone: (_) {
            _swOk();
          },
          onBack: (_) {
            _swExt();
          },
        ),
        Expanded(child: TextCarousel(items: descriptions)),
      ],
    );
  }
}
