import 'package:flutter/material.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/enum.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/lcdBuffer.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/lcd_functions.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/cardDescription.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/show_rendered.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/textSelector.dart';
import 'package:flutter_application_1/ravisApp/models/menu_model.dart';
import 'dart:async';

class RendererSettingMultiGroupData {
  final List<SettingMultyGroupType> items;
  final DescriptionType description;
  late List<int> values;
  final void Function() onBack;

  late int groupIndex;
  late int groupOffset;

  late int itemIndex;
  late int itemOffset;

  late bool grupSelected;
  late int grupSelectedIndex;

  late int slowBlink;

  late bool refreshF;

  late bool itemSelected;

  RendererSettingMultiGroupData({
    required this.onBack,
    required this.items,
    required this.description,
  }) {
    values = List.filled(items.length * 12, 0);
    groupIndex = 0;
    groupOffset = 0;
    grupSelected = false;
    grupSelectedIndex = 0;
    slowBlink = 0;
    itemIndex = 0;
    itemOffset = 0;
    refreshF = false;
    itemSelected = false;
  }

  List<SettingMultyGroupType> get getItem => items;
}

const menuVisibleItems = 3;

void _renderSelectGroup(LcdFunctions lcd, RendererSettingMultiGroupData data) {
  var items = data.getItem;
  if (data.groupIndex >= items.length) {
    data.groupIndex = items.length - 1;
  }

  if (data.groupIndex > (data.groupOffset + menuVisibleItems - 1)) {
    data.groupOffset++;
  }

  if (data.groupIndex < data.groupOffset) {
    data.groupOffset--;
  }

  data.groupOffset = (data.groupOffset < 0) ? 0 : data.groupOffset;

  lcd.fillRect(0, 13, X_PIXELS, Y_PIXELS, false); // Clear Page
  lcd.drawLine(0, 13, X_PIXELS, 13, true); // Line

  for (int i = 0; i < menuVisibleItems && i < items.length; i++) {
    int y = i * 17 + 19;

    String label = "x ${data.groupOffset + i + 1}";

    int lcdX = ((X_PIXELS - lcd.sizeStr12x15(label)) / 2).toInt();
    lcd.print12x15(lcdX, y, label, true);

    if (data.groupOffset + i == data.groupIndex) {
      lcd.drawRoundedRect(0, y - 2, 90, 16, 5, true);
    }
  }

  lcd.drawScrollBar(data.groupOffset, items.length, menuVisibleItems);
}

void _renderGroupSetting(LcdFunctions lcd, RendererSettingMultiGroupData data) {
  var items = data.getItem;
  int totalItems = items.length;

  if (data.itemIndex >= totalItems) data.itemIndex = totalItems - 1;

  if (data.itemIndex > (data.itemOffset + menuVisibleItems - 1)) {
    data.itemOffset++;
  }
  if (data.itemIndex < data.itemOffset) {
    data.itemOffset--;
  }

  data.itemOffset = (data.itemOffset < 0) ? 0 : data.itemOffset;

  lcd.fillRect(0, 13, X_PIXELS, Y_PIXELS, false); // Clear Page
  lcd.drawLine(0, 13, X_PIXELS, 13, false); // Line

  if (data.refreshF) {
    data.refreshF = false;
    data.slowBlink++;
    // print('slowBlink ${data.slowBlink}');
  }
  bool blink = false;
  if (data.slowBlink > 3) data.slowBlink = 0;
  if (data.slowBlink > 2) {
    blink = true;
  }

  for (int i = 0; i < menuVisibleItems && i < totalItems - 1; i++) {
    int y = i * 17 + 19;

    var item = items[data.itemOffset + i];
    if (item.settingOneParameter != null) {
      var settingOneParameter = item.settingOneParameter!;
      int addition = settingOneParameter.addition;
      // int offset = settingOneParameter;
      double factor = settingOneParameter.factor.toDouble();
      if (factor == 0) factor = 1;

      if (factor < 0) {
        factor = 1 / (factor * -1);
      }

      // String stringUnit = settingOneParameter.unit;

      String stringLabel = settingOneParameter.label;
      int strLabelSize = lcd.sizeStr12x15(stringLabel);

      int value = data.values[data.itemOffset + i + 1 + data.groupIndex * 12];

      String stringValue;
      if (factor < 1) {
        double valueFloat = (value - 0) * factor - addition;
        stringValue = valueFloat.toStringAsFixed(2);
      } else {
        int value16 = ((value - 0) * factor - addition).toInt();
        stringValue = value16.toString();
      }

      int stringSize = lcd.sizeStr12x15(stringValue);
      int lcdX = X_PIXELS - stringSize - 10;

      int totalSize = strLabelSize + stringSize + 15;

      if (data.itemOffset + i == data.itemIndex) {
        if (data.itemSelected) {
          if (totalSize < X_PIXELS) {
            lcd.print12x15(2, y - 2, stringLabel, true);
          }
          lcd.fillRoundRect(lcdX - 5, y - 4, stringSize + 10, 16, 5, true);
          lcd.print12x15(lcdX, y - 2, stringValue, false);
        } else {
          if (totalSize < X_PIXELS) {
            lcd.print12x15(2, y - 2, stringLabel, true);
            lcd.print12x15(lcdX, y - 2, stringValue, true);
          } else {
            if (blink) {
              lcd.print12x15(2, y - 2, stringLabel, true);
            }
            if (!blink) {
              lcd.print12x15(lcdX, y - 2, stringValue, true);
            }
          }
        }

        lcd.drawLine(0, y + 11, 90, y + 11, true);
      } else {
        if (totalSize < X_PIXELS) {
          lcd.print12x15(2, y - 2, stringLabel, true);
          lcd.print12x15(lcdX, y - 2, stringValue, true);
        } else {
          if (blink) lcd.print12x15(2, y - 2, stringLabel, true);
          if (!blink) lcd.print12x15(lcdX, y - 2, stringValue, true);
        }
      }
    } else if (item.settingOneSelect != null) {
      var settingOneSelect = item.settingOneSelect!;

      String stringLabel = settingOneSelect.label;
      int strLabelSize = lcd.sizeStr12x15(stringLabel);

      int value = data.values[data.itemOffset + i + 1 + data.groupIndex * 12];
      int numOfOpstion = settingOneSelect.options.length;

      if (value > numOfOpstion - 1) value = numOfOpstion - 1;
      String stringValue = settingOneSelect.options[value].value;

      int stringSize = lcd.sizeStr12x15(stringValue);
      int lcdX = X_PIXELS - stringSize - 10;

      int totalSize = strLabelSize + stringSize + 10;

      if (data.itemOffset + i == data.itemIndex) {
        if (data.itemSelected) {
          if (totalSize < X_PIXELS) lcd.print12x15(2, y - 2, stringLabel, true);
          lcd.fillRoundRect(lcdX - 5, y - 4, stringSize + 10, 16, 5, true);
          lcd.print12x15(lcdX, y - 2, stringValue, false);
        } else {
          if (totalSize < X_PIXELS) {
            lcd.print12x15(2, y - 2, stringLabel, true);
            lcd.print12x15(lcdX, y - 2, stringValue, true);
          } else {
            if (!blink) lcd.print12x15(2, y - 2, stringLabel, true);
            if (blink) lcd.print12x15(lcdX, y - 2, stringValue, true);
          }
          lcd.drawLine(0, y + 11, 90, y + 11, true);
        }
      } else {
        if (totalSize < X_PIXELS) {
          lcd.print12x15(2, y - 2, stringLabel, true);
          lcd.print12x15(lcdX, y - 2, stringValue, true);
        } else {
          if (!blink) lcd.print12x15(2, y - 2, stringLabel, true);
          if (blink) lcd.print12x15(lcdX, y - 2, stringValue, true);
        }
      }
    }
  }

  lcd.drawScrollBar(data.itemOffset, totalItems, menuVisibleItems);
}

void _renderLcd(LcdFunctions lcd, RendererSettingMultiGroupData data) {
  if (data.grupSelected) {
    _renderGroupSetting(lcd, data);
  } else {
    _renderSelectGroup(lcd, data);
  }
}

class RenderSettingMultiGroup extends StatefulWidget {
  final RendererSettingMultiGroupData inputData;
  final double cellSize;
  final LanguageEnum language;

  const RenderSettingMultiGroup({
    super.key,
    required this.inputData,
    this.cellSize = 2.2,
    required this.language,
  });

  @override
  State<RenderSettingMultiGroup> createState() =>
      _RenderSettingMultiGroupState();
}

class _RenderSettingMultiGroupState extends State<RenderSettingMultiGroup> {
  late final LcdFunctions _lcdFunctions;
  Timer? _slowBlinkTimer;

  void _startSlowBlink() {
    _slowBlinkTimer?.cancel();
    _slowBlinkTimer = Timer.periodic(const Duration(milliseconds: 350), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        widget.inputData.refreshF = true;
      });
    });
  }

  @override
  void dispose() {
    _slowBlinkTimer?.cancel();
    _slowBlinkTimer = null;

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _lcdFunctions = LcdFunctions();
    _startSlowBlink();
  }

  void _render() {
    _renderLcd(_lcdFunctions, widget.inputData);
  }

  int getValueActive() {
    var data = widget.inputData;
    return data.values[data.itemIndex + 1 + data.groupIndex * 12];
  }

  void setValueActive(int newValue) {
    setState(() {
      var data = widget.inputData;
      data.values[data.itemIndex + 1 + data.groupIndex * 12] = newValue;
    });
  }

  void _swUp() {
    var data = widget.inputData;
    var items = widget.inputData.getItem;

    if (data.grupSelected) {
      if (!data.itemSelected) {
        if (data.itemIndex > 0) {
          setState(() {
            data.itemIndex--;
          });
        }
      } else {
        var activeItem = items[data.itemIndex];
        if (activeItem.settingOneSelect != null) {
          var settingOneSelect = activeItem.settingOneSelect!;

          int temp = getValueActive();
          int numOfOpstion = settingOneSelect.options.length;
          if (temp < numOfOpstion - 1) {
            temp++;
          } else {
            temp = numOfOpstion - 1;
          }
          setValueActive(temp);
        }

        if (activeItem.settingOneParameter != null) {
          var settingOneParameter = activeItem.settingOneParameter!;

          int temp = getValueActive();
          int max = settingOneParameter.maxValue;

          if (temp < max) {
            temp++;
          } else {
            temp = max;
          }
          setValueActive(temp);
        }
      }
    } else {
      if (data.groupIndex > 0) {
        setState(() {
          data.groupIndex--;
        });
      }
    }
  }

  void _swDn() {
    var data = widget.inputData;
    var items = widget.inputData.getItem;

    if (data.grupSelected) {
      if (!data.itemSelected) {
        if (items.length > data.itemIndex - 1) {
          setState(() {
            data.itemIndex++;
          });
        }
      } else {
        var activeItem = items[data.itemIndex];

        if (activeItem.settingOneSelect != null) {
          var settingOneSelect = activeItem.settingOneSelect!;

          int temp = getValueActive();

          int numOfOpstion = settingOneSelect.options.length;
          if (temp > numOfOpstion - 1) {
            temp = numOfOpstion - 1;
          }
          if (temp > 0) {
            temp--;
          } else {
            temp = 0;
          }
          setValueActive(temp);
        }

        if (activeItem.settingOneParameter != null) {
          var settingOneParameter = activeItem.settingOneParameter!;
          int temp = getValueActive();
          int min = (settingOneParameter.minValue);
          if (temp > min) {
            temp--;
          } else {
            temp = min;
          }

          setValueActive(temp);
        }
      }
    } else {
      if (items.length > data.groupIndex - 1) {
        setState(() {
          data.groupIndex++;
        });
      }
    }
  }

  void _swOk() {
    var data = widget.inputData;
    if (data.grupSelected) {
      setState(() {
        data.itemSelected = !data.itemSelected;
      });
    } else {
      setState(() {
        data.grupSelected = true;
      });
    }
  }

  void _swExt() {
    var data = widget.inputData;
    // var items = widget.inputData.getItem;

    if (data.grupSelected) {
      if (data.itemSelected) {
        setState(() {
          data.itemSelected = false;
        });
      } else {
        data.onBack();
      }
    } else {
      data.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    _render();
    final buffer = _lcdFunctions.getBuffer();

    var data = widget.inputData;
    var items = widget.inputData.getItem;

    List<CarouselItem> descriptions = [];

    if (data.grupSelected) {
      var activeItem = items[data.itemIndex];

      if (activeItem.settingOneParameter != null) {
        var settingOneParameter = activeItem.settingOneParameter!;
        descriptions.add(
          CarouselItem(
            title: settingOneParameter.label,
            content: extranctDescription(
              widget.language,
              settingOneParameter.description,
            ),
          ),
        );
      }

      if (activeItem.settingOneSelect != null) {
        var settingOneSelect = activeItem.settingOneSelect!;
        descriptions.add(
          CarouselItem(
            title: settingOneSelect.label,
            content: extranctDescription(
              widget.language,
              settingOneSelect.description,
            ),
          ),
        );

        descriptions.add(
          CarouselItem(
            title: settingOneSelect.options[getValueActive()].value,
            content:
                settingOneSelect.options[getValueActive()].description.persian,
          ),
        );
      }
    } else {
      descriptions.add(
        CarouselItem(
          title: 'توضیح منو',
          content: extranctDescription(
            widget.language,
            widget.inputData.description,
          ),
        ),
      );
    }

    LcdBuffer newBuf = buffer.copy();

    return Column(
      children: [
        ShowRendered(
          // language: LanguageEnum.english,
          // description: widget.inputData.description,
          buffer: newBuf,
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
