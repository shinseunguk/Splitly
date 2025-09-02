# 📊 Splitly
> 팀 스코어 추적 및 시각화 Flutter 앱

## 📝 프로젝트 소개

Splitly는 팀 기반의 경쟁이나 게임에서 실시간으로 점수를 추적하고 시각화하는 Flutter 애플리케이션입니다. 막대 차트를 통해 각 팀의 점수를 직관적으로 확인할 수 있으며, 실시간으로 업데이트되는 데이터를 제공합니다.

## ✨ 주요 기능

- 📊 **실시간 스코어 시각화**: FL Chart를 활용한 반응형 막대 차트
- 👥 **팀 관리**: 팀 생성, 수정, 삭제 기능
- 🎯 **점수 관리**: 팀별 점수 추가, 수정 시스템
- 🔄 **자동 업데이트**: 5초마다 자동으로 데이터 갱신
- 📱 **반응형 디자인**: 모바일과 웹 환경 모두 지원
- 🏆 **팀 랭킹**: 점수 기반 자동 순위 산정

## 🛠 기술 스택

### Frontend
- **Flutter** (Dart) - 크로스 플랫폼 UI 프레임워크
- **GetX** - 상태 관리 및 의존성 주입
- **FL Chart** - 차트 시각화 라이브러리
- **HTTP** - REST API 통신

### 아키텍처
- **MVVM 패턴** - Model-View-ViewModel 구조
- **Repository 패턴** - 데이터 레이어 추상화
- **Clean Architecture** - 관심사 분리

## 🏗 프로젝트 구조

```
lib/
├── dataSource/          # 데이터 소스 계층
│   ├── team_data_source.dart
│   └── team_score_data_source.dart
├── model/               # 데이터 모델
│   ├── score/
│   │   └── team_score_model.dart
│   └── team/
│       ├── team_create_response.dart
│       └── team_model.dart
├── repository/          # 리포지토리 계층
│   ├── team_repository.dart
│   └── team_score_repository.dart
├── view/               # UI 화면
│   ├── home_view.dart
│   ├── score_manage_view.dart
│   ├── team_create_view.dart
│   ├── team_manage_view.dart
│   └── team_menu_view.dart.dart
├── viewModel/          # 비즈니스 로직
│   ├── team_create_view_model.dart
│   └── team_score_view_model.dart
└── main.dart           # 앱 진입점
```

## 🚀 시작하기

### 사전 요구사항
- Flutter SDK 3.7.2 이상
- Dart SDK
- Android Studio / VS Code
- iOS 개발 시 Xcode (macOS)

### 설치 및 실행

1. **저장소 클론**
   ```bash
   git clone https://github.com/your-username/splitly.git
   cd splitly
   ```

2. **의존성 설치**
   ```bash
   flutter pub get
   ```

3. **앱 실행**
   ```bash
   flutter run
   ```

### 빌드

- **Android APK**
  ```bash
  flutter build apk --release
  ```

- **iOS IPA**
  ```bash
  flutter build ios --release
  ```

- **Web**
  ```bash
  flutter build web
  ```

## 📋 사용법

1. **앱 실행**: 홈 화면에서 실시간 팀 스코어 차트 확인
2. **팀 관리**: 우상단 정보 버튼을 통해 팀 메뉴 접근
3. **팀 생성**: 새로운 팀 추가 및 멤버 설정
4. **점수 관리**: 각 팀의 점수 수정 및 업데이트
5. **실시간 모니터링**: 자동으로 업데이트되는 스코어보드 확인

## 🔧 개발 환경 설정

### API 서버 연동
백엔드 API 서버의 엔드포인트를 `lib/dataSource/` 파일들에서 설정하세요.

### 환경 변수
필요한 환경 변수가 있다면 `.env` 파일을 생성하여 관리하세요.

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

---

**개발자**: Incross Team  
**버전**: 1.0.0  
**최종 업데이트**: 2024년


<!-- Security scan triggered at 2025-09-02 15:04:26 -->