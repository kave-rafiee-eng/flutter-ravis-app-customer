import 'package:flutter/material.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/lcd_functions.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/show_rendered.dart';
import 'package:flutter_application_1/ravisApp/models/menu_model.dart';

class RendererSettingOneParameterData {
  final SettingOneParameterType item;
  final DescriptionType description;
  late int value;
  late double factor;
  final void Function() onBack;

  RendererSettingOneParameterData({
    required this.onBack,
    required this.item,
    required this.description,
  }) {
    value = item.minValue;
    factor = item.factor == 0
        ? 1.0
        : item.factor > 0
        ? item.factor.toDouble()
        : 1.0 / item.factor.abs();
  }

  double get showValue => (value - 0) * factor - item.addition;
  double get showMin => (item.minValue - 0) * factor - item.addition;
  double get showMax => (item.maxValue - 0) * factor - item.addition;

  SettingOneParameterType get getItem => item;
}

void renderSettingOneParameter(
  LcdFunctions lcd,
  RendererSettingOneParameterData data,
) {
  lcd.fillRect(0, 13, X_PIXELS, Y_PIXELS - 13, false);
  lcd.drawLine(0, 13, X_PIXELS - 1, 13, true);
  lcd.fillRect(0, 14, X_PIXELS, 16, true);
  lcd.print12x15(3, 14, data.item.label, false);

  final showValue = data.showValue;
  lcd.drawNumberWhitRectAroune(10, 35, showValue);
  lcd.lcdPrint(75, 35, true, data.item.unit, 1);

  lcd.drawGauge(5, 58, 50, 8, showValue, data.showMin, data.showMax);
}

class RenderSettingOneParameter extends StatefulWidget {
  final RendererSettingOneParameterData inputData;
  final double cellSize;

  const RenderSettingOneParameter({
    super.key,
    required this.inputData,
    this.cellSize = 2.2,
  });

  @override
  State<RenderSettingOneParameter> createState() =>
      _RenderSettingOneParameterState();
}

class _RenderSettingOneParameterState extends State<RenderSettingOneParameter> {
  late final LcdFunctions _lcdFunctions;

  @override
  void initState() {
    super.initState();
    _lcdFunctions = LcdFunctions();
    _render();
  }

  void _render() {
    renderSettingOneParameter(_lcdFunctions, widget.inputData);
  }

  void _changeValue(int delta) {
    final data = widget.inputData;
    final next = (data.value + delta).clamp(
      data.item.minValue,
      data.item.maxValue,
    );
    if (next == data.value) return;
    setState(() {
      widget.inputData.value = next;
      _render();
    });
  }

  int _holdStep(int repeatCount) {
    if (repeatCount < 8) return 1;
    if (repeatCount < 20) return 5;
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    final buffer = _lcdFunctions.getBuffer();

    return ShowRendered(
      description: 'description',
      buffer: buffer,
      cellSize: widget.cellSize,
      onAdd: (step) => _changeValue(step),
      addHoldStep: _holdStep,
      onRemove: (step) => _changeValue(-step),
      removeHoldStep: _holdStep,
      onDone: (_) {},
      onBack: (_) => widget.inputData.onBack(),
    );
  }
}
