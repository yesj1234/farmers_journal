# Farmer's Journal

**Simplify farming, enhance productivity.**

App store: [Farmers Journal](https://apps.apple.com/app/6741880762)

## Introduction

Track your farming journey, share insights, and optimize your methods with real-time data and visualizations.

**Related Keywords**:

- 농업
- 농장
- 작물
- 일지
- 농업기록
- 기록관리
- 생산성
- 데이터시각화
- 공유

## Project Description

### Author

- **Yang Seung Jun**

### Design

- **Figma**: [Design Prototype](https://www.figma.com/design/mH4hN1Mm68mfZOw7ZdPYLO/농업일지기획서?node-id=0-1&t=rUAQsCf8aykENsmw-1)

### Overview

**Farmer's Journal** is a tool designed to assist modern farmers in enhancing their farming methodologies.

Whether managing a small garden or a large-scale farm, this app helps document, analyze, and improve farming processes step-by-step.

### Key Features

- **Journal Creation and Management**:  
  Effortlessly record daily farming activities, including planting, watering, harvesting, and maintenance. Update and delete entries as needed, and access all records in one place.

- **Data Visualizations**:  
  View your farming journey through visually engaging charts and graphs. Analyze trends and patterns to improve methods and increase productivity.

- **Sharing & Collaboration**:  
  Share your farming journal with other users to exchange insights and strategies. Build a community of like-minded farmers to learn and grow together.

- **Encouragement to Write**:  
  Receive gentle reminders and visual feedback to encourage consistent journal entries. Monitor progress over time and take pride in your farming journey.

## Code Structure

The code structure reflects the Riverpod architecture. For detailed insights into this architecture, refer to the following resources:

- [Flutter App Architecture Part 1](https://yesj1234.github.io/posts/flutter_app_architecture)
- [Flutter App Architecture Part 2](https://yesj1234.github.io/posts/flutter_app_architecture2)

```
./lib
├── data
│   └── repositories
├── domain
│   ├── firebase
│   ├── interface
│   └── model
└── presentation
    ├── components
    ├── controller
    └── pages
```


### Data

The gateway between the remote database and the application.


- **Repositories**

Concrete implementations of the interfaces, handling data operations such as fetching, caching, and updating.

### Domain

Defines application-specific model classes representing the data from the data layer.

- **Firebase**

Handles interactions with Firebase services, including authentication, database operations, and storage.

- **Interface**

Defines abstract classes or interfaces that outline the methods for data retrieval and manipulation.

- **Model**

Defines the data structures used throughout the application, ensuring consistency and type safety.

### Presentation

The UI displays application data and serves as the primary point of user interaction.

It updates to reflect changes due to user actions or external inputs, effectively representing the application state as retrieved from the data layer.

- **Components**

Reusable UI elements that form the building blocks of the application's interface.

- **Controller**

Manages the flow of data to and from the UI components, handling user interactions and updating the state accordingly.

- **Pages**

Individual screens or views within the application, each representing a specific section or functionality.

## Trouble shooting experience

- [What are some best practices in Flutter for responsive layout?](https://yesj1234.github.io/posts/responsive_layout)
- [How can I manage important states used in application?](https://yesj1234.github.io/posts/riverpod)
- [How can I handle union types in Dart gracefully?](https://yesj1234.github.io/posts/union_types)
- [How can I structure application code for maintainability and readability?](https://yesj1234.github.io/posts/flutter_app_architecture)
- [How can I document my code for future coworkers?](https://yesj1234.github.io/posts/dart_docs)
- [Why is my Hero animation not work as expected?](https://yesj1234.github.io/posts/understanding_hero_animation)

## Packages in use 
These are the main packages. 
- [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) for data caching, dependency injection, and more
- [GoRouter](https://pub.dev/packages/go_router) for navigation
- [Firebase Auth](https://pub.dev/packages/firebase_auth) for authentication
- [Cloud Firestore](https://pub.dev/packages/cloud_firestore) as a realtime database
- [Firebase Storage](https://pub.dev/packages/firebase_storage) for Cloud storage solution provided by firebase.
- [Flex Color Scheme](https://pub.dev/packages/flex_color_scheme) for advanced theming for Flutter apps
- [Image Picker](https://pub.dev/packages/image_picker) to select images from gallery or camera.
- [uuid](https://pub.dev/packages/uuid) to generates unique identifiers (UUIDs).
- [Shimmer](https://pub.dev/packages/shimmer) to create shimmer loading effects.
- [url_launcher](https://pub.dev/packages/url_launcher) to opens URLs, emails, and phone numbers.
- [Cached Network Image](https://pub.dev/packages/cached_network_image) for caching and loading network images efficiently.

These are the dev dependencies .
- [Json Serializable](https://pub.dev/packages/json_serializable) to generate JSON serialization code.
- [Freezed](https://pub.dev/packages/freezed) to automate code generation for immutable classes.
- [Build Runner](https://pub.dev/packages/build_runner) runs code generators like freezed and json_serializable.


See the [pubspec.yaml](/pubspec.yaml) file for the complete list.



## TODO

- [ ] Fix detail view for image to show the whole image while maintaining the hero animation clear.
- [ ] Add charts and graphical status of the user's journals, such as badges, various graphs, etc. 
- [ ] Add filters for community view. 
- [ ] Upgrade the overall design of the application. 
- [ ] Automate the publishing process via Xcode or github. 
- [ ] Add missing test.
- [ ] Fix Android Kakao login error

## Version note 
- version 1.0.0: Initial release 
- version 1.0.1: Fix Hero animation, change image border radius rules.  
- version 1.0.2: Add draggable gesture for day view journals. Block community view journals that has date set over current date. 
- version 1.0.3: Change monthly view UI. Removed the items shown underneath the calendar. When clicking a certain date from calendar, show the daily view of that selected day in a page view.
- version 1.0.4: Fix handling on deleting the journal callback. 
## Installation

To get started with **Farmer's Journal**, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/farmers-journal.git
   cd farmers-journal
   ```

2. **Install Dependencies**:
   Ensure you have Flutter installed. Then, run:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   ```bash
   flutter run
   ```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add YourFeature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a Pull Request.

## Contact

For questions or suggestions, please contact Yang Seung Jun at [juesc007@gmail.com](mailto:juesc007@gmail.com).

Track what things to be done based on your past notes and ohter farmers notes. 

## License: [MIT](/LICENSE.md)

