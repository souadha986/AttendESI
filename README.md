# AttendESI 🎓

**A Flutter-based attendance management system for ESI.**

AttendESI is a mobile application project designed to simplify attendance management within a school environment. It provides dedicated interfaces for professors, students, administrators, and school administration, helping make attendance tracking more organized and accessible.

## 📌 Project Overview

The project is divided into four applications, each designed for a specific user role:

* **Professor (`prof`)** — Interface for professors and attendance-related activities.
* **Student (`etudiant`)** — Interface for students.
* **Administrator (`admin`)** — Interface for administrative management.
* **School Administration (`scolarite`)** — Interface for school administration tasks.

## 🛠️ Technologies

* **Flutter & Dart** — Application development
* **REST APIs** — Backend communication
* **Git & GitHub** — Version control and collaboration
* **Firebase** — Used for relevant application services, where configured

## 📂 Project Structure

```text
AttendESI-Portfolio/
├── admin/
├── etudiant/
├── prof/
├── scolarite/
├── .gitignore
└── README.md
```

Each application has its own Flutter project structure and can be developed separately.

## 🚀 Getting Started

### Prerequisites

* Flutter SDK
* Dart SDK
* Android Studio or Visual Studio Code
* An emulator or a physical device

### Run an application

1. Clone the repository:

   ```bash
   git clone https://github.com/souadha986/AttendESI-Portfolio.git
   cd AttendESI-Portfolio
   ```

2. Navigate to the application you want to run. For example:

   ```bash
   cd prof
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

Repeat these steps from the relevant folder to run `etudiant`, `admin`, or `scolarite`.

## 🔐 Security

Sensitive configuration files, private credentials, and environment variables should not be committed to the repository.

* Keep API secrets and backend credentials out of source control.
* Configure Firebase securely for local development when required.
* Use `.gitignore` to exclude sensitive local configuration files.
* Never publish private keys, service-account credentials, or database passwords.

## 🎯 Project Goals

* Make attendance management more convenient.
* Provide role-specific interfaces.
* Organize attendance-related workflows.
* Support the digitalization of school administration.

## 👩‍💻 Development

This repository is maintained as a portfolio project to present the application's structure, technologies, and development work.

## 📄 License

No license has been specified yet. Please contact the project owner before reusing or redistributing the code.
