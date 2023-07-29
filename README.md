### 🧑🏻‍💻 DevReels 👩🏻‍💻 

<img src="https://github.com/DevReelsTeam/DevReels/assets/121999075/2e98fac7-1c44-45dd-b935-25ffb9903fb6">


> **개발자들을 위한 숏폼 커뮤니티 플랫폼 'DevReels'입니다.**

- 개발한 기능을 공유하고 다른사람의 기능을 둘러볼 수 있습니다.
- 관심있는 상대를 팔로우 할 수 있습니다.
- 댓글을 통해 소통하고 기능에 대한 소스코드를 공유할 수 있습니다.



<p align = "center">

| <img src="https://avatars.githubusercontent.com/u/64826110?v=4" width="200"> | <img src="https://avatars.githubusercontent.com/u/121999075?v=4" width="200"> | <img src="https://avatars.githubusercontent.com/u/73777995?v=4" width="200"> | 
| ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | 
| **Jerry_한종우**                                                             | **Clamp_강현준**                                                              | **Hoduya_최호준**                                                             |                                                            |
| [@gwd0311](https://github.com/gwd0311)                                     | [@HyeonjunKKang](https://github.com/HyeonjunKKang)                                        | [@Hoduya](https://github.com/Hoduya)                                           |

</p>

## **주요 기능 소개**

### **릴스(숏폼) 기능**

<img alt="릴스" src="https://github.com/DevReelsTeam/DevReels/assets/121999075/01aa92ed-8697-495b-ba8a-046c8bc52c4b" width="350">
</p>
  
- 관심있는 상대방을 팔로우할 수 있습니다.
- 좋아요를 눌러 관심을 표시할 수 있습니다.
- 기능에 해당하는 깃허브로 이동할 수 있습니다.



### **기능에 대해 의견(댓글)남기기**

<p>
<img alt="댓글" src="https://github.com/DevReelsTeam/DevReels/assets/121999075/11f066b4-8597-420d-bd79-cebab9d3d3e9" width="350>
</p>

- 시청한 영상에 대해 의견을 나눌 수 있습니다.
- 댓글을 통해 소통할 수 있습니다.



### **동영상 업로드하기**

<p>
<img alt="업로드" src="https://github.com/DevReelsTeam/DevReels/assets/121999075/906217ef-9d1b-4767-9ba6-4ac18b3818b1" width="350>
</p>

- 동영상을 업로드할 수 있습니다.
- 업로드할 동영상의 시작과 끝을 편집할 수 있습니다.



### **프로필**

<p>
<img alt="프로필" src="https://github.com/DevReelsTeam/DevReels/assets/121999075/1ba024d8-497a-4b21-baba-6101df2f295b" width="350>
</p>

- 원하는 유저의 프로필을 열람할 수 있습니다.
- 유저가 업로드한 포스트를 모아볼 수 있습니다.



### **팔로우**

<p>
<img alt="팔로우" src="https://github.com/DevReelsTeam/DevReels/assets/121999075/f511bced-9d1f-4dba-a3cd-ab0a313f25d9" width="350>
</p>

- 원하는 유저를 팔로우/언팔로우 할 수 있습니다.

---



## **⚒️ 기술적 도전**

### **Clean Architecture**
<p>
<img alt="Coodinator" src="https://github.com/DevReelsTeam/DevReels/assets/121999075/ae1a2e52-6ec8-494b-966d-025dd5624347">
</p>

**Why**

develop하게 되면 서버와 디자인에 가변적인 상황이 벌어질 수 있을 것이라 생각했습니다. 비즈니스 로직을 앱의 핵심적인 파트로 보고 결합도를 낮출 수 있는 구조 설계를 고민하였고, Clean-Architecture가 적합하고 판단되어 아키텍처적 도전을 하게되었습니다.

**Result**

- View - ViewModel - UseCase - Repository - DataSource로 레이어를 나누고 모든 의존성이 outer에서 inner를 향하도록 구현하였습니다.
- 서버에서 온 데이터의 모델과 앱 내에서 사용되는 데이터의 모델을 분리하여 서버의 변경에 유연하게 대처할 수 있었습니다.
- Repository 패턴을 이용해 DataSource를 캡슐화했습니다.
- 앱의 핵심적인 로직인 UseCase를 작은 기능의 단위로 나누어 단일 책임 원칙을 준수하도록 구현하여 재사용성을 높여 생산성을 높일 수 있었습니다.
- 계층과 모듈의 역할이 명확하게 분리되어 코드 가독성, 재사용성, 테스트 코드 작성 시 리소스 절감으로 이어졌습니다.

---

### **RxSwift + MVVM**
<p>
<img alt="Coodinator" src="https://github.com/DevReelsTeam/DevReels/assets/121999075/515d1933-9d50-440e-b9f8-40a66d4cb5ae">
<img alt="Coodinator" src="https://github.com/DevReelsTeam/DevReels/assets/121999075/c3769aba-9df1-4d33-baad-cd2bd23ae052">
</p>

**Why**

사용자 입력 및 뷰의 로직과 비즈니스에 관련된 로직을 분리하기 위해 MVVM 패턴을 채택하고 데이터 흐름을 단방향으로 관리하기 위해 ViewModel을 Input과 Output으로 모델링하였습니다.

**Result**

- 반응형 프로그래밍 언어인 RxSwift를 활용해 MVVM패턴의 적용에 더욱 용이할 수 있었습니다.
- Input에 대한 처리 결과를 Output에 담아서 보낼 때 RxTraits를 사용하여 Thread-Safe하게 UI를 업데이트할 수 있었습니다.
- ViewController에 의존하지 않고 테스트 용이한 구조의 ViewModel을 구성할 수 있었습니다.

---

### **Coordinator**

<img alt="RXMVVM" src="https://github.com/DevReelsTeam/DevReels/assets/121999075/26d1ee9d-b4c2-4144-bbcf-3d15274f7463">

**Why**

화면 전환 로직을 ViewController에서 분리하기 위해 Coordinator 패턴을 도입했습니다.

**Result**

- 코디네이터로 화면 전환 로직이 모이게 되면서 전체 흐름을 파악하기 쉬워졌습니다.
- 의존성 주입 코드를 코디네이터로 분리할 수 있었습니다.
- ViewController를 더 가볍고 쉽게 재사용할 수 있게 되었습니다.

---

### **DI Container**

**Why**

화면 전환을 담당하는 Coordinator에서 의존성 주입의 역할을 분리하기 위해 DIContainer를 도입했습니다.

**Result**

- 의존성 주입에 대한 보일러 플레이트 코드가 감소했습니다.
- 의존성을 한 곳에서 관리할 수 있게 되었습니다.

---

### **Firebase + REST API**

**Why**

서버 개발자없이 프로젝트를 진행하기 위해 Firebase를 사용했습니다. 그러나 Firebase SDK에 대한 의존도를 낮추고자 REST API를 이용하여 네트워크 통신을 진행했습니다.

**Result**

- 한가지 액션에 대한 다중 네트워크 호출 처리를 Data Layer에서 진행하여 다른 Layer에 영향을 끼치지 않도록 구현하였습니다.
- 외부 라이브러리에 대한 의존성을 낮추기 위해 자체 네트워크 레이어를 구현하였고, 템플릿화된 코드 덕분에 Endpoint의 재사용성이 올라갔습니다.
- Firebase REST API 통신으로 인한 복잡한 요청∙응답에 맞는 DTO를 모델링하였습니다.

---

### **Tuist**

<p>
<img width = "50%" alt="tuist1" src="https://user-images.githubusercontent.com/86254784/207780843-1b303ffa-d7ac-42b5-8ebb-1add1d1a3c01.png">
</p>

**Why**

협업 초반 반복되는 `.xcodeproj` 파일의 충돌로 생산성 저하를 느꼈고, 수동적인 해결에 의존하기보다 자동화 시킬 수 있는 프로젝트 관리 툴의 필요성을 느꼈습니다.

**Result**

- `.xcodeproj` 파일 conflict 문제 해결로 생산성 저하 문제를 해결할 수 있었습니다.
- 자체 Image Cacher, Network Layer를 모듈화하여 관리할 수 있었습니다.

---

## **협업 방식**

### **Github**

- Github를 활용해 협업해왔습니다.
- 2명 이상이 approve를 해야 PR이 merge되도록 설정하였습니다.
