# Orchestrator와 산출물 템플릿

이 문서는 실제 `.claude` 파일이나 하네스 청사진을 작성할 때 사용한다. Orchestrator는 일을 직접 다 하는 존재가 아니라, 역할을 나누고 산출물을 이어받고 실패와 승인 지점을 관리하는 입구다.

## 목차

1. 언제 읽을까
2. 하네스 청사진
3. 산출물 구조 선택
4. `artifacts/README.md` 템플릿
5. 산출물 계약과 벤치마크
6. Agent 템플릿
7. Skill 템플릿
8. Orchestrator 템플릿
9. `CLAUDE.md` 포인터

## 언제 읽을까

- 청사진 템플릿이 필요할 때
- `.claude/agents`, `.claude/skills`, `CLAUDE.md` 초안을 만들어야 할 때
- `artifacts/` 산출물 계약과 파일 구조를 정해야 할 때
- `artifacts/README.md`에 산출물 지도와 최신 상태를 남겨야 할 때
- Agent Team Orchestrator의 Task, 메시지, 팀 정리 조건을 작성해야 할 때

## 하네스 청사진

```md
## 하네스 청사진

### 목표

- 이 하네스가 돕는 일:
- 최종 산출물:
- 주요 사용자:
- 현재 성숙도:

### 하네스 7요소

| 요소 | 이번 하네스에서의 내용 |
| --- | --- |
| 목표 |  |
| 컨텍스트 |  |
| 도구 |  |
| 중간 산출물 |  |
| 검증 |  |
| 권한과 승인 |  |
| 기록과 개선 |  |

### 사람의 작업 절차

1.
2.
3.

### 실행 모드와 팀 패턴

- 실행 모드: 단일 흐름 | Subagent | Agent Team | Hybrid
- 패턴:
- 선택 이유:
- 단일 흐름으로 충분하지 않은 이유:
- Agent Team을 선택했다면 필요한 팀 조율:

### Agent 역할표

| Agent | tools | 맡는 일 | 분리 이유 | 입력 | 출력 | 하지 말아야 할 일 |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

### Skill 목록

| Skill | 사용하는 Agent | 절차 요약 | 품질 기준 |
| --- | --- | --- | --- |
|  |  |  |  |

### Orchestrator 흐름

- Orchestrator Skill 이름: `{하네스-이름}-orchestrator`
- Orchestrator Skill 위치: `.claude/skills/{하네스-이름}-orchestrator/SKILL.md`
- 실행 모드:
- 중간 산출물 위치: `artifacts/`
- 사람 승인 지점:

1.
2.
3.

### 산출물 계약

| 단계 | 파일 | 만드는 역할 | 다음에 읽는 역할 | 재사용 방식 |
| --- | --- | --- | --- | --- |
| 입력 정리 | `artifacts/00-input.md` | Orchestrator | 모든 역할 | 요청 범위와 제약 확인 |
| 조사/분석 | `artifacts/01-brief.md` |  |  |  |
| 초안/구현 | `artifacts/02-draft.md` |  |  |  |
| 검토 | `artifacts/03-review.md` |  |  |  |
| 최종 | `artifacts/final.md` | Orchestrator | 사용자와 다음 실행 | 실제 사용 결과 |
| 개선 기록 | `artifacts/improvement-log.md` | Orchestrator | 다음 개선 작업 | 실패와 변경 근거 |

### Agent Team 실행 계약

Agent Team을 선택한 경우에만 작성한다.

| 항목 | 이번 하네스의 계약 |
| --- | --- |
| `TeamCreate` 팀원 |  |
| `TaskCreate` 작업 목록 |  |
| `TaskUpdate` 상태 갱신 | 시작, 차단, 완료, 재할당 |
| `TaskGet` 확인 시점 | Phase 전환 전, 지연 감지, 최종 통합 전 |
| `SendMessage`가 필요한 상황 | 발견 공유, 질문, 충돌, 차단, 완료 |
| 파일 산출물 규칙 | 다음 단계가 읽어야 하는 내용은 모두 `artifacts/`에 저장하고, `artifacts/README.md`에 최신 상태를 갱신한다 |
| 팀 재구성 조건 | 역할 구성이 바뀌거나 Phase 경계가 바뀌면 `artifacts/handoff.md`를 남기고 기존 팀을 정리한 뒤 새 팀을 만든다 |
| `TeamDelete` 시점 | 최종 통합과 개선 기록 작성 후, 팀 재구성 전, 또는 중단 시 현재 상태를 저장한 뒤 |

### 테스트 프롬프트

| 유형 | 프롬프트 | 기대 결과 |
| --- | --- | --- |
| 정상 |  |  |
| 애매함 |  |  |
| 실패 위험 |  |  |
| 부정 테스트 |  |  |
```

청사진 단계에서는 위 내용을 사용자에게 보여주고 멈춘다. 이 단계에서는 `.claude/agents`, `.claude/skills`, `CLAUDE.md`, `artifacts/` 파일을 만들지 않는다. 사용자가 이 청사진에 대해 명시적으로 구성 요청을 한 뒤에만 실행 하네스 파일을 만든다.

## 산출물 구조 선택

기본 위치는 현재 프로젝트의 `artifacts/`이다. 작은 하네스는 평면 구조로 시작하고, 역할이 많거나 실행이 길어지면 폴더형 구조로 확장한다.

| 구조 | 쓰기 좋은 경우 | 특징 |
| --- | --- | --- |
| 평면 구조 | 첫 실습, 짧은 문서 작업, Agent 2-3개 수준 | 파일 수가 적고 사용자가 바로 이해하기 쉽다 |
| 폴더형 구조 | 실무용 문서, 코드 작업, Agent Team 재구성, 긴 실행 | 단계별 산출물을 나누고 archive와 handoff를 관리하기 좋다 |

평면 구조:

```text
artifacts/
├── README.md
├── 00-input.md
├── 01-working.md
├── 02-review.md
├── final.md
└── improvement-log.md
```

폴더형 구조:

```text
artifacts/
├── README.md
├── 00-input.md
├── 10-analysis/
├── 20-agent-outputs/
├── 30-review/
├── final/
├── evals/
├── handoff.md
├── improvement-log.md
└── archive/
```

## `artifacts/README.md` 템플릿

`artifacts/README.md`는 단순 목록이 아니라 다음 실행이 어디서 이어야 하는지 알려주는 지도다. 부분 재실행이나 재검토가 생기면 이 파일을 먼저 갱신한다.

```md
# Artifacts Map

## 현재 실행

- 실행 목적:
- 실행 모드: 초기 실행 | 부분 재실행 | 새 실행
- 마지막 갱신:
- 최종 산출물:
- 승인 상태: 사용 가능 | 사람 승인 필요 | 미검증 영역 있음

## 산출물 지도

| 파일 | 역할 | 만든 Agent | 다음에 읽는 Agent/단계 | 상태 | 승인 상태 | 근거/입력 | 비고 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `artifacts/00-input.md` | 요청, 제약, 승인 지점 정리 | Orchestrator | 모든 Agent | current | 해당 없음 | 사용자 요청 |  |
| `artifacts/01-brief.md` | 조사/분석 요약 |  |  | current | 해당 없음 | `00-input.md` |  |
| `artifacts/02-draft.md` | 초안 또는 구현 결과 |  | Reviewer | current | 미검증 영역 있음 | `01-brief.md` |  |
| `artifacts/03-review.md` | 검토 결과 | Reviewer/QA | Orchestrator | current | 미검증 영역 있음 | `02-draft.md` |  |
| `artifacts/final.md` | 최종 결과 | Orchestrator | 사용자, 다음 실행 | needs-review | 사람 승인 필요 | `03-review.md` |  |
| `artifacts/evals/iteration-N/{eval-name}/comparison.md` | with/without 벤치마크 판정 | Orchestrator/QA | 다음 개선 작업 | current | 해당 없음 | `prompt.md`, `run-config.md`, 양쪽 `metrics.json` | 평가 실행 시 |

상태 값:

- `current`: 최신 입력을 반영했다.
- `stale`: 앞 단계가 바뀌어 다시 검토해야 한다.
- `needs-review`: 내용은 있으나 QA 또는 사람 확인이 필요하다.
- `archived`: 이전 실행 결과로 보관만 한다.

승인 상태 값:

- `사용 가능`: 검증과 필요한 승인이 끝나 실제로 사용할 수 있다.
- `사람 승인 필요`: 외부 발송, 제출, 삭제, 결제, 법적 표현, 개인정보 처리처럼 사용자가 직접 확인해야 하는 행동이 남아 있다.
- `미검증 영역 있음`: 결과물 안에 확인하지 못한 근거, 수치, 사실, 정책 판단이 남아 있다.
- `해당 없음`: 중간 산출물이어서 별도 승인 상태를 붙이지 않는다.

## 부분 재실행 기록

| 날짜 | 바뀐 파일 | stale로 표시한 파일 | 다시 실행할 단계 | 사유 |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

## 미검증 영역과 승인 필요

- 미검증:
- 사람 승인 필요:
- 다음 실행에서 먼저 볼 파일:
```

부분 재실행에서 앞 단계 파일이 바뀌면 그 파일을 입력으로 삼는 뒤 단계 산출물을 `stale`로 표시한다. 예를 들어 `01-brief.md`가 바뀌면 `02-draft.md`, `03-review.md`, `final.md`를 그대로 최신 결과로 보지 않는다.

## 산출물 계약 표

| 단계 | 파일 | 만드는 역할 | 다음에 읽는 역할 | 재사용 방식 | 완료 기준 |
| --- | --- | --- | --- | --- | --- |
| 입력 정리 | `artifacts/00-input.md` | Orchestrator | 모든 역할 | 목표, 제약, 승인 지점 확인 | 누락 질문 분리 |
| 조사/분석 | `artifacts/10-analysis/{topic}.md` | Researcher/Analyst | Writer/Builder | 초안과 판단 근거 | 출처와 불확실성 구분 |
| 생성/구현 | `artifacts/20-agent-outputs/{role}.md` | Writer/Builder | Reviewer | 검토 대상 | 요구 형식 충족 |
| 검토 | `artifacts/30-review/{role}.md` | Reviewer/QA | Orchestrator | 수정과 승인 판단 | 증거 기반 지적 |
| 최종 | `artifacts/final/{name}.md` | Orchestrator | 사용자, 다음 실행 | 실제 사용 결과 | 승인 조건 표시 |
| 벤치마크 | `artifacts/evals/iteration-N/{eval-name}/comparison.md` | Orchestrator/QA | 다음 개선 작업 | with/without 비교 근거 | 품질·토큰·시간 판정 |
| 개선 | `artifacts/improvement-log.md` | Orchestrator | 다음 개선 작업 | 실패와 변경 근거 | 다음 수정 후보 1개 이상 |

## 벤치마크 산출물 계약

with-harness와 without-harness를 비교할 때는 일반 최종 산출물 경로와 별도로 아래 경로를 사용한다. 비교 결과가 대화에만 남으면 다음 개선에서 재사용할 수 없으므로 반드시 파일로 저장한다.

먼저 벤치마크 두께를 고른다.

| 두께 | 사용 상황 | 저장 방식 |
| --- | --- | --- |
| `light` | 작은 하네스, 빠른 가치 확인 | `prompt.md`, `comparison.md` 중심 |
| `targeted` | 큰 프로젝트, 특정 Phase·Agent·Skill 변경 | `target-input.md`, 관련 출력, `comparison.md` |
| `full` | 새 하네스 가치 증명, 릴리스 전 큰 구조 변경 | 아래 전체 폴더 구조 |

큰 프로젝트에서는 `full`을 기본으로 쓰지 않는다. 전체 결과 비교보다 바뀐 구간만 좁혀 비교하는 `targeted`를 우선한다.

아래는 전체 구조다. `light`에서는 `prompt.md`와 `comparison.md`만 둘 수 있고, `target-input.md`는 `targeted`에서만 만든다.

```text
artifacts/evals/iteration-N/{eval-name}/
├── prompt.md
├── run-config.md
├── target-input.md
├── with-harness/
│   ├── output.md
│   └── metrics.json
├── without-harness/
│   ├── output.md
│   └── metrics.json
└── comparison.md
```

- `prompt.md`: 두 실행에 공통으로 사용한 요청과 입력 자료
- `run-config.md`: 벤치마크 두께, with/without 실행 조건, 모델 정책, 사용하지 않은 하네스 요소, 평가 기준
- `target-input.md`: `targeted`에서 비교할 Phase 입력과 기대 출력
- `metrics.json`: 각 실행의 `total_tokens`, `duration_ms`, 완료 상태
- `comparison.md`: 품질 판정, 비용 대비 효과, 다음 수정 후보

## `.claude/agents/{agent-name}.md`

```md
---
name: example-agent
description: 이 Agent가 언제 호출되어야 하는지 한 문장으로 설명한다.
tools: Read, Grep, Glob
---

당신은 {역할 이름}입니다.

## 책임

- 

## 입력

- 

## 출력

- 결과 요약:
- 파일 경로:
- 상태: current | needs-review | stale

## 작업 방식

1. 먼저 요청의 목적과 산출물을 확인합니다.
2. 필요한 자료를 읽고, 근거가 없는 내용은 추측하지 않습니다.
3. 결과를 정해진 형식으로 남깁니다.

## 팀 통신 프로토콜

- 메시지 수신:
- 메시지 발신:
- 작업 요청:
- 파일 산출물:
- 차단 조건:

## 하지 말아야 할 일

- 역할 밖의 결정을 대신 확정하지 않습니다.
- 확인하지 않은 사실을 단정하지 않습니다.
- 외부 발송, 제출, 삭제, 결제처럼 책임이 생기는 행동을 사람 승인 없이 완료하지 않습니다.
```

## `.claude/skills/{skill-name}/SKILL.md`

````md
---
description: 이 Skill이 필요한 상황과 트리거를 구체적으로 적는다.
---

# Example Skill

## Overview

이 Skill은 {역할}이 {작업}을 일관되게 수행하도록 돕는다.
부족한 정보가 있으면 먼저 질문하고, 사용자가 주지 않은 사실을 임의로 만들지 않는다.

## Workflow

1. 입력 자료를 확인한다.
2. 빠진 조건을 표시한다.
3. 결과를 작성한다.
4. 품질 기준으로 점검한다.

## 산출물 형식

```md
## 결과

- 

## 근거

- 

## 확인 필요

- 
```

## 품질 기준

- 결과가 사용자의 원래 목표와 연결되어야 한다.
- 근거와 추측을 구분해야 한다.
- 다음 단계에서 바로 사용할 수 있어야 한다.

## 예외와 금지 행동

- 정보가 부족하면 추측하지 말고 질문한다.
- 이 Skill의 범위를 벗어난 요청은 Orchestrator나 사용자에게 되돌린다.
````

## `.claude/skills/{harness-name}-orchestrator/SKILL.md`

````md
---
description: 여러 Agent와 Skill을 순서대로 묶어 하나의 하네스 실행 흐름을 만들 때 사용한다. 초기 실행뿐 아니라 재실행, 다시 실행, 업데이트, 수정, 보완, 이전 결과 기반 개선, 특정 단계만 다시 처리하는 요청에도 사용한다.
---

# Example Orchestrator

## 목적

이 Orchestrator는 {업무 이름}을 여러 역할로 나누고, 중간 산출물을 이어서 최종 결과를 만든다.

## 실행 모드

기본 후보 실행 모드는 Agent Team이다. 다만 작업이 작고 조율이 필요 없으면 단일 흐름이나 Subagent 흐름으로 줄인다.

## 실행 모드 확인

1. `artifacts/` 또는 기존 중간 산출물이 있는지 확인한다.
2. 기존 산출물이 없으면 초기 실행으로 진행하고 `artifacts/README.md`를 만든다.
3. 기존 산출물이 있고 사용자가 일부 수정만 요청하면 해당 단계만 부분 재실행한다.
4. 새 입력으로 다시 시작해야 하면 기존 산출물을 `artifacts/archive/{YYYYMMDD-HHMMSS}/`에 보존하고 새 실행을 시작한다.
5. 기존 산출물이 있지만 사용자의 의도가 불분명하면 "이어 하기", "부분 수정", "새 실행" 중 무엇인지 먼저 확인한다.
6. 부분 재실행으로 앞 단계 산출물이 바뀌면, 그 산출물을 입력으로 삼는 뒤 단계 파일을 `artifacts/README.md`에서 `stale`로 표시한다.

## 실행 모드별 데이터 전달

| 실행 모드 | 시작과 정리 | 진행 상태 | 중간 공유 | 기억해야 할 산출물 |
| --- | --- | --- | --- | --- |
| Agent Team | `TeamCreate`, `TeamDelete` | `TaskCreate`, `TaskUpdate`, `TaskGet` | `SendMessage` | `artifacts/` |
| Subagent | Orchestrator가 호출하고 반환 후 종료 | Orchestrator가 직접 추적 | 반환값 | `artifacts/` |
| Hybrid | Phase별 시작과 정리를 명시 | Phase별로 다르게 명시 | 전환 시 파일로 인계 | `artifacts/handoff.md` |

## Agent Team 구성

| 팀원 | Agent 파일 | tools | 역할 | 주요 산출물 |
| --- | --- | --- | --- | --- |
| {Agent A} | `.claude/agents/{agent-a}.md` | `Read, Grep, Glob` |  | `artifacts/01-{agent-a}.md` |
| {Agent B} | `.claude/agents/{agent-b}.md` | `Read, Grep, Glob, Write, Edit` |  | `artifacts/02-{agent-b}.md` |
| {Reviewer Agent} | `.claude/agents/{reviewer}.md` | `Read, Grep, Glob, Bash` |  | `artifacts/03-review.md` |

## Task 등록 계약

| Task | 담당 | 입력 | 출력 | 의존 | 완료 기준 | 상태 갱신 |
| --- | --- | --- | --- | --- | --- | --- |
| T01-input | Orchestrator | 사용자 요청 | `artifacts/00-input.md` | 없음 | 목표, 제약, 승인 지점 정리 | 작성 완료 |
| T02-analysis | {Agent A} | `00-input.md` | `artifacts/01-brief.md` | T01 | 근거와 불확실성 구분 | 시작, 차단, 완료 |
| T03-produce | {Agent B} | `01-brief.md` | `artifacts/02-draft.md` | T02 | 요구 형식 충족 | 시작, 차단, 완료 |
| T04-review | {Reviewer Agent} | `02-draft.md` | `artifacts/03-review.md` | T03 | 수정 필요와 승인 필요 구분 | 시작, 차단, 완료 |

## Agent Team 실행 흐름

1. 요청을 정리하고 `artifacts/00-input.md`에 입력, 제약, 승인 지점을 저장한다.
2. `artifacts/README.md`를 만들거나 갱신한다.
3. `TeamCreate`로 필요한 Agent를 팀원으로 구성한다.
4. `TaskCreate`로 단계별 작업과 의존 관계를 등록한다.
5. 팀원들은 `TaskUpdate`로 시작, 차단, 완료 상태를 갱신한다.
6. Orchestrator는 Phase 전환 전 `TaskGet`으로 누락과 지연을 확인한다.
7. 팀원들은 `SendMessage`로 발견, 질문, 충돌 지점, 완료 알림을 공유한다.
8. 각 팀원은 자기 산출물을 `artifacts/`에 저장한다.
9. Orchestrator는 산출물을 읽고 누락, 충돌, 승인 필요 사항을 확인한다.
10. 최종 결과를 `artifacts/final.md`에 저장하고 `사용 가능`, `사람 승인 필요`, `미검증 영역`을 구분한다.
11. `artifacts/README.md`, `artifacts/improvement-log.md`, 필요한 경우 `artifacts/handoff.md`를 갱신한다.
12. 승인 게이트 준비: `사람 승인 필요` 항목이 있으면 발송·제출·배포 같은 위험 행동은 실행하지 않고 `artifacts/README.md`의 승인 상태를 `사람 승인 필요`로 둔다. 라벨만 붙이고 통과하지 않는다.
13. 실행이 끝나면 `TeamDelete`로 팀을 정리한다.
14. 승인 필요한 행동이 남아 있으면 팀 정리 후 아래 "승인 게이트 형식"으로 사용자에게 승인을 요청하고 멈춘다. 해당 행동은 승인 후 별도로 진행한다.

## 하이브리드 전환

- 팀에서 Subagent로 넘어갈 때는 먼저 팀 산출물을 저장하고 `TeamDelete`를 수행한다.
- Subagent 결과를 팀이 이어받아야 하면 반환값만 넘기지 말고 `artifacts/` 파일로 저장한다.
- 새 팀이 필요하면 `artifacts/handoff.md`를 만든 뒤 기존 팀을 정리하고 새 `TeamCreate`를 수행한다.

## 실패 처리

- 입력이 부족하면 바로 생성하지 말고 빠진 정보를 질문한다.
- 중간 산출물이 다음 단계에서 쓰기 어렵다면 해당 단계만 다시 수행한다.
- 팀원 1명이 실패하면 `TaskGet`으로 상태를 확인하고 `SendMessage`로 1회 재시도 또는 재할당을 지시한다.
- 과반 작업이 실패하면 현재 상태, 남은 위험, 가능한 선택지를 사용자에게 보고하고 확인을 받는다.
- 충돌하는 결과는 삭제하지 말고 출처와 근거를 병기한다.
- 품질 기준을 통과하지 못하면 수정 목록을 먼저 제시한다.
- 외부 발송, 제출, 삭제, 결제, 법적 표현, 개인정보 처리는 사람 승인 전 완료하지 않는다. 산출물 저장과 팀 정리는 마치되, 위험 행동은 실행하지 말고 사용자에게 승인을 요청한 뒤 멈춘다.
````

## 승인 게이트 형식

사람 승인은 산출물에 붙이는 라벨이 아니라 위험 행동을 멈추는 게이트다. 승인 지점에 도달하면 Orchestrator는 산출물 저장, 개선 기록, 팀 정리를 마친 뒤 아래 형식으로 사용자에게 승인을 요청하고 멈춘다. Orchestrator Skill에 이 형식을 포함한다.

```md
## 승인 요청

- 승인 대상: {무엇을 승인하는가 — 예: 고객에게 보낼 메일 발송}
- 필요한 이유: {왜 사람 확인이 필요한가 — 외부 발송, 개인정보, 비가역 등}
- 승인하면 일어나는 일: {승인 시 진행할 행동}
- 지금 상태: 사람 승인 필요 (아직 발송·제출·배포하지 않음)
- 확인해 주세요: {사용자가 봐야 할 핵심 항목}
- 보류하면: {대안 또는 다음 행동}
```

규칙:

- 승인 요청 없이 흐름을 끝내지 않는다. 라벨만 붙이고 통과하는 것은 실패다.
- 사용자의 명시적 승인 전에는 발송·제출·삭제·결제·배포를 실행하지 않고 `artifacts/README.md`의 승인 상태를 `사용 가능`으로 바꾸지 않는다.
- 사용자가 승인하면 승인 상태를 `사용 가능`으로 바꾸고 그 행동만 진행한다. 보류하면 사유와 대안을 `artifacts/`에 기록한다.

## `CLAUDE.md` 포인터

```md
# Project Harness

이 프로젝트에는 하네스가 있습니다.

## 주요 위치

- 실행 스킬: `.claude/skills/`
- Agent: `.claude/agents/`
- 중간 산출물: `artifacts/`

## 자연어 라우팅

사용자가 스킬명을 직접 입력하지 않아도 이 하네스의 업무로 판단되면 `{harness-name}-orchestrator`를 먼저 사용한다.

예:

- "{업무} 계획을 만들어줘"
- "{업무} 초안을 정리해줘"
- "{업무}를 역할별로 나눠서 진행해줘"
- "{업무} 결과를 검토하고 개선해줘"
- "{업무}를 이전 결과 기반으로 다시 보완해줘"
- "{업무}의 검토 단계만 다시 실행해줘"

## 하네스 변경 이력

| 날짜 | 변경 내용 | 대상 | 사유 |
| --- | --- | --- | --- |
| YYYY-MM-DD | 초기 구성 | 전체 | 반복 업무 하네스 생성 |
```
