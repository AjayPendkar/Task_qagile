# QAgile Movies App




## Flutter Installation & Setup

### Prerequisites
1. **Operating System Requirements**
   - Windows: Windows 7 SP1 or later (64-bit)
   - macOS: macOS 10.14 (Mojave) or later
   - Linux: Ubuntu 16.04 or later

2. **Tools Required**
   - Git
   - VS Code or Android Studio
   - A supported browser

### Flutter SDK Installation

#### Windows
1. Download Flutter SDK from [Flutter Official Site](https://flutter.dev/docs/get-started/install/windows)
2. Extract the zip file to a desired location (e.g., `C:\flutter`)
3. Add Flutter to your PATH:
   ```bash
   setx PATH "%PATH%;C:\flutter\bin"
   ```

#### macOS
1. Download Flutter SDK
   ```bash
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64.zip
   ```
2. Extract and add to PATH:
   ```bash
   unzip flutter_macos_arm64.zip
   export PATH="$PATH:`pwd`/flutter/bin"
   ```

#### Linux
1. Download Flutter SDK
   ```bash
   sudo snap install flutter --classic
   ```



Engine • revision a18df97ca5
Tools • Dart 3.5.4 • DevTools 2.37.3

### Development Environment Setup

1. **Install IDE**
   - VS Code with Flutter extension
   - Or Android Studio with Flutter plugin

2. **Verify Installation**
   ```bash
   flutter doctor
   ```
   Fix any issues reported by flutter doctor

3. **Platform Setup**

   #### Android Setup
   - Install Android Studio
   - Install Android SDK
   - Create/Setup Android Emulator
   ```bash
   flutter config --android-studio-dir=<directory>
   ```

   #### iOS Setup (macOS only)
   - Install Xcode
   - Install CocoaPods
   ```bash
   sudo gem install cocoapods
   ```

### Project Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/AjayPendkar/Task_qagile.git
   cd Task_qagile
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

### Common Issues & Solutions

1. **Flutter Not Found**
   ```bash
   echo $PATH
   # Add Flutter to PATH if not present
   ```

2. **Android SDK Issues**
   ```bash
   flutter doctor --android-licenses
   ```

3. **iOS Build Issues**
   ```bash
   cd ios
   pod install
   ```

### Development Tools

1. **VS Code Extensions**
   - Flutter
   - Dart
   - Flutter Widget Snippets
   - Flutter Tree
   - Awesome Flutter Snippets

2. **Android Studio Plugins**
   - Flutter
   - Dart
   - Flutter Enhancement Suite

### Recommended Flutter Version



## Environment Configuration

### .env File Setup
The application uses a `.env` file to manage environment variables, particularly the OMDB API key. 

1. Create a `.env` file in the root directory:

2. Add your OMDB API key to the `.env` file:



### Getting an OMDB API Key
1. Visit [OMDB API](http://www.omdbapi.com/apikey.aspx)
2. Choose a plan (Free tier available)
3. Register and get your API key
4. Activate your key via email

### Implementation
The app uses `flutter_dotenv` package to manage environment variables:


### Security Notes
- Never commit  `.env` file to version control
- The `.env` file is included in `.gitignore`
- Use different keys for development and production





## Features

### Movie Browsing
- Browse movies, TV shows, and episodes
- Grid view layout with movie posters
- Detailed movie information including ratings, cast, and plot
- Category filtering (Movies/Series/Episodes)

### Search & Discovery
- Real-time search with debounce
- Recent searches history
- Search across different categories
- Loading states with shimmer effect

### Theme Support
- Dynamic Dark/Light theme switching
- Theme-aware UI components
- Smooth theme transitions
- Consistent styling across app

### Movie Details
- Comprehensive movie information display
- Expandable plot section
- Rating display with stars
- Cast and crew information
- Release details and metadata

### Sharing & Actions
- Share movie details
- Share with screenshot option
- Save movies to favorites
- Download movies (simulated)
- Action buttons with visual feedback

### UI/UX Features
- Custom bottom navigation bar
- Transparent app bar with scroll effect
- Shimmer loading states
- Smooth animations
- Error handling with retry options
- No internet connection handling

## Architecture

### Clean Architecture
- Domain-driven design
- Clear separation of concerns
- Repository pattern implementation
- Use case driven business logic

### State Management
- GetX for reactive state management
- Dependency injection
- Route management
- Reactive controllers

### Project Structure


lib/
├── app/
│ ├── data/
│ │ ├── models/
│ │ │ ├── movie_model.dart
│ │ │ └── movie_details_model.dart
│ │ └── repositories/
│ │ └── movie_repository.dart
│ ├── domain/
│ │ ├── entities/
│ │ │ ├── movie.dart
│ │ │ └── movie_details.dart
│ │ └── repositories/
│ │ └── movie_repository.dart
│ └── presentation/
│ ├── home/
│ │ ├── controllers/
│ │ │ └── home_controller.dart
│ │ ├── views/
│ │ │ └── home_view.dart
│ │ └── widgets/
│ │ ├── movie_grid.dart
│ │ └── search_field.dart
│ ├── movie_details/
│ │ ├── controllers/
│ │ │ └── movie_details_controller.dart
│ │ ├── views/
│ │ │ └── movie_details_view.dart
│ │ └── widgets/
│ │ ├── rating_stars.dart
│ │ └── genre_chip.dart
│ └── shared/
│ └── widgets/
│ ├── custom_bottom_bar.dart
│ ├── shimmer_loading.dart
│ └── no_internet_view.dart
├── core/
│ ├── constants/
│ │ └── theme_constants.dart
│ └── theme/
│ └── theme_controller.dart
└── routes/
└── app_pages.dart
test/
├── app/
│ ├── data/
│ │ └── repositories/
│ │ └── movie_repository_test.dart
│ └── presentation/
│ ├── home/
│ │ └── controllers/
│ │ └── home_controller_test.dart
│ └── movie_details/
│ └── controllers/
│ └── movie_details_controller_test.dart








## Key Files Explanation

### Controllers
`lib/app/presentation/home/controllers/home_controller.dart`
- Manages home screen state and movie search functionality
- Handles debounced search with 500ms delay
- Manages connectivity state and offline mode
- Controls category selection and filtering
- Handles recent searches with a maximum of 5 items
- Implements error handling and loading states

`lib/app/presentation/movie_details/controllers/movie_details_controller.dart`
- Controls movie details view state
- Manages save/unsave functionality
- Handles screenshot and sharing features
- Simulates download progress
- Manages loading and error states
- Controls expandable plot section

### Views
`lib/app/presentation/home/views/home_view.dart`
- Main screen UI implementation
- Implements search bar with suggestions
- Shows movie grid with shimmer loading
- Displays category filters
- Handles offline state display
- Features transparent app bar with scroll effect

`lib/app/presentation/movie_details/views/movie_details_view.dart`
- Detailed movie information display
- Implements expandable plot section
- Shows ratings and cast information
- Features action buttons (Save, Share, Download)
- Handles loading and error states
- Implements screenshot capability

### Widgets
`lib/app/presentation/shared/widgets/custom_bottom_bar.dart`
- Custom navigation bar implementation
- Transparent background with blur effect
- Theme-aware styling
- Animated selection indicators
- Responsive to theme changes

`lib/app/presentation/home/widgets/movie_grid.dart`
- Grid layout for movie posters
- Handles loading states with shimmer
- Implements error handling
- Responsive grid sizing
- Smooth image loading

`lib/app/presentation/shared/widgets/no_internet_view.dart`
- Offline state UI
- Retry mechanism
- Animated illustrations
- User-friendly error messages

### Tests
`test/app/presentation/home/controllers/home_controller_test.dart`
- Tests search functionality
- Verifies category selection
- Validates recent searches
- Tests connectivity handling
- Confirms loading states
- Verifies error handling

`test/app/presentation/movie_details/controllers/movie_details_controller_test.dart`
- Tests save functionality
- Validates sharing features
- Verifies download simulation
- Tests loading states
- Confirms error handling
- Validates movie details loading





### Test Categories

1. **Functionality Tests**
   - Search functionality
   - Category filtering
   - Movie details loading
   - Save/unsave features
   - Share capabilities
   - Download simulation

2. **State Management Tests**
   - Initial states
   - Loading states
   - Error states
   - Data states
   - UI state updates

3. **Error Handling Tests**
   - API errors
   - Network errors
   - Invalid data
   - Edge cases
   - Timeout scenarios

4. **Integration Tests**
   - Repository with API
   - Controllers with Views
   - Navigation flow
   - Theme changes
   - Offline mode


