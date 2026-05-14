# Codex Harness Lab 개선 적용 보고서

작성일: 2026-05-13

## 목적

이 문서는 Claude용 `harness-lab`에 적용한 개선 사항을 Codex용 `harness-lab`에 맞게 반영한 기록이다.

이번 작업의 핵심은 같은 하네스 엔지니어링 개념을 유지하되, Claude Code의 `.claude` 구조가 아니라 Codex의 `AGENTS.md`, `.agents/skills`, `.codex/agents` 구조에 맞게 바꾸는 것이었다.

## 적용 기준

| 구분 | Claude용 기준 | Codex용 적용 |
| --- | --- | --- |
| 프로젝트 안내 | `CLAUDE.md` | `AGENTS.md`, 필요 시 `AGENTS.override.md` |
| 작업 Skill | `.claude/skills/{name}/SKILL.md` | `.agents/skills/{name}/SKILL.md` |
| Agent 정의 | `.claude/agents/{name}.md` | `.codex/agents/{name}.toml` |
| Orchestrator | `.claude/skills/{name}-orchestrator/SKILL.md` | `.agents/skills/{name}-orchestrator/SKILL.md` |
| 직접 호출 예시 | `/skill-name` | `$skill-name` |
| 중간 산출물 | `artifacts/` | `artifacts/` |

## 적용한 핵심 개선

### 1. 하네스 7요소를 Codex 스킬의 기본 설계 기준으로 추가

Codex용 `SKILL.md`에 목표, 컨텍스트, 도구, 중간 산출물, 검증, 권한과 승인, 기록과 개선을 기본 설계 기준으로 추가했다.

이제 Codex용 스킬도 바로 Agent와 Skill 파일을 만들기보다, 먼저 사용자의 반복 업무가 왜 흔들리는지와 어떤 기준이 필요한지 정리한다.

### 2. 청사진 흐름 강화

Codex용 청사진에 아래 항목을 포함하도록 개선했다.

- 하네스 7요소
- 산출물 계약
- 현재 성숙도
- 단일 흐름으로 충분하지 않은 이유
- Agent 분리 이유
- 사람 승인 지점
- 부정 테스트

이 변경은 Codex에서도 "파일을 많이 만드는 일"보다 "왜 이 하네스 구조가 필요한지"를 먼저 설명하기 위한 것이다.

산출물 계약은 실행 후 다음 작업이 이어받을 수 있도록 `artifacts/README.md`, `artifacts/00-input.md`, `artifacts/01-brief.md`, `artifacts/02-draft.md`, `artifacts/03-review.md`, `artifacts/final.md`, `artifacts/improvement-log.md` 같은 파일을 명시한다. 대화에만 남은 중간 결과는 다음 실행이 읽을 수 없으므로 산출물로 보지 않는다는 원칙도 추가했다.

추가로 청사진 승인 게이트를 강화했다. 첫 요청에서 "바로 파일로 만들어줘", "분석 없이 생성해"라고 해도 파일을 만들지 않고 청사진을 먼저 보여준다. 사용자가 직전 청사진에 대해 명시적으로 구성 요청을 한 뒤에만 실행 하네스 파일을 만든다.

### 3. Codex Agent 설계 기준 추가

Codex에서는 Agent가 `.codex/agents/{agent-name}.toml` 파일로 표현된다. 그래서 Claude용 Agent Markdown 템플릿을 그대로 쓰지 않고, TOML 구조에 맞는 설계 기준을 새로 정리했다.

Agent를 만들기 전에는 아래 기준을 확인하도록 했다.

- 입력과 출력이 독립적인가?
- 다른 전문성이 필요한가?
- 반복해서 재사용할 책임인가?
- 빠지면 품질이나 안전에 큰 문제가 생기는가?
- 같은 정보를 계속 이어서 봐야 하는 일은 아닌가?

### 4. Codex Skill description 기준 강화

Codex용 Skill도 `description`이 트리거 판단의 핵심이므로, 소개문처럼 쓰지 않고 아래 세 가지를 넣도록 했다.

- 이 Skill이 무엇을 하는지
- 사용자가 어떤 말을 할 때 써야 하는지
- 어떤 요청에는 쓰면 안 되는지

### 5. 기존 Codex 하네스 점검과 drift 확인 추가

기존 하네스를 점검할 때 아래를 확인하도록 했다.

- `AGENTS.md` 포인터와 Orchestrator 이름 일치 여부
- `AGENTS.override.md`의 로컬 임시 지시 충돌 여부
- `.agents/skills`와 Orchestrator의 Skill 참조 일치 여부
- `.codex/agents`와 Orchestrator의 Agent 참조 일치 여부
- Skill description의 트리거와 제외 조건
- 중간 산출물 경로
- 테스트 프롬프트와 실패 처리
- 사람 승인 조건
- 변경 이력 존재 여부

## 추가한 파일

### `codex/.agents/skills/harness-lab/references/harness-design-cards.md`

Codex용 하네스 설계 카드 문서다.

주요 내용:

- 하네스 한 문장 정의
- 하네스 7요소
- 성숙도 5단계
- 한 장 설계 카드
- 실습 키트 7장
- 하네스 두께 판단
- `$harness-lab` 기반 청사진 입력 프롬프트

### `codex/.agents/skills/harness-lab/references/agent-skill-design.md`

Codex용 Agent와 Skill 설계 기준을 정리했다.

주요 내용:

- Agent, Skill, Orchestrator의 차이
- Agent 분리 전 질문
- 문맥 경계 기준
- 커스텀 Agent를 만들기 좋은 경우와 피해야 할 경우
- `.codex/agents/{name}.toml` 템플릿
- Skill의 5가지 구성요소
- description 작성법
- Skill 실패 진단

### `codex/.agents/skills/harness-lab/references/failure-maintenance.md`

Codex용 기존 하네스 점검과 실패 복구 문서다.

주요 내용:

- 하네스 도입 실패 10가지
- 실패했을 때 다시 세우는 순서
- 기존 하네스 감사 절차
- Codex 기준 drift 점검표
- `AGENTS.md` 변경 이력 형식
- 개선 기록 형식
- 유지보수 판단 기준

## 수정한 파일

### `codex/.agents/skills/harness-lab/SKILL.md`

적용 내용:

- description에 Codex용 하네스 생성, 성숙도 진단, 기존 하네스 점검 트리거 추가
- 하네스 7요소 추가
- 청사진 승인 게이트 추가
- Agent를 과하게 늘리지 않는 원칙 추가
- Skill을 업무 매뉴얼로 다루는 원칙 추가
- 기존 하네스 점검과 drift 확인 흐름 추가
- `AGENTS.md`, `.agents/skills`, `.codex/agents` 기준의 실행 하네스 구성 원칙 강화
- 새 reference 문서 3개 연결
- 위험 작업의 사람 승인 기준 추가

### `codex/.agents/skills/harness-lab/references/phase-guide.md`

적용 내용:

- Phase 0에 성숙도 진단 추가
- Phase 0 뒤에 청사진 승인 게이트 추가
- Phase 2에 하네스 7요소와 산출물 계약 추가
- Phase 3에 단일 흐름 우선 판단 추가
- Phase 4에 Agent 분리 기준 추가
- Phase 5에 Skill description과 부정 케이스 설계 추가
- Phase 6에 부분 재실행과 사람 승인 조건 추가
- Phase 7에 부정 테스트, 반복 테스트, 변경 이력 추가

### `codex/.agents/skills/harness-lab/references/codex-templates.md`

적용 내용:

- 청사진에 하네스 7요소와 산출물 계약 추가
- 청사진 템플릿 뒤에 "파일을 만들지 않고 멈춘다"는 승인 게이트 안내 추가
- Agent 역할표에 분리 이유 추가
- `.codex/agents/{name}.toml` 템플릿에 도구와 Skill, 사람 승인 금지 행동 추가
- Skill 템플릿을 Overview, Workflow, Examples 구조로 개선
- Orchestrator 템플릿에 실행 모드 확인, 실패 처리, 테스트 시나리오 추가
- `AGENTS.md` 포인터에 하네스 변경 이력 추가

### `codex/.agents/skills/harness-lab/references/testing-improvement.md`

적용 내용:

- 실무용 5종 테스트 추가
- 트리거 테스트 추가
- 체크리스트에 사람 승인, description 제외 조건, Agent/Skill 책임 분리 추가
- 흔한 실패와 수정 방향에 Skill 트리거 문제와 위험 행동 문제 추가
- 변경 이력 남기기 섹션 추가

### `codex/.agents/skills/harness-lab/references/pattern-catalog.md`

팀 패턴을 고르기 전에 단일 흐름과 문맥 경계를 먼저 확인하도록 보강했다.

### `codex/README.md`

Codex용 안내 문서에 하네스 7요소 기반 청사진과 기존 하네스 점검 설명을 추가했다.

## 의도적으로 유지한 Codex 차이

Claude용 개선 내용을 그대로 복사하지 않고 아래 차이는 유지했다.

- `.claude/agents` 대신 `.codex/agents/{name}.toml` 사용
- `CLAUDE.md` 대신 `AGENTS.md`와 필요 시 `AGENTS.override.md` 사용
- 직접 호출 예시는 `/skill-name`이 아니라 `$skill-name` 사용
- `.codex/config.toml`은 필요한 경우에만 제안
- 실행 하네스 기본 대상은 `AGENTS.md`, `.agents/skills`, `.codex/agents`, `artifacts/`로 제한

## 검증 예정 항목

적용 후 확인해야 할 항목은 다음과 같다.

- 새 reference 문서가 Codex용 `SKILL.md`에서 참조되는가
- Claude 전용 `.claude` 경로가 Codex 문서에 섞이지 않았는가
- `$skill-name` 호출 예시가 유지되는가
- `git diff --check`가 통과하는가
