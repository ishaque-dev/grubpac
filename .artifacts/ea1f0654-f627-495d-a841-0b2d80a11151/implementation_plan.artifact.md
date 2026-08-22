# TaskFlow Implementation Plan

This plan outlines the steps to implement the "TaskFlow" assignment based on the provided `mock-data.json` and the existing project structure.

## Overview
TaskFlow is a multi-tenant task management application where users belong to organizations and can have different roles (`org_admin` or `member`).

## Proposed Features

### 1. Authentication & Role-Based Access
- **Login**: Implement a login screen using the credentials provided in `mock-data.json`.
- **Role Control**: `org_admin` can create projects and tasks, while `member` can only view and update task statuses.
- **Persistence**: Store the mock session using `flutter_secure_storage`.

### 2. Project Management
- **Dashboard**: A list of projects associated with the logged-in user's organization.
- **Project Stats**: Display the `task_count` and current status.

### 3. Task Management
- **Task List**: Grouped by status (`todo`, `in_progress`, `done`, `review`).
- **Task Sorting/Filtering**: Filter by priority (`low`, `medium`, `high`, `urgent`).
- **Task Details**: View description, assignee, due date, and comments.

### 4. Persistence (Offline Support)
- **Local Database**: Use `sqflite` (already initialized in `lib/core/database/db.dart`) to cache data from `mock-data.json`.
- **Sync Logic**: On app start, load data from `mock-data.json` into SQLite if the DB is empty.

### 5. Notifications
- **Inbox**: A screen to view notifications like "You were assigned to X".

## Implementation Roadmap

### Phase 1: Core Setup & Data Layer
1. **[MODIFY] [db.dart](file:///Users/ishaque/flutter_projects/grubpac/lib/core/database/db.dart)**: Update schema to include `projects`, `users`, `organizations`, `comments`, and `notifications`.
2. **[NEW] Data Models**: Create fromJson/toJson for all entities in `lib/features/*/data/models/`.
3. **[NEW] Mock Data Source**: Implement a data source that reads `assets/mock-data.json` and populates the local DB.

### Phase 2: Authentication
1. **[NEW] Auth Repository**: Logic to verify credentials against the `auth_mock` in the JSON.
2. **[NEW] Login Screen**: Simple form with email/password validation.
3. **[NEW] Auth BLoC**: Manage authenticated/unauthenticated states.

### Phase 3: Project & Task Display
1. **[NEW] Dashboard Screen**: Displaying projects using `ProjectEntity`.
2. **[NEW] Project Details Screen**: Displaying tasks using `TaskEntity`.
3. **[NEW] Task Item Widget**: A card showing title, priority badge, and assignee avatar.

### Phase 4: Task Interaction
1. **[NEW] Task Details Screen**: Detailed view with a comment list.
2. **[NEW] Update Status**: Logic to move tasks between statuses.
3. **[NEW] Add Comment**: Simple text field to append comments (locally).

### Phase 5: Notifications & Profile
1. **[NEW] Notification Screen**.
2. **[NEW] Profile Screen**: Showing user info and logout button.

## Verification Plan
- **Mock Login**: Verify login with `ava.admin@nimbusdigital.test`.
- **Data Integrity**: Ensure the project list matches the JSON for the specific organization.
- **UI Responsiveness**: Test on different screen sizes using `flutter_screenutil`.
- **Offline Mode**: Verify data is visible without "network" calls (simulated).
