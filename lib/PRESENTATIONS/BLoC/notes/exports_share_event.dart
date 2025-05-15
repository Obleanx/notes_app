import 'dart:io';
import 'package:equatable/equatable.dart';

// Base event class
abstract class ExportShareEvent extends Equatable {
  const ExportShareEvent();

  @override
  List<Object?> get props => [];
}

// Event to export note as PDF
class ExportNoteToPdfEvent extends ExportShareEvent {
  final String title;
  final String content;
  final DateTime createdAt;

  const ExportNoteToPdfEvent({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [title, content, createdAt];
}

// Event to preview PDF
class PreviewPdfEvent extends ExportShareEvent {
  final String title;
  final String content;
  final DateTime createdAt;

  const PreviewPdfEvent({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [title, content, createdAt];
}

// Event to share note as text
class ShareNoteAsTextEvent extends ExportShareEvent {
  final String title;
  final String content;

  const ShareNoteAsTextEvent({
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [title, content];
}

// Event to share note as PDF
class ShareNoteAsPdfEvent extends ExportShareEvent {
  final String title;
  final String content;
  final DateTime createdAt;

  const ShareNoteAsPdfEvent({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [title, content, createdAt];
}

// Event to share to WhatsApp
class ShareToWhatsAppEvent extends ExportShareEvent {
  final String title;
  final String content;

  const ShareToWhatsAppEvent({
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [title, content];
}

// State classes
abstract class ExportShareState extends Equatable {
  const ExportShareState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ExportShareInitial extends ExportShareState {}

// Loading state
class ExportShareLoading extends ExportShareState {
  final String message;

  const ExportShareLoading({required this.message});

  @override
  List<Object?> get props => [message];
}

// Success state
class ExportShareSuccess extends ExportShareState {
  final String message;
  final File? file;

  const ExportShareSuccess({
    required this.message,
    this.file,
  });

  @override
  List<Object?> get props => [message, file];
}

// Failure state
class ExportShareFailure extends ExportShareState {
  final String error;

  const ExportShareFailure({required this.error});

  @override
  List<Object?> get props => [error];
}