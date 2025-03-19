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
