/*
#define X_PIXELS            96
#define Y_PIXELS            68
#define DISPLAY_STR_SIZE    9
#define W                   94
#define H                   66
*/

import 'package:flutter_application_1/lcd_simulation/lcdBuffer.dart';
import 'package:flutter_application_1/lcd_simulation/const_data/font.dart';

const int X_PIXELS = 96;
const int Y_PIXELS = 68;
const int DISPLAY_STR_SIZE = 9;
const int W = 94;
const int H = 66;

const int FONT_WIDTH_12x15 = 12;
const int FONT_HEIGHT_12x15 = 15;

const SCROLLBAR_WIDTH = 3;
const ITEM_HEIGHT = 15;

class FloatResult {
  final int value;
  final int decimals;

  const FloatResult({required this.value, required this.decimals});
}

class LcdFunctions {
  final LcdBuffer lcdbuffer;

  LcdFunctions() : lcdbuffer = LcdBuffer(Y_PIXELS, X_PIXELS);

  LcdBuffer getBuffer() => lcdbuffer;

  void clear() {
    for (int index = 0; index < 864; index++) {
      lcdbuffer.set(index, 0, false);
    }
  }

  void drawPixel(int x, int y, bool color) {
    if ((x < 0) || (x >= X_PIXELS) || (y < 0) || (y >= Y_PIXELS)) return;

    if (color) {
      lcdbuffer.set(y, x, true);
    } else {
      lcdbuffer.set(y, x, false);
    }
  }

  void drawLine(int x0, int y0, int x1, int y1, bool color) {
    final steep = (y1 - y0).abs() > (x1 - x0).abs();
    if (steep) {
      final t0 = x0;
      x0 = y0;
      y0 = t0;
      final t1 = x1;
      x1 = y1;
      y1 = t1;
    }
    if (x0 > x1) {
      final tx = x0;
      x0 = x1;
      x1 = tx;
      final ty = y0;
      y0 = y1;
      y1 = ty;
    }

    final dx = x1 - x0;
    final dy = (y1 - y0).abs();
    var err = dx ~/ 2;
    final ystep = y0 < y1 ? 1 : -1;

    for (; x0 <= x1; x0++) {
      if (steep) {
        drawPixel(y0, x0, color);
      } else {
        drawPixel(x0, y0, color);
      }
      err -= dy;
      if (err < 0) {
        y0 += ystep;
        err += dx;
      }
    }
  }

  void drawFastVLine(int x, int y, int h, bool color) {
    drawLine(x, y, x, y + h - 1, color);
  }

  void drawFastHLine(int x, int y, int w, bool color) {
    drawLine(x, y, x + w - 1, y, color);
  }

  void drawRect(int x, int y, int w, int h, bool color) {
    drawFastHLine(x, y, w, color);
    drawFastHLine(x, y + h - 1, w, color);
    drawFastVLine(x, y, h, color);
    drawFastVLine(x + w - 1, y, h, color);
  }

  void drawCircle(int x0, int y0, int r, bool color) {
    int f = 1 - r;
    int ddfX = 1;
    int ddfY = -2 * r;
    int x = 0;
    int y = r;

    drawPixel(x0, y0 + r, color);
    drawPixel(x0, y0 - r, color);
    drawPixel(x0 + r, y0, color);
    drawPixel(x0 - r, y0, color);

    while (x < y) {
      if (f >= 0) {
        y--;
        ddfY += 2;
        f += ddfY;
      }
      x++;
      ddfX += 2;
      f += ddfX;

      drawPixel(x0 + x, y0 + y, color);
      drawPixel(x0 - x, y0 + y, color);
      drawPixel(x0 + x, y0 - y, color);
      drawPixel(x0 - x, y0 - y, color);
      drawPixel(x0 + y, y0 + x, color);
      drawPixel(x0 - y, y0 + x, color);
      drawPixel(x0 + y, y0 - x, color);
      drawPixel(x0 - y, y0 - x, color);
    }
  }

  void drawRoundedRect(int x, int y, int w, int h, int r, bool color) {
    drawFastHLine(x + r, y, w - 2 * r, color); // Top
    drawFastHLine(x + r, y + h - 1, w - 2 * r, color); // Bottom
    drawFastVLine(x, y + r, h - 2 * r, color); // Left
    drawFastVLine(x + w - 1, y + r, h - 2 * r, color); // Right
    drawCircleHelper(x + r, y + r, r, 1, color);
    drawCircleHelper(x + w - r - 1, y + r, r, 2, color);
    drawCircleHelper(x + w - r - 1, y + h - r - 1, r, 4, color);
    drawCircleHelper(x + r, y + h - r - 1, r, 8, color);
  }

  void drawCircleHelper(int x0, int y0, int r, int cornername, bool color) {
    int f = 1 - r;
    int ddfX = 1;
    int ddfY = -2 * r;
    int x = 0;
    int y = r;
    while (x < y) {
      if (f >= 0) {
        y--;
        ddfY += 2;
        f += ddfY;
      }
      x++;
      ddfX += 2;
      f += ddfX;
      if (cornername & 0x4 != 0) {
        drawPixel(x0 + x, y0 + y, color);
        drawPixel(x0 + y, y0 + x, color);
      }
      if (cornername & 0x2 != 0) {
        drawPixel(x0 + x, y0 - y, color);
        drawPixel(x0 + y, y0 - x, color);
      }
      if (cornername & 0x8 != 0) {
        drawPixel(x0 - y, y0 + x, color);
        drawPixel(x0 - x, y0 + y, color);
      }
      if (cornername & 0x1 != 0) {
        drawPixel(x0 - y, y0 - x, color);
        drawPixel(x0 - x, y0 - y, color);
      }
    }
  }

  void fillCircleHelper(
    int x0,
    int y0,
    int r,
    int cornername,
    int delta,
    bool color,
  ) {
    int f = 1 - r;
    int ddfX = 1;
    int ddfY = -2 * r;
    int x = 0;
    int y = r;

    while (x < y) {
      if (f >= 0) {
        y--;
        ddfY += 2;
        f += ddfY;
      }
      x++;
      ddfX += 2;
      f += ddfX;

      if (cornername & 0x1 != 0) {
        drawFastVLine(x0 + x, y0 - y, 2 * y + 1 + delta, color);
        drawFastVLine(x0 + y, y0 - x, 2 * x + 1 + delta, color);
      }
      if (cornername & 0x2 != 0) {
        drawFastVLine(x0 - x, y0 - y, 2 * y + 1 + delta, color);
        drawFastVLine(x0 - y, y0 - x, 2 * x + 1 + delta, color);
      }
    }
  }

  void fillCircle(int x0, int y0, int r, bool color) {
    drawFastVLine(x0, y0 - r, 2 * r + 1, color);
    fillCircleHelper(x0, y0, r, 3, 0, color);
  }

  void drawChar(int x, int y, bool color, int c, int size) {
    if ((x >= X_PIXELS) || (y >= Y_PIXELS) || ((x + 4) < 0) || ((y + 7) < 0)) {
      return;
    }

    if (c < 128) c = c - 32;
    if (c >= 144 && c <= 175) c = c - 48;
    if (c >= 128 && c <= 143) c = c + 16;
    if (c >= 176 && c <= 191) c = c - 48;
    if (c > 191) return;

    for (int i = 0; i < 5 * size; i += size) {
      int line = 0;
      if (i == 5) {
        line = 0x00;
      } else {
        line = fontSimple[(c * 5) + (i / size).toInt()];
      }

      for (int j = 0; j < 8 * size; j += size) {
        bool pixle = false;
        if (line & 0x1 == 1) {
          pixle = true;
        } else {
          pixle = false;
        }
        if (color == false) pixle = !pixle;

        int k, h;
        for (k = 0; k < size; k++) {
          for (h = 0; h < size; h++) {
            drawPixel(x + i + k, y + j + h, pixle);
          }
        }

        line >>= 1;
      }
    }
  }

  void lcdPrint(int x, int y, bool color, String str, int size) {
    if (str.codeUnitAt(0) >= 128) x -= 3;
    for (int i = 0; i < str.length; i++) {
      int type = str.codeUnitAt(i);
      drawChar(x, y, color, type, size);
      if (type >= 128) {
        x += 3 * size;
      } else {
        x = x + 6 * size;
      }
    }
  }

  void print_1607(int x, int y, bool color, String str) {
    List<int> nPos = [
      0,
      6,
      12,
      18,
      24,
      30,
      36,
      42,
      48,
      54,
      60,
      66,
      72,
      78,
      84,
      90,
    ];
    List<int> nStr = [1, 10, 20, 30, 40, 50, 60];
    lcdPrint(nPos[x], nStr[y], color, str, 1);
  }

  void drawTriangle(
    int x0,
    int y0,
    int x1,
    int y1,
    int x2,
    int y2,
    bool color,
  ) {
    drawLine(x0, y0, x1, y1, color);
    drawLine(x1, y1, x2, y2, color);
    drawLine(x2, y2, x0, y0, color);
  }

  void simb16x32(int x, int y, bool color, int c) {
    for (int k = 0; k < 4; k++) {
      for (int i = 0; i < 16; i++) {
        int line = mass16x32[c][i + k * 16];

        for (int j = 0; j < 8; j++) {
          (line & 0x01 == 1)
              ? drawPixel(x + i, y + j + k * 8, color)
              : drawPixel(x + i, y + j + k * 8, !color);
          line >>= 1;
        }
      }
    }
  }

  void simb10x16(int x, int y, bool color, int c) {
    for (int k = 0; k < 2; k++) {
      for (int i = 0; i < 10; i++) {
        //byte line = PROGRAM(&(mass10x16[c][i+k*10]));
        int line = mass10x16[c][i + k * 10];

        for (int j = 0; j < 8; j++) {
          (line & 0x01 == 1)
              ? drawPixel(x + i, y + j + k * 8, color)
              : drawPixel(x + i, y + j + k * 8, !color);
          line >>= 1;
        }
      }
    }
  }

  void clearArea(int x, int y, int w, int h) {
    for (int j = y; j < y + h; j++) {
      for (int i = x; i < x + w; i++) {
        drawPixel(i, j, false); // ??? 0 ???? ?????
      }
    }
  }

  /*
void STE2007_drawChar12x15(int x, int y, char c, bool color) {
    // ???: ???? ?? ??????? ' ' (???? 32) ???? ??????
    int index = (c - 32) * (FONT_WIDTH_12x15 * 2 +1);  // ?? ???? 2 ????
		index++;
    for (int col = 0; col < FONT_WIDTH_12x15; col++) {

        uint8_t lowByte = font12x15[index+(col*2)]; 
        uint8_t highByte = font12x15[index+(col*2)+1];
        uint16_t columnBits = (highByte << 8) | lowByte;

        for (int row = 0; row < FONT_HEIGHT_12x15; row++) {
            if (columnBits & (1 << row)) {
                STE2007_drawPixel(x + col, y + row, color);
            }
        }
    }
}
*/
  void drawChar12x15(int x, int y, int c, bool color) {
    int index = (c - 32) * (FONT_WIDTH_12x15 * 2 + 1);
    index++;
    for (int col = 0; col < FONT_WIDTH_12x15; col++) {
      final lowByte = font12x15[index + col * 2] & 0xFF;
      final highByte = font12x15[index + col * 2 + 1] & 0xFF;
      final columnBits = (highByte << 8) | lowByte;

      for (int row = 0; row < FONT_HEIGHT_12x15; row++) {
        if ((columnBits & (1 << row)) != 0) {
          drawPixel(x + col, y + row, color);
        }
      }
    }
  }

  int sizeStr12x15(String str) {
    int lcdX = 0;
    List<int> listChar = str.codeUnits;

    for (int c in listChar) {
      if (c == ' '.codeUnitAt(0)) {
        lcdX += font12x15[0];
      } else {
        lcdX += font12x15[(c - 32) * (FONT_WIDTH_12x15 * 2 + 1)] + 1;
      }
    }
    return lcdX;
  }

  int sizeStr(String str) {
    int lcdX = 0;

    for (int _ in str.codeUnits) {
      lcdX += 5;
    }
    return lcdX;
  }

  void printFixedPoint(
    int x,
    int y,
    bool color,
    int number,
    int decimalPlaces,
  ) {
    List<int> buffer = [];
    int len = 0;

    if (number == 0) {
      buffer.add('0'.codeUnitAt(0));
    } else {
      while (number > 0) {
        len++;
        buffer.add('0'.codeUnitAt(0) + (number % 10).toInt());
        number = (number / 10).toInt();
      }
    }

    while (len <= decimalPlaces) {
      len++;
      buffer.add('0'.codeUnitAt(0));
    }

    int i = len - 1;
    int startX = x;
    for (; i >= 0; i--) {
      if (i == decimalPlaces - 1) {
        drawPixel(startX + 4, y + 14, color);
        drawPixel(startX + 5, y + 14, color);
        drawPixel(startX + 4, y + 15, color);
        drawPixel(startX + 5, y + 15, color);
        startX += 10;
      }

      simb10x16(startX, y, color, buffer[i] - '0'.codeUnitAt(0));
      startX += 12;
    }
  }

  void drawCircleScrollBar(int pos, int total, int x, int y, int width) {
    if (total <= 1) return;

    int lineStartX = x + 6;
    int lineEndX = x + width - 6;

    drawLine(lineStartX, y, lineEndX, y, true);

    int cx =
        lineStartX +
        ((pos * (lineEndX - lineStartX)).toInt() / (total - 1)).toInt();
    int cy = y;

    drawCircle(cx, cy, 2, true);
    fillCircle(cx, cy, 1, true);

    drawLine(x + 1, y, x + 3, y - 2, true);
    drawLine(x + 1, y, x + 3, y + 2, true);

    int rightX = x + width - 1;
    drawLine(rightX, y, rightX - 2, y - 2, true);
    drawLine(rightX, y, rightX - 2, y + 2, true);

    int textX = rightX + 5;
    int textY = y - 3;

    lcdPrint(textX, textY, true, "${pos + 1}/$total", 1);
  }

  void fillRect(int x, int y, int w, int h, bool color) {
    for (int i = x; i < x + w; i++) {
      drawFastVLine(i, y, h, color);
    }
  }

  void drawScrollBar(int menuOffset, int totalItems, int visibleItems) {
    int scrollBarX = X_PIXELS - SCROLLBAR_WIDTH;
    int scrollBarY = 17;
    int scrollBarHeight = visibleItems * ITEM_HEIGHT;

    fillRect(scrollBarX, scrollBarY, SCROLLBAR_WIDTH, scrollBarHeight, false);

    drawRect(scrollBarX, scrollBarY, SCROLLBAR_WIDTH, scrollBarHeight, true);
    if (totalItems <= visibleItems) {
      fillRect(scrollBarX, scrollBarY, SCROLLBAR_WIDTH, scrollBarHeight, true);
      return;
    }

    int filledHeight = ((visibleItems * scrollBarHeight) / totalItems).toInt();

    int filledY =
        ((menuOffset * (scrollBarHeight - filledHeight)) /
                (totalItems - visibleItems))
            .toInt();

    fillRect(
      scrollBarX,
      scrollBarY + filledY,
      SCROLLBAR_WIDTH,
      filledHeight,
      true,
    );
  }

  void drawProgressBar(
    int x,
    int y,
    int width,
    int height,
    int progress,
    int min,
    int max,
  ) {
    if (progress < 0) progress = 0;
    if (progress > 100) progress = 100;

    lcdPrint(x, y, true, min.toString(), 1);
    x += 10;

    drawRect(x, y, width, height, true);

    int filledWidth = ((progress * (width - 2)) / 100).toInt();

    fillRect(filledWidth + x, y + 1, 5, height - 2, true);

    lcdPrint(x + width + 4, y, true, max.toString(), 1);
  }

  int countDigits(int num) {
    if (num == 0) return 1;
    int count = 0;
    if (num < 0) num = -num;

    while (num != 0) {
      num = (num / 10).toInt();
      count++;
    }

    return count;
  }

  void drawNumberWhitRectAroune(int x, int y, double Number) {
    FloatResult res = floatToIntWithDecimals(Number);

    int lcdX = ((X_PIXELS - (countDigits(res.value) * 10).toInt()) / 2).toInt();
    printFixedPoint(lcdX - x, y, true, res.value, res.decimals);
  }

  void drawSignedNumberWhitRectAroune(int x, int y, double number) {
    final isNegative = number < 0;
    final res = floatToIntWithDecimals(number.abs());

    final signWidth = isNegative ? 10 : 0;
    final decimalExtra = res.decimals > 0 ? 10 : 0;
    final totalWidth = (countDigits(res.value) * 10) + signWidth + decimalExtra;
    final lcdX = ((X_PIXELS - totalWidth) / 2).toInt();

    printFixedPointSigned(
      lcdX - x,
      y,
      true,
      isNegative,
      res.value,
      res.decimals,
    );
  }

  void printFixedPointSigned(
    int x,
    int y,
    bool color,
    bool isNegative,
    int number,
    int decimalPlaces,
  ) {
    var startX = x;

    if (isNegative) {
      _drawMinusSign10x16(startX, y, color);
      startX += 12;
    }

    printFixedPoint(startX, y, color, number, decimalPlaces);
  }

  void _drawMinusSign10x16(int x, int y, bool color) {
    fillRect(x + 1, y + 7, 8, 2, color);
  }

  FloatResult floatToIntWithDecimals(double number) {
    int decimals = 0;
    double temp = number;

    while (decimals < 2) {
      final fracPart = temp - temp.truncateToDouble();

      if (fracPart.abs() < 0.0001) {
        break;
      }

      temp *= 10;
      decimals++;
    }

    return FloatResult(value: temp.round(), decimals: decimals);
  }

  void print12x15(int x, int y, String str, bool color) {
    int lcdX = x;
    List<int> listChar = str.codeUnits;

    for (int c in listChar) {
      if (c == ' '.codeUnitAt(0)) {
        lcdX += font12x15[0];
      } else {
        drawChar12x15(lcdX, y, c, color);
        lcdX += font12x15[(c - 32) * (FONT_WIDTH_12x15 * 2 + 1)] + 1;
      }
    }
  }

  void DrawTextWhitRectAroune(int y, String str) {
    int size = str.length * 15;

    int Lcdx = ((X_PIXELS - size) / 2).toInt();

    print12x15(Lcdx + 2, y + 2, str, true);
    drawRect(Lcdx, y, size, 16, true);
  }

  String _gaugeLabel(double d) {
    final intPart = d.truncate();
    final diff = d - intPart;
    if (diff.abs() > 0.0001) {
      return d.toStringAsFixed(1);
    }
    return intPart.toString();
  }

  void drawGauge(
    int x,
    int y,
    int width,
    int height,
    double value,
    double min,
    double max,
  ) {
    if (value < min) {
      value = min;
    }
    if (value > max) {
      value = max;
    }

    lcdPrint(x, y, true, _gaugeLabel(min), 1);
    x += 20;

    drawRect(x, y, width, height, true);

    final value16 = (value * 100).toInt();
    final min16 = (min * 100).toInt();
    final max16 = (max * 100).toInt();
    final range = max16 - min16;

    if (range > 0) {
      const barWidth = 5;
      final posX =
          x + 1 + ((value16 - min16) * (width - 2 - barWidth)) ~/ range;
      fillRect(posX, y + 1, barWidth, height - 2, true);
    }

    lcdPrint(x + width + 2, y, true, _gaugeLabel(max), 1);
  }

  void fillRoundRect(int x, int y, int w, int h, int r, bool color) {
    // smarter version
    fillRect(x + r, y, w - 2 * r, h, color);

    // draw four corners
    fillCircleHelper(x + w - r - 1, y + r, r, 1, h - 2 * r - 1, color);
    fillCircleHelper(x + r, y + r, r, 2, h - 2 * r - 1, color);
  }
}
