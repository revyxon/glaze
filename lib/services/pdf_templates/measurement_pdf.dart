import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../models/customer.dart';
import '../../models/window.dart';
import '../../config/app_data.dart';

class MeasurementPdf {
  // Brand Colors - Clean & Professional
  static final _primaryColor = PdfColor.fromHex('#00897B'); // Teal
  static final _black = PdfColors.black;
  static final _darkColor = PdfColor.fromHex('#1F2937'); // Gray 800
  static final _lightColor = PdfColor.fromHex('#6B7280'); // Gray 500
  static final _borderColor = PdfColor.fromHex('#E5E7EB');

  static Future<pw.Document> generate({
    required Customer customer,
    required List<Window> windows,
    bool countHoldOnTotal = false,
  }) async {
    final pdf = pw.Document();

    // Calculate totals based on setting
    double totalSqFt = 0;
    int totalWindows = 0;

    for (final w in windows) {
      if (!w.isOnHold || countHoldOnTotal) {
        totalSqFt += (w.sqFt * w.quantity);
        totalWindows += w.quantity;
      }
    }

    final fontRegular = pw.Font.helvetica();
    final fontBold = pw.Font.helveticaBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
        build: (context) {
          return [
            _buildHeader(),
            pw.SizedBox(height: 10),
            _buildDivider(),
            pw.SizedBox(height: 15),
            _buildCustomerSection(customer),
            pw.SizedBox(height: 20),
            _buildTable(windows),
            pw.SizedBox(height: 20),
            _buildSummary(totalWindows, totalSqFt),
          ];
        },
        footer: _buildPageFooter,
      ),
    );

    return pdf;
  }

  static pw.Widget _buildDivider() {
    return pw.Container(height: 1, width: double.infinity, color: _borderColor);
  }

  static pw.Widget _buildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'DD UPVC WINDOWS SYSTEM',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 20,
                color: _primaryColor, // Revert to Brand Color for Logo effect
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Kudri (Medical College Road), Shahdol, M.P.',
              style: pw.TextStyle(fontSize: 10, color: _darkColor),
            ),
            pw.Text(
              '+91 9826414729  |  ddupvcwindowsystem@gmail.com',
              style: pw.TextStyle(fontSize: 10, color: _darkColor),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: _primaryColor,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text(
                'MEASUREMENT SHEET',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'DATE: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
              style: pw.TextStyle(
                fontSize: 10,
                color: _darkColor,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildCustomerSection(Customer customer) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _borderColor),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'CUSTOMER DETAILS',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: _lightColor,
                  letterSpacing: 1,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                customer.name,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  color: _darkColor,
                ),
              ),
              pw.Text(
                customer.location,
                style: pw.TextStyle(fontSize: 10, color: _lightColor),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Framework', customer.framework),
              _buildInfoRow('Glass', customer.glassType ?? '-'),
              if (customer.isFinalMeasurement)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 4),
                  child: pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: pw.BoxDecoration(
                      color: _black,
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(2),
                      ),
                    ),
                    child: pw.Text(
                      'FINALIZED',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 60,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 9, color: _lightColor),
            ),
          ),
          pw.Text(
            ': $value',
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: _darkColor,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTable(List<Window> windows) {
    return pw.Table(
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
      ),
      columnWidths: {
        0: const pw.FixedColumnWidth(30), // #
        1: const pw.FlexColumnWidth(3), // Size
        2: const pw.FlexColumnWidth(3), // Type
        3: const pw.FixedColumnWidth(45), // Qty
        4: const pw.FlexColumnWidth(2), // Area
      },
      children: [
        // Header
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            _buildHeaderCell('#', textColor: _darkColor),
            _buildHeaderCell('SIZE (mm)', textColor: _darkColor),
            _buildHeaderCell('TYPE', textColor: _darkColor),
            _buildHeaderCell(
              'QTY',
              align: pw.TextAlign.center,
              textColor: _darkColor,
            ),
            _buildHeaderCell(
              'AREA (Sq.Ft)',
              align: pw.TextAlign.right,
              textColor: _darkColor,
            ),
          ],
        ),
        // Rows
        ...windows.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final w = entry.value;
          final isHold = w.isOnHold;

          // Alternating row colors for better readability could be added here
          // but clean white is often more "Pro" for print unless it's a huge invoice.
          // We'll stick to clean lines.

          final textColor = isHold ? _lightColor : _darkColor;
          final rowBg = isHold
              ? PdfColor.fromHex('#FFF7ED')
              : PdfColors.white; // Soft amber for hold

          String sizeStr =
              '${w.width.toStringAsFixed(0)} x ${w.height.toStringAsFixed(0)}';
          if (w.width2 != null && w.width2! > 0) {
            sizeStr =
                '(${w.width.toStringAsFixed(0)} + ${w.width2!.toStringAsFixed(0)}) x ${w.height.toStringAsFixed(0)}';
          }

          String typeStr = AppData.getWindowName(w.type);
          if (w.customName != null && w.customName!.isNotEmpty) {
            typeStr = '$typeStr (${w.customName!})';
          }
          if (isHold) {
            typeStr += ' [HOLD]';
          }

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: rowBg),
            children: [
              _buildCell(index.toString(), textColor: textColor),
              _buildCell(sizeStr, textColor: textColor, isBold: !isHold),
              _buildCell(typeStr, textColor: textColor),
              _buildCell(
                w.quantity.toString(),
                align: pw.TextAlign.center,
                textColor: textColor,
                isBold: true,
              ),
              _buildCell(
                (w.sqFt * w.quantity).toStringAsFixed(2),
                align: pw.TextAlign.right,
                textColor: textColor,
                isBold: !isHold,
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildHeaderCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
    PdfColor? textColor,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: textColor ?? _darkColor,
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          letterSpacing: 0.5,
        ),
        textAlign: align,
      ),
    );
  }

  static pw.Widget _buildCell(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
    PdfColor? textColor,
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: textColor ?? _darkColor,
          fontSize: 9,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: align,
      ),
    );
  }

  static pw.Widget _buildSummary(int totalQty, double totalSqFt) {
    return pw.Container(
      width: double.infinity,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'TOTAL (Active)',
            style: pw.TextStyle(
              color: _darkColor,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _black),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Row(
              children: [
                pw.Text(
                  '$totalQty Windows',
                  style: pw.TextStyle(color: _black, fontSize: 10),
                ),
                pw.SizedBox(width: 20),
                pw.Container(width: 1, height: 12, color: _lightColor),
                pw.SizedBox(width: 20),
                pw.Text(
                  '${totalSqFt.toStringAsFixed(2)} Sq.Ft',
                  style: pw.TextStyle(
                    color: _black,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPageFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(color: _borderColor),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Generated via DD UPVC App',
              style: pw.TextStyle(fontSize: 8, color: _lightColor),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 8, color: _lightColor),
            ),
          ],
        ),
      ],
    );
  }
}
