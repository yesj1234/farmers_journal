# Farmer's Journal

**Simplify farming, enhance productivity.**

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

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or suggestions, please contact Yang Seung Jun at [juesc007@gmail.com](mailto:juesc007@gmail.com).


Track what things to be done based on your past notes and ohter farmers notes. 

