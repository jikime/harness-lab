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
