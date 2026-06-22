# Claude Code용 Harness Lab

이 폴더는 `harness-lab`을 Claude Code 방식으로 사용할 수 있도록 구성한 배포본입니다.

```text
claude/
  skills/
    harness-lab/
      SKILL.md
      references/
```

## 설치하기

개인용 스킬로 설치하면 모든 Claude Code 프로젝트에서 사용할 수 있습니다.

```bash
mkdir -p ~/.claude/skills
cp -R claude/skills/harness-lab ~/.claude/skills/
```

특정 프로젝트에서만 쓰고 싶다면, 해당 프로젝트 루트에서 프로젝트 스킬로 복사합니다.

```bash
mkdir -p .claude/skills
cp -R /path/to/harness-engineering-lab/claude/skills/harness-lab .claude/skills/
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

## 두 단계 흐름

`harness-lab`은 먼저 청사진을 보여주고, 사용자가 승인하면 현재 프로젝트 안에 실행 가능한 하네스 파일을 만듭니다.

| 단계 | 무엇을 하나 | 사용자가 할 일 |
| --- | --- | --- |
| 1. 청사진 제안 | Agent/Skill/Orchestrator 구조, 역할표, 테스트 프롬프트를 제안합니다. | 역할과 흐름이 마음에 드는지 확인합니다. |
| 2. 실행 하네스 생성 | 사용자가 승인하면 현재 프로젝트의 기존 설정을 확인한 뒤 실행 가능한 하네스 구성을 만듭니다. | "좋아, 이 구조로 만들어줘"처럼 승인합니다. |

청사진은 이제 하네스 7요소도 함께 봅니다. 목표, 컨텍스트, 도구, 중간 산출물, 검증, 사람 승인, 개선 기록을 먼저 정리한 뒤 Agent와 Skill로 바꿉니다. 또한 어떤 산출물을 어떤 파일에 남기고 다음 단계가 무엇을 다시 읽을지 정하는 산출물 계약을 포함합니다. 그래서 단순히 파일을 많이 만드는 것이 아니라, 사용자의 반복 업무가 덜 흔들리도록 작업 환경을 잡는 데 초점을 둡니다.

실행 하네스는 Agent Team 흐름을 기본 후보로 설계합니다. Orchestrator가 팀을 구성하고, 작업을 등록하고, Agent들이 메시지로 조율한 뒤, 각 결과를 `artifacts/`에 남기는 방식입니다. 다만 작업이 작거나 독립 조사만 필요하면 단일 흐름이나 Subagent 방식으로 줄일 수 있습니다.

Agent Team으로 구성되는 하네스는 Agent 파일만 여러 개 만드는 데서 끝나지 않습니다. Orchestrator Skill 안에 `TeamCreate`, `TaskCreate`, `TaskUpdate`, `TaskGet`, `SendMessage`, `TeamDelete`, 파일 산출물, 팀 정리 조건이 함께 들어갑니다.

기존 하네스를 개선할 때는 `.claude/agents`, `.claude/skills`, `CLAUDE.md`가 서로 맞는지 먼저 점검합니다. 오래된 Agent, 쓰이지 않는 Skill, 빠진 테스트, 자연어 라우팅 누락도 함께 확인합니다.

## 생성되는 파일

사용자가 승인하면 현재 프로젝트 안에 보통 아래와 비슷한 구조가 생깁니다.

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
CLAUDE.md
artifacts/
  README.md
  00-input.md
  01-brief.md
  02-draft.md
  03-review.md
  final.md
  improvement-log.md
```

| 위치 | 쉬운 비유 | 역할 |
| --- | --- | --- |
| `.claude/agents/{agent-name}.md` | 팀원 역할 카드 | 특정 일을 맡는 Agent의 책임, 입력, 출력, 사용 가능한 `tools`, 하지 말아야 할 일을 적습니다. |
| `.claude/skills/{task-skill}/SKILL.md` | 작업 매뉴얼 | 특정 역할이 어떤 순서로 일하고, 어떤 형식으로 결과를 남기며, 무엇을 확인해야 하는지 적습니다. |
| `.claude/skills/{harness-name}-orchestrator/SKILL.md` | 전체 진행표 | Agent Team을 어떻게 구성하고, 어떤 작업을 등록하고, 중간 산출물을 어떻게 이어받을지 정합니다. Orchestrator Skill 폴더명은 항상 `-orchestrator`로 끝납니다. |
| `CLAUDE.md` | 프로젝트 안내판 | 이 프로젝트에서 만든 하네스가 어디에 있고, 자연어 요청을 어떤 Orchestrator Skill로 먼저 이어야 하는지 참고할 포인터를 남깁니다. |
| `artifacts/README.md` | 산출물 지도 | 어떤 파일이 어떤 역할을 하고 다음 실행이 무엇을 읽어야 하는지, 현재 파일이 최신인지 남깁니다. |
| `artifacts/` | 작업 기록지 | 실행 중 입력 요약, 조사 노트, 초안, 검토 결과, 최종 결과처럼 다음 단계가 이어받을 자료를 남깁니다. |

Agent 파일은 역할별로 `tools`를 다르게 둡니다. 예를 들어 조사 담당은 `Read, Grep, Glob`처럼 읽기 중심으로 두고, 구현 담당에게만 필요한 쓰기와 실행 도구를 줍니다. `model`은 기본 Agent frontmatter에 고정하지 않습니다. 직접 Subagent는 기본 모델 정책을 따르게 두고, Agent Team은 팀 생성 지시와 teammate 모델 설정을 실행 기록에 남깁니다.

부분 재실행을 하면 `artifacts/README.md`에서 뒤 단계 산출물을 `stale`로 표시합니다. 예를 들어 조사 요약이 바뀌면 그 요약을 바탕으로 만든 초안, 검토, 최종본은 다시 확인해야 합니다.

하네스가 실제로 나아졌는지 보려면 같은 프롬프트를 하네스를 쓴 결과와 쓰지 않은 결과로 나눠 비교합니다. 작은 하네스는 가볍게 비교하고, 큰 프로젝트는 전체 재실행보다 바뀐 Phase나 핵심 산출물만 `targeted`로 비교합니다. 이 벤치마크 기록은 `artifacts/evals/iteration-N/{eval-name}/` 아래에 남깁니다.

## 실행 예시

실행 하네스가 생성된 뒤에는 스킬명을 꼭 외우지 않아도 됩니다. `CLAUDE.md`에 자연어 요청을 Orchestrator Skill로 연결하는 규칙을 남기기 때문에, 평소처럼 요청하면 Orchestrator가 전체 입구 역할을 합니다.

```text
부모님과 함께 가는 2박 3일 제주 여행 계획을 다시 정리해줘.
예산은 1인 50만원 이하이고, 너무 빡빡하지 않은 일정이면 좋겠어.
```

직접 호출하고 싶을 때는 아래처럼 Orchestrator Skill 이름을 명시할 수도 있습니다.

```text
/trip-planning-orchestrator 부모님과 함께 가는 2박 3일 제주 여행 계획을 만들어줘.
예산은 1인 50만원 이하이고, 너무 빡빡하지 않은 일정이면 좋겠어.
```

필요할 때 특정 Agent를 직접 호출할 수도 있습니다.

```text
trip-researcher subagent를 사용해서 제주 동쪽과 서쪽 숙소 후보를 비교해줘.
```

Claude Code에서 `@` 멘션을 사용할 수 있다면 아래처럼 더 명확하게 지정할 수 있습니다.

```text
@agent-trip-researcher 제주 동쪽 숙소 후보를 가족 여행 관점에서 비교해줘.
```

새로 만든 Agent가 보이지 않으면 Claude Code 안에서 `/agents`를 실행해 목록을 확인하거나, 세션을 새로 열어 파일을 다시 읽게 합니다.

```text
/agents
```

## 처음 써볼 프롬프트

```text
/harness-lab 1박 2일 가족 여행 계획을 위한 작은 하네스를 만들어줘.
Agent, Skill, Orchestrator, Test, Evolution을 일상 언어로 설명해줘.
```

## 강화된 설계 원칙

최근 버전에서 아래가 보강되었습니다. 개념은 Claude Code·Codex 공통이며, 파일 위치만 환경에 맞게 달라집니다(이 배포본은 `.claude/agents`·`.claude/skills`·`CLAUDE.md` 기준).

- **적합성 게이트**: 하네스를 만들기 전에 "이 업무가 하네스화할 가치가 있는가"를 반복성·구조 안정성·검증 가능성·외부 신호 등 6차원으로 먼저 판정합니다. 일회성·고변동·즉흥 업무는 오히려 손해라, 그럴 땐 얇게 가거나 만들지 않습니다. 효율은 에이전트를 많이 둬서가 아니라 구조화·검증·사람 승인에서 나옵니다.
- **검증 강화**: 결과를 만든 Agent가 자기 결과를 합격 처리하지 않도록 생성과 평가를 분리하고, 평가는 테스트·체크리스트·사람 승인 같은 외부 신호에 묶습니다. "통과할 때까지 다듬는" 반복 검증 루프에는 종료 계약(횟수 상한·수렴 정체·미통과 시 사람 승인 에스컬레이션·best 롤백)을 함께 둡니다.
- **결함 주입과 회귀 세트**: 결정적 점검 단계가 있으면 일부러 망가뜨린 입력을 흘려 검증이 실제로 잡는지(거수기 아님) 확인하고, 그 입력을 회귀 세트로 보관합니다.
- **덜어내기 진단**: 하네스는 두꺼워지기만 하지 않습니다. 모델이나 업무가 좋아져 불필요해진 Agent·Skill·검증은 하나씩 빼며 품질 영향을 확인해 줄입니다.
- **ADR(설계 결정 기록)**: 큰 구조 결정(Agent Team vs 단일 흐름, 두께, 패턴 선택, 역할 분리)은 `CLAUDE.md` 변경 이력(무엇이 바뀌었나)과 별개로 ADR(결정 / 버린 대안 / 가정·트레이드오프 / 재검토 조건)로 남겨, 나중에 덜어내기 판단의 근거로 씁니다.
- **긴 작업의 컨텍스트 관리**: 단계가 길면 요약으로 이어붙이기보다 핸드오프 산출물을 남기고 깨끗한 컨텍스트로 다시 시작합니다.

## 주의할 점

- 새로 만든 스킬이나 Agent가 보이지 않으면 Claude Code 세션을 새로 여는 편이 안전합니다.
- Subagent는 메인 대화의 Skill을 자동으로 모두 물려받지 않습니다.
- Agent Team에서 반드시 따라야 하는 작업법은 Agent 본문과 Orchestrator 흐름에 함께 적습니다.
- Agent 파일에는 역할별 `tools`를 명시해 권한 범위를 조절합니다. `model`은 기본 생성물에 넣지 않고, Agent Team을 쓸 때는 팀 생성 지시와 teammate 모델 설정을 실행 기록에 남깁니다.

```md
---
name: trip-planner
description: 여행 일정을 설계하는 Agent입니다.
tools: Read, Grep, Glob, Write, Edit
---
```
