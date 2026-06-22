# Harness Engineering Lab

> **감사의 말**
> 이 프로젝트는 [`revfactory/harness`](https://github.com/revfactory/harness)를 만드신 카카오의 황민호 님의 스킬을 기반으로, 하네스 엔지니어링을 더 쉽게 실습할 수 있도록 교육용 흐름에 맞게 재구성한 것입니다. 좋은 공개 자료와 아이디어를 공유해 주신 황민호 님께 다시 한번 깊이 감사드립니다.

이 프로젝트는 하네스 엔지니어링을 Claude Code와 Codex CLI에서 각각 실습할 수 있도록 실행 환경별로 분리한 교육용 스킬 프로젝트입니다.

목표는 사용자가 자신의 일상 업무나 작은 프로젝트를 Agent, Skill, Orchestrator, Test, Evolution 구조로 바꾸는 감각을 익히도록 돕는 것입니다.

## 폴더 구조

```text
harness-engineering-lab/
  agents/
    researcher.md
    editor.md
    project-manager.md
    analyst.md
    recruiter.md
    ops-lead.md
    cfo.md
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

## 예시 Agent 파일

`agents/` 폴더에는 Claude Code의 `.claude/agents/`에 복사해 실험해 볼 수 있는 교육용 Subagent 예시가 들어 있습니다.

| 파일 | 역할 |
| --- | --- |
| `researcher.md` | 자료 조사, 근거 확인, 출처 정리 |
| `editor.md` | 초안 편집, 문장 흐름과 주장 정리 |
| `project-manager.md` | 목표를 일정, 단계, 위험, 완료 기준으로 나누기 |
| `analyst.md` | 숫자와 표에서 핵심 의미 찾기 |
| `recruiter.md` | 채용 기준, 인터뷰 질문, 커뮤니케이션 문안 정리 |
| `ops-lead.md` | 반복 업무 점검, 자동화 후보, SOP 정리 |
| `cfo.md` | 예산, 비용, 런웨이, 지출 우선순위 점검 |

처음에는 7개를 모두 설치하기보다 자신의 실습 주제와 가까운 2~3개만 골라 사용하는 것을 권장합니다.

## 공통 사용 흐름

`harness-lab`은 바로 파일을 만들기보다, 먼저 청사진을 보여주고 사용자가 승인하면 실행 가능한 하네스 구성을 만듭니다.

```text
사용자: harness-lab으로 여행 계획 하네스를 만들어줘.

스킬: 청사진부터 만들겠습니다. 이런 역할과 흐름으로 만들 수 있습니다.
      이 구조로 실행 가능한 하네스를 구성해드릴까요?

사용자: 좋아, 이 구조로 실제 사용할 수 있게 만들어줘.

스킬: 현재 실행 환경의 기존 설정을 확인한 뒤 실행 하네스 구성을 만듭니다.
```

생성된 실행 하네스에는 자연어 요청을 Orchestrator Skill로 연결하는 안내가 함께 들어갑니다. 또한 `artifacts/`에 입력 요약, 조사 노트, 초안, 검토표, 최종 결과, 개선 기록을 남기도록 산출물 계약을 포함합니다. 그래서 이후에는 스킬명을 외우지 않아도 "가족 여행 일정 다시 정리해줘"처럼 말하면 프로젝트 안내 파일이 전체 진행표 역할의 Orchestrator를 먼저 사용하도록 돕고, 이전 산출물을 읽어 이어갈 수 있습니다.

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

- 하네스 7요소를 기준으로 목표, 자료, 검증, 승인, 기록 정리
- `artifacts/`에 남길 산출물 계약과 파일 흐름
- 사람이 직접 한다면 어떤 절차로 일할지 정리
- Agent Team이 필요한 경우 `TeamCreate`, `TaskCreate`, `SendMessage`, `TeamDelete`를 포함한 실행 계약
- 필요한 Agent 역할표
- 각 Agent가 따를 Skill 설계
- 전체 흐름을 묶는 Orchestrator 구조
- 정상 사례, 애매한 사례, 실패 위험 사례를 포함한 테스트 프롬프트
- 실행 후 다음 버전에서 고칠 개선 기록
- 기존 하네스의 중복, 누락, 오래된 규칙, 라우팅 문제 점검
- 하네스화 가치 판정(적합성 게이트)과 적정 두께 선택
- 생성-평가 분리·외부 신호 검증·결함 주입 회귀 세트로 거수기 검증 방지
- 큰 구조 결정의 ADR 기록과, 불필요해진 조각을 줄이는 덜어내기 진단

## 설계 원칙

- Claude Code용 배포본은 `.claude/agents`, `.claude/skills`, `CLAUDE.md` 구조를 기준으로 합니다.
- Codex용 배포본은 `.agents/skills`, `.codex/agents`, `AGENTS.md` 구조를 기준으로 합니다.
- Orchestrator 역할을 하는 Skill은 양쪽 모두 `{harness-name}-orchestrator` 형식으로 만들고, 일반 작업 Skill과 이름을 분리합니다.
- 생성되는 `CLAUDE.md`와 `AGENTS.md`에는 스킬명을 모르는 사용자의 자연어 요청도 Orchestrator Skill로 이어지도록 라우팅 규칙을 남깁니다.
- Agent Team은 Agent 파일만 여러 개 두는 구조가 아니라, 작업 등록, 팀 메시지, 파일 산출물, 팀 정리 조건까지 포함하는 실행 구조로 다룹니다.
- 누구나 처음 실습할 수 있도록 일상 언어와 작은 예시를 먼저 사용합니다.
- 하네스 용어를 일상 언어로 먼저 풀어 설명합니다.
- Phase 번호는 Phase 0부터 Phase 7까지로 고정합니다.
- 생성보다 이해, 테스트, 개선을 더 중요하게 봅니다.
- 만들기 전에 적합성 게이트로 하네스화 가치를 먼저 판정합니다. 효율은 에이전트 수가 아니라 구조화·검증·사람 승인에서 나옵니다.
- 생성과 평가를 분리하고 평가를 외부 신호(테스트·체크리스트·사람 승인)에 묶습니다. 결정적 점검이 있으면 결함 주입으로 검증이 살아 있는지 확인합니다. 통과까지 다듬는 반복 검증 루프에는 종료 계약(횟수 상한·수렴·미통과 시 사람 승인)을 둡니다.
- 하네스는 두꺼워지기만 하지 않습니다. 불필요해진 조각은 덜어내고, 큰 구조 결정은 변경 이력과 별개로 ADR(결정·버린 대안·가정·재검토 조건)로 남깁니다. 변경 이력·ADR은 Claude Code는 `CLAUDE.md`, Codex는 `AGENTS.md`에 둡니다.
