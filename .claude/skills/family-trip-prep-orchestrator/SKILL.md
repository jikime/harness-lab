---
description: 가족 여행 준비를 조사, 일정·예산 설계, 체크리스트 검토, HTML 대시보드 제작 순서로 진행할 때 사용한다. 최초 실행뿐 아니라 재실행, 부분 재실행("항공권 후보만 다시", "예산 다시 배분", "체크리스트만 갱신"), 이전 결과 기반 보완에도 사용한다. 여행과 무관한 하네스 설계 상담이나 일반 코딩 작업에는 사용하지 않는다.
---

# Family Trip Prep Orchestrator

## 목적

이 Orchestrator는 가족 여행 준비를 조사(trip-researcher) → 일정·예산 설계(itinerary-planner) → 체크리스트·검토(checklist-reviewer) → HTML 대시보드 조립(dashboard-builder) 네 역할로 나누고, 중간 산출물을 이어 최종 대시보드를 만든다. 실제 항공권/숙소 예약과 결제는 이 하네스가 실행하지 않는다 — 후보를 정리하고 사람의 승인을 받는 데까지만 책임진다.

## 실행 모드

기본 실행 모드는 Agent Team이다. 4개 역할이 순차 의존 관계를 가지고, checklist-reviewer가 itinerary-planner의 결과를 되돌려 수정 요청하는 상호작용이 있어 단일 흐름보다 Agent Team이 적합하다.

## 실행 모드 확인

1. `artifacts/family-trip-prep/`이 있는지 확인한다.
2. 없으면 초기 실행으로 진행하고 `artifacts/family-trip-prep/README.md`를 만든다.
3. 있고 사용자가 특정 단계만 요청하면("항공권 후보만 다시", "예산만 다시 배분", "체크리스트만 갱신", "대시보드만 다시 만들어줘") 해당 단계만 부분 재실행한다.
4. 완전히 새로운 여행으로 다시 시작해야 하면 기존 산출물을 `artifacts/family-trip-prep/archive/{YYYYMMDD-HHMMSS}/`에 보존하고 새 실행을 시작한다.
5. 기존 산출물이 있지만 사용자 의도가 불분명하면 "이어 하기 / 부분 수정 / 새 여행으로 새 실행" 중 무엇인지 먼저 확인한다.
6. 부분 재실행으로 앞 단계 파일이 바뀌면, 그 파일을 입력으로 삼는 뒤 단계 파일을 `README.md`에서 `stale`로 표시한다. 예: `01-research-notes.md`가 바뀌면 `02-itinerary-current.md`, `03-checklist-review.md`, `dashboard.html`을 `stale`로 표시한다.

## Agent Team 구성

| 팀원 | Agent 파일 | tools | model | 주요 산출물 |
| --- | --- | --- | --- | --- |
| trip-researcher | `.claude/agents/trip-researcher.md` | `WebSearch, WebFetch, Read, Write, Edit` | sonnet | `artifacts/family-trip-prep/01-research-notes.md` |
| itinerary-planner | `.claude/agents/itinerary-planner.md` | `Read, Write, Edit` | opus | `artifacts/family-trip-prep/02-itinerary-current.md` |
| checklist-reviewer | `.claude/agents/checklist-reviewer.md` | `Read, Write` | sonnet | `artifacts/family-trip-prep/03-checklist-review.md` |
| dashboard-builder | `.claude/agents/dashboard-builder.md` | `Read, Write` | haiku | `artifacts/family-trip-prep/dashboard.html` |

## Task 등록 계약

| Task | 담당 | 입력 | 출력 | 의존 | 완료 기준 | 상태 갱신 |
| --- | --- | --- | --- | --- | --- | --- |
| T01-input | Orchestrator | 사용자 요청 | `artifacts/family-trip-prep/00-trip-brief.md` | 없음 | 목적지, 날짜, 가족 구성, 예산, 제약이 정리됨 | 작성 완료 |
| T02-research | trip-researcher | `00-trip-brief.md` | `artifacts/family-trip-prep/01-research-notes.md` | T01 | 항공권·숙소 후보 각 2개 이상, 출처 포함 | 시작, 차단, 완료 |
| T03-itinerary | itinerary-planner | `00-trip-brief.md`, `01-research-notes.md`, (있으면) 직전 `03-checklist-review.md` | `artifacts/family-trip-prep/02-itinerary-current.md`(유일 정본) | T02, **미검토 버전 확인(아래 T03 진입 검사)** | 예산 항목 합산과 표시 합계 일치 | 시작, 차단, 완료 |
| T04-checklist-review | checklist-reviewer | `00-trip-brief.md`, `01-research-notes.md`, `02-itinerary-current.md` | `artifacts/family-trip-prep/03-checklist-review.md` | T03 | 예산 재검산·동선 검토 완료, 이슈 심각도 판정 | 시작, 차단, 완료 |
| T05-dashboard | dashboard-builder | `01-research-notes.md`, `02-itinerary-current.md`, `03-checklist-review.md` | `artifacts/family-trip-prep/dashboard.html` | T04 | 숫자 일치, 승인 배지 존재, 모바일 확인, **직전 검토가 조건부 승인이면 그 조건이 산출물에 실제로 반영됨(아래 T05 조건 이행 확인)** | 시작, 차단, 완료 |
| T06-artifact-sync | Orchestrator (dashboard-builder에게 위임하지 않음) | `dashboard.html`(갱신된 최종본) | `artifacts/family-trip-prep/dashboard-artifact.html` + Artifact 웹 발행/갱신 | T05 | `dashboard-artifact.html`의 데이터가 `dashboard.html`과 일치, 기존 Artifact URL이 있으면 그 URL로 갱신(새 URL 발급 방지). **본문(day-card·예산표)뿐 아니라 메타 요소(헤더 배지·D-day·`<title>`·하단 버전 로그·요약 리스크표처럼 본문 갱신 시 자연히 손대지 않는 별도 섹션)도 이전 버전 번호·날짜 문자열이 남아있는지 grep으로 스캔(2026-08-20·08-28·08-31 세 차례 방치 발견 이후 정식 반영, **추가로(2026-09-03 신설): `02-itinerary-current.md`의 1장 Day 표와 두 대시보드의 Day 카드에서 `HH:MM` 시각을 각각 집합으로 뽑아 차집합이 비는지 확인한다** — 대시보드에만 있고 정본에 없는 시각이 하나라도 나오면 그 카드는 옛 판이다. 42차에서 `dashboard.html`의 Day 7 자정 블록(불꽃놀이를 01:00~01:20에 배치 — 정본·쌍둥이본·노션은 전부 자정 정각)과 Day 8 오후 전체(산책·월먼 링크·트램·J.G. Melon 네 시각)가 옛 판인 채 방치돼 있던 것을 이 방법으로 처음 잡았다. 지금까지의 감사는 프로즈·리스크행·메모만 훑었고 Day 카드의 시각 자체를 정본과 대조한 적이 없었다. 태그 균형(`<strong>`/`<span>`/`<div>` 개폐 수)과 `iconv -f UTF-8 -t UTF-8`도 같이 돌린다. T06b 절 참고)** | 시작, 차단, 완료 |
| T06b-notion-sync | Orchestrator (서브에이전트에게 위임하지 않음) | `02-itinerary-current.md`·`03-checklist-review.md` 최신 데이터 | 노션 "뉴욕 여행 — 한장 정리" 페이지 | T06 | 노션 페이지의 예산 표·일자별 일정·조건부 사항 콜아웃이 최신 데이터와 일치, 제목·상단 안내문의 버전 표기 갱신 | 시작, 차단, 완료 |
| T07-record-close | Orchestrator | 이번 회차에 바뀐 모든 산출물 | `artifacts/family-trip-prep/README.md`, `artifacts/family-trip-prep/improvement-log.md` | T06b(대시보드·노션까지 간 회차) 또는 실제로 수행한 마지막 단계 | 이번 회차가 두 파일에 모두 기록됨(아래 T07 완료 기준) | 시작, 차단, 완료 |

T04에서 중요 이상 이슈가 발견되면 itinerary-planner에게 수정 Task를 재등록한다(최대 2회, `T03-itinerary-revision-N`).

### T03 진입 검사 — 미검토 버전 위에 덧쓰지 않기

T03을 시작하기 전에 **직전 버전이 T04 검토를 받았는지** 확인한다. `README.md`의 `03-checklist-review.md` 행이 현재 `02-itinerary-current.md` 버전을 검토한 상태가 아니면(예: 일정은 v7인데 검토는 v6까지), 그대로 진행하지 말고 다음 중 하나를 택한다.

- **원칙**: 미검토분을 먼저 T04로 검토한 뒤 새 요청을 T03에 태운다.
- **예외**: 사용자가 연속으로 요청해 중간 검토가 비효율적이면, 새 버전 작업을 진행하되 **다음 T04를 "통합 검토"로 등록**한다(예: `T04-checklist-review-v7+v8`). 이때 checklist-reviewer에게 **미검토 구간이 어디부터인지 명시적으로 알린다** — 그러지 않으면 reviewer가 마지막 회차만 보고 넘어간다.
- 어느 쪽이든 `README.md`에 미검토 구간이 있었다는 사실을 남긴다.

이 검사가 없으면 요청이 연달아 들어올 때 T04를 건너뛰고 T03만 반복하는 흐름이 생긴다(2026-07-30 v7이 실제로 그랬다).

### 일정 정본 `02-itinerary-current.md` — 이력을 파일에 쌓지 않는다(2026-09-03 통합)

**연혁**: 초기 설계는 `02-itinerary-draft.md`가 "과거 장을 소급 수정하지 않고 새 장으로만 갱신"하는 이력 누적 원본이었다. v28에 8,541줄이 되어 전수 대조가 비현실적이라는 reviewer 보고가 나왔고(폐기된 A안 09:05 열차 서술이 현행 표에 여덟 회차 잔존), 2026-09-02에 현행 값만 담은 스냅샷 `02-itinerary-current.md`를 별도로 뒀다. 그런데 스냅샷을 뒀는데도 draft는 v29~v32에서 계속 커졌고(9,282줄), **본표는 고치면서 그 값을 재인용하는 프로즈·리스크·메모는 안 고치는** 사고가 한 세션에서 5번 났다. 사용자가 "폐기된 건 지워버려 — 데이터가 너무 많으니까 못 찾는 거 아냐"라고 지시해, 2026-09-03에 **`02-itinerary-draft.md`를 폐지하고 `02-itinerary-current.md` 하나로 통합**했다.

**현재 규칙**:
- **`02-itinerary-current.md`가 유일한 일정 정본**이다(약 600줄, 현행 값만). planner·reviewer·dashboard-builder·T06·T06b 전부 이 파일 하나를 본다.
- planner는 이 파일에 **개정 이력 챕터를 쌓지 않는다** — 회차별 재검산·트레이드오프 계산 과정과 폐기 대안의 이유는 **git 커밋(`가족 여행 준비: N차 —`)에 위임**하고, 이 파일에는 「개정 이력 요약」 표에 v2~vNN 한 줄 행 하나만 추가한다.
- **Orchestrator는 T03 완료 판정 전에 grep으로** ① 이번 회차 바뀐 값이 프로즈·리스크·대조표·메모에 옛 값으로 남아 있지 않은지(바뀐 값의 *이전 값* 문자열로 검색), ② 헤더 버전 표기가 갱신됐는지 확인한다.
- reviewer T04에도 "이전 값 문자열 grep"이 필수 절차로 들어가 있다(checklist-reviewer 정의 3-1).

### 회차 진입 시 "가정" 값 산술 검증(2026-09-02 신설)

브리프·일정표에 "(가정)"으로 남아 있는 값은 회차마다 그냥 넘기지 말고, **확정값과 산술 대조가 가능한 것은 그 자리에서 계산**한다. "한국 08:30 출발 → 뉴욕 13:00 도착(가정)"은 비행 14.5시간·시차 14시간을 대입하면 10:00이 나오는데, 30회차 동안 "확인 필요"로만 남아 도착일 오후 3시간이 비어 있었다. 마찬가지로 "부족 가능성 높음" 같은 방향성 경고는 실가 조사로 금액을 확정한다(Blue Note 배정액이 실가의 1/3인 채 여덟 회차 유지). **가정이 여러 회차 살아남았다는 것 자체가 신호**다 — 회차 시작 시 `(가정)` grep 결과를 한 번 훑는다.

### T05 조건 이행 확인 — "조건부 승인"의 조건은 승인의 일부다

T04 결과가 **조건부 승인**이면(예: "이 리스크를 대시보드에 반드시 노출할 것"), 그 조건은 권고가 아니라 승인의 전제다. Orchestrator는 T05 완료를 판정하기 전에 **조건이 산출물에 실제로 들어갔는지 직접 확인한다** — dashboard-builder의 자체보고로 대신하지 않고, 생성된 `dashboard.html`에서 해당 문구·경고 요소를 찾아 확인한다. 조건이 빠졌으면 T05를 완료로 표시하지 않고 dashboard-builder에게 반영을 요청한다. T06의 `dashboard-artifact.html`에도 같은 조건이 들어가야 한다.

**T06을 Orchestrator가 직접 맡는 이유**: `Artifact` 발행 도구는 최상위 대화(Orchestrator)에만 있고 Task 서브에이전트에는 없다. `dashboard.html`은 TailwindCSS/Chart.js를 CDN으로 불러오는데, Artifact 게시 환경은 외부 CDN 요청을 막는 CSP를 쓰기 때문에 그대로 발행하면 스타일·차트가 깨진다. 그래서 CDN 없이 완전히 자체완결된 쌍둥이 파일(`dashboard-artifact.html`, 폰트까지 데이터 URI로 내장)을 별도로 유지한다.

### T06b-notion-sync — 노션 "한장 정리" 페이지도 매 회차 자동 갱신(2026-08-27 신설)

사용자가 데이터베이스 4개로 나뉜 기존 노션 페이지("일정표")가 편집하기 불편하다고 해서, 예산·예약·일정·체크리스트를 한 페이지에 담은 노션 페이지 **"뉴욕 여행 — 한장 정리"** 를 신설했다(2026-08-26). 이후 사용자가 명시적으로 "노션도 업데이트해줘"라고 요청할 때만 갱신했는데, **매번 요청해야 하는 방식은 결국 잊히기 쉽다** — 실제로 v22 회차에서 대시보드는 자동으로 갱신됐지만 노션은 사용자가 따로 요청할 때까지 v21 상태로 남아 있었다. 그래서 이 페이지도 **`dashboard-artifact.html`과 동급으로, 매 회차 자동 동기화 대상**으로 승격했다.

- **페이지 ID/URL은 `README.md`에 기록**한다(dashboard-artifact.html의 Artifact URL을 기록하는 방식과 동일). 처음 만들 때만 신규 생성하고, 이후에는 항상 이 URL로 `notion-update-page`를 호출해 같은 페이지를 갱신한다(새 페이지를 또 만들지 않는다).
- **갱신 대상**: 페이지 제목의 버전 표기, 상단 안내문의 "vNN 기준(날짜 갱신) 스냅샷" 줄, 상단 콜아웃의 "확인 필요 N건" 목록, 예산 배분 표, 예약 상태 체크리스트, 바뀐 날짜의 일자별 일정 토글, 준비 체크리스트 항목. `dashboard-artifact.html`을 만들 때 이미 정리한 "이번 회차에 뭐가 바뀌었는가" 목록을 그대로 재사용하면 된다 — 별도로 다시 분석할 필요 없음.
- **⚠ 노션 마크다운 문법 주의(2026-08-27 실제로 두 번 실패하고 알아낸 것)**: `<callout>`·토글처럼 "여는 태그 + 자식" 구조인 블록은 **여는 태그 줄에는 속성만 두고, 본문 텍스트는 반드시 다음 줄부터 탭으로 들여써서 시작**해야 한다. `<callout icon="⚠️">본문 텍스트...`처럼 태그와 텍스트를 같은 줄에 쓰면 태그가 그대로 이스케이프된 리터럴 텍스트로 렌더링되고 뒤에 낙동강 오리알 같은 `</callout>`이 별도 문단으로 남는다.
- **⚠⚠ `replace_content`(페이지 전체 재작성) 금지, 반드시 `update_content`(search-replace)만 사용할 것.** 이 페이지는 사용자가 여행 준비 중 체크박스를 직접 켜고 끄며 쓰는 실사용 문서다(예약 상태·일자별 체크리스트). `replace_content`로 페이지를 통째로 다시 쓰면 **사용자가 이미 체크해 둔 항목까지 전부 초기화**된다 — 이건 `dashboard-live.html`을 자동 파이프라인에서 애초에 제외한 것과 똑같은 이유의 위험이다. 다행히 이 페이지는 `dashboard-live.html`과 달리 **"매 회차 데이터를 다시 채우는" 성격이라 자동 동기화 자체는 안전**하지만, 그 동기화 방법이 `update_content`로 **바뀐 부분만 정확히 짚어 교체하는 것**이어야 안전하다는 뜻이다 — 안 바뀐 체크박스·토글은 건드리지 않고 그대로 둔다.
- **`dashboard-live.html`과는 무관하다** — 그 파일은 뷰어가 직접 편집하는 라이브 문서라 자동 재발행하면 편집 내용이 사라지므로 파이프라인에서 의도적으로 제외돼 있다(아래 절 참고). 반면 "한장 정리" 노션 페이지는 `dashboard.html`과 성격이 같은 **"매 회차 통째로 다시 채우는" 스냅샷**이라 자동 동기화가 안전하다.
- 기존 데이터베이스 4개짜리 "일정표" 페이지는 건드리지 않는다(사용자가 삭제를 요청하지 않는 한 그대로 둔다).

### `dashboard-live.html` — T06과는 별개의 편집 가능 대시보드(2026-08-20 신설)

사용자가 "대시보드를 편집 가능하게, DB에 연결하고 싶다"고 요청해 신설한 세 번째 산출물. `artifacts/family-trip-prep/dashboard-live.html`을 Artifact `capabilities: {artifact: {}}`(라이브 문서)로 발행해, 뷰어의 클릭·타이핑이 그대로 저장·동기화되는 재량 예산 표 + 자유 메모 카드를 제공한다(항목 추가/삭제, 금액·메모 수정). URL: https://claude.ai/code/artifact/f1266676-b0f9-4a81-9d78-9abfea0e287e

**`dashboard.html`/`dashboard-artifact.html`(T05·T06)과 반드시 구분할 것 — 절대 같은 파이프라인에 넣지 않는다**:

- T05·T06은 매 회차 **전체를 다시 만들어 재발행**하는 것이 정상 동작이다(일정이 바뀌면 대시보드도 그 데이터로 통째로 교체).
- `dashboard-live.html`은 반대로 **한 번 시딩한 뒤에는 자동으로 다시 발행하지 않는다.** 라이브 문서는 뷰어의 편집을 그 페이지의 마크업 자체에 저널로 누적하는 방식이라, Orchestrator가 새 데이터로 다시 `Artifact` 발행을 하면 그 순간까지 쌓인 부부의 편집 내용(추가한 항목, 고친 메모)이 통째로 사라진다.
- 따라서 이 파일은 **T03~T07 자동 파이프라인의 입력에도 출력에도 포함되지 않는다.** 일정·예산이 크게 바뀌어도(v20, v21 ...) 이 페이지를 자동으로 갱신하지 않는다.
- 저장소의 `dashboard-live.html`은 최초 발행 당시의 "시드" 스냅샷일 뿐이며, 이후 실제 편집 내용은 발행된 웹 페이지에만 존재하고 저장소 파일과 자연히 갈라진다. 되돌리기용 백업이 필요하면 그때 가서 웹 페이지 내용을 다시 파일로 옮겨 적어야 한다.
- 사용자가 "재량 예산 기준선 자체를 바꿔달라"고 명시적으로 요청하는 경우에만, 그 요청을 별도 작업으로 다뤄 새 시드로 재발행할지(=편집 내용 초기화 동의를 먼저 받고) 판단한다 — 절대 T06의 일부인 것처럼 자동으로 같이 재발행하지 않는다.

## Agent Team 실행 흐름

1. 사용자 요청에서 목적지, 날짜, 가족 구성(인원·나이), 예산, 제약을 확인한다. 부족하면 질문하고 추측하지 않는다.
2. `artifacts/family-trip-prep/00-trip-brief.md`에 정리해 저장한다.
3. `TeamCreate`로 4개 역할을 팀원으로 구성한다(모델 정책은 위 표를 그대로 팀 생성 지시에 반영한다).
4. `TaskCreate`로 T01-T07을 등록한다(T06·T06b·T07은 Orchestrator가 직접 수행하는 단계지만, 빠뜨리지 않도록 Task로도 등록한다).
5. 각 팀원은 자기 Task를 시작·차단·완료 시 `TaskUpdate`로 갱신한다.
6. Orchestrator는 `TaskGet`으로 지연·차단·의존 관계 막힘을 확인한다.
7. 팀원은 발견·충돌·완료를 `SendMessage`로 공유한다. checklist-reviewer가 중요 이상 이슈를 찾으면 itinerary-planner에게 수정 요청 메시지를 보낸다.
8. 각 산출물은 파일로 저장한다(`artifacts/family-trip-prep/` 아래).
9. Orchestrator는 모든 산출물을 읽고 누락·충돌·승인 필요 지점을 정리한다.
10. `dashboard.html`을 최종 산출물로 삼는다. 이때 직전 T04가 조건부 승인이었으면 위 "T05 조건 이행 확인"을 수행한다.
11. **Artifact 동기화(T06, Orchestrator 직접 수행)**: `artifacts/family-trip-prep/dashboard-artifact.html`이 아직 없으면 `dashboard.html`을 CDN 없는 자체완결 버전으로 새로 만들어 저장한다(폰트는 data URI로 내장, 디자인은 처음 한 번만 공들여 만들고 이후에는 데이터만 갱신). 이미 있으면 `dashboard.html`과 같은 값으로 데이터 부분만 옮겨 적는다(레이아웃·CSS·폰트는 그대로 둔다). 그 다음 `Artifact` 도구로 발행한다 — `README.md`에 기록된 기존 Artifact URL이 있으면 그 `url`을 지정해 같은 링크를 유지하고, 없으면 새로 발행한 뒤 URL을 `README.md`에 기록한다.
12. **노션 동기화(T06b, Orchestrator 직접 수행)**: 위 "T06b-notion-sync" 절 지시대로 노션 "한장 정리" 페이지를 이번 회차 데이터로 갱신한다. 페이지가 아직 없으면(최초 실행) 새로 만들고 URL을 `README.md`에 기록하며, 있으면 항상 같은 URL로 갱신한다.
13. **기록 종료(T07, Orchestrator 직접 수행)**: 아래 "기록 종료(T07)" 절차대로 `README.md`와 `improvement-log.md`를 갱신한다. **이 단계를 끝내기 전에는 회차를 완료로 보고하지 않는다.**
14. `TeamDelete`로 팀을 정리한다.
15. 항공권/숙소 예약, 결제처럼 사람 승인이 필요한 항목이 있으면 아래 "승인 요청" 형식으로 멈추고 사용자에게 확인을 요청한다. 승인 전에는 실제 예약·결제를 진행하지 않는다.

## 승인 요청 형식

```md
## 승인 요청

- 승인 대상: 정리된 항공권/숙소 후보로 실제 예약·결제를 진행할지 여부
- 필요한 이유: 실제 결제와 예약은 되돌리기 어렵고 금전이 결부된 행동이라 하네스가 대신 실행하지 않음
- 승인하면 일어나는 일: 사용자가 대시보드의 후보를 보고 직접 항공사·숙소 사이트에서 예약을 진행함(이 하네스는 예약을 대신하지 않음)
- 지금 상태: 사람 승인 필요 (아직 예약·결제하지 않음)
- 확인해 주세요: `dashboard.html`의 항공권/숙소 후보, 예산 합계, 체크리스트 이슈 목록
- 보류하면: 후보 유지, 다음 실행에서 조사 단계부터 다시 진행 가능
```

## 실패 처리

- 입력이 부족하면(목적지·날짜·예산 등) 바로 진행하지 않고 질문한다.
- 팀원 1명이 실패하거나 응답이 없으면 `TaskGet`으로 확인 후 `SendMessage`로 원인을 묻고 1회 재시도한다. 재시도도 실패하면 재할당하거나 누락으로 표시하고 사용자에게 영향도를 보고한다.
- checklist-reviewer가 치명 이슈를 2회 수정 요청 후에도 해결하지 못하면, 계속 반복하지 말고 사용자에게 현재 상태와 선택지를 보고한다.
- dashboard-builder가 입력 파일 간 숫자 불일치를 보고하면, 임의로 조정하지 말고 itinerary-planner에게 재확인을 요청한다.
- 항공권/숙소 예약, 결제는 사람 승인 전 완료하지 않는다.

## 기록 종료(T07)

각 회차(초기 실행, 부분 재실행 모두)는 산출물을 만든 것으로 끝나지 않는다. **아래 두 파일을 갱신해야 회차가 닫힌다.**

1. **`artifacts/family-trip-prep/README.md`**
   - 상단 "현재 실행"의 버전·마지막 갱신일·승인 상태
   - "산출물 지도" 표의 상태(`current`/`stale`/`needs-review`)와 버전 표기
   - **"부분 재실행 기록" 표에 이번 회차 행 추가** — 날짜, 바뀐 파일, stale로 표시한 파일, 다시 실행한 단계, 사유
2. **`artifacts/family-trip-prep/improvement-log.md`**
   - 날짜, 바뀐 점, 실패했던 케이스, 다음 실행에서 고칠 후보
   - 하네스 자체를 고쳤으면 저장소 루트 `CLAUDE.md`의 "하네스 변경 이력" 표에도 남긴다(산출물만 바뀐 회차는 여기 적지 않는다)

**완료 기준**: `README.md`의 "부분 재실행 기록" 표 마지막 행과 `improvement-log.md` 마지막 행이 **모두 이번 회차를 가리킨다.** 헤더의 버전 표기만 바꾸고 표에 행을 추가하지 않는 것은 완료가 아니다. **이번 회차가 T03(일정 변경)까지 실행됐다면, T06b(노션 동기화)가 완료됐는지도 함께 확인한다** — 노션 페이지가 대시보드보다 뒤처진 채로 회차를 닫지 않는다.

**왜 정식 단계인가**: 2026-07-30 v7·v8 두 회차는 산출물·검토·발행이 모두 정상이었는데 이 기록만 빠진 채 커밋됐다(README 헤더의 버전 표기만 v8로 바뀌어 있어 더 알아채기 어려웠다). 기록 갱신이 T01~T06 어디에도 속하지 않은 "마무리 관행"으로만 존재했던 것이 원인이라, 번호가 붙은 단계로 승격했다. 사용자 요청이 연달아 들어오는 회차에서 특히 빠지기 쉬우므로, 다음 요청을 받기 전에 먼저 닫는다.
