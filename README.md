# Project Summary

## Assumptions & Design Decisions
- **Followed Clean Architecture:** The project is structured into three layers: domain (entities, repository interfaces), data (network & SQLite), and presentation (UI & BLoC).
- **Local ID Management:** Todos get unique IDs locally using `Uuid()` to handle immediate UI updates.
- **UX Improvements:** `PopScope` prevents accidental dismissal of "Add Todo" dialogs.
- **Reactive Validation:** Validation for login is handled via BLoC for reactive error feedback.

## BLoC Implementation
- **AuthBloc:** Manages login/logout and input validation.
- **TaskBloc:** Handles loading, adding, updating, toggling, deleting, and searching todos.
- **State Management:** UI reacts to states (`Loading`, `Loaded`, `Error`, `ActionSuccess`) using `BlocConsumer`.
- **Optimistic Updates:** Provides instant feedback before API confirmation.

## Challenges & Solutions
- **Offline Access:** Used SQLite to cache todos and sync with the server when online.
- **Smooth Animations:** scroll controllers added for dynamic insert/delete.
- **Validation & Dialogs:** Input errors are shown via BLoC; `PopScope` prevents accidental closure.
- **Error Handling:** Unified Success/Failure pattern ensures consistent feedback.

## Offline Support
- **Local Storage:** Todos are stored locally in SQLite.
- **Full Functionality:** Users can add, toggle, and delete todos offline; changes sync when back online.
- **Responsiveness:** Optimistic updates keep the UI responsive even without network access.

## App Demo Video

[Watch the App Demo Video](project_video/app_video.mp4)


