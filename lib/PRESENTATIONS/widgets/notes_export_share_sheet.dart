import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/export_share_bloc.dart';
import 'package:notes_app/PRESENTATIONS/BLoC/notes/exports_share_event.dart';

class NoteExportShareSheet extends StatelessWidget {
  final String title;
  final String content;
  final DateTime createdAt;

  const NoteExportShareSheet({
    Key? key,
    required this.title,
    required this.content,
    required this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExportShareBloc, ExportShareState>(
      listener: (context, state) {
        if (state is ExportShareLoading) {
          // Show loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ExportShareFailure) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'Export & Share Options',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            
            // Export options
            const Text(
              'Export',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Export as PDF
                _buildOptionButton(
                  context,
                  icon: Icons.picture_as_pdf,
                  label: 'Save as PDF',
                  onTap: () {
                    context.read<ExportShareBloc>().add(
                      ExportNoteToPdfEvent(
                        title: title,
                        content: content,
                        createdAt: createdAt,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
                
                // Preview PDF
                _buildOptionButton(
                  context,
                  icon: Icons.preview,
                  label: 'Preview PDF',
                  onTap: () {
                    context.read<ExportShareBloc>().add(
                      PreviewPdfEvent(
                        title: title,
                        content: content,
                        createdAt: createdAt,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24.0),
            const Divider(),
            const SizedBox(height: 24.0),
            
            // Share options
            const Text(
              'Share',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Share as text
                _buildOptionButton(
                  context,
                  icon: Icons.text_format,
                  label: 'Share as Text',
                  onTap: () {
                    context.read<ExportShareBloc>().add(
                      ShareNoteAsTextEvent(
                        title: title,
                        content: content,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
                
                // Share as PDF
                _buildOptionButton(
                  context,
                  icon: Icons.picture_as_pdf,
                  label: 'Share as PDF',
                  onTap: () {
                    context.read<ExportShareBloc>().add(
                      ShareNoteAsPdfEvent(
                        title: title,
                        content: content,
                        createdAt: createdAt,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
                
                // Share to WhatsApp
                _buildOptionButton(
                  context,
                    icon: FontAwesomeIcons.whatsapp,
                  label: 'WhatsApp',
                  onTap: () {
                    context.read<ExportShareBloc>().add(
                      ShareToWhatsAppEvent(
                        title: title,
                        content: content,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}