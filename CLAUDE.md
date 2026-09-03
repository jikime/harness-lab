# Project Harness

이 저장소에는 하네스 엔지니어링 실습을 위한 `harness-lab` 스킬(`.claude/skills/harness-lab`)과, 그 스킬로 만든 실행 하네스가 함께 있습니다.

## 주요 위치

- 하네스 설계·생성 스킬: `.claude/skills/harness-lab`
- 실행 스킬: `.claude/skills/`
- Agent: `.claude/agents/`
- 중간 산출물: `artifacts/`

## 가족 여행 준비 하네스

가족 여행 준비를 조사 → 일정·예산 설계 → 체크리스트 검토 → HTML 대시보드 순서로 진행하는 실행 하네스입니다.

- Orchestrator: `.claude/skills/family-trip-prep-orchestrator/SKILL.md`
- Agent: `trip-researcher`, `itinerary-planner`, `checklist-reviewer`, `dashboard-builder` (`.claude/agents/`)
- 중간 산출물: `artifacts/family-trip-prep/`
- 최종 산출물: `artifacts/family-trip-prep/dashboard.html`

### 자연어 라우팅

사용자가 스킬명을 직접 입력하지 않아도 가족 여행 준비 업무로 판단되면 `family-trip-prep-orchestrator`를 먼저 사용합니다.

예:

- "가족 여행 준비해줘"
- "여행 일정 초안 정리해줘"
- "항공권 후보만 다시 찾아줘"
- "일정표 예산 다시 배분해줘"
- "체크리스트만 다시 만들어줘"
- "지난번 여행 준비 결과 기반으로 대시보드만 다시 만들어줘"

## 하네스 변경 이력

| 날짜 | 변경 내용 | 대상 | 사유 |
| --- | --- | --- | --- |
| 2026-07-27 | 초기 구성 | family-trip-prep-orchestrator, trip-researcher, itinerary-planner, checklist-reviewer, dashboard-builder | 가족 여행 준비 반복 업무 하네스 생성 |
| 2026-07-29 | itinerary-planner에 `Edit` 도구 추가, "부분 재실행은 Write 전체 재출력 대신 Edit" 지침 추가 | itinerary-planner | 965줄짜리 02-itinerary-draft.md를 Write로 통째로 재출력하려다 출력 길이 한도에 두 번 걸려 실패(v6). 문서가 개정마다 누적되는 구조라 앞으로 더 길어질 것이 뻔해 도구 부재라는 근본 원인을 고침 |
| 2026-07-29 | T06-artifact-sync 단계 추가: `dashboard.html`(CDN 버전) 갱신 시마다 CDN 없는 자체완결 쌍둥이본 `dashboard-artifact.html`을 같은 데이터로 갱신하고 Artifact로 재발행(기존 URL 유지) | family-trip-prep-orchestrator | `dashboard.html`은 CDN(Tailwind/Chart.js)을 쓰는데 Artifact 발행 환경은 CSP로 외부 CDN을 막아 그대로 발행하면 깨짐. 사용자가 "웹으로 안 보여주냐"고 물어서 한 번은 수작업으로 자체완결 버전을 새로 만들었는데, 이후 일정이 바뀌어도 그 웹 링크는 자동으로 안 바뀐다는 걸 사용자가 지적 — Orchestrator가 매번 잊지 않도록 정식 단계(T06)로 하네스에 반영 |
| 2026-08-01 | T07-record-close 단계 신설: `README.md`의 "부분 재실행 기록" 표와 `improvement-log.md` 갱신을 정식 단계로 승격하고, 두 파일 마지막 행이 모두 이번 회차를 가리켜야 완료로 판정 | family-trip-prep-orchestrator | v7·v8 두 회차가 산출물·검토·발행은 정상인데 기록만 빠진 채 커밋됨(README 헤더 버전 표기만 v8이라 알아채기 어려웠음). 기록 갱신이 T01~T06 어디에도 없는 "마무리 관행"으로만 존재한 것이 원인 |
| 2026-08-01 | T03 진입 검사 추가: 직전 `02-itinerary-draft.md` 버전이 T04 검토를 받았는지 확인하고, 미검토분이 있으면 먼저 검토하거나 다음 T04를 "통합 검토"로 등록하며 미검토 구간을 reviewer에게 명시 | family-trip-prep-orchestrator | 사용자 요청이 연달아 들어온 v7→v8 구간에서 T04를 건너뛰고 T03만 두 번 도는 흐름이 실제로 발생. v8 때 v7+v8 통합 검토로 회수했지만 우연이었고 구조적 보장이 없었음 |
| 2026-08-01 | 조건부 승인 계약 명문화: checklist-reviewer는 조건을 `조건부 사항` 라벨로 분리 기재, dashboard-builder는 그 조건을 반드시 대시보드에 반영, Orchestrator는 T05 완료 판정 전 산출물에서 직접 확인(자체보고로 대체 금지) | checklist-reviewer, dashboard-builder, family-trip-prep-orchestrator | v8에서 reviewer가 "12/26 여유 0분을 대시보드에 노출할 것"을 조건으로 승인했는데, 그 조건의 이행을 확인하는 단계가 하네스에 없었음. 이번엔 이행됐지만 세 파일 어디에도 조건부 승인이라는 개념 자체가 없어 다음에 빠질 수 있었음 |
| 2026-08-18 | checklist-reviewer에 `Edit` 도구 추가, "이미 존재하는 03-checklist-review.md에 이어 붙일 때는 Write 전체 재출력 대신 Edit" 지침 추가 | checklist-reviewer | v15 검토 중 978줄로 커진 03-checklist-review.md를 `Write`(당시 유일한 저장 도구)로 통째로 재출력하려다 응답 길이 한도(64,000 토큰)에 걸려 실패. 2026-07-29 itinerary-planner에서 이미 한 번 겪은 것과 동일한 근본 원인(부분 재실행마다 누적되는 파일 + Edit 도구 부재)이 checklist-reviewer에는 그때 반영되지 않아 재발함 — 같은 조치를 적용 |
| 2026-08-20 | 세 번째 대시보드 산출물 `dashboard-live.html` 신설: Artifact `artifact`(라이브 문서) 캐퍼빌리티로 발행해 뷰어가 직접 재량 예산 항목·메모를 추가/삭제·수정할 수 있게 함. T05·T06(dashboard.html/dashboard-artifact.html)과는 파이프라인을 완전히 분리 — 이 파일은 T03~T07 자동 재생성 대상에서 제외됨을 SKILL.md에 명문화 | family-trip-prep-orchestrator | 사용자가 "전체 편집하고 DB 연결하고 싶다"고 요청. dashboard.html/dashboard-artifact.html은 매 회차 전체를 다시 만들어 재발행하는 구조라 그대로 라이브 문서로 바꾸면 일정이 바뀔 때마다 재발행이 부부의 편집 내용(추가한 항목, 메모)을 통째로 지워버리는 근본적 충돌이 있음 — 이를 피하기 위해 자동 파이프라인과 무관한 별도 산출물로 분리하고, 저장소 파일은 최초 시드일 뿐 이후 실제 편집 내용과 자연히 갈라진다는 점을 SKILL.md에 명시 |
| 2026-08-27 | T06b-notion-sync 단계 신설: 노션 "뉴욕 여행 — 한장 정리" 페이지를 `dashboard-artifact.html`과 동급으로 매 회차 자동 동기화 대상에 편입(T06 다음, T07 이전). 노션 콜아웃/토글 블록에서 "여는 태그와 본문을 같은 줄에 쓰면 파싱이 깨진다"는 문법 주의사항도 함께 명문화 | family-trip-prep-orchestrator | v20~v22 세 회차 동안 노션 페이지는 사용자가 "노션도 업데이트해줘"라고 매번 따로 요청해야만 갱신됐다 — 대시보드는 자동 갱신되는데 노션만 뒤처지는 비대칭이 실제로 발생(v22 직후 대시보드는 최신인데 노션은 v21 상태). 사용자가 "항상 반영하는 하네스로 구성해달라"고 명시 요청해 T06과 동급 정식 단계로 승격. 노션 마크다운 콜아웃 문법 실수(태그와 본문을 같은 줄에 써서 파싱이 깨짐)를 이번 세션에서 두 번 겪은 뒤 원인을 찾아 SKILL.md에 재발 방지용으로 기록 |
| 2026-08-31 | T06-artifact-sync 완료 기준에 메타 요소(헤더 배지, D-day, title 태그, 하단 버전 로그, 리스크표처럼 본문 갱신 시 자연히 손대지 않는 섹션)를 grep으로 스캔하는 항목 명문화 | family-trip-prep-orchestrator | v24 반영 중 dashboard-artifact.html의 헤더 배지가 V19(5개 버전 뒤처짐), D-day가 11일 뒤처진 채 방치돼 있었고, 삭제된 지 오래된 Trattoria를 여전히 언급하는 리스크 행도 발견됨 — 같은 유형의 메타 요소 방치가 2026-08-20과 08-28에 이미 두 번(둘 다 title 태그) 지적됐는데도 다음에 검토로만 남아 세 번째로 재발했다. 이번엔 실제로 SKILL.md 절차에 반영해 재발을 구조적으로 막기로 함 |
| 2026-09-01 | dashboard-builder 에이전트 정의에 "지시받지 않은 날짜 카드는 원본 그대로 둘 것"이라는 금지 규칙 명문화 | dashboard-builder | v27 반영 중 "12/30 카드만 고쳐라"는 지시에도 1/1·1/2 카드를 통째로 지어내고, 심지어 1/1에 트램과 월먼 링크를 같은 시각(16:45)에 중복 배정한 뒤 "동시 불가" 경고 배지만 붙이는 사고가 발생. 같은 유형의 사고가 2026-08-27(v23)에 이미 한 번 있었는데 이번이 더 심각(자기모순 방치)해 재발 방지 규칙을 정식으로 추가함. Orchestrator가 git checkout으로 즉시 되돌리고 직접 재작성해 실제 피해는 없었음 |
| 2026-09-02 | `02-itinerary-current.md`(현행 스냅샷) 신설 및 이중 유지 규칙: itinerary-planner는 이력 원본과 스냅샷을 둘 다 갱신, checklist-reviewer는 스냅샷 기준 전수 대조 + 원본 일치 확인, Orchestrator는 T03 완료 전 두 파일 헤더 버전·변경 표 grep 확인 | itinerary-planner, checklist-reviewer, family-trip-prep-orchestrator | 이력 원본이 8,541줄·2MB가 되어 reviewer가 v28에서 "전수 대조 비현실적"을 공식 보고. 실제로 폐기된 A안(09:05 열차) 서술이 현행 1-A·2-4·3장 표에 v21~v28 여덟 회차 잔존했는데 30차 전체 일관성 감사가 놓침 — 사용자가 모델 교체 후 전체 재점검을 요청해 Orchestrator가 발견 |
| 2026-09-02 | "(가정)" 값 산술 검증 규칙: 회차 진입 시 `(가정)` grep 후 확정값과 산술 대조 가능한 것은 즉시 계산, "부족 가능성" 같은 방향성 경고는 실가 조사로 금액 확정. itinerary-planner 1단계·checklist-reviewer 3단계·SKILL.md에 동일 규칙 | itinerary-planner, checklist-reviewer, family-trip-prep-orchestrator | 브리프의 "08:30 출발"과 일정표의 "13:00 도착(가정)"이 비행시간·시차 산술로 양립 불가(실제 OZ222 JFK 10:00)인데 30회차 동안 아무도 계산하지 않아 도착일 오후 3시간이 비어 있었고, Blue Note 배정액(140,000원)이 실가(2인 약 550,000원)의 1/3인 채 "부족 가능성 높음"으로만 여덟 회차 유지됨. 둘 다 "확인 필요로 적어 두면 처리한 것"으로 간주하는 구조적 허점 |
| 2026-09-03 | "바뀐 값의 *이전 값*을 grep" 규칙 신설(itinerary-planner 출력·작업 방식 8, checklist-reviewer 3-1, SKILL.md T03절): 회차에서 어떤 값이 바뀌면 그 옛 값 문자열을 전 산출물에 grep해 `[v-N]`·이력·취소선 문맥이 아닌 잔존을 정정 | itinerary-planner, checklist-reviewer, family-trip-prep-orchestrator | v29~v32에서 본표·검산식·헤더는 갱신됐는데 그 값을 재인용하는 프로즈·6장 리스크행·Day 메모·T-note·1-A 셀·04 항목별 메모가 안 바뀐 사고가 한 세션에서 5번(35~37차). 특히 6장 리스크행이 "귀가 늦으면 라이드셰어로 전환"(v31 「택시 절대 안 탐」 위반)과 "12/31 스파 위협 금지"(v24에서 The Met으로 교체·삭제됨) 두 폐기 전제 위에서 실행 지침을 주고 있었음. 지금까지 grep은 "새 값이 반영됐는가"만 봤음 |
| 2026-09-03 | **`02-itinerary-draft.md` 폐지 · `02-itinerary-current.md` 단일 정본화**: 이력 누적 원본을 삭제(9,282줄, git 히스토리에 보존)하고 현행 스냅샷을 유일 정본으로 승격. draft에만 있던 4장 트레이드오프·3장 예산-일정 대조표를 current.md로 이관. planner는 개정 이력 챕터를 파일에 쌓지 않고 git 커밋 + 「개정 이력 요약」 한 줄 표에 위임. reviewer T04에 "바뀐 값의 *이전 값* 문자열 grep"이 필수 절차로 편입 | itinerary-planner, checklist-reviewer, dashboard-builder, family-trip-prep-orchestrator, itinerary-planning/trip-checklist-review/trip-dashboard-building SKILL | 2026-09-02 스냅샷 신설 후에도 draft가 v29~v32에서 계속 비대해졌고, "본표는 고치고 재인용은 안 고치는" 잔존-오류 사고가 한 세션에서 5번 발생(라이드셰어 지침이 v31 「택시 안 탐」과 모순, 폐기된 12/31 스파 언급 등). 사용자 "폐기된 건 지워버려 — 데이터가 너무 많으니까 못 찾는 거 아냐" → AskUserQuestion으로 단일화 확정. git이 전체 이력을 보존하므로 파일 내 이력 보존은 중복이자 오류의 은신처였음 |
| 2026-09-03 | trip-researcher 작업 방식에 7·8번 신설: ⑦ "우리가 이미 가기로 한 곳 전체"를 대상으로 하는 조사(무료입장·할인·멤버십·휴관)는 `02-itinerary-current.md` 2-4 액티비티표 행을 전부 뽑아 한 행씩 대조하고 그 대조표를 노트에 남길 것, ⑧ 자격 충족 여부가 미확인인 혜택은 금액을 확정으로 쓰지 말고 "성립 시 −N원 / 미확인이라 정가 유지"로 적을 것 | trip-researcher | `01-research-notes.md` 42장(2026-08-27)이 제목에 "무료 박물관 입장 — **우리가 이미 방문 예정인 곳**"이라 써 놓고 MoMA·구겐하임만 조사한 뒤 The Met을 빠뜨린 채 "아낄 돈 없음"으로 결론을 냈고, 그 결론이 v24~v32 여덟 회차를 그대로 통과했다. 실제로는 The Met에 현대백화점 앱 The Met Pass(Green 등급 이상 본인+동반 1인 무료, 연 1회, 리뉴얼판 유효기간 2026-02-01~2027-01-31이라 12/31 방문일 포함)라는 80,000원짜리 경로가 있었고, **사용자가 밖에서 안내문을 가져와 "이런 혜택도 많네"라고 말하지 않았으면 계속 못 잡았을 항목**이다. 조사 대상 목록을 인상으로 만든 것이 원인이라 전수 대조표를 강제하는 절차로 고침 |
| 2026-09-03 | T06-artifact-sync 완료 기준에 "정본 Day 표와 두 대시보드 Day 카드의 `HH:MM` 시각을 집합으로 뽑아 차집합 확인" + 태그 균형·UTF-8 검사 추가 | family-trip-prep-orchestrator | 42차 감사에서 `dashboard.html`의 **Day 7 자정 블록이 불꽃놀이를 01:00~01:20에 배치**(정본·쌍둥이본·노션은 전부 자정 정각 00:00~00:20)하고 **Day 8 오후 네 시각이 통째로 옛 판**인 것이 발견됨. 쌍둥이본은 둘 다 맞았으므로 **두 대시보드가 갈라진 것을 아무도 안 보고 있었다**는 뜻이다. 2026-08-31에 메타 요소 grep을 넣었지만 그건 헤더·배지·푸터 같은 "본문 밖" 요소였고, **본문인 Day 카드의 시각 자체를 정본과 대조하는 검사는 하네스에 아예 없었다.** 부수로 `<strong>` 미닫힘 1건도 같은 회차에서 발견돼 태그 균형 검사를 함께 넣음 |
| 2026-09-03 | itinerary-planner·checklist-reviewer에 **외부 정합성 검사** 2종 신설: ① 새 이동 구간이 들어오면 **출발역·도착역의 운행 노선 집합에 교집합이 있는지**(환승역이면 무료환승 존재 여부까지) 확인, ② `04`의 상대 기한("출발 며칠 전")을 **회차 기준일로 환산**해 「지금 시점에 살아 있는 액션」 표를 갱신 | itinerary-planner, checklist-reviewer, family-trip-prep-orchestrator | 43차에서 12/30 저녁 Smalls 이동이 v14 무렵부터 「N/R/W 8 St–NYU → W 4th St 3분」으로 적혀 있었는데 **8 St–NYU는 N/R/W 전용, W 4th St는 A·C·E·B·D·F·M 전용이라 두 역 사이에 열차도 무료환승도 없다** — 존재하지 않는 구간이 정본·대시보드 2종·노션 네 곳에 똑같이 복제된 채 40회차를 넘겼다. **원인: 지금까지의 모든 감사가 "문서 간 값이 일치하는가"(내부 정합성)만 봤고 "그 값이 바깥 세계에서 참인가"를 본 적이 없었다** — 내부 정합성 검사는 복제된 오류를 원리적으로 잡지 못한다. 같은 회차에 기한도 처음으로 오늘 날짜에 대입해 봤더니 **리버티 아일랜드 페리 권장 예매 창(3~4개월 전)이 이미 열려 있고 "4개월 전" 시점은 지나 있었다** — "성수기 매진 위험"은 48장이 이미 조사해 둔 사실인데 그것과 오늘 날짜를 곱해 본 적이 없었다 |
