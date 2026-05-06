# Harness Engineering Lab

> **감사의 말**
> 이 프로젝트는 [`revfactory/harness`](https://github.com/revfactory/harness)를 만드신 카카오의 황민호 님의 스킬을 기반으로, 하네스 엔지니어링을 더 쉽게 실습할 수 있도록 교육용 흐름에 맞게 재구성한 것입니다. 좋은 공개 자료와 아이디어를 공유해 주신 황민호 님께 다시 한번 깊이 감사드립니다.

이 프로젝트는 하네스 엔지니어링을 Claude Code와 Codex CLI에서 각각 실습할 수 있도록 실행 환경별로 분리한 교육용 스킬 프로젝트입니다.

목표는 사용자가 자신의 일상 업무나 작은 프로젝트를 Agent, Skill, Orchestrator, Test, Evolution 구조로 바꾸는 감각을 익히도록 돕는 것입니다.

## 폴더 구조

```text
harness-engineering-lab/
  claude/
    README.md
    skills/
      harness-lab/
        SKILL.md
        references/
  codex/
    README.md
    .agents/
      skills/
        harness-lab/
          SKILL.md
          agents/
            openai.yaml
          references/
```

## 어떤 폴더를 쓰면 되나요?

| 실행 환경 | 사용할 폴더 | 호출 방식 | 자세한 안내 |
| --- | --- | --- | --- |
| Claude Code | `claude/skills/harness-lab` | `/harness-lab` | [claude/README.md](claude/README.md) |
| Codex CLI | `codex/.agents/skills/harness-lab` | `$harness-lab` | [codex/README.md](codex/README.md) |

Claude Code와 Codex CLI는 스킬을 설치하는 위치와 Agent 파일을 두는 위치가 다릅니다. 그래서 같은 교육 목표를 가진 스킬이라도 폴더를 분리해 두었습니다.

## 공통 사용 흐름

`harness-lab`은 바로 파일을 만들기보다, 먼저 청사진을 보여주고 사용자가 승인하면 실행 가능한 하네스 구성을 만듭니다.

```text
사용자: harness-lab으로 여행 계획 하네스를 만들어줘.

스킬: 청사진부터 만들겠습니다. 이런 역할과 흐름으로 만들 수 있습니다.
      이 구조로 실행 가능한 하네스를 구성해드릴까요?

사용자: 좋아, 이 구조로 실제 사용할 수 있게 만들어줘.

스킬: 현재 실행 환경의 기존 설정을 확인한 뒤 실행 하네스 구성을 만듭니다.
```

생성된 실행 하네스에는 자연어 요청을 Orchestrator Skill로 연결하는 안내가 함께 들어갑니다. 그래서 이후에는 스킬명을 외우지 않아도 "가족 여행 일정 다시 정리해줘"처럼 말하면 프로젝트 안내 파일이 전체 진행표 역할의 Orchestrator를 먼저 사용하도록 돕습니다.

## 첫 실습 추천

처음에는 개발 프로젝트보다 일상 업무로 시작하는 편이 좋습니다.

Claude Code에서는:

```text
/harness-lab 1박 2일 가족 여행 계획을 위한 작은 하네스를 만들어줘.
```

Codex CLI에서는:

```text
$harness-lab 1박 2일 가족 여행 계획을 위한 작은 하네스를 만들어줘.
```

## 기대할 수 있는 결과

- 사람이 직접 한다면 어떤 절차로 일할지 정리
- 필요한 Agent 역할표
- 각 Agent가 따를 Skill 설계
- 전체 흐름을 묶는 Orchestrator 구조
- 정상 사례, 애매한 사례, 실패 위험 사례를 포함한 테스트 프롬프트
- 실행 후 다음 버전에서 고칠 개선 기록

## 설계 원칙

- Claude Code용 배포본은 `.claude/agents`, `.claude/skills`, `CLAUDE.md` 구조를 기준으로 합니다.
- Codex용 배포본은 `.agents/skills`, `.codex/agents`, `AGENTS.md` 구조를 기준으로 합니다.
- Orchestrator 역할을 하는 Skill은 양쪽 모두 `{harness-name}-orchestrator` 형식으로 만들고, 일반 작업 Skill과 이름을 분리합니다.
- 생성되는 `CLAUDE.md`와 `AGENTS.md`에는 스킬명을 모르는 사용자의 자연어 요청도 Orchestrator Skill로 이어지도록 라우팅 규칙을 남깁니다.
- 누구나 처음 실습할 수 있도록 일상 언어와 작은 예시를 먼저 사용합니다.
- 하네스 용어를 일상 언어로 먼저 풀어 설명합니다.
- Phase 번호는 Phase 0부터 Phase 7까지로 고정합니다.
- 생성보다 이해, 테스트, 개선을 더 중요하게 봅니다.
