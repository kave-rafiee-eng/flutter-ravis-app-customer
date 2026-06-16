import 'package:flutter/material.dart';
import 'package:flutter_application_1/lcd_simulation/enums/Language_enums.dart';
import 'package:flutter_application_1/lcd_simulation/lcd_functions.dart';
import 'package:flutter_application_1/lcd_simulation/widgets/cardDescription.dart';
import 'package:flutter_application_1/lcd_simulation/widgets/ShowRendered.dart';
import 'package:flutter_application_1/lcd_simulation/widgets/textSelector.dart';
import 'package:flutter_application_1/lcd_simulation/models/menu_model.dart';

class RendererSettingOneSelectData {
  final SettingOneSelectType item;
  late int value;
  final void Function() onBack;

  RendererSettingOneSelectData({required this.onBack, required this.item}) {
    value = 0;
  }

  SettingOneSelectType get getItem => item;
}

void renderSettingOneSelect(
  LcdFunctions lcd,
  RendererSettingOneSelectData data,
) {
  lcd.fillRect(0, 13, X_PIXELS, Y_PIXELS, false);
  lcd.drawLine(0, 13, X_PIXELS, 13, true);
  lcd.fillRect(0, 14, X_PIXELS, 16, true);
  lcd.print12x15(3, 14, data.item.label, false);

  String option = data.item.options[data.value].value;
  int sizeStr = lcd.sizeStr12x15(option);
  int lcdX = ((X_PIXELS - sizeStr) / 2).toInt();
  lcd.print12x15(lcdX + 1, 36, option, true);

  lcd.drawRect(0, 36, X_PIXELS, 16, true);

  lcd.drawCircleScrollBar(data.value, data.item.options.length, 5, 60, 60);
}

class RenderSettingOneSelect extends StatefulWidget {
  final RendererSettingOneSelectData inputData;
  final double cellSize;
  final LanguageEnum language;

  const RenderSettingOneSelect({
    super.key,
    required this.inputData,
    this.cellSize = 2.2,
    required this.language,
  });

  @override
  State<RenderSettingOneSelect> createState() =>
      _RenderSettingOneParameterState();
}

class _RenderSettingOneParameterState extends State<RenderSettingOneSelect> {
  late final LcdFunctions _lcdFunctions;

  @override
  void initState() {
    super.initState();
    _lcdFunctions = LcdFunctions();
    _render();
  }

  void _render() {
    renderSettingOneSelect(_lcdFunctions, widget.inputData);
  }

  void _changeValue(int delta) {
    final data = widget.inputData;
    final next = (data.value + delta).clamp(0, data.item.options.length - 1);
    if (next == data.value) return;
    setState(() {
      widget.inputData.value = next;
      _render();
    });
  }

  @override
  Widget build(BuildContext context) {
    final buffer = _lcdFunctions.getBuffer();

    final data = widget.inputData;

    List<CarouselItem> descriptions = [];

    descriptions.add(
      CarouselItem(
        title: 'توضیح منو',
        content: extranctDescription(
          widget.language,
          widget.inputData.item.description,
        ),
        textDir: claculateTextDir(widget.language),
      ),
    );

    descriptions.add(
      CarouselItem(
        title: data.item.options[data.value].value,
        content: data.item.options[data.value].description.persian,
        textDir: TextDirection.rtl,
      ),
    );

    return Column(
      children: [
        ShowRendered(
          // language: LanguageEnum.english,
          // description: widget.inputData.description,
          buffer: buffer,
          cellSize: widget.cellSize,
          onAdd: (step) => _changeValue(1),
          onRemove: (step) => _changeValue(-1),
          onDone: (_) {},
          onBack: (_) => widget.inputData.onBack(),
        ),
        Expanded(child: TextCarousel(items: descriptions)),
      ],
    );
  }
}
