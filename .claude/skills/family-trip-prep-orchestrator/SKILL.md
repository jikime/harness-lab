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
6. 부분 재실행으로 앞 단계 파일이 바뀌면, 그 파일을 입력으로 삼는 뒤 단계 파일을 `README.md`에서 `stale`로 표시한다. 예: `01-research-notes.md`가 바뀌면 `02-itinerary-draft.md`, `03-checklist-review.md`, `dashboard.html`을 `stale`로 표시한다.

## Agent Team 구성

| 팀원 | Agent 파일 | tools | model | 주요 산출물 |
| --- | --- | --- | --- | --- |
| trip-researcher | `.claude/agents/trip-researcher.md` | `WebSearch, WebFetch, Read, Write` | sonnet | `artifacts/family-trip-prep/01-research-notes.md` |
| itinerary-planner | `.claude/agents/itinerary-planner.md` | `Read, Write` | opus | `artifacts/family-trip-prep/02-itinerary-draft.md` |
| checklist-reviewer | `.claude/agents/checklist-reviewer.md` | `Read, Write` | sonnet | `artifacts/family-trip-prep/03-checklist-review.md` |
| dashboard-builder | `.claude/agents/dashboard-builder.md` | `Read, Write` | haiku | `artifacts/family-trip-prep/dashboard.html` |

## Task 등록 계약

| Task | 담당 | 입력 | 출력 | 의존 | 완료 기준 | 상태 갱신 |
| --- | --- | --- | --- | --- | --- | --- |
| T01-input | Orchestrator | 사용자 요청 | `artifacts/family-trip-prep/00-trip-brief.md` | 없음 | 목적지, 날짜, 가족 구성, 예산, 제약이 정리됨 | 작성 완료 |
| T02-research | trip-researcher | `00-trip-brief.md` | `artifacts/family-trip-prep/01-research-notes.md` | T01 | 항공권·숙소 후보 각 2개 이상, 출처 포함 | 시작, 차단, 완료 |
| T03-itinerary | itinerary-planner | `00-trip-brief.md`, `01-research-notes.md` | `artifacts/family-trip-prep/02-itinerary-draft.md` | T02 | 예산 항목 합산과 표시 합계 일치 | 시작, 차단, 완료 |
| T04-checklist-review | checklist-reviewer | `00-trip-brief.md`, `01-research-notes.md`, `02-itinerary-draft.md` | `artifacts/family-trip-prep/03-checklist-review.md` | T03 | 예산 재검산·동선 검토 완료, 이슈 심각도 판정 | 시작, 차단, 완료 |
| T05-dashboard | dashboard-builder | `01-research-notes.md`, `02-itinerary-draft.md`, `03-checklist-review.md` | `artifacts/family-trip-prep/dashboard.html` | T04 | 숫자 일치, 승인 배지 존재, 모바일 확인 | 시작, 차단, 완료 |

T04에서 중요 이상 이슈가 발견되면 itinerary-planner에게 수정 Task를 재등록한다(최대 2회, `T03-itinerary-revision-N`).

## Agent Team 실행 흐름

1. 사용자 요청에서 목적지, 날짜, 가족 구성(인원·나이), 예산, 제약을 확인한다. 부족하면 질문하고 추측하지 않는다.
2. `artifacts/family-trip-prep/00-trip-brief.md`에 정리해 저장한다.
3. `TeamCreate`로 4개 역할을 팀원으로 구성한다(모델 정책은 위 표를 그대로 팀 생성 지시에 반영한다).
4. `TaskCreate`로 T01-T05를 등록한다.
5. 각 팀원은 자기 Task를 시작·차단·완료 시 `TaskUpdate`로 갱신한다.
6. Orchestrator는 `TaskGet`으로 지연·차단·의존 관계 막힘을 확인한다.
7. 팀원은 발견·충돌·완료를 `SendMessage`로 공유한다. checklist-reviewer가 중요 이상 이슈를 찾으면 itinerary-planner에게 수정 요청 메시지를 보낸다.
8. 각 산출물은 파일로 저장한다(`artifacts/family-trip-prep/` 아래).
9. Orchestrator는 모든 산출물을 읽고 누락·충돌·승인 필요 지점을 정리한다.
10. `dashboard.html`을 최종 산출물로 삼고, `artifacts/family-trip-prep/README.md`와 `improvement-log.md`를 갱신한다.
11. `TeamDelete`로 팀을 정리한다.
12. 항공권/숙소 예약, 결제처럼 사람 승인이 필요한 항목이 있으면 아래 "승인 요청" 형식으로 멈추고 사용자에게 확인을 요청한다. 승인 전에는 실제 예약·결제를 진행하지 않는다.

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

## 개선 기록 갱신

각 실행(초기 실행, 부분 재실행 모두) 후 `artifacts/family-trip-prep/improvement-log.md`에 날짜, 바뀐 점, 실패했던 케이스, 다음 실행에서 고칠 후보를 남긴다.
