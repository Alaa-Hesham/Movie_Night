# Movie Night

A Flutter movie application that allows users to discover movies, search for movies, view movie details, and manage their personal movie lists.

## Features

- View popular movies
- Search for movies
- View movie details
- Add movies to Favorites
- Add movies to Watched
- Add movies to Watch Later
- Add movies to Currently Watching
- User Register and Login
- User Logout
- Store user profile data using Firestore
- Store saved movies using SQLite
- Pagination for movies and search results
- Loading and error handling
- Empty states for movie lists

## Technologies used

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- SQFLite
- Provider
- TMDB API
- MVC Architecture

## Architecture explanation

The project is divided into different parts:
![alt text](<Screenshot 2026-09-02 133803.png>)

![alt text](<Screenshot 2026-09-02 133859.png>)

![alt text](<Screenshot 2026-09-02 133915.png>)


- Models: Contains the movie model and represents the movie data used in the application.
- Views: Contains screens and widgets.
- Providers:Manages application state using Provider, including movies, search results, loading states, errors, saved movie list like Favorites, Watched, Watch Later, and Currently Watching
- Controllers: Connects the Provider with the services.
- Services: Handles TMDB API, SQLite, Firebase Authentication, and Firestore.


## Installation Instructions
Before running the project, make sure you have:
- Flutter installed
- Dart installed
- Android Studio or VS Code
- Internet connection

Steps to run the application:
- Clone the project.
- Open the project in Android Studio or VS Code.
- Run in Terminal:[flutter pub get]
- ((Ask the auther)) about your TMDB API token.
- Run the project:[flutter run --dart-define=TMDB_TOKEN=your_token]


## API setup instruction
The application uses the TMDB API to retrieve movie information.

TMDB API is used to get:
- Popular movies
- Search results
- Movie details
- Ratings
- Posters
- Release dates
- Genres

To use the API:
- Create a TMDB account.
- Create an API application.
- Get the API token.
- Use the token in TMDB service in the project.

## Firebase Setup instructions
Firebase is used for authentication and user profile data.
### Firebase

Firebase Authentication is used for:
- Register
- Login
- Logout
- Checking the current logged-in user

### Cloud Firestore

 Cloud Firestore is used to store user profile information, such as:
 - name 
 - username 
 - phone 
 - date of birth 
 - country
 - favorite genre
 After registration, the user's profile information is stored in Firestore.


## Database explanation 

SQFLite is used to save movies in:
- Favorites
- Watched
- Watch Later
- Currently Watching

The saved movies are connected to the logged-in user's ID.

## Application Flow
Splash Screen --> [if the user not login] Login / Register --> Home Screen --> Movie Details --> Favorites / Watched / Watch Later / Currently Watching --> Profile --> Logout

Splash Screen --> [if the user login without logout] Home Screen --> Movie Details --> Favorites / Watched / Watch Later / Currently Watching --> Profile --> Logout
 
## Screenshots
### Splash Screen
Checks whether a user is already logged in.
- If the user is logged in → Home Screen
- If the user is not logged in → Login Screen

![alt text](<Screenshot 2026-09-02 153029.png>)

### Login Screen
Users can login using their existing account.
![alt text](aeb7940b-caff-411c-9158-d7d05d54f595.jpg)

### Register Screen
Users can register a new account .
![alt text](dd3664ab-5036-4641-82d3-183b93696022.jpg)



### Home Screen
Displays popular movies retrieved from the TMDB API.
![alt text](d1a95a6d-c5b1-48b2-b069-ab34b6691439.jpg)


### Movie Details
Displays detailed information about the selected movie and allows the user to add or remove the movie from the different lists.

![alt text](5e60d17e-d9d9-4e17-aff0-f08888dfc955.jpg)
![alt text](8eba142e-57df-404e-9b69-d57dc192e397.jpg)

### Favorites
![alt text](96d702f0-beeb-4f38-badf-7fd29c775c6a.jpg)

### Watched
![alt text](f0adda40-ef19-4391-870a-e315ae0a2d7a.jpg)

### Watch Later
![alt text](00f93bd6-2872-4c76-8c53-ec2926ae5aaf.jpg)

### Currently Watching
![alt text](f80325a2-b793-4369-b460-5e030357e44c.jpg)

### Profile
Displays the user's profile information and provides the logout option.  
![alt text](dd3664ab-5036-4641-82d3-183b93696022-1.jpg)

### Search Screen
The TMDB API and allows the user to search for movies.
![alt text](8d3b4d7b-3411-4422-a954-577d7df4b7be.jpg)


## Known Limitations
- Movie data depends on the TMDB API and requires an internet connection.
- you should ask about [API Token] to run the application by [flutter run --dart-define=TMDB_TOKEN=your_token]

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
