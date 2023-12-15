# Plant Disease Detection and Treatment App "AgriCure"

This is a full-stack mobile application for plant disease detection and treatment recommendations. The app uses Flutter for the frontend, Node.js with Express.js for the backend, MongoDB for the primary database, Firebase for additional functionalities, and integrates IoT functions through Firebase for real-time data monitoring.

## Features

- **Disease Detection:** Utilizes AI-powered FastAPI to detect diseases in plants.
- **Treatment Recommendations:** Provides treatment recommendations for identified plant diseases.
- **IoT Integration:** Utilizes Firebase for IoT functions, including real-time data monitoring for soil humidity, air humidity, and air temperature.
- **User-friendly Interface:** Offers an intuitive mobile app interface for easy interaction.

## Technologies Used

- **Frontend:** Flutter
- **Backend:** Node.js, Express.js
- **Database:** MongoDB
- **Firebase:** IoT Functions
- **AI Integration:** Python FastAPI

## Getting Started

### Prerequisites

- Ensure you have Flutter and Dart installed on your development machine.
- Node.js and npm for the backend.
- MongoDB installed locally or a cloud-based instance.
- Set up IoT devices and Firebase integration for real-time data monitoring.

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/AmenyElokb7/AgriCure.git
2. **Frontend Setup:**
   cd agri_cure/frontend
flutter pub get
flutter run
3. **Backend Setup:**
   cd NodeJs_backend/backend
npm install
npm start
4. **Database Setup:**
Ensure MongoDB is running, update the connection details in the backend.
5. **Firebase Setup:**
Set up Firebase and add configuration details in the frontend and backend.
Configure Firebase for IoT devices and real-time data monitoring.
6. **AI Integration:**
Set up the Python FastAPI server for AI integration.


