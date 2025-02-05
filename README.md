# Project

**Title**: *Farmer's journal*

**SubTitle**: *Simplify farming, enhance productivity.*

**Introduction**: Track your farming journey, share insights, and optimize your methods with real-time data and visualizations. 

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

- **Yang seung jun** 

### Design 

- **figma** : https://www.figma.com/design/mH4hN1Mm68mfZOw7ZdPYLO/%EB%86%8D%EC%97%85%EC%9D%BC%EC%A7%80%EA%B8%B0%ED%9A%8D%EC%84%9C?node-id=0-1&t=rUAQsCf8aykENsmw-1

### Description

**Farmer's Journal** is helpful tool for modern farmers to enhance their farming methodologies. 

Whether you're managing a small garden or a large-scale farm, this app helps you document, analyze, and improve your farming processes step-by-step.

### Key Features 

- **Journal Creation and Management**:  
  Effortlessly record daily farming activities, including planting, watering, harvesting, and maintenance. Update and delete entries as needed, and access all your records in one place.

- **Data Visualizations**:  
  View your farming journey through visually engaging charts and graphs. Analyze trends and patterns to improve your methods and increase productivity.

- **Sharing & Collaboration**:  
  Share your farming journal with other users to exchange insights and strategies. Build a community of like-minded farmers to learn and grow together.

- **Encouragement to Write**:  
  Get gentle reminders and visual feedback to encourage consistent journal entries. Watch your progress over time and take pride in your farming journey.

## Code Structure 
The code structure reflects the Riverpod architecture.
You can read more about the architecture in [here](https://yesj1234.github.io/posts/flutter_app_architecture2) and [here](https://yesj1234.github.io/posts/flutter_app_architecture)
```
./lib
├── data
│   ├── interface
│   └── repositories
├── domain
│    ├── firebase
│    └── model
└── presentation
    ├── components
    ├── controller
    └── pages  
```


### Presentation
The role of the UI is to display the application data on the screen and also to serve as the primary point of user interaction.
Whenever the data changes, either due to user interaction (like pressing a button) or external input (like a network response), the UI should update to reflect those changes.
Effectively, the UI is a visual representation of the application state as retrieved from the data layer.

### Domain
The primary role of the domain layer is to define application-specific model classes that represent the data that comes from the data layer.

### Data
Data layer is the gateway between remote database and the application. 



**TODO** :
1. Riverpod Architecture를 어떻게 적용했는지 설명 
2. 외부 API를 어떻게 체계적으로 사용했는지 설명 (Data schema가 명확한 외부 source로부터 데이터를 받아와 사용할 때 모델을 어떻게 만들었고 왜 그렇게 만들었는지에 대한 고민들을 설명)
3. 