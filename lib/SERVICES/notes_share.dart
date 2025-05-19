import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

class NoteShareService {
  // Share note as text
  Future<void> shareAsText({
    required String title,
    required String content,
    required BuildContext context,
  }) async {
    try {
      // Prepare text to share
      final String textToShare = '$title\n\n$content';

      // Calculate position for share sheet
      final box = context.findRenderObject() as RenderBox?;
      final sharePositionOrigin =
          box != null ? box.localToGlobal(Offset.zero) & box.size : null;

      // Share the text
      await Share.share(
        textToShare,
        subject: title,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      debugPrint('Error sharing note as text: $e');
      throw Exception('Failed to share note: $e');
    }
  }

  // Share note as PDF file
  Future<void> shareAsPdf({
    required File pdfFile,
    required String title,
    required BuildContext context,
  }) async {
    try {
      // Make sure the file exists
      if (!await pdfFile.exists()) {
        throw Exception('PDF file does not exist at path: ${pdfFile.path}');
      }

      // Calculate position for share sheet
      final box = context.findRenderObject() as RenderBox?;
      final sharePositionOrigin =
          box != null ? box.localToGlobal(Offset.zero) & box.size : null;

      // Create XFile from File
      final xFile = XFile(pdfFile.path);

      // Share the file
      await Share.shareXFiles(
        [xFile],
        text: 'Note: $title',
        subject: title,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      debugPrint('Error sharing note as PDF: $e');
      throw Exception('Failed to share PDF: $e');
    }
  }

  // Share to WhatsApp specifically
  Future<void> shareToWhatsApp({
    required String text,
    required BuildContext context,
  }) async {
    try {
      // Create WhatsApp URI
      Uri.parse('whatsapp://send?text=${Uri.encodeComponent(text)}');

      // Try to launch WhatsApp directly
      // if (await canLaunchUrl(uri)) {
      //   await launchUrl(uri);
      // } else {
      //   // Fall back to regular sharing if WhatsApp isn't installed
      //   await shareAsText(title: '', content: text, context: context);
      // }
    } catch (e) {
      debugPrint('Error sharing to WhatsApp: $e');
      throw Exception('Failed to share to WhatsApp: $e');
    }
  }
}
