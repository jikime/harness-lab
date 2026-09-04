# Orchestrator와 산출물 템플릿

이 문서는 Orchestrator 런타임과 하네스 청사진·산출물 템플릿을 작성할 때 사용한다. Orchestrator는 일을 직접 다 하는 존재가 아니라, 역할을 나누고 산출물을 이어받고 실패와 승인 지점을 관리하는 입구다. 이 문서는 그 런타임 계약(실행 계약·실행 흐름·Task·데이터 전달·메시지·에러)과 청사진·`.claude` 파일·`artifacts/` 산출물 템플릿을 함께 담는다. Agent를 어떻게 설계·분리하고 어떤 팀 패턴으로 묶을지는 `agent-design.md`를 본다.

## 목차

1. 언제 읽을까
2. Agent Team 최소 실행 계약
3. 위임 4종 세트
4. Orchestrator 실행 흐름
5. Task 설계 형식
6. TaskUpdate와 TaskGet 운영 규칙
7. 데이터 전달 프로토콜
8. SendMessage 규칙
9. 하이브리드 전환, 팀 재구성, 에러 처리
10. 하네스 청사진
11. 산출물 구조 선택과 `artifacts/README.md` 템플릿
12. 산출물 계약과 벤치마크
13. Agent / Skill / Orchestrator 템플릿
14. 승인 게이트 형식과 `CLAUDE.md` 포인터

## 언제 읽을까

- Orchestrator 실행 계약, 실행 흐름, Task, 데이터 전달, 에러 처리를 작성해야 할 때
- 청사진 템플릿이 필요할 때
- `.claude/agents`, `.claude/skills`, `CLAUDE.md` 초안을 만들어야 할 때
- `artifacts/` 산출물 계약과 파일 구조를 정해야 할 때
- `artifacts/README.md`에 산출물 지도와 최신 상태를 남겨야 할 때
- Agent Team Orchestrator의 Task, 메시지, 팀 정리 조건을 작성해야 할 때

## Agent Team 최소 실행 계약

Orchestrator Skill에는 아래 항목이 모두 있어야 한다.

| 계약 | 설명 | 산출물 |
| --- | --- | --- |
| 팀 구성 | 어떤 Agent를 `TeamCreate`로 팀원화할지 정한다 | Agent Team 구성표 |
| 작업 등록 | 단계별 작업, 담당자, 의존 관계, 완료 기준을 등록한다 | Task 목록 |
| 작업 상태 관리 | 지연, 차단, 완료, 재할당을 갱신하고 확인한다 | `TaskUpdate`, `TaskGet` 기준 |
| 메시지 규칙 | 어떤 발견, 질문, 충돌, 완료 알림을 누구에게 보낼지 정한다 | 팀 통신 프로토콜 |
| 파일 산출물 | 다음 단계가 반드시 읽어야 하는 내용은 파일로 남긴다 | `artifacts/` 파일 |
| 통합 절차 | Orchestrator가 산출물을 읽어 충돌과 누락을 정리한다 | 최종 산출물 |
| 정리 절차 | 실행 종료 후 `TeamDelete`로 팀을 정리하고 다음 실행을 위한 기록을 남긴다 | 개선 기록, handoff |

## 위임 4종 세트

Task를 맡길 때 모호한 한 줄("이거 조사해줘")은 중복·누락·방향 어긋남의 가장 큰 원인이다. 각 위임에는 네 가지를 반드시 담는다.

| 요소 | 담을 내용 |
| --- | --- |
| 목표 | 이 Task가 끝나면 무엇이 있어야 하는가. 한 문장으로 |
| 출력 형식 | 어떤 파일에 어떤 구조로 남기는가. 다음 단계가 그대로 읽을 수 있게 |
| 도구·출처 | 어떤 도구와 자료를 쓰고, 어디는 보지 말아야 하는가 |
| 경계 | 어디까지가 이 Task의 책임이고, 어디부터는 다른 역할인가 |

이 네 가지는 Task 설계 형식(아래)과 Agent 본문 양쪽에 반영한다. 위임이 구체적일수록 팀원이 같은 자료를 중복 조사하거나 빈틈을 남길 확률이 줄어든다.

## Orchestrator 실행 흐름

1. `artifacts/`를 확인해 초기 실행, 부분 재실행, 새 실행 중 하나를 고른다.
2. 사용자 요청, 입력 자료, 제약, 사람 승인 지점을 `artifacts/00-input.md`에 저장한다.
3. `TeamCreate`로 필요한 Agent를 팀원으로 구성한다.
4. `TaskCreate`로 단계별 작업을 등록한다.
5. 각 Task에는 담당자, 입력 파일, 출력 파일, 의존 관계, 완료 기준을 둔다.
6. 팀원은 시작, 차단, 완료 상태를 `TaskUpdate`로 갱신한다.
7. Orchestrator는 `TaskGet`으로 지연, 누락, 의존 관계 막힘을 확인한다.
8. 팀원들은 `SendMessage`로 중간 발견, 질문, 충돌, 완료 알림을 공유한다.
9. 팀원들은 다음 단계가 읽어야 할 내용을 `artifacts/` 파일에 저장한다.
10. Orchestrator는 산출물을 읽고 누락, 충돌, 승인 필요 지점을 정리한다.
11. 최종 결과를 `artifacts/final.md` 또는 도메인별 최종 파일에 저장하고, `사용 가능`, `사람 승인 필요`, `미검증 영역`을 구분한다.
12. `artifacts/README.md`, `artifacts/improvement-log.md`와 필요하면 `artifacts/handoff.md`를 갱신한다.
13. 실행이 끝나면 `TeamDelete`로 팀을 정리한다.
14. 승인 필요 지점이 있으면 발송, 제출, 배포, 삭제 같은 위험 행동은 실행하지 않고 사용자에게 승인을 요청한 뒤 멈춘다. 명시적 승인 전에는 위험 행동을 실행하지 않는다.

## Task 설계 형식

| 필드 | 작성 기준 |
| --- | --- |
| Task ID | `T01-input`, `T02-research`처럼 순서와 의미가 보이게 쓴다 |
| 담당 Agent | 실제 `.claude/agents/{name}.md` 파일, frontmatter `name`, Orchestrator의 호출 이름과 일치시킨다 |
| 입력 | 읽어야 할 사용자 자료와 이전 산출물 경로 |
| 출력 | 반드시 남길 `artifacts/` 파일 경로 |
| 의존 관계 | 먼저 완료되어야 하는 Task |
| 완료 기준 | 통과해야 할 체크리스트 또는 검증 기준 |
| 메시지 대상 | 발견, 차단, 충돌을 누구에게 보낼지 |
| 상태 갱신 | 언제 `TaskUpdate`로 시작, 차단, 완료, 재할당을 표시할지 |

각 Task의 출력 지시에는 저장 계약을 함께 적는다: 지정한 `artifacts/` 경로에 반드시 저장하고, 저장에 실패하면 재시도한 뒤 그래도 안 되면 `TaskUpdate`로 차단을 보고한다. **저장에 성공한 척 본문 요약으로 대체하지 않는다.** 파일 산출물을 맡는 Agent는 위임 전에 `Write` 권한을 갖췄는지 확인한다 — 검토·QA처럼 "수정 금지" 역할도 자기 판정 파일을 쓰려면 `Write`가 필요하다.

## TaskUpdate와 TaskGet 운영 규칙

공유 작업 목록은 장식이 아니라 팀의 현재 상태판이다. Agent Team에서는 Orchestrator가 모든 진행을 대화로만 추적하지 않고 Task 상태를 확인한다.

`TaskUpdate`가 필요한 경우:

- Agent가 자기 Task를 시작했을 때
- 입력 부족, 권한, 산출물 누락 때문에 막혔을 때
- 다른 Agent의 결과를 기다려야 할 때
- 산출물 파일을 저장하고 완료했을 때
- Orchestrator가 담당자를 바꾸거나 Task를 쪼갤 때

`TaskGet`이 필요한 경우:

- 다음 Phase로 넘어가기 전 전체 완료 상태를 확인할 때
- 특정 Agent가 오래 응답하지 않거나 유휴 상태일 때
- 의존 Task가 끝나지 않아 뒤 단계가 막힌 것처럼 보일 때
- 최종 통합 전에 누락 Task가 없는지 확인할 때

작업 재할당 기준:

1. 먼저 `TaskGet`으로 막힌 Task와 의존 관계를 확인한다.
2. 담당 Agent에게 `SendMessage`로 차단 원인을 묻는다.
3. 입력 부족이면 사용자 질문으로 멈추고, 역할 과부하면 Task를 쪼개거나 다른 Agent에게 재할당한다.
4. 재할당하면 `TaskUpdate`에 변경 이유와 새 담당자를 남긴다.
5. 기존 부분 산출물은 삭제하지 않고 `artifacts/`에 보존한다.

## 데이터 전달 프로토콜

Agent Team에서 데이터 전달은 네 가지 방식으로 나눈다.

| 방식 | 쓰는 곳 | 기준 |
| --- | --- | --- |
| 메시지 기반 | `SendMessage` | 가벼운 발견, 질문, 충돌, 완료 알림 |
| 태스크 기반 | `TaskCreate`, `TaskUpdate`, `TaskGet` | 작업 상태, 의존 관계, 재할당 |
| 파일 기반 | `artifacts/` | 다음 단계가 반드시 읽어야 하는 산출물, 감사 추적 |
| 반환값 기반 | Subagent 흐름 | 단발성 위임 결과 요약 |

팀 모드에서는 태스크 기반으로 진행을 맞추고, 파일 기반으로 기억을 남기며, 메시지 기반으로 실시간 조율한다. Subagent 모드에서는 반환값 기반으로 결과를 받고, 중요한 중간 결과는 파일로 저장한다. 하이브리드 모드에서는 Phase마다 어떤 전달 방식을 쓰는지 Orchestrator에 명시한다.

## SendMessage 규칙

메시지는 대화용이고, 파일은 기억용이다. 다음 실행이나 다음 단계가 반드시 알아야 하는 내용은 메시지에만 두지 않는다.

팀원이 반드시 메시지를 보내야 하는 경우:

- 입력 자료가 부족해 추측이 필요한 경우
- 자기 발견이 다른 Agent의 방향을 바꿀 수 있는 경우
- 이전 산출물과 충돌하는 사실을 찾은 경우
- 사람 승인 없이는 진행하면 안 되는 위험 지점을 찾은 경우
- 자기 Task를 완료했고 산출물 파일을 남긴 경우

메시지 형식:

```md
수신: {agent-name 또는 orchestrator}
유형: 발견 | 질문 | 충돌 | 차단 | 완료
관련 Task:
관련 파일:
내용:
필요한 조치:
```

## 하이브리드 전환 규칙

하이브리드는 Phase마다 실행 모드가 달라질 때 사용한다.

| 전환 | 규칙 |
| --- | --- |
| 팀에서 Subagent로 | 현재 팀 산출물을 `artifacts/`에 저장하고 `TeamDelete` 후 Subagent를 호출한다 |
| Subagent에서 팀으로 | Subagent 결과 파일을 `artifacts/`에 저장하고 새 팀의 입력으로 전달한다 |
| 팀에서 새 팀으로 | 기존 팀의 `handoff.md`를 만든 뒤 `TeamDelete`, 새 `TeamCreate` 순서로 진행한다 |

하이브리드 Orchestrator에는 각 Phase 상단에 `실행 모드: Agent Team | Subagent | 단일 흐름`을 적는다.

## 팀 재구성 규칙

팀을 중첩해서 운영하지 않는다. 다른 팀 구성이 필요하면 먼저 현재 팀의 결과를 파일로 남기고 팀을 정리한 뒤 새 팀을 만든다.

1. 현재 팀의 산출물을 `artifacts/`에 저장한다.
2. Orchestrator가 `artifacts/handoff.md`에 다음 팀이 읽을 요약을 남긴다.
3. 현재 팀을 정리한다.
4. 새 Agent Team을 만든다.
5. 새 팀은 `handoff.md`와 필요한 산출물만 읽고 시작한다.

## 에러 처리 원칙

| 상황 | 처리 |
| --- | --- |
| 팀원 1명이 실패하거나 멈춤 | `TaskGet`으로 상태 확인 후 `SendMessage`로 원인을 묻고 1회 재시도한다 |
| 재시도 실패 | 해당 Task를 재할당하거나 누락으로 표시하고 사용자에게 영향도를 보고한다 |
| 과반 작업 실패 | 계속 진행하지 말고 사용자에게 현재 상태와 선택지를 보고한다 |
| 팀원 간 결과 충돌 | 한쪽을 지우지 않고 출처와 근거를 함께 남긴 뒤 Orchestrator가 판단한다 |
| 입력 부족 | 추측하지 않고 질문 목록을 만든다 |
| 위험 작업 발견 | 멈추고 사용자에게 승인을 요청한다. 명시적 승인 전에는 발송·제출·삭제·결제·배포를 실행하지 않고, 묻지 않고 라벨만 붙여 통과하지 않는다 |

검증은 주장이 아니라 증거로 한다. "검토했고 괜찮다"가 아니라 테스트 결과, 산출물의 해당 줄, 수치 일치처럼 확인 가능한 근거를 남긴다. 위험도가 높은 하네스에서는 검토자를 작성자와 분리하고, 가능하면 **결과물(diff·초안)과 합격 기준만 보는 별도 검토 Agent**를 둔다. 같은 맥락을 공유하지 않은 검토자가 과신을 더 잘 잡아낸다. 검토자의 `tools`는 읽기·검증 중심으로 좁혀 작성과 검토 책임이 섞이지 않게 한다.

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

| Agent | model | tools | 맡는 일 | 분리 이유 | 입력 | 출력 | 하지 말아야 할 일 |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

`model` 컬럼은 청사진 단계에서 역할별로 정한다(빈칸으로 두지 않는다). 같은 팀이라도 역할마다 추론 깊이가 다르므로 값이 갈린다. 선택 루브릭과 한 팀 안 혼합 예시는 `agent-design.md`의 "Agent 모델 선택"을 따른다 — 팀 전체에 한 모델을 일괄로 박지 않는다.

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

벤치마크 두께(`light`/`targeted`/`full`) 선택, 폴더 구조, 파일별 역할(`prompt.md`·`run-config.md`·`target-input.md`·`metrics.json`·`comparison.md`)은 `testing-qa-evolution.md`의 "With/Without 하네스 A/B 비교"를 정본으로 따른다. 여기서는 산출물이 `artifacts/evals/iteration-N/{eval-name}/` 아래에 파일로 남는다는 경로 약속만 둔다.

## `.claude/agents/{agent-name}.md`

Agent 파일 템플릿과 frontmatter(`name`·`description`·`tools`·`model`)는 `agent-design.md`의 "Agent 파일 구조"·"Agent frontmatter 설계"를 정본으로 따른다.

## `.claude/skills/{skill-name}/SKILL.md`

Skill 파일 템플릿과 작성법(description·본문·progressive disclosure)은 `skill-authoring-guide.md`의 "기본 구조"를 정본으로 따른다.

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

표준 14단계 실행 흐름은 이 문서의 "Orchestrator 실행 흐름"을 따른다(요청 정리 → TeamCreate → TaskCreate/Update/Get → SendMessage → artifacts 저장 → 통합 → 승인 게이트 → TeamDelete).

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
