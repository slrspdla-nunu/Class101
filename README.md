# CLASS101 리디자인 (포트폴리오)

온라인 클래스 플랫폼 **CLASS101**을 **나만의 다크 + 네온 옐로우 무드로 재해석한** 리디자인 포트폴리오 프로젝트입니다.
원본 사이트를 그대로 따라 만든 클론이 아니라, 레이아웃과 디자인 시스템을 직접 새로 구성했습니다. (콘텐츠·데이터는 CLASS101에서 수집해 활용)
순수 **HTML · CSS · JavaScript**로 제작했습니다.

> 🔗 GitHub Pages로 배포 시 `https://slrspdla-nunu.github.io/Class101/` 에서 확인할 수 있어요.

---

## ✨ 주요 특징

- **일관된 디자인 시스템** — 다크 테마(`#161616` / `#1f1f1f` / `#252525`) + 네온 옐로우 그라데이션(`#E5F800 → #BEF800`)
- **실제 데이터 기반** — 클래스 제목·크리에이터·평점·썸네일을 CLASS101에서 수집해 구성
- **인터랙션 구현**
  - Swiper 기반 히어로 슬라이더 (화살표 · 페이지네이션)
  - 무신사 스타일 **카테고리 메가메뉴** (헤더 "카테고리" 클릭 시 펼침 · 아코디언)
  - **마우스 드래그 가로 캐러셀** (인기 클래스 TOP 10) + 좌우 이동 버튼
  - 카테고리 필터 칩 · 정렬 아코디언
  - `localStorage` 기반 **목업 로그인** & 마이페이지 상태 반영
- **카드 호버 효과** — 떠오르기 + 네온 글로우 + 썸네일 줌 + 제목 강조

---

## 📄 페이지 구성

| 구분 | 파일 | 설명 |
|------|------|------|
| 메인 | `index.html` | 홈 (히어로 슬라이더, 추천 클래스, 카테고리) |
| 클래스 | `class.html` | 클래스 목록 (검색 · 필터 · 정렬) |
| 클래스 상세 | `class-kakimaku.html`, `class-yurang.html`, `class-brr.html` | 소개 · 커리큘럼 · 후기 · 추천 클래스 |
| 멤버십 | `membership.html` | 멤버십 목록 (Swiper 슬라이더 · 카테고리별) |
| 멤버십 상세 | `membership-baksaesama.html` | 브릉이 멤버십 소개 |
| 크리에이터 홈 | `home-baksaesama.html` | 브르 크리에이터 페이지 (프로필 · 커뮤니티 · 클래스) |
| 결제 | `payment-baksaesama.html` | 결제 화면 (목업) |
| 커뮤니티 | `community.html`, `post-thefieldplayer.html`, `post-brr-topic.html` | 피드 · 게시글 상세 |
| 카테고리 | `category-illust.html` | 디지털 드로잉 › 일러스트 (TOP 10 캐러셀 · 전체 목록) |
| 계정 | `login.html`, `signup.html` | 로그인 · 회원가입 |
| 마이페이지 | `mypage.html`, `my-classes.html`, `settings.html` | 대시보드 · 내 클래스 · 계정 설정 |

---

## 🧪 테스트 계정

목업 로그인용 테스트 계정입니다.

```
이메일:   test@gmail.com
비밀번호: test1234
```

로그인하면 헤더가 "마이페이지 / 로그아웃"으로 바뀌고, 마이페이지에 정보가 반영됩니다.

---

## 🛠 기술 스택

- HTML5 · CSS3 · Vanilla JavaScript
- [Swiper](https://swiperjs.com/) (히어로 슬라이더, CDN)
- 폰트: Paperozi(Paperlogy), Anton

프레임워크/빌드 도구 없이 정적 파일로만 동작합니다.

---

## 📁 폴더 구조

```
0610_class101/
├── index.html
├── class.html / class-*.html
├── membership.html / membership-baksaesama.html
├── community.html / post-*.html
├── category-illust.html
├── login.html / signup.html
├── mypage.html / my-classes.html / settings.html
├── home-baksaesama.html / payment-baksaesama.html
├── css/
│   ├── style.css          # 전체 스타일 (디자인 시스템)
│   └── font.css
├── js/
│   └── category-menu.js   # 카테고리 메가메뉴 · 로그인 상태 처리
└── image/                 # 로고 · 아이콘 등 정적 이미지
```

---

## ▶ 실행 방법

별도 설치 없이 `index.html`을 브라우저로 열면 됩니다.
또는 GitHub Pages(`Settings → Pages → main 브랜치`)로 배포해 URL로 접속할 수 있습니다.

---

## 📝 참고 사항

- **학습 · 포트폴리오 목적**의 리디자인 프로젝트입니다. 원본을 복제한 것이 아니라 UI/레이아웃을 직접 재설계했으며, 모든 클래스 콘텐츠·이미지·브랜드의 권리는 **CLASS101**에 있고 상업적 목적이 아닙니다.
- 로그인·결제는 실제로 동작하지 않는 **목업(mock-up)** 입니다.
- 일부 썸네일 이미지는 CLASS101 CDN을 통해 표시됩니다.
- 현재 **데스크톱 기준**으로 제작되었으며, 모바일 반응형은 추후 작업 예정입니다.
