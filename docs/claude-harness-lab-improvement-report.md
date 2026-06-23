# Claude Harness Lab 개선 적용 보고서

작성일: 2026-05-13
갱신일: 2026-06-23 (주제별 1파일 재구성 반영)

## 목적

이 문서는 Claude용 `harness-lab` 스킬을 개선하면서, 어떤 기준을 적용했으며, 최종적으로 어떤 파일 구조로 정리했는지 남긴 기록이다.


## 핵심 개선

### 1. 청사진 승인 게이트 강화

하네스 생성 요청은 바로 파일을 만들지 않고 먼저 청사진을 제시하도록 강화했다.

청사진에는 아래 항목이 포함된다.

- 하네스 7요소
- 사람의 작업 절차
- 산출물 계약
- 실행 모드
- Agent 역할표와 분리 이유
- Skill 목록
- Orchestrator 흐름
- 테스트 프롬프트

사용자가 직전 청사진에 대해 명시적으로 승인한 뒤에만 현재 프로젝트의 `.claude/agents`, `.claude/skills`, `CLAUDE.md`, `artifacts/` 파일을 생성하거나 수정한다.

### 2. 현재 프로젝트 기준 생성 원칙 적용

실행 하네스는 사용자 홈의 전역 위치가 아니라 현재 작업 중인 프로젝트 루트에 만든다.

기본 위치는 아래와 같다.

| 목적 | 위치 |
| --- | --- |
| 프로젝트 안내 | `CLAUDE.md` |
| Agent 정의 | `.claude/agents/{agent-name}.md` |
| 작업 Skill | `.claude/skills/{skill-name}/SKILL.md` |
| Orchestrator Skill | `.claude/skills/{harness-name}-orchestrator/SKILL.md` |
| 산출물 | `artifacts/` |

스킬 본문에서도 불필요하게 특정 실행 환경 이름을 반복하지 않도록 정리했다.

### 3. Agent Team 기능 재반영

원본 하네스의 중요한 특징은 단순히 Agent 파일을 여러 개 만드는 것이 아니라, Orchestrator가 팀을 구성하고 작업을 등록하며 중간 발견을 메시지와 파일 산출물로 조율한다는 점이었다.

개선판에는 Agent Team을 기본 후보 실행 모드로 반영했다.

필수 계약:

- `TeamCreate`: 필요한 Agent를 팀원으로 구성
- `TaskCreate`: 단계별 작업과 의존 관계 등록
- `TaskUpdate`: 시작, 차단, 완료, 재할당 상태 갱신
- `TaskGet`: Phase 전환 전 지연, 누락, 의존 관계 확인
- `SendMessage`: 발견, 질문, 충돌, 차단, 완료 상태 공유
- 파일 산출물: 다음 단계가 읽을 결과를 `artifacts/`에 저장
- 최종 통합: Orchestrator가 산출물을 읽고 승인 지점을 확인
- `TeamDelete`: 실행 종료 후 팀 정리

이 기준 때문에 "Agent 파일이 여러 개 있다"와 "Agent Team으로 실행된다"를 분명히 구분하도록 했다.

추가 점검에서 원본의 운영 계약을 다시 대조해 아래 내용을 더 보강했다.

- 기존 하네스 확장 시 신규 Orchestrator를 무조건 만들지 않고 기존 Orchestrator 갱신을 우선 검토
- Agent Team의 `TaskUpdate`, `TaskGet`, 작업 재할당, 유휴/지연 확인 기준 추가
- 메시지 기반, 태스크 기반, 파일 기반, 반환값 기반 데이터 전달 방식 구분
- 팀에서 Subagent로, Subagent에서 팀으로, 팀에서 새 팀으로 넘어가는 하이브리드 전환 규칙 추가
- 소/중/대규모별 권장 팀원 수와 팀원당 Task 수 기준 추가
- 후속 작업 키워드, 부분 재실행, 이전 결과 기반 개선 기준 추가
- QA를 최종 1회 검토가 아니라 중간 산출물 직후 점진 실행하도록 보강
- `.claude/commands/`를 만들지 않는 검증 항목 추가

### 4. 산출물 계약 추가

실행 결과가 대화에만 남으면 다음 실행이 이어받을 수 없다. 그래서 모든 실행 하네스에 산출물 계약을 포함하도록 했다.

작은 하네스의 기본 예:

| 파일 | 역할 |
| --- | --- |
| `artifacts/README.md` | 산출물 지도 |
| `artifacts/00-input.md` | 입력과 요구사항 |
| `artifacts/01-brief.md` | 작업 요약과 방향 |
| `artifacts/02-draft.md` | 초안 |
| `artifacts/03-review.md` | 검토 결과 |
| `artifacts/final.md` | 최종 산출물 |
| `artifacts/improvement-log.md` | 개선 기록 |

긴 작업은 `10-analysis/`, `20-agent-outputs/`, `30-review/`, `final/` 같은 폴더형 구조를 사용하도록 정리했다.

### 5. QA와 Evolution 흐름 보강

QA Agent는 단순 존재 확인이 아니라 경계면 교차 검증을 맡도록 했다.

검증 예:

- 요구사항과 초안 비교
- 이전 Agent 산출물과 다음 Agent 산출물 비교
- 검토 의견과 최종 결과 비교
- 승인 조건과 실제 실행 비교

또한 기존 하네스 점검, drift 확인, baseline 비교, assertion 검증, 개선 기록 갱신 흐름을 함께 포함했다.

### 6. Reference 구조 통합

처음 개선 과정에서는 reference가 11개로 늘어났다. 하지만 원본 하네스는 6개 reference로 역할이 비교적 명확했고, 실제 사용 시에도 너무 많은 파일은 읽기 부담을 만든다.

그래서 Claude용 references를 아래 6개로 통합했다.

| 새 reference | 역할 | 통합한 기존 주제 |
| --- | --- | --- |
| `harness-design-workflow.md` | 청사진 승인, 하네스 7요소, Phase 0-7, 성숙도, 설계 카드 | `phase-guide`, `harness-design-cards` |
| `agent-design.md` | Agent frontmatter·모델 선택·빌트인·분리, 실행 모드, 팀 패턴, Agent 파일 구조, 생성자-평가자·반복합의 패턴 | `agent-skill-design`, `pattern-catalog` |
| `orchestrator-design.md` | Orchestrator 실행 계약·흐름·Task·데이터 전달·에러, 청사진·`artifacts/` 산출물 템플릿, Orchestrator·`CLAUDE.md` 템플릿 | `agent-team-runtime`, `templates`, `artifact-contract` |
| `skill-authoring-guide.md` | Skill description, workflow, output format, examples, progressive disclosure | Skill 작성 기준 |
| `testing-qa-evolution.md` | 테스트, QA, baseline, assertion, drift, 개선 기록 | `testing-improvement`, `qa-agent-guide`, `failure-maintenance` |
| `examples.md` | 일상 업무와 사업계획서 예시 | `everyday-examples` |

결과적으로 원본과 비슷한 효과를 유지하면서도, 책의 개념과 Claude용 실행 구조를 더 잘 묶는 형태가 되었다.

### 7. 주제별 1파일 재구성 (후속, 2026-06-23)

처음 통합본은 `agent-team-design.md`가 Agent 개념과 Orchestrator 런타임을 함께 담고, `orchestrator-artifacts-template.md`가 Agent·Skill·Orchestrator 템플릿을 모두 모아 두었다. 점검 결과 Orchestrator 내용이 두 파일에 흩어지고, Agent·Skill 파일 템플릿이 주제 문서와 템플릿 파일에 중복되는 문제가 있었다. 원본 harness의 "1주제=1파일" 원칙에 맞춰 아래로 재구성했다.

- `agent-team-design.md` → **`agent-design.md`** 로 rename. Orchestrator 런타임(최소 실행 계약·실행 흐름·Task·데이터 전달·에러·팀 재구성)을 빼내고 Agent 설계 + 팀 패턴만 남겼다.
- `orchestrator-artifacts-template.md` → **`orchestrator-design.md`** 로 rename. 빼낸 Orchestrator 런타임을 모아 받았고, Agent·Skill 파일 템플릿은 본문을 지우고 `agent-design.md`·`skill-authoring-guide.md`를 가리키는 포인터로 바꿔 중복을 제거했다.
- 결과: **Agent 정본 = `agent-design.md`, Orchestrator 정본 = `orchestrator-design.md`, Skill 정본 = `skill-authoring-guide.md`** 로 주제가 한 파일씩 정리되고, 파일명이 내용과 일치하게 되었다.

## 현재 파일 구조

현재 Claude용 하네스 스킬의 핵심 파일은 아래와 같다.

```text
claude/skills/harness-lab/
├── SKILL.md
└── references/
    ├── agent-design.md
    ├── examples.md
    ├── harness-design-workflow.md
    ├── orchestrator-design.md
    ├── skill-authoring-guide.md
    └── testing-qa-evolution.md
```

## 수정한 파일

### `claude/skills/harness-lab/SKILL.md`

적용 내용:

- 청사진 승인 게이트를 핵심 원칙으로 명시
- 현재 프로젝트의 `.claude`와 `artifacts/`에 생성한다는 기준 정리
- Agent Team을 기본 후보 실행 모드로 반영
- Agent 파일만으로는 팀 하네스가 아니라는 기준 추가
- `TaskUpdate`, `TaskGet`, 후속 실행 키워드, 기존 확장 분기 추가
- 팀 규모와 팀원당 Task 수 기준 추가
- 산출물 계약을 필수 요소로 반영
- reference 목록을 새 6개 구조로 정리
- QA, drift, 개선 기록 기준을 통합 reference로 연결

### `claude/skills/harness-lab/references/harness-design-workflow.md`

적용 내용:

- 청사진 승인 게이트
- 하네스 7요소
- 성숙도 5단계
- Phase 0-7
- Phase 0 신규 구축, 기존 확장, 운영/유지보수 분기
- 변경 유형별 재설계 Phase 선택 기준
- 설계 카드
- 하네스 두께
- 청사진 입력 프롬프트

### `claude/skills/harness-lab/references/agent-design.md`

적용 내용 (Agent + 팀 패턴):

- Agent, Skill, Orchestrator 구분
- 단일 흐름, Subagent, Agent Team 선택 기준(실행 모드)
- Agent frontmatter 설계와 역할별 model 선택 루브릭(haiku/sonnet/opus/fable), 빌트인 타입 규칙
- Agent 분리 기준
- Agent 파일 구조 템플릿과 팀 통신 프로토콜
- 팀 패턴과 팀 크기 가이드
- 생성자-평가자 분리, 반복·합의·자기비판 패턴
- Agent Team 안티패턴
- (Orchestrator 런타임·Task·데이터 전달·에러·팀 재구성은 `orchestrator-design.md`로 이동)

### `claude/skills/harness-lab/references/orchestrator-design.md`

적용 내용 (Orchestrator 런타임 + 템플릿 + artifacts):

- Agent Team 최소 실행 계약과 Orchestrator 실행 흐름(`TeamCreate`~`TeamDelete`)
- 위임 4종 세트, Task 설계, `TaskUpdate`/`TaskGet` 운영 규칙
- 데이터 전달 프로토콜, `SendMessage` 규칙
- 하이브리드 전환·팀 재구성·에러 처리 규칙
- 하네스 청사진 템플릿, 산출물 구조·`artifacts/README.md`·산출물 계약·벤치마크 템플릿
- Orchestrator Skill 템플릿과 승인 게이트 형식, `CLAUDE.md` 포인터 템플릿
- Agent·Skill 파일 템플릿은 `agent-design.md`·`skill-authoring-guide.md`를 가리키는 포인터로 정리(중복 제거)

### `claude/skills/harness-lab/references/skill-authoring-guide.md`

적용 내용:

- Skill의 역할과 기본 구조
- description 작성법
- 본문 작성 원칙
- progressive disclosure 기준
- 출력 형식
- 예시와 edge case
- Orchestrator Skill 작성 주의점
- Skill 점검 체크리스트

### `claude/skills/harness-lab/references/testing-qa-evolution.md`

적용 내용:

- 정상, 애매함, 실패 위험, 부정, 반복 테스트
- baseline 비교
- assertion 기반 검증
- Agent Team 검증
- QA Agent 원칙
- 점진 QA 실행 시점
- trigger should/should-not 검증 기준
- 기존 하네스 감사 절차
- drift 점검표
- 개선 기록 형식

### `claude/skills/harness-lab/references/examples.md`

적용 내용:

- 여행 계획 하네스
- 블로그 글 작성 하네스
- 회의록 하네스
- 작은 개발 프로젝트 하네스
- 사업계획서 하네스

각 예시는 실행 모드와 `artifacts/` 산출물 예시를 포함한다.

## 제거한 파일

아래 파일들은 내용이 새 6개 reference에 통합되어 제거했다.

- `agent-skill-design.md`
- `agent-team-runtime.md`
- `artifact-contract.md`
- `everyday-examples.md`
- `failure-maintenance.md`
- `harness-design-cards.md`
- `pattern-catalog.md`
- `phase-guide.md`
- `qa-agent-guide.md`
- `templates.md`
- `testing-improvement.md`

## 남은 주의점

이번 통합은 Claude용 `claude/skills/harness-lab`에 적용한 것이다. Codex용 하네스 스킬에는 앞서 청사진 승인 게이트와 산출물 원칙을 반영했지만, reference 통합 구조까지 동일하게 맞추지는 않았다.

앞으로 Codex용도 같은 방식으로 정리하려면, Codex의 `AGENTS.md`, `.agents/skills`, `.codex/agents` 경로 규칙에 맞춰 별도 통합 작업을 진행하면 된다.
