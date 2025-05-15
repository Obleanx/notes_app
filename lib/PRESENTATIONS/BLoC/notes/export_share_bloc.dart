import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/SERVICES/notes_share.dart';
import 'package:notes_app/SERVICES/notes_export.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/exports_share_event.dart';

class ExportShareBloc extends Bloc<ExportShareEvent, ExportShareState> {
  final NoteExportService _exportService;
  final NoteShareService _shareService;
  final BuildContext context;

  ExportShareBloc({
    required NoteExportService exportService,
    required NoteShareService shareService,
    required this.context,
  }) : _exportService = exportService,
       _shareService = shareService,
       super(ExportShareInitial()) {
    on<ExportNoteToPdfEvent>(_onExportNoteToPdf);
    on<PreviewPdfEvent>(_onPreviewPdf);
    on<ShareNoteAsTextEvent>(_onShareNoteAsText);
    on<ShareNoteAsPdfEvent>(_onShareNoteAsPdf);
    on<ShareToWhatsAppEvent>(_onShareToWhatsApp);
  }

  // Handle PDF export event
  Future<void> _onExportNoteToPdf(
    ExportNoteToPdfEvent event,
    Emitter<ExportShareState> emit,
  ) async {
    emit(const ExportShareLoading(message: 'Exporting as PDF...'));

    try {
      final file = await _exportService.exportAsPdf(
        title: event.title,
        content: event.content,
        createdAt: event.createdAt,
      );

      emit(
        ExportShareSuccess(
          message: 'Note exported as PDF successfully',
          file: file,
        ),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported to ${file.path}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      emit(ExportShareFailure(error: 'Failed to export as PDF: $e'));

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to export as PDF'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Handle PDF preview event
  Future<void> _onPreviewPdf(
    PreviewPdfEvent event,
    Emitter<ExportShareState> emit,
  ) async {
    emit(const ExportShareLoading(message: 'Preparing PDF preview...'));

    try {
      await _exportService.previewPdf(
        title: event.title,
        content: event.content,
        createdAt: event.createdAt,
        context: context,
      );

      emit(const ExportShareSuccess(message: 'PDF preview opened'));
    } catch (e) {
      emit(ExportShareFailure(error: 'Failed to preview PDF: $e'));

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to preview PDF'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Handle sharing note as text
  Future<void> _onShareNoteAsText(
    ShareNoteAsTextEvent event,
    Emitter<ExportShareState> emit,
  ) async {
    emit(const ExportShareLoading(message: 'Preparing to share...'));

    try {
      await _shareService.shareAsText(
        title: event.title,
        content: event.content,
        context: context,
      );

      emit(const ExportShareSuccess(message: 'Note shared as text'));
    } catch (e) {
      emit(ExportShareFailure(error: 'Failed to share note: $e'));

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to share note'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Handle sharing note as PDF
  Future<void> _onShareNoteAsPdf(
    ShareNoteAsPdfEvent event,
    Emitter<ExportShareState> emit,
  ) async {
    emit(const ExportShareLoading(message: 'Creating PDF for sharing...'));

    try {
      // First generate the PDF
      final pdfFile = await _exportService.exportAsPdf(
        title: event.title,
        content: event.content,
        createdAt: event.createdAt,
      );

      // Then share it
      await _shareService.shareAsPdf(
        pdfFile: pdfFile,
        title: event.title,
        context: context,
      );

      emit(ExportShareSuccess(message: 'Note shared as PDF', file: pdfFile));
    } catch (e) {
      emit(ExportShareFailure(error: 'Failed to share note as PDF: $e'));

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to share note as PDF'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Handle sharing to WhatsApp
  Future<void> _onShareToWhatsApp(
    ShareToWhatsAppEvent event,
    Emitter<ExportShareState> emit,
  ) async {
    emit(
      const ExportShareLoading(message: 'Preparing to share to WhatsApp...'),
    );

    try {
      final textToShare = '${event.title}\n\n${event.content}';

      await _shareService.shareToWhatsApp(text: textToShare, context: context);

      emit(const ExportShareSuccess(message: 'Note shared to WhatsApp'));
    } catch (e) {
      emit(ExportShareFailure(error: 'Failed to share to WhatsApp: $e'));

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to share to WhatsApp'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
