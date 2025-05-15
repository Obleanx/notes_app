Notes_app
Overview
Notes_app is a Flutter application for creating and managing notes with a clean architecture and BLoC pattern for state management.
Features

Create, view, edit, and delete notes
Search notes by title and content
Sort notes by date or alphabetically
Tag notes for organization
Dark and light mode support
Export and share notes

Architecture
Built with clean architecture principles:

Data Layer: Storage and retrieval
Domain Layer: Business logic
Presentation Layer: UI and state

Project Structure
lib/
├── core/        # Utilities and constants
├── data/        # Data sources and models
├── domain/      # Entities and use cases
├── presentation/# UI components and BLoCs
└── main.dart    # Entry point
