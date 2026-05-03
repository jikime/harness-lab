# Harness Engineering Lab

> **감사의 말**
> 이 프로젝트는 [`revfactory/harness`](https://github.com/revfactory/harness)를 만드신 카카오의 황민호 님의 스킬을 기반으로, 하네스 엔지니어링을 더 쉽게 실습할 수 있도록 교육용 흐름에 맞게 재구성한 것입니다. 좋은 공개 자료와 아이디어를 공유해 주신 황민호 님께 다시 한번 깊이 감사드립니다.

이 프로젝트는 Claude Code에서 하네스 엔지니어링을 연습하고 실행 가능한 하네스를 구성하기 위한 교육용 스킬 프로젝트입니다.

목표는 사용자가 자신의 일상 업무나 작은 프로젝트를 Agent, Skill, Orchestrator, Test, Evolution 구조로 바꾸는 감각을 익히도록 돕는 것입니다.

## 사용 방법

이 프로젝트의 핵심 스킬은 `skills/harness-lab`입니다. 이 스킬은 독자의 업무를 바로 자동화해주는 도구라기보다, 업무를 하네스 구조로 바꾸는 연습을 도와주는 안내자입니다.

## Claude Code에서 설치하기

개인용 스킬로 설치하면 모든 Claude Code 프로젝트에서 사용할 수 있습니다.

```bash
mkdir -p ~/.claude/skills
cp -R skills/harness-lab ~/.claude/skills/
```

특정 프로젝트에서만 쓰고 싶다면, 해당 프로젝트 루트에서 프로젝트 스킬로 복사합니다.

```bash
mkdir -p .claude/skills
cp -R /path/to/harness-engineering-lab/skills/harness-lab .claude/skills/
```

Claude Code를 새로 열면 `/harness-lab`으로 직접 호출할 수 있습니다.

```text
/harness-lab 여행 계획 하네스를 만들어줘.
```

스킬 이름을 직접 쓰지 않아도, 요청이 `SKILL.md`의 description과 잘 맞으면 Claude Code가 자동으로 해당 스킬을 사용할 수 있습니다.

```text
내 블로그 글쓰기 업무를 작은 에이전트 팀 하네스로 바꿔줘.
처음 보는 사람도 이해할 수 있게 역할과 작업 순서를 설명해줘.
```

사용 가능한 스킬을 확인하고 싶다면 Claude Code 안에서 이렇게 물어봅니다.

```text
사용 가능한 스킬 목록을 보여줘.
```

참고로 Claude Code는 스킬 폴더 변경을 감지하지만, `~/.claude/skills`나 `.claude/skills` 같은 상위 폴더를 새로 만든 직후에는 새 세션을 여는 편이 가장 안전합니다.

## 두 단계 흐름

`harness-lab`은 기본적으로 두 단계로 동작합니다. 사용자가 "하네스를 만들어줘"라고 요청하면 먼저 **청사진**을 보여주고, 사용자가 그 구조를 확인한 뒤 승인하면 실제로 계속 사용할 수 있는 **실행 하네스**를 만듭니다.

| 단계 | 무엇을 하나 | 사용자가 할 일 |
| --- | --- | --- |
| 1. 청사진 제안 | Agent/Skill/Orchestrator 구조, 역할표, 테스트 프롬프트를 제안합니다. | 역할과 흐름이 마음에 드는지 확인합니다. |
| 2. 실행 하네스 생성 | 사용자가 승인하면 기존 Claude Code 설정을 먼저 확인한 뒤 실행 가능한 하네스 구성을 만들고, 생성된 흐름으로 실제 작업을 수행할 수 있게 안내합니다. | "좋아, 이 구조로 만들어줘"처럼 승인합니다. |

이 흐름을 쓰면 독자가 내부 파일 구조를 몰라도 됩니다. 먼저 설계안을 읽어보고, 마음에 들 때만 실행 가능한 하네스 구성을 승인하면 됩니다.

기본 흐름은 아래처럼 생각하면 됩니다.

```text
사용자: /harness-lab 블로그 글쓰기 하네스 만들어줘.

스킬: 청사진부터 만들겠습니다. 이런 역할과 흐름으로 만들 수 있습니다. 이 구조로 실행 가능한 하네스를 구성해드릴까요?

사용자: 좋아, 이 구조로 만들어줘.

스킬: 기존 Claude Code 설정을 확인한 뒤 실행 가능한 하네스 구성을 만듭니다.
```

## 첫 프롬프트 예시

처음에는 개발 프로젝트보다 일상 업무로 시작하는 편이 좋습니다. 그래야 Agent, Skill, Orchestrator가 훨씬 쉽게 느껴집니다.

```text
/harness-lab 1박 2일 가족 여행 계획을 위한 작은 하네스를 만들어줘.
Agent, Skill, Orchestrator, Test, Evolution을 일상 언어로 설명해줘.
```

다른 표현으로는 이렇게 요청해도 좋습니다.

```text
/harness-lab 2박 3일 가족 여행 계획을 위한 작은 하네스를 만들어줘.
Agent, Skill, Orchestrator, Test, Evolution은 처음 보는 사람도 이해할 수 있게 일상 언어로 설명해줘.
```

## 기대할 수 있는 결과

스킬을 사용하면 보통 아래와 같은 결과를 얻게 됩니다.

- 사람이 직접 한다면 어떤 절차로 일할지 정리
- 필요한 Agent 역할표
- 각 Agent가 따를 Skill 설계
- 전체 흐름을 묶는 Orchestrator 구조
- 정상 사례, 애매한 사례, 실패 위험 사례를 포함한 테스트 프롬프트
- 실행 후 다음 버전에서 고칠 개선 기록

## 일상생활에서 써볼 수 있는 예시

처음에는 "AI로 큰 프로젝트를 자동화한다"라고 생각하기보다, 평소에 반복해서 하는 일을 작은 팀 작업으로 나눠본다고 생각하면 쉽습니다.

### 여행 계획 세우기

```text
/harness-lab 2박 3일 제주도 가족 여행 계획 하네스를 만들어줘.
숙소 조사, 일정 설계, 예산 검토, 최종 정리 역할로 나눠서 설명해줘.
```

이 예시는 Agent를 "여행 준비를 나눠 맡는 가족 구성원"처럼 이해하는 데 좋습니다.

### 블로그 글쓰기

```text
/harness-lab 입문 독자를 위한 블로그 글쓰기 하네스를 만들어줘.
자료 조사, 목차 구성, 초안 작성, 문체 검토 역할을 나눠줘.
```

이 예시는 Skill을 "각 담당자가 따르는 글쓰기 체크리스트"로 이해하는 데 좋습니다.

### 회의록 정리하기

```text
/harness-lab 회의록 정리 하네스를 만들어줘.
결정 사항, 할 일, 리스크, 후속 질문을 분리해서 정리하는 흐름으로 설계해줘.
```

이 예시는 Fan-out/Fan-in, 즉 여러 관점으로 나눠 보고 다시 합치는 방식을 익히기 좋습니다.

### 개인 학습 계획 만들기

```text
/harness-lab 4주 동안 Git 기초를 배우는 학습 하네스를 만들어줘.
현재 수준 확인, 주차별 계획, 연습 문제, 회고 방식까지 포함해줘.
```

이 예시는 Evolution, 즉 한 번 만든 계획을 실제 학습 결과에 맞춰 고치는 감각을 익히기 좋습니다.

### 집안일이나 반복 업무 정리하기

```text
/harness-lab 주말 집안일을 정리하는 하네스를 만들어줘.
할 일 분류, 우선순위 정하기, 가족별 역할 나누기, 완료 점검으로 구성해줘.
```

이 예시는 Orchestrator를 "누가 먼저 무엇을 하고, 다음 사람에게 무엇을 넘길지 정하는 흐름표"로 이해하는 데 좋습니다.

### 작은 개발 프로젝트 준비하기

```text
/harness-lab 개인 웹사이트 문구 수정 작업을 위한 작은 개발 하네스를 만들어줘.
요구사항 정리, 파일 찾기, 수정, 테스트, 변경 요약 역할로 나눠줘.
```

이 예시는 하네스 개념을 실제 프로젝트 파일과 연결하는 연습에 좋습니다.

## 청사진을 확인한 뒤 실행 하네스로 만들기

처음부터 실행 환경을 만들기보다, 먼저 하네스 청사진을 확인한 뒤 필요할 때 실행 가능한 하네스로 옮기는 흐름을 권장합니다.

즉, 단순히 `/harness-lab 여행 계획 하네스를 만들어줘`라고 하면 먼저 하네스 청사진을 보여줍니다. 그 다음 사용자가 승인하면 실제 실행 하네스로 만듭니다.

```text
/harness-lab 블로그 글쓰기 하네스 만들어줘.
```

청사진을 확인한 뒤 마음에 들면 이렇게 말합니다.

```text
좋아, 이 구조로 실제 사용할 수 있게 만들어줘.
기존 설정이 있으면 먼저 확인하고, 무엇을 바꿀지 설명한 뒤 진행해줘.
```

이렇게 요청하면 `harness-lab`이 필요한 Claude Code 하네스 구조를 대신 선택합니다. 독자가 `.claude/agents`나 `.claude/skills` 같은 용어를 미리 알 필요는 없습니다.

## 생성된 실행 하네스 사용하기

사용자가 승인하면 Claude Code 프로젝트 안에 보통 아래와 비슷한 구조가 생깁니다.

```text
.claude/
  agents/
    trip-researcher.md
    trip-planner.md
    budget-reviewer.md
  skills/
    trip-planning-orchestrator/
      SKILL.md
    trip-research-guide/
      SKILL.md
```

여기서 `.claude/agents`는 "일을 맡을 팀원"이고, `.claude/skills`는 "팀원이 따를 작업 매뉴얼"입니다. 실제로 사용할 때는 보통 개별 Agent를 하나씩 직접 부르기보다, 전체 흐름을 묶는 Orchestrator Skill을 먼저 실행하는 편이 좋습니다.

```text
/trip-planning-orchestrator 부모님과 함께 가는 2박 3일 제주 여행 계획을 만들어줘.
예산은 1인 50만원 이하이고, 너무 빡빡하지 않은 일정이면 좋겠어.
```

Claude Code는 Agent 설명과 현재 요청이 잘 맞으면 필요한 Agent를 자동으로 사용할 수 있습니다. 직접 특정 Agent에게 맡기고 싶을 때는 자연어로 이름을 말하면 됩니다.

```text
trip-researcher subagent를 사용해서 제주 동쪽과 서쪽 숙소 후보를 비교해줘.
```

더 확실하게 특정 Agent를 지정하고 싶다면 Claude Code의 `@` 멘션을 사용할 수 있습니다. `@`를 입력하면 사용 가능한 Agent 후보가 표시됩니다.

```text
@agent-trip-researcher 제주 동쪽 숙소 후보를 가족 여행 관점에서 비교해줘.
```

새로 만든 Agent가 보이지 않으면 Claude Code 안에서 `/agents`를 실행해 목록을 확인하거나, 세션을 새로 열어 파일을 다시 읽게 합니다.

```text
/agents
```

중요한 점이 하나 있습니다. Claude Code의 subagent는 독립된 컨텍스트에서 일하기 때문에, 메인 대화에서 사용할 수 있는 Skill을 자동으로 모두 물려받지 않습니다. 특정 Agent가 특정 Skill을 항상 알고 있어야 한다면 Agent 파일의 frontmatter에 `skills`를 명시합니다.

```md
---
name: trip-planner
description: 여행 일정을 설계하는 Agent입니다.
skills:
  - trip-research-guide
---
```

전체 흐름은 아래 순서로 사용하면 충분합니다.

1. `/harness-lab`으로 하네스 청사진을 만든다.
2. 청사진의 역할과 흐름을 읽어본다.
3. 구조가 괜찮으면 "좋아, 이 구조로 실제 사용할 수 있게 만들어줘"라고 승인한다.
4. 생성된 Agent와 Skill 파일을 읽고 역할이 맞는지 확인한다.
5. 새 세션을 열거나 `/agents`로 Agent 목록을 확인한다.
6. Orchestrator Skill을 먼저 실행해서 원하는 결과물을 만든다.
7. 필요할 때만 특정 Agent를 직접 호출한다.
8. 결과가 부족하면 테스트 프롬프트와 개선 기록으로 하네스를 고친다.

## 현재 구성

```text
skills/
  harness-lab/
    SKILL.md
    references/
      everyday-examples.md
      pattern-catalog.md
      phase-guide.md
      templates.md
      testing-improvement.md
```

## 설계 원칙

- Claude Code의 `.claude/agents`, `.claude/skills`, `CLAUDE.md` 구조를 기준으로 합니다.
- 누구나 처음 실습할 수 있도록 일상 언어와 작은 예시를 먼저 사용합니다.
- 하네스 용어를 일상 언어로 먼저 번역합니다.
- Phase 번호는 Phase 0부터 Phase 7까지로 고정합니다.
- 생성보다 이해, 테스트, 개선을 더 중요하게 봅니다.
