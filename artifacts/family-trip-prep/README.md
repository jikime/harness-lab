# Artifacts Map — family-trip-prep

## 현재 실행

- 실행 목적: 뉴욕 여행(2026-12-25 도착~2027-01-03 새벽 출발, 부부 2인) 준비
- 실행 모드: 완료 (초기 실행 + 2회 부분 재실행: 항공/예산/NYE 정정, 체력·식사스타일 반영)
- 마지막 갱신: 2026-07-28
- 최종 산출물: `dashboard.html` (v4 데이터 반영 완료)
- 승인 상태: 사람 승인 필요 (항공권·숙소는 결제 완료 / Trattoria Dell'Arte 예약, QC NY Spa 예약, Peter Luger Resy 시도, 항공 스케줄 최종 확인은 사람 승인·확인 대기)

## 산출물 지도

| 파일 | 역할 | 만드는 Agent | 다음에 읽는 Agent/단계 | 상태 | 승인 상태 | 근거/입력 |
| --- | --- | --- | --- | --- | --- | --- |
| `00-trip-brief.md` | 목적지·날짜·가족 구성·예산·제약 정리 | Orchestrator | trip-researcher | current | 해당 없음 | 사용자 요청(항공 스케줄 정정, 예산 500만원 증액, NYE 선호 변경) |
| `01-research-notes.md` | 조사 노트(볼거리·날씨·연말 이벤트·이동수단·숙소 참고 시세·NYE 대안 8장·유명 맛집 9장) | trip-researcher | itinerary-planner | current | 해당 없음 | `00-trip-brief.md` |
| `02-itinerary-draft.md` | 일자별 일정 + 예산 내역 초안(v4 — v3 중요 이슈 3건 수정: Day7 이동시간 정정, 피터루거 백업 순서 재정렬, 12/30 슬롯 우선순위 규정) | itinerary-planner | checklist-reviewer, dashboard-builder | current (checklist-reviewer v4 검토 통과) | 사용 가능 | `03-checklist-review.md`(v3 지적사항) |
| `03-checklist-review.md` | 준비물 체크리스트 + 예산·동선 검토 | checklist-reviewer | dashboard-builder | current (v4 검토 — 승인, 중요 이슈 없음) | 사용 가능 | `02-itinerary-draft.md` |
| `dashboard.html` | 최종 HTML 여행 대시보드 | dashboard-builder | 사용자 | current (v4 반영 재생성 완료) | 사람 승인 필요(Trattoria·QC Spa·Peter Luger Resy 예약, 항공 스케줄 확인) | 위 네 파일 |

상태 값: `미생성`(아직 실행 전) / `current`(최신 입력 반영) / `stale`(앞 단계가 바뀌어 재검토 필요) / `needs-review`(사람 확인 필요) / `archived`(이전 실행 보관).

승인 상태 값: `사용 가능` / `사람 승인 필요` / `미검증 영역 있음` / `해당 없음`.

## 부분 재실행 기록

| 날짜 | 바뀐 파일 | stale로 표시한 파일 | 다시 실행할 단계 | 사유 |
| --- | --- | --- | --- | --- |
| 2026-07-27 | `00-trip-brief.md` (항공 스케줄 정정: 가는편 12/25 08:30 한국출발/오는편 1/3 00:30 미국출발, 예산 1,000→1,500만원, NYE A안·초고가 패키지 모두 제외 후 1인 30만원대 대안으로 변경) | `01-research-notes.md`, `02-itinerary-draft.md`, `03-checklist-review.md` | T02(NYE 대안만 추가 조사), T03(전면 재설계), T04(재검토) | 사용자가 최초 입력한 항공 시간이 실제로는 귀국편 시간이었음(가는 편은 새벽이 아니라 오전 출발), 예산 여유 확보 요청, 새해 전야 옵션 재선정 |
| 2026-07-28 | `00-trip-brief.md` (체력: 하루 3만보 편함 → 도보 경고 불필요, 식사 스타일: 하루 2끼 = 유명맛집 1끼 + 캐주얼 1끼, 피터루거 필수 방문 희망) | `01-research-notes.md`(NYE 8장 이후 유명맛집 9장 추가), `02-itinerary-draft.md`, `03-checklist-review.md`, `dashboard.html` | T02(유명 맛집만 추가 조사), T03(전면 재설계 v3), T04(재검토 v3→중요 이슈 3건→수정 v4→재검토 v4 승인), T05(대시보드 재생성) | 사용자가 도보량·식사 취향을 구체화, 피터루거 등 아이코닉 맛집을 반드시 가고 싶어함. v3 최초 설계에서 checklist-reviewer가 Day7 이동시간 계산 누락·피터루거 백업 순서 모순·12/30 슬롯 충돌 3건(중요)을 발견해 itinerary-planner가 v4로 1차 수정, 2차 재검토에서 승인 |

## 미검증 영역과 승인 필요

- 미검증: 도착 공항(JFK/EWR/LGA)·정확한 도착 시각, 숙소 체크인/아웃 세부, Trattoria Dell'Arte 조망석 지정 가능 여부, QC NY Spa 12/31 페리 운항 스케줄, Grimaldi's/Juliana's 12/27 영업·대기 상황(피터루거 즉시 백업용), TKTS 연말 운영시간·판매시각, DUMBO↔윌리엄스버그 도보 대체경로 실측(3.5km/45~55분 추정치).
- 사람 승인 필요: Trattoria Dell'Arte 예약(90만원), QC NY Spa 예약(40만원), Peter Luger Resy 예약 시도(30일 전 오픈, 신용카드 불가·현금 전용), 항공 스케줄 최종 확인. 항공권·숙소는 이미 결제 완료(하네스가 예약을 대신하지 않음). 피터루거·J.G. Melon 현금 약 $500 환전 필요.
- 다음 실행에서 먼저 볼 파일: `dashboard.html`(최종 확인용), 부분 재실행 시 `00-trip-brief.md`부터.
