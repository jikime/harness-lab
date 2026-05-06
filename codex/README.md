# Codex CLI용 Harness Lab

이 폴더는 `harness-lab`을 Codex CLI 방식으로 사용할 수 있도록 구성한 배포본입니다.

```text
codex/
  .agents/
    skills/
      harness-lab/
        SKILL.md
        agents/
          openai.yaml
        references/
```

## 설치하기

개인용 스킬로 설치하면 모든 Codex 프로젝트에서 사용할 수 있습니다.

```bash
mkdir -p ~/.agents/skills
cp -R codex/.agents/skills/harness-lab ~/.agents/skills/
```

특정 프로젝트에서만 쓰고 싶다면, 해당 프로젝트 루트에서 프로젝트 스킬로 복사합니다.

```bash
mkdir -p .agents/skills
cp -R /path/to/harness-engineering-lab/codex/.agents/skills/harness-lab .agents/skills/
```

Codex를 새로 열고 `$harness-lab`으로 호출합니다.

```text
$harness-lab 여행 계획 하네스를 만들어줘.
```

## 두 단계 흐름

`harness-lab`은 먼저 청사진을 보여주고, 사용자가 승인하면 실행 가능한 Codex 하네스 파일을 만듭니다.

| 단계 | 무엇을 하나 | 사용자가 할 일 |
| --- | --- | --- |
| 1. 청사진 제안 | Agent/Skill/Orchestrator 구조, 역할표, 테스트 프롬프트를 제안합니다. | 역할과 흐름이 마음에 드는지 확인합니다. |
| 2. 실행 하네스 생성 | 사용자가 승인하면 기존 Codex 설정을 확인한 뒤 실행 가능한 하네스 구성을 만듭니다. | "좋아, 이 구조로 만들어줘"처럼 승인합니다. |

## 생성되는 파일

사용자가 승인하면 Codex 프로젝트 안에 보통 아래와 비슷한 구조가 생깁니다.

```text
.agents/
  skills/
    trip-planning-orchestrator/
      SKILL.md
    trip-research-guide/
      SKILL.md
.codex/
  agents/
    trip_researcher.toml
    trip_planner.toml
    budget_reviewer.toml
AGENTS.md
artifacts/
```

| 위치 | 쉬운 비유 | 역할 |
| --- | --- | --- |
| `.agents/skills/{task-skill}/SKILL.md` | 작업 매뉴얼 | 특정 역할이 어떤 순서로 일하고, 어떤 형식으로 결과를 남기며, 무엇을 확인해야 하는지 적습니다. |
| `.agents/skills/{harness-name}-orchestrator/SKILL.md` | 전체 진행표 | 여러 Agent와 Skill을 어떤 순서로 실행하고, 중간 산출물을 어떻게 이어받을지 정합니다. Orchestrator Skill 폴더명은 항상 `-orchestrator`로 끝납니다. |
| `.codex/agents/{agent-name}.toml` | 팀원 역할 카드 | 특정 일을 맡는 Agent의 책임, 입력, 출력, 하지 말아야 할 일을 적습니다. |
| `AGENTS.md` | 프로젝트 안내판 | 이 프로젝트에서 만든 하네스가 어디에 있고, 자연어 요청을 어떤 Orchestrator Skill로 먼저 이어야 하는지 Codex가 참고할 포인터를 남깁니다. |
| `artifacts/` | 작업 기록지 | 실행 중 조사 노트, 초안, 검토 결과, 최종 결과처럼 다음 단계가 이어받을 자료를 남깁니다. |

## 실행 예시

실행 하네스가 생성된 뒤에는 스킬명을 꼭 외우지 않아도 됩니다. `AGENTS.md`에 자연어 요청을 Orchestrator Skill로 연결하는 규칙을 남기기 때문에, 평소처럼 요청하면 Orchestrator가 전체 입구 역할을 합니다.

```text
부모님과 함께 가는 2박 3일 제주 여행 계획을 다시 정리해줘.
예산은 1인 50만원 이하이고, 너무 빡빡하지 않은 일정이면 좋겠어.
```

직접 호출하고 싶을 때는 아래처럼 Orchestrator Skill 이름을 명시할 수도 있습니다.

```text
$trip-planning-orchestrator 부모님과 함께 가는 2박 3일 제주 여행 계획을 만들어줘.
예산은 1인 50만원 이하이고, 너무 빡빡하지 않은 일정이면 좋겠어.
```

필요할 때 특정 Agent를 직접 호출할 수도 있습니다.

```text
trip_researcher를 사용해서 제주 동쪽과 서쪽 숙소 후보를 비교해줘.
```

## 처음 써볼 프롬프트

```text
$harness-lab 1박 2일 가족 여행 계획을 위한 작은 하네스를 만들어줘.
Agent, Skill, Orchestrator, Test, Evolution을 일상 언어로 설명해줘.
```

## 주의할 점

- 새로 설치한 스킬이 보이지 않으면 Codex 세션을 새로 여는 편이 안전합니다.
- `harness-lab`으로 만든 실행 Skill은 `.agents/skills`에 둡니다.
- `harness-lab`으로 만든 Agent는 기본적으로 `.codex/agents`에 둡니다.
- 모든 프로젝트에서 공통으로 쓰는 Agent가 필요할 때만 `~/.codex/agents`를 사용합니다.
