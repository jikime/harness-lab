# Project Harness

이 저장소에는 하네스 엔지니어링 실습을 위한 `harness-lab` 스킬(`.claude/skills/harness-lab`)과, 그 스킬로 만든 실행 하네스가 함께 있습니다.

## 주요 위치

- 하네스 설계·생성 스킬: `.claude/skills/harness-lab`
- 실행 스킬: `.claude/skills/`
- Agent: `.claude/agents/`
- 중간 산출물: `artifacts/`

## 가족 여행 준비 하네스

가족 여행 준비를 조사 → 일정·예산 설계 → 체크리스트 검토 → HTML 대시보드 순서로 진행하는 실행 하네스입니다.

- Orchestrator: `.claude/skills/family-trip-prep-orchestrator/SKILL.md`
- Agent: `trip-researcher`, `itinerary-planner`, `checklist-reviewer`, `dashboard-builder` (`.claude/agents/`)
- 중간 산출물: `artifacts/family-trip-prep/`
- 최종 산출물: `artifacts/family-trip-prep/dashboard.html`

### 자연어 라우팅

사용자가 스킬명을 직접 입력하지 않아도 가족 여행 준비 업무로 판단되면 `family-trip-prep-orchestrator`를 먼저 사용합니다.

예:

- "가족 여행 준비해줘"
- "여행 일정 초안 정리해줘"
- "항공권 후보만 다시 찾아줘"
- "일정표 예산 다시 배분해줘"
- "체크리스트만 다시 만들어줘"
- "지난번 여행 준비 결과 기반으로 대시보드만 다시 만들어줘"

## 하네스 변경 이력

| 날짜 | 변경 내용 | 대상 | 사유 |
| --- | --- | --- | --- |
| 2026-07-27 | 초기 구성 | family-trip-prep-orchestrator, trip-researcher, itinerary-planner, checklist-reviewer, dashboard-builder | 가족 여행 준비 반복 업무 하네스 생성 |
| 2026-07-29 | itinerary-planner에 `Edit` 도구 추가, "부분 재실행은 Write 전체 재출력 대신 Edit" 지침 추가 | itinerary-planner | 965줄짜리 02-itinerary-draft.md를 Write로 통째로 재출력하려다 출력 길이 한도에 두 번 걸려 실패(v6). 문서가 개정마다 누적되는 구조라 앞으로 더 길어질 것이 뻔해 도구 부재라는 근본 원인을 고침 |
| 2026-07-29 | T06-artifact-sync 단계 추가: `dashboard.html`(CDN 버전) 갱신 시마다 CDN 없는 자체완결 쌍둥이본 `dashboard-artifact.html`을 같은 데이터로 갱신하고 Artifact로 재발행(기존 URL 유지) | family-trip-prep-orchestrator | `dashboard.html`은 CDN(Tailwind/Chart.js)을 쓰는데 Artifact 발행 환경은 CSP로 외부 CDN을 막아 그대로 발행하면 깨짐. 사용자가 "웹으로 안 보여주냐"고 물어서 한 번은 수작업으로 자체완결 버전을 새로 만들었는데, 이후 일정이 바뀌어도 그 웹 링크는 자동으로 안 바뀐다는 걸 사용자가 지적 — Orchestrator가 매번 잊지 않도록 정식 단계(T06)로 하네스에 반영 |
| 2026-08-01 | T07-record-close 단계 신설: `README.md`의 "부분 재실행 기록" 표와 `improvement-log.md` 갱신을 정식 단계로 승격하고, 두 파일 마지막 행이 모두 이번 회차를 가리켜야 완료로 판정 | family-trip-prep-orchestrator | v7·v8 두 회차가 산출물·검토·발행은 정상인데 기록만 빠진 채 커밋됨(README 헤더 버전 표기만 v8이라 알아채기 어려웠음). 기록 갱신이 T01~T06 어디에도 없는 "마무리 관행"으로만 존재한 것이 원인 |
| 2026-08-01 | T03 진입 검사 추가: 직전 `02-itinerary-draft.md` 버전이 T04 검토를 받았는지 확인하고, 미검토분이 있으면 먼저 검토하거나 다음 T04를 "통합 검토"로 등록하며 미검토 구간을 reviewer에게 명시 | family-trip-prep-orchestrator | 사용자 요청이 연달아 들어온 v7→v8 구간에서 T04를 건너뛰고 T03만 두 번 도는 흐름이 실제로 발생. v8 때 v7+v8 통합 검토로 회수했지만 우연이었고 구조적 보장이 없었음 |
| 2026-08-01 | 조건부 승인 계약 명문화: checklist-reviewer는 조건을 `조건부 사항` 라벨로 분리 기재, dashboard-builder는 그 조건을 반드시 대시보드에 반영, Orchestrator는 T05 완료 판정 전 산출물에서 직접 확인(자체보고로 대체 금지) | checklist-reviewer, dashboard-builder, family-trip-prep-orchestrator | v8에서 reviewer가 "12/26 여유 0분을 대시보드에 노출할 것"을 조건으로 승인했는데, 그 조건의 이행을 확인하는 단계가 하네스에 없었음. 이번엔 이행됐지만 세 파일 어디에도 조건부 승인이라는 개념 자체가 없어 다음에 빠질 수 있었음 |
