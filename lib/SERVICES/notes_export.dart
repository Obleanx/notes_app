import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;

class NoteExportService {
  // Export note as PDF and save to device
  Future<File> exportAsPdf({
    required String title,
    required String content,
    required DateTime createdAt,
  }) async {
    // Create PDF document
    final pdf = pw.Document();

    // Load font (optional, use system font if not loading custom)
    // If you have custom fonts, load them like this:
    // final font = await PdfGoogleFonts.nunitoRegular();

    // Add page to the PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Title
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),

                // Date
                pw.Text(
                  "Created: ${_formatDate(createdAt)}",
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.SizedBox(height: 16),

                // Content
                pw.Text(content, style: const pw.TextStyle(fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );

    // Get directory for saving file
    final output = await getApplicationDocumentsDirectory();
    final fileName =
        "${_sanitizeFileName(title)}_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final file = File("${output.path}/$fileName");

    // Save PDF
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  // Preview and print PDF
  Future<void> previewPdf({
    required String title,
    required String content,
    required DateTime createdAt,
    required material.BuildContext context,
  }) async {
    // Create PDF document
    final pdf = pw.Document();

    // Add page to the PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(16.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Title
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),

                // Date
                pw.Text(
                  "Created: ${_formatDate(createdAt)}",
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.SizedBox(height: 16),

                // Content
                pw.Text(content, style: const pw.TextStyle(fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );

    // Show the PDF preview and print dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: title,
    );
  }

  // Helper function to format date
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  // Helper function to sanitize file name
  String _sanitizeFileName(String input) {
    return input
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
  }
}
