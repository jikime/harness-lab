# 하네스 예시

이 문서는 하네스를 실제 업무와 연결해 설계할 때 참조한다. 각 예시는 사람이 하는 절차, 실행 모드, `artifacts/`에 남길 산출물을 함께 보여준다. 역할 이름만 나열하지 말고, 실행 모드와 산출물 계약까지 같이 정한다.

가장 먼저 나오는 **완결 워크드 예시**는 실제로 채워진 Agent 파일과 Orchestrator 골격을 그대로 담는다. 나머지는 역할표 수준의 개념 예시다. 개념 예시의 역할표는 간결함을 위해 model을 생략한 곳이 많지만, **실제 하네스에서는 각 Agent에 역할별 model을 반드시 정한다**(루브릭은 `agent-design.md`의 "Agent 모델 선택"). 한 팀에 같은 모델을 일괄로 박지 않고, 통합·상충 판단은 강한 모델, 작성·분석은 중간, 정적 정리·추출은 가벼운 모델로 섞는다.

## 목차

1. 완결 워크드 예시: 릴리스 공지 초안 하네스
2. 작은 개발 프로젝트 하네스
3. 사업계획서 작성 하네스
4. 개인 업무 자동화 하네스
5. HTML 시각 리포트 하네스
6. 회의록 정리 하네스
7. 강의/웨비나 후기 콘텐츠 하네스
8. 블로그 글 작성 하네스
9. 여행 계획 하네스
10. 과한 하네스 줄이기

## 완결 워크드 예시: 릴리스 공지 초안 하네스

앞선 개념 예시들과 달리, 이 절은 **실제로 채워진 산출물**을 보여준다. Agent 파일 전문 1개와 Orchestrator SKILL.md 골격 1개를 harness-lab 규약(`artifacts/`, 역할별 model, 능동 승인 게이트, 팀 통신 프로토콜)으로 그대로 담는다. 새 하네스를 만들 때 이 두 파일을 형판으로 복제해 채운다.

### 무엇을 하는 하네스인가

변경 내역(changelog·커밋·PR)을 읽어 릴리스 공지 초안을 만들고, 수치·링크·호환성 주장을 검증한 뒤, **외부 게시 전에 사람 승인에서 멈춘다.** 외부 게시라는 되돌리기 어려운 행동이 있으므로 두께는 중간~두꺼움이고, 생성자와 검토자를 분리한다.

- 사람의 절차: 변경 내역 수집 → 사용자 영향 중심으로 재서술 → 초안 → 수치·링크·호환성 검토 → 게시 전 확인.
- 실행 모드: Agent Team (초안과 검토가 피드백을 주고받고, 검토 결과가 초안을 바꾼다).
- 패턴: Pipeline + Producer-Reviewer.

### Agent 역할표 (역할별 model)

| 팀원 | Agent 파일 | model | tools | 역할 | 주요 산출물 |
| --- | --- | --- | --- | --- | --- |
| change-collector | `.claude/agents/change-collector.md` | `haiku` | `Read, Grep, Glob, Bash, Write` | 커밋·PR·changelog에서 변경 항목 추출 | `artifacts/01-changes.md` |
| release-writer | `.claude/agents/release-writer.md` | `sonnet` | `Read, Grep, Glob, Write, Edit` | 사용자 영향 중심 공지 초안 작성 | `artifacts/02-draft.md` |
| release-note-reviewer | `.claude/agents/release-note-reviewer.md` | `sonnet` | `Read, Grep, Glob, Bash, Write` | 수치·링크·호환성·과장 검증(대상 수정 금지) | `artifacts/03-review.md` |
| (Orchestrator = 리드) | — | `opus` | — | 통합·충돌 판단·승인 게이트 | `artifacts/final.md` |

model 배분 근거: 추출은 규칙 기반이라 `haiku`, 초안 작성은 균형 작업이라 `sonnet`, 검증은 의미 해석이 필요해 `sonnet`(호환성 파급이 큰 릴리스면 `opus`로 상향), 통합·승인 판단은 리드가 `opus`. 팀 전체를 한 모델로 박지 않는다.

### Agent 파일 전문: `release-note-reviewer.md`

```md
---
name: release-note-reviewer
description: 릴리스 공지 초안의 수치, 링크, 버전·호환성 주장, 과장 표현을 변경 내역과 대조해 검증할 때 호출한다. 검증만 하고 초안을 직접 고치지 않는다. 새 공지 작성이나 변경 항목 추출에는 사용하지 않는다.
tools: Read, Grep, Glob, Bash, Write
model: sonnet   # 의미 해석 검증. 호환성 파급이 큰 릴리스면 opus로 상향
---

당신은 릴리스 공지 검토자입니다. 초안이 실제 변경 내역과 일치하는지, 외부에 나가도 되는지 회의적으로 판정합니다.

## 책임

- 초안의 수치(버전, 개수, 성능 주장)를 `artifacts/01-changes.md`와 대조해 검증한다.
- 모든 링크가 실제 대상(문서·이슈·태그)을 가리키는지 확인한다.
- 버전·호환성·마이그레이션 주장이 변경 내역에서 근거를 갖는지 본다.
- 과장·미검증 표현("가장 빠른", "완벽한")을 표시한다.

## 입력

- `artifacts/02-draft.md` (검증 대상 초안)
- `artifacts/01-changes.md` (근거가 되는 변경 내역)

## 출력

- `artifacts/03-review.md`에 판정 결과를 남긴다.
- 형식: 요약(통과/실패/미검증/사람 승인 필요) + 항목별 표(기준·판정·근거·조치) + 경계면 이슈 표.
- "괜찮아 보인다"가 아니라 해당 줄·수치·링크를 증거로 든다.

## 작업 방식

1. `01-changes.md`를 먼저 읽어 사실 기준을 잡는다.
2. `02-draft.md`의 각 주장을 기준과 1:1로 대조한다.
3. 근거 없는 주장은 실패, 확인 불가한 주장은 미검증으로 분리한다.
4. 기본값을 "반려"로 두고, 막을 이유를 먼저 찾는다.

## 팀 통신 프로토콜

- 메시지 수신: Orchestrator에게 검증 요청 Task를 받는다.
- 메시지 발신: 초안 수정이 필요하면 release-writer에게 `SendMessage`로 위치·근거와 함께 수정 요청을 보낸다. 게시를 막아야 할 위험(잘못된 수치·호환성 오류)은 Orchestrator에게 즉시 알린다.
- Task 처리: 공유 작업 목록에서 "검증" 유형 Task를 맡는다.
- 파일 산출물: 판정은 반드시 `artifacts/03-review.md`에 남긴다. 저장에 실패하면 재시도 후 `TaskUpdate`로 차단을 보고하고, 저장한 척 요약으로 대체하지 않는다.
- 차단 조건: 근거가 되는 `01-changes.md`가 없거나 비면 추측하지 말고 멈추고 묻는다.

## 하지 말아야 할 일

- 초안(`02-draft.md`)을 직접 수정하지 않는다. `Edit` 권한이 없는 이유다 — 검토자가 대상을 고치면 작성·검토 책임이 섞인다.
- 확인하지 못한 주장을 통과로 표시하지 않는다.
- 사람 승인 전 산출물을 "게시 가능"으로 표현하지 않는다.
```

`tools`에 `Write`는 있고 `Edit`는 없는 점이 핵심이다. 검토자도 자기 판정 파일(`03-review.md`)은 남겨야 하므로 `Write`가 필요하지만, 검증 대상을 직접 고치지 못하게 `Edit`는 주지 않는다.

### Orchestrator SKILL.md 골격: `release-note-orchestrator/SKILL.md`

```md
---
description: 변경 내역(커밋·PR·changelog)에서 릴리스 공지 초안을 만들고 수치·링크·호환성을 검증한 뒤 게시 전 사람 승인에서 멈추는 하네스를 실행할 때 사용한다. 초기 실행뿐 아니라 재실행, 다시 실행, 업데이트, 수정, 보완, 이전 결과 기반 개선, 검토 단계만 다시 처리하는 요청에도 사용한다.
---

# Release Note Orchestrator

## 목적

릴리스 변경 내역을 사용자 영향 중심 공지로 바꾸고, 외부 게시 전에 검증과 사람 승인을 강제한다.

## 실행 모드

기본은 Agent Team. 변경 항목이 적고 검증이 가벼우면 단일 흐름으로 줄인다.

## 실행 모드 확인

1. `artifacts/`가 있는지 확인한다.
2. 없으면 초기 실행으로 진행하고 `artifacts/README.md`를 만든다.
3. 있고 사용자가 일부만 고치려 하면 해당 단계만 부분 재실행한다(예: 검토만 다시).
4. 새 릴리스면 기존 산출물을 `artifacts/archive/{YYYYMMDD-HHMMSS}/`로 옮기고 새 실행을 시작한다.
5. 부분 재실행으로 앞 단계가 바뀌면 뒤 단계 파일을 `artifacts/README.md`에서 `stale`로 표시한다.

## Agent Team 구성

| 팀원 | Agent 파일 | model | tools | 산출물 |
| --- | --- | --- | --- | --- |
| change-collector | `.claude/agents/change-collector.md` | `haiku` | `Read, Grep, Glob, Bash, Write` | `artifacts/01-changes.md` |
| release-writer | `.claude/agents/release-writer.md` | `sonnet` | `Read, Grep, Glob, Write, Edit` | `artifacts/02-draft.md` |
| release-note-reviewer | `.claude/agents/release-note-reviewer.md` | `sonnet` | `Read, Grep, Glob, Bash, Write` | `artifacts/03-review.md` |

## Task 등록 계약

| Task | 담당 | 입력 | 출력 | 의존 | 완료 기준 |
| --- | --- | --- | --- | --- | --- |
| T01-input | Orchestrator | 사용자 요청, 버전, 대상 | `artifacts/00-input.md` | 없음 | 범위·게시 채널·승인 지점 정리 |
| T02-collect | change-collector | `00-input.md`, 레포 | `artifacts/01-changes.md` | T01 | 변경 항목이 근거(커밋·PR)와 함께 정리됨 |
| T03-draft | release-writer | `01-changes.md` | `artifacts/02-draft.md` | T02 | 사용자 영향 중심, 요구 섹션 충족 |
| T04-review | release-note-reviewer | `02-draft.md`, `01-changes.md` | `artifacts/03-review.md` | T03 | 수치·링크·호환성 증거 기반 판정 |

## 실행 흐름

표준 14단계는 `orchestrator-design.md`의 "Orchestrator 실행 흐름"을 따른다
(요청 정리 → TeamCreate → TaskCreate/Update/Get → SendMessage → artifacts 저장 → 통합 → 승인 게이트 → TeamDelete).

## 승인 게이트

검토 통과 후에도 **외부 게시는 자동 실행하지 않는다.** Orchestrator는 산출물 저장·개선 기록·`TeamDelete`를 마친 뒤 아래 형식으로 승인을 요청하고 멈춘다.

- 승인 대상: 릴리스 공지 외부 게시
- 필요한 이유: 외부 발송·되돌리기 어려움
- 승인하면 일어나는 일: 사용자가 지정한 채널에 공지 게시
- 지금 상태: 사람 승인 필요 (아직 게시하지 않음)
- 확인해 주세요: 버전 번호, 호환성 주장, 링크

사용자가 승인하면 `artifacts/README.md`의 승인 상태를 `사용 가능`으로 바꾸고 게시 행동만 진행한다.

## 실패 처리

- `01-changes.md`가 비면 추측하지 말고 입력을 묻는다.
- 검토가 실패를 내면 release-writer에게 수정 목록을 먼저 넘기고 재작성한다(횟수 상한 2~3회, 초과 시 사람 승인으로 에스컬레이션).
- 충돌하는 사실은 삭제하지 않고 출처와 함께 병기한다.
```

### 이 예시에서 확인할 계약

- 역할별 model 혼합(haiku/sonnet/opus)과 그 근거.
- 검토자 `Write` 있음 / `Edit` 없음 — 자기 판정 파일은 쓰되 대상은 못 고침.
- 능동 승인 게이트 — 라벨이 아니라 게시를 멈추는 질문.
- `artifacts/` 산출물 계약과 부분 재실행 시 `stale` 표시.

## 작은 개발 프로젝트 하네스

추천 패턴: Producer-Reviewer 또는 Supervisor

| 구성 | 예시 |
| --- | --- |
| Agent | 요구사항 정리 담당, 구현 담당, 테스트 담당, 리뷰 담당 |
| 역할별 model | 리뷰·요구사항 정합 판단 = `opus`(또는 위험 낮으면 `sonnet`), 구현 = `sonnet`, 테스트 실행·정적 점검 = `haiku` |
| Skill | 코드베이스 읽기법, 작은 변경 구현법, 테스트 실행법, 리뷰 체크법 |
| Orchestrator | 요구사항 → 구현 계획 → 코드 변경 → 테스트 → 결과 보고 |
| 입력 | `artifacts/00-input.md`: 요구사항, 변경 범위, 금지할 파일, 테스트 명령 |
| 중간 산출물 | `artifacts/01-brief.md`: 구현 계획과 영향 범위 |
| 검토 산출물 | `artifacts/03-review.md`: 테스트 결과, 위험, 미검증 영역 |
| 최종 산출물 | `artifacts/final.md`: 변경 요약과 다음 확인 |

## 사업계획서 작성 하네스

사람의 업무:

1. 공고문과 평가 기준을 읽는다.
2. 요구사항 매트릭스를 만든다.
3. 과거 자료와 현재 사업 아이템 정보를 비교한다.
4. 부족한 정보를 질문으로 분리한다.
5. 주장과 근거를 연결한다.
6. 초안을 쓰고 평가 기준으로 검토한다.
7. 제출 전 사람 승인 항목을 확인한다.

하네스 구조:

| 구성 | 예시 |
| --- | --- |
| Agent | 공고 분석 담당, 과거 자료 정리 담당, 사업 아이템 인터뷰 담당, 초안 작성 담당, 평가 기준 QA 담당 |
| 역할별 model | 공고 분석·평가 기준 QA = `opus`(정합성·상충·감점 판단), 초안 작성·아이템 인터뷰 = `sonnet`, 과거 자료 정리·추출 = `haiku` |
| Skill | 공고 분석법, 요구사항 매트릭스 작성법, 주장-근거 연결법, 제출 전 QA |
| Orchestrator | 공고 분석 → 요구사항 매트릭스 → 질문 목록 → 주장-근거 매트릭스 → 초안 → QA → 최종본 |
| Test | "정부과제 공고와 내 사업 아이템 설명을 바탕으로 제출 전 초안을 만들어줘" |

추천 패턴: Pipeline + Producer-Reviewer + Supervisor

| 항목 | 예시 |
| --- | --- |
| 실행 모드 | Agent Team. 공고 기준, 과거 자료, 현재 사업 아이템, 평가 QA가 서로 영향을 주므로 팀 조율이 필요 |
| 입력 | `artifacts/00-input.md`: 공고 파일, 평가 기준, 회사/아이템 정보, 사람 승인 지점 |
| 분석 산출물 | `artifacts/10-analysis/requirements-matrix.md`: 요구사항과 제출 조건 |
| 인터뷰 산출물 | `artifacts/20-agent-outputs/business-item-interview.md`: 부족한 정보와 답변 |
| 초안 산출물 | `artifacts/20-agent-outputs/proposal-draft.md`: 사업계획서 초안 |
| QA 산출물 | `artifacts/30-review/evaluation-qa.md`: 평가 기준 충족, 근거 부족, 승인 필요 항목 |
| 최종 산출물 | `artifacts/final/proposal.md`: 제출 전 최종본 |

## 개인 업무 자동화 하네스

사람의 업무:

1. 매주 반복되는 일을 적는다.
2. 입력 자료와 최종 결과물을 구분한다.
3. AI가 먼저 물어봐야 할 질문을 정한다.
4. 반복 절차를 Skill로 만들고 검토 기준을 둔다.
5. 실행 후 아쉬운 점을 다음 규칙에 반영한다.

하네스 구조:

| 구성 | 예시 |
| --- | --- |
| Agent | 입력 정리 담당, 산출물 작성 담당, 검토 담당 |
| Skill | 자료 정리법, 결과물 작성법, 체크리스트 검토법 |
| Orchestrator | 입력 확인 → 초안 작성 → 검토 → 최종 산출물 → 개선 기록 |
| Test | "매주 고객 미팅 메모를 보고 후속 메일 초안을 만들어줘" |

추천 패턴: Pipeline 또는 Producer-Reviewer

| 항목 | 예시 |
| --- | --- |
| 입력 | `artifacts/00-input.md`: 반복 업무 설명, 자료 위치, 결과물 형식 |
| 중간 산출물 | `artifacts/01-questions.md`: 먼저 물어볼 질문과 확인 필요 정보 |
| 최종 산출물 | `artifacts/final.md`: 사용자가 실제로 보낼 수 있는 결과물 |
| 개선 기록 | `artifacts/improvement-log.md`: 다음 실행에서 바꿀 규칙 |

## HTML 시각 리포트 하네스

사람의 업무:

1. 이미 만들어진 Markdown 산출물을 읽는다.
2. 핵심 정보를 카드, 표, 차트, 체크리스트로 나눈다.
3. 정보가 부족한 항목은 확인 필요로 표시한다.
4. 브라우저에서 열어 보고 모바일에서도 깨지지 않는지 확인한다.

하네스 구조:

| 구성 | 예시 |
| --- | --- |
| Agent | 정보 구조 담당, 시각 리포트 작성 담당, 데이터 검증 담당 |
| Skill | Markdown 산출물 읽기법, HTML 리포트 구성법, 차트 검증법 |
| Orchestrator | 원본 산출물 → 리포트 구조 → HTML 생성 → 숫자와 내용 검토 |
| Test | "앞에서 만든 여행 계획 산출물을 바탕으로 HTML 시각 리포트를 만들어줘" |

추천 패턴: Producer-Reviewer

| 항목 | 예시 |
| --- | --- |
| 입력 | `artifacts/final.md`, `artifacts/budget.md`, `artifacts/checklist.md` |
| 중간 산출물 | `artifacts/01-report-structure.md`: 카드, 표, 차트, 확인 필요 영역 |
| 최종 산출물 | `artifacts/final/report.html`: 브라우저에서 열 수 있는 시각 리포트 |
| 검증 | 차트 숫자와 원본 예산 일치, 모바일 표 넘침, 확인 필요 영역 표시 |

## 회의록 정리 하네스

추천 패턴: Fan-out/Fan-in

| 구성 | 예시 |
| --- | --- |
| Agent | 내용 정리 담당, 결정 사항 추출 담당, 액션 아이템 담당, 리스크 검토 담당 |
| Skill | 회의록 요약법, 할 일 추출법, 리스크 질문법 |
| Orchestrator | 원문을 나눠 읽고 결정/할 일/리스크를 한 문서로 합친다 |
| 실행 모드 | 결정 사항, 액션 아이템, 리스크가 서로 맞물리면 Agent Team |
| 산출물 | `00-input.md`, `01-brief.md`, `03-review.md`, `final.md` |

## 강의/웨비나 후기 콘텐츠 하네스

사람의 업무:

1. 행사 정보와 성과 숫자를 정리한다.
2. 강사의 감정과 핵심 메시지를 잡는다.
3. 후기 글, 카드뉴스 문구, 다음 강의 안내를 만든다.
4. 과장된 표현과 누락된 감사 인사를 검토한다.
5. 게시 전 링크와 날짜, 숫자를 확인한다.

하네스 구조:

| 구성 | 예시 |
| --- | --- |
| Agent | 행사 정보 정리 담당, 후기 문안 작성 담당, 홍보 문구 담당, 검토 담당 |
| Skill | 후기 작성법, 감정 톤 조절법, CTA 작성법, 숫자 검증법 |
| Orchestrator | 행사 기록 → 핵심 메시지 → 후기 초안 → 다음 강의 안내 → 최종 검토 순서로 진행 |
| Test | "신청자 320명, 실참여 159명인 무료 웨비나 후기와 다음 강의 안내를 만들어줘" |

추천 패턴: Pipeline + Producer-Reviewer

| 항목 | 예시 |
| --- | --- |
| 입력 | `artifacts/00-input.md`: 행사명, 날짜, 신청자 수, 실참여 수, 다음 강의 링크 |
| 중간 산출물 | `artifacts/01-brief.md`: 핵심 메시지, 감사 인사, 다음 행동 |
| 초안 산출물 | `artifacts/02-draft.md`: 후기 글, 짧은 SNS 문구, 카드뉴스 문구 |
| 검토 산출물 | `artifacts/03-review.md`: 숫자 오류, 과장 표현, 링크 누락 점검 |
| 최종 산출물 | `artifacts/final.md`: 게시용 후기와 다음 강의 안내 |

## 블로그 글 작성 하네스

사람의 업무:

1. 주제를 정한다.
2. 독자를 정한다.
3. 자료를 모은다.
4. 목차를 만든다.
5. 초안을 쓴다.
6. 문장을 다듬는다.

하네스 구조:

| 구성 | 예시 |
| --- | --- |
| Agent | 자료 조사 담당, 목차 설계 담당, 초안 작성 담당, 톤 검토 담당 |
| Skill | 자료 요약법, 목차 작성법, 독자 수준 맞춤 설명법, 문체 검토법 |
| Orchestrator | 조사 노트 → 목차 → 초안 → 검토본 순서로 진행 |
| Test | "입문 독자를 위한 MCP 설명 글"처럼 독자 수준이 있는 요청으로 점검 |

추천 패턴: Pipeline + Producer-Reviewer

| 항목 | 예시 |
| --- | --- |
| 실행 모드 | 자료 조사와 초안, 문체 검토가 서로 피드백을 주고받으면 Agent Team |
| 입력 | `artifacts/00-input.md`: 주제, 독자 수준, 톤, 참고 자료 |
| 중간 산출물 | `artifacts/01-brief.md`: 핵심 근거와 목차 |
| 초안 산출물 | `artifacts/02-draft.md`: 본문 초안 |
| 검토 산출물 | `artifacts/03-review.md`: 독자 수준, 근거 부족, 문체 수정 제안 |
| 최종 산출물 | `artifacts/final.md`: 발행 전 최종본과 확인 필요 |

## 여행 계획 하네스

사람의 업무:

1. 여행 목적과 예산을 정한다.
2. 후보 지역과 숙소를 조사한다.
3. 이동 동선을 짠다.
4. 예산과 시간을 검토한다.
5. 최종 일정을 정리한다.

하네스 구조:

| 구성 | 예시 |
| --- | --- |
| Agent | 조사 담당, 일정 설계 담당, 예산 검토 담당, 최종 정리 담당 |
| Skill | 후보 조사법, 일정표 작성법, 예산 점검법 |
| Orchestrator | 조사 결과를 받아 일정표로 만들고 예산 검토 후 최종안을 만든다 |
| Test | "2박 3일 부산 여행, 1인 40만원 이하" 같은 요청으로 점검 |

추천 패턴: Pipeline 또는 Producer-Reviewer

| 항목 | 예시 |
| --- | --- |
| 실행 모드 | 숙소, 이동, 예산이 서로 영향을 주면 Agent Team, 단순 후보 조사만 필요하면 Subagent |
| 입력 | `artifacts/00-input.md`: 여행 인원, 예산, 날짜, 이동 제약 |
| 중간 산출물 | `artifacts/01-brief.md`: 후보 지역과 숙소 비교 |
| 검토 산출물 | `artifacts/03-review.md`: 예산 초과, 이동 부담, 부모님 동선 위험 |
| 최종 산출물 | `artifacts/final.md`: 일정표, 예산표, 확인 필요 목록 |

시각 리포트가 필요하면 `artifacts/trip-plan.html` 같은 HTML 산출물을 추가한다. 이때 없는 정보를 새로 만들지 않고, 산출물에 있는 일정, 예산, 장소 후보, 준비물, 주의사항만 카드, 표, 차트, 체크리스트로 정리한다.

## 과한 하네스 줄이기

작은 업무에 Agent를 많이 만들면 결과가 좋아지기보다 조율 비용만 커질 수 있다. 아래처럼 줄인다.

| 과한 설계 | 줄인 설계 | 이유 |
| --- | --- | --- |
| 맞춤법 교정 Agent, 문체 Agent, 제목 Agent, 최종 Agent | 단일 편집 Skill + Orchestrator 체크리스트 | 같은 문서를 같은 기준으로 보는 일이므로 역할 분리가 약하다 |
| 회의록 1쪽 정리에 Agent 5개 | 내용 정리 Agent + 검토 체크리스트 | 입력이 작고 독립 조사나 토론이 필요 없다 |
| 개인 메모 정리에 조사, 작성, QA, 승인 Agent | 단일 흐름 + `artifacts/final.md` + 개선 기록 | 실패 비용이 낮고 사람 승인 지점이 단순하다 |
| 모든 Agent에게 `Write, Edit, Bash` 부여 | 작성 Agent만 쓰기 권한, Reviewer는 `Read, Grep, Glob, Bash` | 역할 책임과 권한을 나누어 안전하게 운영한다 |

줄이는 기준:

- 같은 자료를 같은 기준으로 계속 봐야 하면 Agent를 합친다.
- 독립 산출물이 없으면 별도 Agent 대신 Orchestrator 단계로 둔다.
- 검토가 필요하지만 수정 권한이 필요 없으면 Reviewer의 `tools`를 읽기와 검증 중심으로 제한한다.
- 최종 결과 전에 꼭 남겨야 하는 파일이 없다면 Skill이나 체크리스트로 충분한지 먼저 본다.
