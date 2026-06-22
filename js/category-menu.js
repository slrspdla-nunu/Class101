// 헤더 "카테고리" 클릭 시 슬라이드 다운 메가메뉴 (class101 실제 카테고리 기반)
(function () {
    var LINKS = { '일러스트': 'category-illust.html' };
    var CATS = [
        { t: '디지털 드로잉', s: ['일러스트', '컨셉아트', '캐릭터 드로잉', '인물 드로잉', '굿즈·이모티콘', '웹툰', '캘리그라피'] },
        { t: '드로잉', s: ['펜·연필', '마카', '색연필', '수채화', '유화', '동양화'] },
        { t: '공예', s: ['대바늘 뜨개', '코바늘 뜨개', '자수', '가죽 공예', '플라워 공예', '도예', '레진 공예'] },
        { t: '요리·음료', s: ['한식', '일식·중식', '양식', '세계요리', '건강·다이어트식', '음료·술'] },
        { t: '베이킹·디저트', s: ['케이크', '제과', '제빵', '떡·전통다과', '비건'] },
        { t: '음악', s: ['악기', '보컬·랩', '작곡·프로듀싱'] },
        { t: '운동', s: ['요가', '필라테스', '발레', '러닝·사이클', '피트니스', '스포츠'] },
        { t: '라이프스타일', s: ['뷰티', '명상', '심리', '타로·사주·운세', '게임·e스포츠', '댄스·무용', '반려동물', '인문학'] },
        { t: '사진·영상', s: ['사진', '영상'] },
        { t: '금융·재테크', s: ['주식', '부동산'] },
        { t: '창업·부업', s: ['국내 쇼핑몰', '해외 쇼핑몰', '블로그', '유튜브', 'SNS', '전자책·디지털파일', '요식업'] },
        { t: 'AI', s: ['AI 스킬업', '생성형 AI 실전', 'AI 수익화', 'AI 비즈니스 생산성', 'AI 크리에이티브', 'AI 엔지니어링'] },
        { t: '개발·프로그래밍', s: ['Web·프론트엔드', '백엔드', 'App', '게임', '데이터분석', '인공지능', '딥러닝·머신러닝', 'IT교양'] },
        { t: '기획·비즈니스', s: ['제품 기획', 'PM·PO', 'UI·UX', '사업기획·전략', '리더십', '취업·이직', '재무·회계', '생산성'] },
        { t: '마케팅', s: ['디지털마케팅', '퍼포먼스마케팅', '콘텐츠마케팅', 'CRM마케팅', '브랜드마케팅'] },
        { t: '디자인', s: ['디자인툴', '그래픽디자인', '브랜드디자인', '타이포그래피', '건축디자인'] },
        { t: '영상/3D', s: ['영상편집', '모션그래픽', '게임그래픽', '3D'] },
        { t: '외국어', s: ['영어회화', '외국어 시험', '토익', '오픽', '중국어', '일본어', '기타언어'] },
        { t: '아이 교육', s: ['미술·공예', '요리', '자연·과학', '수학·코딩', '사회·경제', '언어·외국어', '음악'] },
        { t: '부모 교육', s: ['육아', '학습'] }
    ];

    function build() {
        var header = document.querySelector('header.centerbox');
        if (!header) return;

        var trigger = null;
        header.querySelectorAll('.gnb li a').forEach(function (a) {
            if (a.textContent.trim() === '카테고리') trigger = a;
        });
        if (!trigger) return;

        var panel = document.createElement('div');
        panel.className = 'cat-mega';
        var html = '<div class="cat-mega-inner">';
        CATS.forEach(function (c) {
            html += '<div class="cat-col">'
                + '<button type="button" class="cat-head">' + c.t
                + '<svg class="cat-arrow" viewBox="0 0 24 24"><path d="M6 9L12 15L18 9" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/></svg>'
                + '</button><ul class="cat-subs">';
            c.s.forEach(function (s) { var href = LINKS[s] || '#'; html += '<li><a href="' + href + '">' + s + '</a></li>'; });
            html += '</ul></div>';
        });
        html += '</div>';
        panel.innerHTML = html;
        header.appendChild(panel);

        panel.querySelectorAll('.cat-head').forEach(function (head) {
            head.addEventListener('click', function (e) {
                e.stopPropagation();
                head.parentNode.classList.toggle('open');
            });
        });

        // 실제 페이지로 연결되는 메뉴 항목에 네온 점 (메뉴가 열렸을 때만 보임)
        function markCat(el) {
            if (!el || el.querySelector(':scope > .clickdot-mark')) return;
            if (getComputedStyle(el).position === 'static') el.style.position = 'relative';
            var d = document.createElement('span');
            d.className = 'clickdot-mark cat-dot';
            el.appendChild(d);
        }
        panel.querySelectorAll('.cat-col').forEach(function (col) {
            var hasLink = false;
            col.querySelectorAll('.cat-subs a').forEach(function (a) {
                var h = a.getAttribute('href');
                if (h && h !== '#') { markCat(a); hasLink = true; }
            });
            if (hasLink) markCat(col.querySelector('.cat-head'));
        });

        function syncBody() {
            document.body.classList.toggle('cat-open', panel.classList.contains('open'));
        }

        trigger.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            panel.classList.toggle('open');
            trigger.classList.toggle('cat-active');
            syncBody();
        });

        document.addEventListener('click', function (e) {
            if (!panel.contains(e.target) && e.target !== trigger) {
                panel.classList.remove('open');
                trigger.classList.remove('cat-active');
                syncBody();
            }
        });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                panel.classList.remove('open');
                trigger.classList.remove('cat-active');
                syncBody();
            }
        });
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', build);
    else build();
})();

// 로그인 상태에 따라 헤더 표시 (로그인 시: 마이페이지 / 로그아웃)
(function () {
    function applyAuth() {
        var user = null;
        try { user = JSON.parse(localStorage.getItem('c101_user')); } catch (e) {}
        if (!user) return;
        var loginA = document.querySelector('.loginbox .login a[href*="login.html"]');
        var signupA = document.querySelector('.loginbox .login a[href*="signup.html"]');
        if (loginA) { loginA.textContent = '마이페이지'; loginA.setAttribute('href', 'mypage.html'); }
        if (signupA) {
            signupA.textContent = '로그아웃';
            signupA.setAttribute('href', '#');
            signupA.addEventListener('click', function (e) {
                e.preventDefault();
                try { localStorage.removeItem('c101_user'); } catch (err) {}
                location.href = 'index.html';
            });
        }
    }
    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', applyAuth);
    else applyAuth();
})();

// 클릭 가능한 요소를 네온 점으로 표시 (토글)
(function () {
    // 항상 동작하는 컨트롤(메뉴·필터·정렬·캐러셀·더보기) → 무조건 표시
    var ALWAYS = ['.gnb li a', '.sort_btn', '.cls_nav'];
    // 조건부: 실제로 페이지 이동/동작이 있을 때만 표시
    var CONDITIONAL = [
        '.board', '.board2', '.mem_card', '.cls_card', '.rec_card',
        '.post_card', '.class_card', '.my_membership',
        '.hero_btn', '.subscribe_btn', '.plan_btn',
        '.home_link', '.loginbox .login a', '.my_menu a',
        '.creator_box .csns a', '.cr_btns a'
    ];

    function validHref(a) {
        var h = a && a.getAttribute('href');
        return !!h && h.trim() !== '' && h.trim() !== '#' && !/^javascript:/i.test(h);
    }
    function isActionable(el) {
        if (el.tagName === 'BUTTON') return true;
        if (el.hasAttribute('onclick')) return true;
        if (el.tagName === 'A' && validHref(el)) return true;
        var a = el.querySelector('a[href]');
        return !!(a && validHref(a));
    }
    function placeDot(el) {
        if (el.closest('.clickguide-btn')) return;
        if (el.querySelector(':scope > .clickdot-mark')) return;
        if (getComputedStyle(el).position === 'static') {
            el.style.position = 'relative';
            el.setAttribute('data-cd-pos', '1');
        }
        var d = document.createElement('span');
        d.className = 'clickdot-mark';
        if (el.closest('.cat-mega')) d.className += ' cat-dot';
        el.appendChild(d);
    }

    function addDots() {
        ALWAYS.forEach(function (sel) {
            document.querySelectorAll(sel).forEach(placeDot);
        });
        CONDITIONAL.forEach(function (sel) {
            document.querySelectorAll(sel).forEach(function (el) {
                if (isActionable(el)) placeDot(el);
            });
        });
    }

    function removeDots() {
        // 메뉴 점(.cat-dot)은 항상 유지, 토글로 켠 점만 제거
        document.querySelectorAll('.clickdot-mark:not(.cat-dot)').forEach(function (d) { d.remove(); });
        document.querySelectorAll('[data-cd-pos]').forEach(function (el) {
            el.style.position = '';
            el.removeAttribute('data-cd-pos');
        });
    }

    function build() {
        if (document.querySelector('.clickguide-btn')) return;
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'clickguide-btn';
        btn.innerHTML = '<span class="cg-dot"></span><span class="cg-label">클릭 가능 표시</span>';
        document.body.appendChild(btn);

        var on = false;
        try { on = localStorage.getItem('c101_clickdots') === '1'; } catch (e) {}

        function apply() {
            document.body.classList.toggle('show-clickdots', on);
            btn.querySelector('.cg-label').textContent = on ? '표시 끄기' : '클릭 가능 표시';
            if (on) addDots(); else removeDots();
        }
        apply(); // 저장된 상태를 페이지 로드 시 복원

        btn.addEventListener('click', function () {
            on = !on;
            try { localStorage.setItem('c101_clickdots', on ? '1' : '0'); } catch (e) {}
            apply();
        });
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', build);
    else build();
})();
