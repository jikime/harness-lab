# Artifacts Map — family-trip-prep

## 현재 실행

- 실행 목적: 뉴욕 여행(2026-12-25 도착~2027-01-03 새벽 출발, 부부 2인) 준비
- 실행 모드: 완료 (5회 부분 재실행: 항공/예산/NYE → 체력·식사스타일 → 한국인 만족도 맛집 재조사 → 45,000원 재배분 → 쇼핑 스팟 반영(v8, 12/26 여유 0분 조건부 승인))
- 마지막 갱신: 2026-07-30
- 최종 산출물: `dashboard.html` (v8 데이터 반영 완료)
- 웹 공유용 산출물: `dashboard-artifact.html` → https://claude.ai/code/artifact/a139c73b-b86f-4dc2-a61a-edd55bd58d1e (v8 반영 완료, 비공개 — 공유하려면 페이지 우측 상단 Share 메뉴)
- 실행 보조 산출물: `04-execution-action-checklist.md` (예약·확인 액션 분리)
- 승인 상태: 사람 승인 필요 (항공권·숙소는 결제 완료 / Trattoria Dell'Arte 예약, QC NY Spa 예약, Peter Luger Resy 시도, 항공 스케줄 최종 확인은 사람 승인·확인 대기)

## 산출물 지도

| 파일 | 역할 | 만드는 Agent | 다음에 읽는 Agent/단계 | 상태 | 승인 상태 | 근거/입력 |
| --- | --- | --- | --- | --- | --- | --- |
| `00-trip-brief.md` | 목적지·날짜·가족 구성·예산·제약 정리 | Orchestrator | trip-researcher | current | 해당 없음 | 사용자 요청(유명 맛집 선정 기준을 "한국인 만족도" 우선으로 재조정, 12/30 교체 확정) |
| `01-research-notes.md` | 조사 노트(볼거리·날씨·연말 이벤트·이동수단·숙소 참고 시세·NYE 대안 8장·유명 맛집 9장·한국인 만족도 재조사 10장) | trip-researcher | itinerary-planner | current | 해당 없음 | `00-trip-brief.md` |
| `02-itinerary-draft.md` | 일자별 일정 + 예산 내역 초안(v8 — 쇼핑 스팟 반영: Exit9·MoMA Design Store·LEGO Store·Nintendo NY·Rough Trade·Kinokuniya·Nike SoHo·Village Revival Records) | itinerary-planner | checklist-reviewer, dashboard-builder | current (checklist-reviewer v8 검토 통과, 조건부) | 사용 가능(조건: 12/26 오후 여유 0분 사전 숙지) | `01-research-notes.md`(11장 쇼핑 추천) |
| `03-checklist-review.md` | 준비물 체크리스트 + 예산·동선 검토 | checklist-reviewer | dashboard-builder | current (v8 검토 — 조건부 승인, 12/26 오후 여유 0분을 중요 이슈로 등록) | 사용 가능 | `02-itinerary-draft.md` |
| `dashboard.html` | 최종 HTML 여행 대시보드(TailwindCSS/Chart.js CDN, 저장소·로컬 미리보기용) | dashboard-builder | 사용자 | current (v8 반영 재생성 완료, 12/26 여유 0분 경고 박스 포함) | 사람 승인 필요(Trattoria·QC Spa·Peter Luger Resy 예약, 항공 스케줄 확인) | 위 네 파일 |
| `dashboard-artifact.html` | `dashboard.html`의 자체완결 쌍둥이본(CDN 없음, 폰트 내장) — Artifact 웹 발행 전용 | Orchestrator (dashboard.html 데이터를 옮겨 담음) | 사용자(웹 링크로 확인) | current (v8 반영, URL: a139c73b-b86f-4dc2-a61a-edd55bd58d1e) | 사람 승인 필요(동일) | `dashboard.html` |
| `04-execution-action-checklist.md` | 예약·확인 실행 체크리스트(Peter Luger, Trattoria, QC NY Spa, TKTS, 항공·숙소 확인) | Codex 보조 검토 | 사용자/오케스트레이터 | current | 사람 승인 필요(실제 예약·결제는 사용자 직접 실행) | `README.md`, `02-itinerary-draft.md`, `03-checklist-review.md`, 공식 페이지 확인 |

상태 값: `미생성`(아직 실행 전) / `current`(최신 입력 반영) / `stale`(앞 단계가 바뀌어 재검토 필요) / `needs-review`(사람 확인 필요) / `archived`(이전 실행 보관).

승인 상태 값: `사용 가능` / `사람 승인 필요` / `미검증 영역 있음` / `해당 없음`.

## 부분 재실행 기록

| 날짜 | 바뀐 파일 | stale로 표시한 파일 | 다시 실행할 단계 | 사유 |
| --- | --- | --- | --- | --- |
| 2026-07-27 | `00-trip-brief.md` (항공 스케줄 정정: 가는편 12/25 08:30 한국출발/오는편 1/3 00:30 미국출발, 예산 1,000→1,500만원, NYE A안·초고가 패키지 모두 제외 후 1인 30만원대 대안으로 변경) | `01-research-notes.md`, `02-itinerary-draft.md`, `03-checklist-review.md` | T02(NYE 대안만 추가 조사), T03(전면 재설계), T04(재검토) | 사용자가 최초 입력한 항공 시간이 실제로는 귀국편 시간이었음(가는 편은 새벽이 아니라 오전 출발), 예산 여유 확보 요청, 새해 전야 옵션 재선정 |
| 2026-07-28 | `00-trip-brief.md` (체력: 하루 3만보 편함 → 도보 경고 불필요, 식사 스타일: 하루 2끼 = 유명맛집 1끼 + 캐주얼 1끼, 피터루거 필수 방문 희망) | `01-research-notes.md`(NYE 8장 이후 유명맛집 9장 추가), `02-itinerary-draft.md`, `03-checklist-review.md`, `dashboard.html` | T02(유명 맛집만 추가 조사), T03(전면 재설계 v3), T04(재검토 v3→중요 이슈 3건→수정 v4→재검토 v4 승인), T05(대시보드 재생성) | 사용자가 도보량·식사 취향을 구체화, 피터루거 등 아이코닉 맛집을 반드시 가고 싶어함. v3 최초 설계에서 checklist-reviewer가 Day7 이동시간 계산 누락·피터루거 백업 순서 모순·12/30 슬롯 충돌 3건(중요)을 발견해 itinerary-planner가 v4로 1차 수정, 2차 재검토에서 승인 |
| 2026-07-28 | `04-execution-action-checklist.md` 신규 작성 | 없음 | 실행 전 예약·확인 액션 분리 | v4 산출물은 current로 유지하되, 실제 여행 준비 단계에서 필요한 항공·숙소·예약·현금·연말 운영 확인 항목을 별도 체크리스트로 분리 |
| 2026-07-29 | `00-trip-brief.md` (유명 맛집 선정 기준을 "아이코닉·유명세" → "한국인 여행자 만족도 우선"으로 재조정, 피터루거·울프강 비교 및 12/26·12/27 이틀 연속 스테이크하우스 재검토 추가) | `01-research-notes.md`(9장), `02-itinerary-draft.md`, `03-checklist-review.md`, `dashboard.html` | T02(9장 맛집만 재조사, 사용자 선택 후 진행), T03~T05(선택 확정 후 순차 재실행) | 사용자가 기존 맛집 리스트("피터루거·Keens·Katz's 등")가 대안 비교 없이 "이미 유명한 곳"을 그대로 채운 것임을 지적하고, 한국인 만족도 기준 재평가와 스테이크하우스 중복 재검토를 요청 |
| 2026-07-29 | 재조사 결과 확정(12/26 Keens 유지, 12/30 Lombardi's → Joe's Pizza 교체) → `02-itinerary-draft.md` v5(스코프 한정 수정), `03-checklist-review.md` v5(스코프 한정 재검토), `dashboard.html` 재생성 | `02-itinerary-draft.md`, `03-checklist-review.md`, `dashboard.html` | T03(v5, 12/30 항목·예산 재배분 1곳만 수정), T04(v5 스코프 한정 재검토), T05(대시보드 재생성) | 한국어 소스(마일모아·브런치 등) 기준 Joe's Pizza가 Lombardi's보다 근거 탄탄, 12/26은 Grand Central Oyster Bar 대안도 검토했으나 Keens 유지가 사용자 선택. 전면 재작성 대신 최소 범위 수정으로 v4의 나머지 승인 내용을 보존 |
| 2026-07-29 | v5가 planner 판단으로 남겨뒀던 "45,000원 배분처"를 사용자가 쇼핑·기념품 복원으로 확정(식비 버퍼 325,000→280,000 원복, 식비 2,950,000→2,905,000, 쇼핑 650,000→695,000) → `02-itinerary-draft.md` v6, `03-checklist-review.md` v6, `dashboard.html`·`dashboard-artifact.html` 재생성·재발행 | `02-itinerary-draft.md`, `03-checklist-review.md`, `dashboard.html`, `dashboard-artifact.html` | T03(v6, 숫자 2곳 재배분만), T04(v6 스코프 한정 재검토), T05(대시보드 재생성), T06(Artifact 동기화·재발행) | 사용자가 "울프강도 3대 스테이크인데 안 가냐"고 물어 Keens 유지를 재확인하고, 동시에 v5의 미확정 항목(45,000원 배분처)을 쇼핑 복원으로 확정. itinerary-planner가 965줄 파일을 Write로 통째로 재출력하다 출력 한도에 두 번 걸려 실패 — 대신 OLD→NEW 패치 스펙(38곳)을 만들었고 Orchestrator가 Edit 도구로 직접 적용(부분 편집 도구가 없는 서브에이전트의 한계를 오케스트레이터가 보완한 사례) |
| 2026-07-30 | 조사노트 11장(쇼핑 추천)의 매장을 12/25·12/26·12/30 동선에 배치 → `02-itinerary-draft.md` v7 (S1~S7: Exit9 20분, MoMA Design Store 관람 내 흡수, LEGO 25분, Kinokuniya 35분, 소호 4개 매장 150분 구체화, Village Revival Records 30분) | `02-itinerary-draft.md` | T03(v7, 쇼핑 3개 날짜 한정 수정) | 사용자가 "예산은 재배분하지 말 것, 12/26에 다 욱여넣지 말 것, 자전거 용품은 시간 배정하지 말 것" 조건으로 쇼핑 스팟 구체화를 요청. 각 날의 블록 총량(12/25 75분, 12/30 소호 150분·빌리지 70분)을 유지한 채 내부에서만 분할해 예산·맛집 배치·이동시간 표기는 전부 불변 |
| 2026-07-30 | v7이 "확인 필요"로 남긴 판단 3건을 사용자가 결정 → `02-itinerary-draft.md` v8(U1~U8: Nintendo NY 확정 25분 승격, Rough Trade 확정 15분 재삽입, 재원은 커피 −15·5번가 −20·LEGO −5로 ±40분 상계, ToR 입장 대기 15분 명시), `03-checklist-review.md` v7+v8 통합 검토(**조건부 승인**), `dashboard.html`·`dashboard-artifact.html` 재생성·재발행 | `02-itinerary-draft.md`, `03-checklist-review.md`, `dashboard.html`, `dashboard-artifact.html` | T03(v8, 12/26 오후 창 내부 재배분만), T04(v7+v8 통합 재검토), T05(대시보드 재생성), T06(Artifact 동기화·재발행) | 사용자 결정 3건(①닌텐도 확정 배정 ②Rough Trade 재삽입 ③윈터빌리지↔Kinokuniya 배분은 planner 위임)에 "고정 시각·예산 불변, 무리하게 욱여넣고 숨기지 말 것" 조건. v7이 검토 없이 반영된 상태였어서 checklist-reviewer가 v7+v8을 한 번에 원문 대조 — 치명 0건이나 **12/26 오후 창 여유 0분을 중요 이슈(I1)로 신규 등록**, 대시보드 경고 노출을 조건으로 승인 |

## 미검증 영역과 승인 필요

- 미검증: 도착 공항(JFK/EWR/LGA)·정확한 도착 시각, 숙소 체크인/아웃 세부, Trattoria Dell'Arte 조망석 지정 가능 여부, QC NY Spa 12/31 페리 운항 스케줄, Grimaldi's/Juliana's 12/27 영업·대기 상황(피터루거 즉시 백업용), TKTS 연말 운영시간·판매시각, DUMBO↔윌리엄스버그 도보 대체경로 실측(3.5km/45~55분 추정치).
- 사람 승인 필요: Trattoria Dell'Arte 예약(90만원), QC NY Spa 예약(40만원), Peter Luger Resy 예약 시도(30일 전 오픈, 신용카드 불가·현금 전용), 항공 스케줄 최종 확인. 항공권·숙소는 이미 결제 완료(하네스가 예약을 대신하지 않음). 피터루거·J.G. Melon 현금 약 $500 환전 필요.
- 다음 실행에서 먼저 볼 파일: `04-execution-action-checklist.md`(예약·확인 실행용), `dashboard.html`(최종 확인용), 부분 재실행 시 `00-trip-brief.md`부터.
- `dashboard.html`을 재생성할 때마다 `dashboard-artifact.html`도 같은 데이터로 갱신하고, 위에 적힌 URL로 Artifact를 재발행할 것(자동으로 동기화되지 않음 — `family-trip-prep-orchestrator` SKILL.md의 T06 참고).
