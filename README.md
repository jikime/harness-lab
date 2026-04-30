# Harness Engineering Lab

이 프로젝트는 하네스 엔지니어링 책의 실습을 위한 교육용 스킬 프로젝트입니다.

목표는 특정 공개 프로젝트 사용법을 그대로 따라 하는 것이 아니라, 독자가 자신의 일상 업무나 작은 프로젝트를 Agent, Skill, Orchestrator, Test, Evolution 구조로 바꾸는 감각을 익히도록 돕는 것입니다.

## 사용 방법

이 프로젝트의 핵심 스킬은 `skills/harness-lab`입니다. 이 스킬은 독자의 업무를 바로 자동화해주는 도구라기보다, 업무를 하네스 구조로 바꾸는 연습을 도와주는 안내자입니다.

## 호출 방식 요약

| 환경 | 호출 방식 | 예시 |
| --- | --- | --- |
| Claude Code | 슬래시 명령 | `/harness-lab 여행 계획 하네스를 만들어줘.` |
| Codex | 스킬 멘션 | `$harness-lab 여행 계획 하네스를 만들어줘.` |
| 직접 참조 | 경로 지정 | `./skills/harness-lab 스킬을 사용해서 ...` |

## 두 가지 사용 경로

`harness-lab`은 크게 두 가지 방식으로 사용할 수 있습니다. 먼저 하네스 사고방식을 익히는 **청사진 경로**가 있고, 실제 `.claude/agents`와 `.claude/skills`를 만들어 실행하는 **실행 하네스 경로**가 있습니다.

| 경로 | 언제 사용하나 | 결과 | 추천 상황 |
| --- | --- | --- |
| 청사진 경로 | "하네스를 만들어줘", "설계해줘", "연습해보자"처럼 요청할 때 | Agent/Skill/Orchestrator 구조를 설명하고 역할표와 테스트 프롬프트를 제안합니다. 실제 파일은 만들지 않습니다. | 개념을 익히거나, 업무를 하네스 관점으로 나눠보고 싶을 때 |
| 실행 하네스 경로 | "실제 파일로 만들어줘", ".claude agents와 skills 파일을 생성해줘"처럼 명시할 때 | 기존 `.claude` 구조를 먼저 확인한 뒤 `.claude/agents`와 `.claude/skills` 초안을 만들고, 생성된 Orchestrator Skill로 실제 작업을 수행합니다. | 반복해서 쓸 작업 흐름을 프로젝트 안에 남기고 싶을 때 |

처음에는 청사진 경로로 시작하는 것을 권장합니다. 구조가 마음에 들면 그 다음에 실행 하네스 경로로 넘어가면 됩니다.

간단히 말하면 아래처럼 고르면 됩니다.

```text
개념을 이해하고 싶다
→ 청사진 경로

실제 프로젝트에서 반복해서 쓰고 싶다
→ 실행 하네스 경로
```

### 1. Codex에서 사용하기

Codex에서 스킬로 자동 인식하게 하려면 `harness-lab` 폴더를 Codex 스킬 폴더에 복사합니다.

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -R skills/harness-lab "${CODEX_HOME:-$HOME/.codex}/skills/"
```

복사한 뒤에는 새 Codex 세션을 열어 스킬 목록이 다시 읽히도록 합니다.

Codex에서는 `$harness-lab`처럼 스킬 이름을 mention해서 사용할 수 있습니다.

```text
$harness-lab 여행 계획 하네스를 만들어줘.
Agent, Skill, Orchestrator, Test, Evolution을 일상 언어로 설명해줘.
```

설치하지 않고 실습만 해볼 때는 프롬프트에서 스킬 경로를 직접 말해도 됩니다.

```text
./skills/harness-lab 스킬을 사용해서 내 블로그 글쓰기 업무를 작은 하네스로 바꿔줘.
```

### 2. Claude Code에서 사용하기

Claude Code에서도 같은 `SKILL.md` 구조를 사용할 수 있습니다. Claude Code에서는 스킬 폴더 이름을 기준으로 `/harness-lab`처럼 직접 호출할 수 있습니다.

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

Claude Code를 실행한 뒤에는 직접 호출할 수 있습니다.

```text
/harness-lab 2박 3일 가족 여행 계획을 위한 작은 하네스를 만들어줘.
Agent, Skill, Orchestrator, Test, Evolution을 일상 언어로 설명해줘.
```

또는 스킬 이름을 직접 쓰지 않아도, 요청이 `SKILL.md`의 description과 잘 맞으면 Claude Code가 자동으로 해당 스킬을 사용할 수 있습니다.

```text
내 블로그 글쓰기 업무를 작은 에이전트 팀 하네스로 바꿔줘.
처음 보는 사람도 이해할 수 있게 역할과 작업 순서를 설명해줘.
```

사용 가능한 스킬을 확인하고 싶다면 Claude Code 안에서 이렇게 물어봅니다.

```text
사용 가능한 스킬 목록을 보여줘.
```

참고로 Claude Code는 스킬 폴더 변경을 감지하지만, `~/.claude/skills`나 `.claude/skills` 같은 상위 폴더를 새로 만든 직후에는 새 세션을 여는 편이 가장 안전합니다.

### 3. 첫 프롬프트 예시

처음에는 개발 프로젝트보다 일상 업무로 시작하는 편이 좋습니다. 그래야 Agent, Skill, Orchestrator가 훨씬 쉽게 느껴집니다.

아래 예시는 Claude Code 기준으로 `/harness-lab`을 사용합니다. Codex에서 사용할 때는 앞부분만 `$harness-lab`으로 바꾸면 됩니다.

```text
/harness-lab 1박 2일 가족 여행 계획을 위한 작은 하네스를 만들어줘.
Agent, Skill, Orchestrator, Test, Evolution을 일상 언어로 설명해줘.
```

한국어로는 이렇게 요청해도 좋습니다.

```text
/harness-lab 2박 3일 가족 여행 계획을 위한 작은 하네스를 만들어줘.
Agent, Skill, Orchestrator, Test, Evolution은 처음 보는 사람도 이해할 수 있게 일상 언어로 설명해줘.
```

### 4. 기대할 수 있는 결과

스킬을 사용하면 보통 아래와 같은 결과를 얻게 됩니다.

- 사람이 직접 한다면 어떤 절차로 일할지 정리
- 필요한 Agent 역할표
- 각 Agent가 따를 Skill 설계
- 전체 흐름을 묶는 Orchestrator 구조
- 정상 사례, 애매한 사례, 실패 위험 사례를 포함한 테스트 프롬프트
- 실행 후 다음 버전에서 고칠 개선 기록

### 5. 일상생활에서 써볼 수 있는 예시

처음에는 "AI로 큰 프로젝트를 자동화한다"라고 생각하기보다, 평소에 반복해서 하는 일을 작은 팀 작업으로 나눠본다고 생각하면 쉽습니다.

아래 예시는 Claude Code 기준입니다. Codex에서는 `/harness-lab` 대신 `$harness-lab`을 사용합니다.

#### 여행 계획 세우기

```text
/harness-lab 2박 3일 제주도 가족 여행 계획 하네스를 만들어줘.
숙소 조사, 일정 설계, 예산 검토, 최종 정리 역할로 나눠서 설명해줘.
```

이 예시는 Agent를 "여행 준비를 나눠 맡는 가족 구성원"처럼 이해하는 데 좋습니다.

#### 블로그 글쓰기

```text
/harness-lab 입문 독자를 위한 블로그 글쓰기 하네스를 만들어줘.
자료 조사, 목차 구성, 초안 작성, 문체 검토 역할을 나눠줘.
```

이 예시는 Skill을 "각 담당자가 따르는 글쓰기 체크리스트"로 이해하는 데 좋습니다.

#### 회의록 정리하기

```text
/harness-lab 회의록 정리 하네스를 만들어줘.
결정 사항, 할 일, 리스크, 후속 질문을 분리해서 정리하는 흐름으로 설계해줘.
```

이 예시는 Fan-out/Fan-in, 즉 여러 관점으로 나눠 보고 다시 합치는 방식을 익히기 좋습니다.

#### 개인 학습 계획 만들기

```text
/harness-lab 4주 동안 Git 기초를 배우는 학습 하네스를 만들어줘.
현재 수준 확인, 주차별 계획, 연습 문제, 회고 방식까지 포함해줘.
```

이 예시는 Evolution, 즉 한 번 만든 계획을 실제 학습 결과에 맞춰 고치는 감각을 익히기 좋습니다.

#### 집안일이나 반복 업무 정리하기

```text
/harness-lab 주말 집안일을 정리하는 하네스를 만들어줘.
할 일 분류, 우선순위 정하기, 가족별 역할 나누기, 완료 점검으로 구성해줘.
```

이 예시는 Orchestrator를 "누가 먼저 무엇을 하고, 다음 사람에게 무엇을 넘길지 정하는 흐름표"로 이해하는 데 좋습니다.

#### 작은 개발 프로젝트 준비하기

```text
/harness-lab 개인 웹사이트 문구 수정 작업을 위한 작은 개발 하네스를 만들어줘.
요구사항 정리, 파일 찾기, 수정, 테스트, 변경 요약 역할로 나눠줘.
```

이 예시는 하네스 개념을 실제 프로젝트 파일과 연결하는 연습에 좋습니다.

### 6. 실행 하네스 경로로 넘어가기

책의 실습에서는 처음부터 파일을 많이 만들기보다, 먼저 하네스 청사진을 만든 뒤 필요할 때 `.claude/agents`와 `.claude/skills` 파일로 옮기는 흐름을 권장합니다.

즉, 단순히 `/harness-lab 여행 계획 하네스를 만들어줘`라고 하면 보통 하네스 청사진을 만들고, 실제 파일 생성을 원할 때는 "실제 파일로 만들어줘" 또는 ".claude agents와 skills 파일을 생성해줘"라고 명시합니다.

Claude Code에서 파일 생성을 요청할 때는 이렇게 말합니다.

```text
/harness-lab 블로그 글쓰기 하네스를 실제 .claude agents와 skills 파일로 만들어줘.
먼저 기존 .claude 파일을 확인하고, 무엇을 바꿀지 설명하기 전에는 덮어쓰지 마.
```

Codex에서는 같은 요청을 이렇게 바꿔 말하면 됩니다.

```text
$harness-lab 블로그 글쓰기 하네스를 실제 .claude agents와 skills 파일로 만들어줘.
먼저 기존 .claude 파일을 확인하고, 무엇을 바꿀지 설명하기 전에는 덮어쓰지 마.
```

이렇게 요청하면 기존 파일을 먼저 확인하고, 역할과 작업 매뉴얼을 분리해서 만들도록 유도할 수 있습니다.

### 7. 생성된 Agents와 Skills 사용하기

실행 하네스 경로를 선택하면 보통 아래와 비슷한 구조가 생깁니다.

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

실행 하네스 경로는 아래 순서로 사용하면 충분합니다.

1. `/harness-lab`으로 하네스 청사진을 만든다.
2. 구조가 괜찮으면 `.claude/agents`와 `.claude/skills` 파일 생성을 요청한다.
3. 생성된 Agent와 Skill 파일을 읽고 역할이 맞는지 확인한다.
4. 새 세션을 열거나 `/agents`로 Agent 목록을 확인한다.
5. Orchestrator Skill을 먼저 실행해서 원하는 결과물을 만든다.
6. 필요할 때만 특정 Agent를 직접 호출한다.
7. 결과가 부족하면 테스트 프롬프트와 개선 기록으로 하네스를 고친다.

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

- 누구나 처음 실습할 수 있도록 일상 언어와 작은 예시를 먼저 사용합니다.
- 하네스 용어를 일상 언어로 먼저 번역합니다.
- Phase 번호는 Phase 0부터 Phase 7까지로 고정합니다.
- 외부 프로젝트는 참고 사례로만 다루고, 책의 실습은 이 프로젝트 안에서 독립적으로 진행합니다.
- 생성보다 이해, 테스트, 개선을 더 중요하게 봅니다.
# harness-lab
