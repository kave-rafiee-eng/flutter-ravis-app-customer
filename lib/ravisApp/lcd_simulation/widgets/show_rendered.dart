import 'package:flutter/material.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/GridPainter.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/enum.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/lcdBuffer.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/cardDescription.dart';
import 'package:flutter_application_1/ravisApp/lcd_simulation/widgets/fastAdjustButton.dart';
import 'package:flutter_application_1/ravisApp/models/menu_model.dart';

class ShowRendered extends StatelessWidget {
  // final LanguageEnum language;
  // final DescriptionType description;
  final LcdBuffer buffer;
  final double cellSize;
  final void Function(int step) onAdd;
  final void Function(int step) onRemove;
  final void Function(int step) onDone;
  final void Function(int step) onBack;
  final int Function(int repeatCount)? addHoldStep;
  final int Function(int repeatCount)? removeHoldStep;
  final Color trueColor;
  final Color falseColor;
  final Color borderColor;

  const ShowRendered({
    super.key,
    // required this.language,
    // required this.description,
    required this.buffer,
    required this.onAdd,
    required this.onRemove,
    required this.onDone,
    required this.onBack,
    this.cellSize = 2.2,
    this.addHoldStep,
    this.removeHoldStep,
    this.trueColor = const Color.fromARGB(255, 39, 58, 100),
    this.falseColor = const Color.fromARGB(255, 235, 234, 234),
    this.borderColor = const Color.fromARGB(255, 41, 10, 10),
  });

  @override
  Widget build(BuildContext context) {
    final w = buffer.cols * cellSize;
    final h = buffer.rows * cellSize;
    final panelHeight = h + 45;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // CardDescription(description: description, language: language),
        // const SizedBox(height: 20),
        SizedBox(
          width: w + 30,
          height: panelHeight,
          child: CustomPaint(
            painter: BoolGridPainter(
              lcdbuffer: buffer,
              cellSize: cellSize,
              trueColor: trueColor,
              falseColor: falseColor,
              borderColor: borderColor,
            ),
          ),
        ),

        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SimpleAdjustButton(
              icon: Icons.add,
              onStep: onAdd,
              holdStep: addHoldStep,
            ),
            SimpleAdjustButton(
              icon: Icons.remove,
              onStep: onRemove,
              holdStep: removeHoldStep,
            ),
            SimpleAdjustButton(icon: Icons.done, onStep: onDone),
            SimpleAdjustButton(icon: Icons.exit_to_app, onStep: onBack),
          ],
        ),
      ],
    );
  }
}
