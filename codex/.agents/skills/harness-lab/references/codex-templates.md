# Codex 산출물 템플릿

이 문서는 실제 Codex용 파일이나 하네스 청사진을 작성할 때 사용한다. 프로젝트의 기존 규칙이 있으면 기존 규칙을 우선한다.

## 하네스 청사진

```md
## 하네스 청사진

### 목표

- 이 하네스가 돕는 일:
- 최종 산출물:
- 주요 사용자:

### 사람의 작업 절차

1.
2.
3.

### 선택한 팀 패턴

- 패턴:
- 선택 이유:
- 주의할 점:

### Agent 역할표

| Agent | 맡는 일 | 입력 | 출력 | 하지 말아야 할 일 |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

### Skill 목록

| Skill | 사용하는 Agent | 절차 요약 | 품질 기준 |
| --- | --- | --- | --- |
|  |  |  |  |

### Orchestrator 흐름

- Orchestrator Skill 이름: `{하네스-이름}-orchestrator`
- Orchestrator Skill 위치: `.agents/skills/{하네스-이름}-orchestrator/SKILL.md`

1.
2.
3.

### 테스트 프롬프트

| 유형 | 프롬프트 | 기대 결과 |
| --- | --- | --- |
| 정상 |  |  |
| 애매함 |  |  |
| 실패 위험 |  |  |
```

## `.codex/agents/{agent-name}.toml`

```toml
name = "example_agent"
description = "이 Agent가 언제 호출되어야 하는지 한 문장으로 설명한다."

developer_instructions = """
당신은 {역할 이름}입니다.

책임:
-

입력:
-

출력:
-

작업 방식:
1. 먼저 요청의 목적과 산출물을 확인합니다.
2. 필요한 자료를 읽고, 근거가 없는 내용은 추측하지 않습니다.
3. 결과를 정해진 형식으로 남깁니다.

하지 말아야 할 일:
- 역할 밖의 결정을 대신 확정하지 않습니다.
- 확인하지 않은 사실을 단정하지 않습니다.
"""
```

필요한 경우 `model`, `model_reasoning_effort`, `sandbox_mode`, MCP 서버 설정을 추가할 수 있다. 처음 실습에서는 과하게 지정하지 않는다. 파일을 고쳐야 하는 역할이 아니라 조사나 검토만 하는 역할이라면 읽기 중심으로 설명하고, 구현 역할이라면 어떤 파일 범위까지 맡는지 좁게 적는다.

## `.agents/skills/{skill-name}/SKILL.md`

````md
---
name: example-skill
description: 이 Skill이 필요한 상황과 트리거를 구체적으로 적는다.
---

# Example Skill

## 목적

이 Skill은 {역할}이 {작업}을 일관되게 수행하도록 돕는다.

## 절차

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
````

## `.agents/skills/{harness-name}-orchestrator/SKILL.md`

Orchestrator 역할을 하는 Skill은 폴더명과 frontmatter `name`이 반드시 `-orchestrator`로 끝나야 한다. 일반 작업 Skill에는 이 접미사를 쓰지 않는다.

```md
---
name: example-orchestrator
description: 여러 Agent와 Skill을 순서대로 묶어 하나의 Codex 하네스 실행 흐름을 만들 때 사용한다.
---

# Example Orchestrator

## 목적

이 Orchestrator는 {업무 이름}을 여러 역할로 나누고, 중간 산출물을 이어서 최종 결과를 만든다.

## 입력

- 사용자 요청:
- 참고 자료:
- 제약 조건:

## 실행 흐름

1. 요청을 정리하고 최종 산출물을 확인한다.
2. {Agent A}가 {중간 산출물 A}를 만든다.
3. {Agent B}가 {중간 산출물 A}를 바탕으로 {중간 산출물 B}를 만든다.
4. {Reviewer Agent}가 누락, 충돌, 독자 수준 불일치를 확인한다.
5. 최종 결과와 확인 필요 사항을 함께 보고한다.

## 파일 기반 산출물

- `artifacts/01-brief.md`
- `artifacts/02-draft.md`
- `artifacts/03-review.md`
- `artifacts/final.md`

## 실패 처리

- 입력이 부족하면 바로 생성하지 말고 빠진 정보를 질문한다.
- 중간 산출물이 다음 단계에서 쓰기 어렵다면 해당 단계만 다시 수행한다.
- 품질 기준을 통과하지 못하면 수정 목록을 먼저 제시한다.
```

## `AGENTS.md` 포인터

```md
# Project Harness

이 프로젝트에는 Codex용 하네스가 있습니다.

## 주요 위치

- 실행 스킬: `.agents/skills/`
- 커스텀 에이전트: `.codex/agents/`
- 중간 산출물: `artifacts/`

## 자연어 라우팅

사용자가 스킬명을 직접 입력하지 않아도 이 하네스의 업무로 판단되면 `{harness-name}-orchestrator`를 먼저 사용한다.

예:

- "{업무} 계획을 만들어줘"
- "{업무} 초안을 정리해줘"
- "{업무}를 역할별로 나눠서 진행해줘"
- "{업무} 결과를 검토하고 개선해줘"

## 사용 흐름

1. 자연어 요청이 이 하네스의 범위에 들어오면 `{harness-name}-orchestrator`를 우선 실행한다.
2. Orchestrator가 필요한 Agent와 작업 Skill을 선택한다.
3. 사용자가 특정 Agent나 작업 Skill을 직접 지정한 경우에만 해당 구성요소를 바로 사용한다.
4. 범위가 애매하면 한 가지 확인 질문을 먼저 한다.
5. 결과는 `artifacts/`에 남기고, 검토 후 다음 단계로 넘긴다.
```

`AGENTS.md`가 이미 프로젝트 전체 규칙으로 쓰이고 있다면, 기존 내용을 지우지 말고 하네스 위치와 자연어 라우팅을 가리키는 짧은 섹션만 추가한다. 임시로 로컬에서만 덮어써야 하는 지시가 필요할 때는 `AGENTS.override.md`를 검토한다.

## 생성 후 사용 안내

````md
## 이 하네스 사용 방법

### 1. 자연어로 요청합니다

생성된 `AGENTS.md`에는 자연어 요청을 Orchestrator Skill로 연결하는 규칙이 들어 있습니다. 그래서 스킬명을 외우지 않아도 아래처럼 평소 말하듯 요청할 수 있습니다.

```text
{사용자의 실제 요청}
```

### 2. 필요하면 Orchestrator Skill을 직접 실행합니다

```text
$trip-planning-orchestrator {사용자의 실제 요청}
```

위 예시의 `trip-planning-orchestrator`는 실제 하네스 이름에 맞게 바꾼다. 단, 이름은 반드시 `-orchestrator`로 끝나야 한다.

Orchestrator는 여러 Agent와 Skill의 순서를 묶는 입구입니다. 처음에는 개별 Agent를 직접 부르기보다 Orchestrator를 통해 실행하는 편이 안전합니다.

### 3. 필요할 때 특정 Agent를 직접 사용합니다

```text
example_agent를 사용해서 {맡길 작업}을 수행합니다.
```

Codex에서 커스텀 Agent 파일을 새로 추가한 직후에는 새 세션에서 다시 읽히는지 확인합니다.

### 4. 결과를 테스트하고 개선합니다

정상 사례, 애매한 사례, 실패 위험 사례를 각각 실행하고 개선 기록에 남깁니다.
````

## 개선 기록

```md
## 개선 기록

- 날짜:
- 실행한 요청:
- 기대한 결과:
- 실제 결과:
- 막힌 지점:
- 다음 버전에서 바꿀 규칙:
```
