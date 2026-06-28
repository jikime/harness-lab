# 테스트, QA, 유지보수 가이드

이 문서는 Phase 7에서 사용한다. 목표는 "잘 만든 것 같다"가 아니라 "어떤 요청에서 잘 작동했고, 어떤 요청에서 흔들렸는지"를 확인하고 다음 버전에 반영하는 것이다.

## 목차

1. 언제 읽을까
2. 테스트 3종 세트
3. 결함 주입과 회귀 세트
4. With/Without 하네스 A/B 비교
5. Assertion 기반 검증
6. Agent Team 검증
7. QA Agent 원칙
8. 경계면 교차 검증
9. 하네스 테스트 체크리스트
10. Trigger 검증
11. 기존 하네스 감사와 Drift 점검
12. 하네스 덜어내기 진단
13. 개선 기록과 ADR 형식

## 언제 읽을까

- 테스트 프롬프트, with/without 벤치마크 비교, assertion 검증이 필요할 때
- QA Agent나 Reviewer를 설계해야 할 때
- 기존 하네스를 점검하거나 drift를 찾을 때
- 실패 사례를 바탕으로 Agent, Skill, Orchestrator를 개선할 때

## 테스트 3종 세트

| 유형 | 목적 | 예시 |
| --- | --- | --- |
| 정상 사례 | 의도한 업무가 잘 되는지 확인 | "입문 독자를 위한 Git 브랜치 설명 글을 써줘" |
| 애매한 사례 | 범위가 흐릴 때 질문하거나 정리하는지 확인 | "Git 좀 정리해줘" |
| 실패 위험 사례 | 자료 부족, 조건 충돌, 과도한 요구를 다루는지 확인 | "공식 문서 없이 최신 기능까지 정확히 설명해줘" |

실무용 하네스라면 부정 테스트와 반복 테스트를 추가한다.

| 유형 | 목적 |
| --- | --- |
| 부정 테스트 | 이 Skill이나 Orchestrator가 쓰이면 안 되는 요청을 가려내는지 확인 |
| 반복 테스트 | 같은 입력을 여러 번 넣어도 구조와 품질이 안정적인지 확인 |

## 결함 주입과 회귀 세트

검토 단계가 매번 통과만 한다면 두 가지 원인이 섞여 있다. (1) 모델이 좋아져 앞 단계 출력이 실제로 깨끗해진 진짜 통과거나, (2) 검토 기준이 무뎌 실제 결함도 통과시키는 거수기다. 이 둘을 가르지 않고 검토를 빼면 사고가 난다. 가르는 가장 빠른 방법이 **결함 주입(fault injection)**이다.

결함 주입은 일부러 망가뜨린 입력을 흘려보내 검증 단계가 그 결함을 잡는지 보는 것이다. 잡으면 살아 있는 검토, 그냥 통과시키면 죽은 검토다. 이 한 가지 테스트가 "모델이 좋아져서 통과"와 "검토가 망가져서 통과"를 가장 깔끔하게 가른다. 이 문서의 "하네스 덜어내기 진단"에서 always-pass 검증을 식별할 때 이 테스트를 함께 쓴다.

산출물 종류별 결함 예시:

| 산출물 | 심을 결함 | 살아 있는 검토라면 |
| --- | --- | --- |
| 문서·콘텐츠 | 사실 오류, 깨진 인용·링크, 톤 이탈, 금지 표현, 누락 섹션, 분량 초과 | 해당 항목을 위치·근거와 함께 탈락시킨다 |
| 수치·보고서 | 합계 불일치, 단위 혼용, 직전 분기 대비 근거 누락 | 경계면 교차 검증에서 불일치를 잡는다 |
| 코드 | 응답 shape 변조, 깨진 라우트, 누락 상태 전이 | 생산자-소비자 계약 불일치를 잡는다 |
| 제출·발송물 | 잘못된 수신자, 빠진 첨부, 미승인 상태 | 승인 게이트에서 멈춘다 |

결함 주입 입력은 한 번 쓰고 버리지 않는다. **회귀 세트**로 `artifacts/evals/regression/`에 보관하고, 프롬프트·모델·하네스 구조를 바꿀 때마다 다시 흘려보내 검토가 여전히 잡는지 확인한다. 이것이 모델이 바뀌어도 하네스가 늙지 않게 하는 핵심 장치다.

검토 프롬프트는 "문제없으면 PASS"가 아니라 "막을 이유를 찾아라(반려 우선)"로 뒤집는다. 기본값을 반려로 두고, 발견 항목 목록·위치·근거·심각도를 강제로 출력하게 하면 빈 결과가 진짜인지 게으름인지 드러난다. 분량·섹션 존재·링크 유효성·금지어처럼 객관적인 항목은 LLM 검토 대신 결정적 체크(체크리스트·스크립트)로 빼고, LLM 검토는 논리·톤·사실성 같은 판단 영역에 집중시킨다.

## With/Without 하네스 A/B 비교

하네스가 정말 가치를 더하는지 보려면, 같은 요청을 하네스로 한 번, 하네스 없이 한 번 실행해 나란히 비교한다. "좋아 보인다"가 아니라 "하네스를 썼을 때 무엇이 더 나아졌는가"를 증거로 확인한다.

다만 with/without 비교는 항상 전체 실행으로 하지 않는다. 큰 프로젝트에서 전체 비교를 매번 돌리면 비용이 커지고, 결과 차이가 하네스 때문인지 실행 흔들림 때문인지 흐려질 수 있다. 먼저 벤치마크 두께를 고른다.

### 벤치마크 두께 선택

| 두께 | 언제 쓰나 | 실행 범위 | 저장 |
| --- | --- | --- | --- |
| `light` | 작은 하네스, 초기 감 잡기, 저위험 업무 | 대표 프롬프트 1개만 비교한다 | `comparison.md` 중심. 필요하면 `metrics.json`을 추가한다 |
| `targeted` | 중간·큰 프로젝트, 특정 Agent·Skill·Phase를 고쳤을 때 | 바뀐 구간과 그 구간의 입력·출력만 비교한다 | `prompt.md`, `run-config.md`, 관련 산출물, `comparison.md` |
| `full` | 새 하네스의 가치 증명, 릴리스 전 큰 구조 변경 | 전체 with-harness와 without-harness를 비교한다 | 전체 벤치마크 폴더 구조를 사용한다 |

기본값은 `light`다. 큰 프로젝트에서는 `full`을 기본값으로 쓰지 않는다. 전체 결과보다 바뀐 Phase, 핵심 산출물, 위험 지점을 좁혀 보는 `targeted`를 우선한다.

| 상황 | 권장 두께 |
| --- | --- |
| 첫 실습 또는 개인용 작은 문서 하네스 | `light` |
| Reviewer, QA, 트리거 description만 수정 | `targeted` |
| 사업계획서, 코드베이스, 여러 Agent가 얽힌 프로젝트 | `targeted` |
| 새 하네스가 실제로 기준 실행보다 나은지 처음 증명 | `full` |
| 운영 중 회귀 확인 | with/without보다 regression, assertion, drift 점검 우선 |

### 실행 구조

각 테스트 프롬프트마다 같은 입력을 두 방식으로 실행한다. 테스트 입력은 같아야 하지만 실행 방식은 분명히 분리한다. `targeted`에서는 전체 요청 대신 특정 Phase의 입력 파일과 기대 출력만 공통 입력으로 삼는다.

| 구성 | 입력 | 실행 조건 | 출력 경로 |
| --- | --- | --- | --- |
| With-harness | {동일 프롬프트} | Orchestrator·Skill·Agent Team 사용 | `artifacts/evals/iteration-N/{eval-name}/with-harness/` |
| Without-harness | {동일 프롬프트} | Orchestrator·Skill·Agent Team 미사용 | `artifacts/evals/iteration-N/{eval-name}/without-harness/` |

두 실행의 프롬프트와 입력 자료는 완전히 같아야 한다. 입력이 달라지면, 결과 차이가 하네스 덕분인지 입력 차이 때문인지 구분할 수 없다.

`without-harness`는 기준 실행이다. 같은 프로젝트에서 자동 라우팅이 켜질 수 있으므로, 실행 기록에 "어떤 하네스 요소를 쓰지 않았는지"를 남긴다. 일반 답변, 단일 흐름, 직접 파일 작성은 허용하되, 해당 하네스의 Orchestrator Skill, Agent Team, 작업 Skill 호출은 쓰지 않는다.

### 벤치마크 저장 구조

비교 결과는 임시 메모가 아니라 다음 개선에서 다시 읽을 수 있는 벤치마크 기록으로 남긴다. 다만 두께에 따라 파일 수를 조절한다.

`light` 최소 구조:

```text
artifacts/evals/iteration-N/{eval-name}/
├── prompt.md
└── comparison.md
```

`targeted` 구조:

```text
artifacts/evals/iteration-N/{eval-name}/
├── prompt.md
├── run-config.md
├── target-input.md
├── with-harness-output.md
├── without-harness-output.md
└── comparison.md
```

`full` 구조:

```text
artifacts/evals/iteration-N/{eval-name}/
├── prompt.md
├── run-config.md
├── with-harness/
│   ├── output.md
│   └── metrics.json
├── without-harness/
│   ├── output.md
│   └── metrics.json
└── comparison.md
```

파일별 역할:

| 파일 | 내용 |
| --- | --- |
| `prompt.md` | 두 실행에 공통으로 준 사용자 요청, 입력 자료, 제약 |
| `run-config.md` | 벤치마크 두께, 실행 일시, 모델 정책, 허용/금지한 하네스 요소, 평가 기준 |
| `target-input.md` | `targeted`에서 비교할 Phase 입력, 이전 산출물, 기대 출력 |
| `with-harness-output.md` | `targeted`에서 하네스 구간을 사용한 결과 |
| `without-harness-output.md` | `targeted`에서 같은 입력을 하네스 구간 없이 처리한 기준 결과 |
| `with-harness/output.md` | Orchestrator·Skill·Agent Team을 사용한 결과 |
| `with-harness/metrics.json` | with 실행의 `total_tokens`, `duration_ms`, 완료 상태 |
| `without-harness/output.md` | 하네스를 사용하지 않은 기준 결과 |
| `without-harness/metrics.json` | without 실행의 `total_tokens`, `duration_ms`, 완료 상태 |
| `comparison.md` | 품질 판정, 비용 대비 개선 여부, 다음 버전 수정 후보 |

### 벤치마크 파일 형식

`run-config.md`에는 두 실행의 차이가 입력 차이가 아니라 실행 방식 차이였음을 증명할 수 있게 적는다.

```md
# Eval Run Config

- eval name:
- iteration:
- benchmark thickness: light | targeted | full
- 실행 일시:
- 공통 프롬프트: `prompt.md`
- 공통 입력 자료:
- targeted 범위:
- 모델 정책: 각 Agent의 `model`을 역할별 루브릭(haiku/sonnet/opus/fable, 균형 작업은 sonnet 또는 inherit)으로 정한 값과, Agent Team teammate 모델 설정 또는 팀 생성 지시문을 기록한다.
- with-harness 허용: Orchestrator, Skill, Agent Team
- without-harness 금지: 해당 하네스의 Orchestrator Skill, Agent Team, 작업 Skill 호출
- 평가 기준:
```

`metrics.json`은 with와 without 양쪽에 같은 형식으로 둔다.

```json
{
  "total_tokens": null,
  "duration_ms": null,
  "status": "completed",
  "notes": ""
}
```

`comparison.md`는 판정과 다음 개선으로 바로 이어지게 쓴다.

```md
# Benchmark Comparison

- eval name:
- winner: with-harness | without-harness | tie | inconclusive
- verdict:

## Quality

| 기준 | with-harness | without-harness | 판정 근거 |
| --- | --- | --- | --- |

## Cost

| 항목 | with-harness | without-harness | 차이 |
| --- | --- | --- | --- |
| total_tokens |  |  |  |
| duration_ms |  |  |  |

## Next Changes

- 유지할 점:
- 줄일 점:
- 다음 버전 수정 후보:
```

### 비교 기준 고르기

| 상황 | 기준 실행 |
| --- | --- |
| 새 하네스를 처음 만들 때 | `without-harness`: 하네스 없이 같은 프롬프트 실행 |
| 기존 하네스를 개선할 때 | 수정 전 버전(Agent·Skill 스냅샷 보존). 필요하면 `without-harness`도 함께 유지 |

기존 하네스를 고칠 때는 수정 전 Agent·Skill을 스냅샷으로 남겨, 새 버전과 옛 버전을 같은 프롬프트로 비교한다.

### 무엇을 기록할까

- 산출물: `light`는 핵심 결과를 `comparison.md`에 요약하고, `targeted`와 `full`은 비교 대상 산출물을 별도 파일로 저장한다.
- 측정값: 실행 완료 알림의 `total_tokens`, `duration_ms`를 그 자리에서 저장한다. 알림 시점이 지나면 복구할 수 없다. `light`에서 측정값을 못 얻었으면 `알 수 없음`으로 두고 억지로 추정하지 않는다.
- 판정: `comparison.md`에 with-harness가 without-harness보다 나은지, 같은지, 오히려 나쁜지 적는다.

비교 기준:

- 산출물이 더 구조적인가?
- 빠진 정보가 줄었는가?
- 검토 단계가 실제 오류를 잡았는가?
- 사용자가 다음 행동을 하기 쉬워졌는가?
- 설명이 독자 수준에 맞는가?

### 변동성(variance) 다루기

에이전트 실행은 비결정적이라, with/without를 **한 번씩만** 돌린 비교는 운으로 뒤집힐 수 있다. 단발 결과를 그대로 "하네스가 낫다/아니다"의 결론으로 쓰지 않는다.

- 단발 금지: 대표 프롬프트 1개라도 양쪽을 **2~3회** 시행한다. `light`는 같은 프롬프트를 반복 실행해 결과가 흔들리는지만 보고, `targeted`·`full`은 시행마다 `metrics.json`을 남긴다.
- 효과 대 흔들림: 시행 간 품질·토큰 편차가 with/without 차이보다 크면 결론을 내리지 말고 `winner: inconclusive`로 둔 뒤, 더 차별력 있는 평가 항목으로 바꾸거나 시행 수를 늘린다.
- 같은 입력 고정: 변동의 원인을 실행 방식으로 좁히려면 프롬프트·입력 자료·모델 정책을 동일하게 두고, 달라진 것이 하네스 사용 여부뿐이게 한다.
- 결정적 항목은 분리: `scripts/`로 채점되는 객관 항목(링크·숫자·섹션·금지어)은 시행마다 흔들리지 않으므로 변동성 판단에서 빼고, 흔들리는 판단 항목에만 다회 시행을 적용한다.

작은 하네스에서 매번 다회 시행이 과하면, 최소한 "단발이라 결론이 약함"을 `comparison.md`에 명시해 과신을 막는다.
- 토큰과 시간이 더 들었다면, 그만큼의 품질 향상이 있었는가?

### 블라인드 비교(선택)

"새 버전이 정말 더 나은가"를 엄밀히 보고 싶으면, 두 산출물을 A/B로 익명화해 어느 쪽이 하네스 결과인지 모르는 상태에서 품질을 판정한다. 일반적인 반복 개선에서는 생략해도 된다. 시간·토큰이 늘었는데 품질이 비슷하면 하네스를 더 얇게 만드는 신호로 본다.

## Assertion 기반 검증

객관적으로 판단할 수 있는 항목은 assertion으로 만든다.

```json
{
  "expectations": [
    {
      "text": "artifacts/README.md에 산출물 지도가 있다",
      "passed": true,
      "evidence": "README.md의 산출물 지도 표 확인"
    }
  ],
  "summary": {
    "passed": 1,
    "failed": 0,
    "total": 1,
    "pass_rate": 1.0
  }
}
```

두 구성 모두에서 항상 통과하는 항목만 있으면 하네스의 차별적 가치가 보이지 않는다.

## Agent Team 검증

| 검증 항목 | 확인 방법 |
| --- | --- |
| 팀 구성 | Orchestrator에 `TeamCreate` 대상 Agent가 명시되어 있는지 확인 |
| Agent frontmatter | 각 Agent에 `name`, `description`, `tools`, `model`이 있고 역할과 맞는지 확인 |
| 모델 정합성 | 각 Agent의 `model`이 역할 루브릭(haiku=정적·추출 / sonnet=분석·리뷰·작성 / opus=설계·상충해소 / fable=장시간 자율)과 맞는지, 한 팀이 전부 같은 모델(일괄 opus=과지출, 일괄 생략=티어 무시)은 아닌지 확인 |
| 이름 정합성 | Agent 파일명, frontmatter `name`, Orchestrator의 호출 이름이 일치하는지 확인 |
| 작업 등록 | Task마다 담당자, 입력, 출력, 의존, 완료 기준이 있는지 확인 |
| 작업 상태 | `TaskUpdate`로 시작, 차단, 완료, 재할당을 표시하는 기준이 있는지 확인 |
| 진행 확인 | `TaskGet`으로 Phase 전환 전 누락과 지연을 확인하는지 확인 |
| 메시지 규칙 | `SendMessage`가 필요한 발견, 질문, 충돌, 차단, 완료 조건이 있는지 확인 |
| 파일 산출물 | 각 Agent가 자기 결과를 `artifacts/`에 남기도록 되어 있는지 확인 |
| 산출물 지도 | `artifacts/README.md`에 만든 Agent, 다음에 읽는 Agent, 파일 상태, 승인 상태가 적혀 있는지 확인 |
| stale 처리 | 부분 재실행에서 뒤 단계 산출물을 `stale` 또는 `needs-review`로 표시하는지 확인 |
| 팀 정리 | 실행 종료 또는 팀 재구성 시 `TeamDelete` 조건이 있는지 확인 |
| 팀 재구성 | 중첩 팀 대신 `handoff.md`와 새 팀 생성 절차가 있는지 확인 |
| 후속 실행 | 재실행, 부분 수정, 업데이트, 이전 결과 기반 개선 분기가 있는지 확인 |

## QA Agent 원칙

QA Agent의 목적은 "괜찮아 보인다"라고 말하는 것이 아니라, 산출물과 구현 사이의 경계면이 실제로 맞는지 확인하는 것이다. QA는 존재 확인보다 교차 검증을 우선한다.

| 약한 QA | 강한 QA |
| --- | --- |
| 파일이 있는가? | 그 파일이 다음 단계의 입력 형식과 맞는가? |
| API가 있는가? | API 응답 shape과 호출부 타입이 일치하는가? |
| 초안이 있는가? | 초안이 요구사항, 근거, 승인 조건을 모두 반영하는가? |
| 체크리스트가 있는가? | 체크리스트 항목이 산출물에서 증거로 확인되는가? |

QA Agent는 통과, 실패, 미검증, 사람 승인 필요를 분리해 보고한다.

QA는 전체가 끝난 뒤 한 번만 실행하지 않는다. 중간 산출물이 다음 단계의 입력이 되거나, 코드/문서/제출물의 경계면이 바뀌는 지점마다 점진적으로 실행한다.

점진 QA가 필요한 시점:

- 요구사항 정리 후 초안 또는 구현으로 넘어가기 전
- API, 데이터 형식, 문서 구조처럼 다음 단계가 의존하는 계약이 바뀐 직후
- 작성자 Agent가 초안을 저장한 직후
- Reviewer 지적을 반영한 직후
- 최종 제출, 발송, 배포, 삭제 전

## 경계면 교차 검증

| 검증 대상 | 생산자 | 소비자 | 확인 질문 |
| --- | --- | --- | --- |
| 산출물 전달 | 이전 Agent의 출력 파일 | 다음 Agent의 입력 조건 | 다음 단계가 필요한 필드를 실제로 받을 수 있는가? |
| 요구사항 반영 | `00-input.md`의 목표와 제약 | 초안, 구현, 최종 결과 | 입력 조건이 빠지거나 바뀌지 않았는가? |
| 검토 반영 | `30-review/` 또는 `03-review.md` | 수정본, 최종본 | 지적 사항이 반영, 보류, 거절 중 하나로 처리됐는가? |
| 승인 조건 | 승인 필요 목록 | 최종 산출물 | 사람 확인 전 완료처럼 표현하지 않았는가? |
| 최신 상태 | `artifacts/README.md` | 중간 산출물, 최종 산출물 | 앞 단계 변경 후 뒤 단계가 stale로 표시됐는가? |
| 코드 연결 | API, 타입, 라우트, 상태 | 훅, UI, 테스트 | 생산자와 소비자의 계약이 일치하는가? |

## QA 산출물 형식

```md
# QA Review

## 요약

- 통과:
- 실패:
- 미검증:
- 사람 승인 필요:

## 상세 검증

| 기준 | 판정 | 근거 | 설명 | 조치 |
| --- | --- | --- | --- | --- |

## 경계면 이슈

| 생산자 | 소비자 | 문제 | 영향 | 권장 조치 |
| --- | --- | --- | --- | --- |

## 미검증 영역

- 
```

## 하네스 테스트 체크리스트

- [ ] 요청의 목적을 다시 말해준다.
- [ ] 최종 산출물 형식을 분명히 한다.
- [ ] 최종 산출물에 `사용 가능`, `사람 승인 필요`, `미검증 영역`이 구분되어 있다.
- [ ] 역할이 너무 많거나 적지 않다.
- [ ] Agent와 Skill의 책임이 겹치지 않는다.
- [ ] 각 Agent frontmatter에 역할에 맞는 `tools`가 있다.
- [ ] 각 Agent frontmatter에 `model`이 있고(생략 시 inherit를 의도한 것인지 확인), 역할 루브릭(haiku/sonnet/opus/fable)과 맞는다.
- [ ] 한 팀의 Agent가 전부 같은 모델이 아니다(일괄 opus=과지출, 일괄 생략=티어 무시). 역할별로 티어가 갈렸는지 확인한다.
- [ ] Agent Team 하네스면 frontmatter `model`과 Orchestrator의 `TeamCreate` 모델 정책이 일치한다(팀 모드에서는 frontmatter만으로 런타임 모델이 보장되지 않는다).
- [ ] 각 Agent를 배정한 model 티어로 실제 테스트했다(haiku=지침이 충분한가, opus=과설명 아닌가).
- [ ] 산출물 계약에서 파일을 소유한 모든 Agent가 그 파일을 만들 `Write` 권한을 갖췄다(검토·QA도 자기 판정 파일을 쓰므로 포함). 권한과 산출물이 어긋나면 저장 실패나 헛보고가 난다.
- [ ] Agent 파일명, frontmatter `name`, Orchestrator의 호출 이름이 일치한다.
- [ ] Orchestrator가 중간 산출물을 이어준다.
- [ ] `artifacts/README.md`에 산출물 지도와 다음 단계가 읽을 파일이 적혀 있다.
- [ ] `artifacts/README.md`에 각 산출물의 상태가 `current`, `stale`, `needs-review`, `archived` 중 하나로 표시되어 있다.
- [ ] `artifacts/README.md`에 승인 상태가 `사용 가능`, `사람 승인 필요`, `미검증 영역 있음`, `해당 없음` 중 하나로 파일 상태와 분리되어 있다.
- [ ] 단계별 중간 산출물과 최종 산출물이 대화가 아니라 파일로 남는다.
- [ ] 부분 재실행으로 앞 단계가 바뀌면 뒤 단계 산출물이 `stale`로 표시된다.
- [ ] Agent Team 하네스라면 `TeamCreate`, `TaskCreate`, `TaskUpdate`, `TaskGet`, `SendMessage`, `TeamDelete` 흐름이 있다.
- [ ] QA Agent가 있다면 존재 확인보다 경계면 교차 검증을 수행한다.
- [ ] QA Agent가 있다면 전체 완료 후 1회가 아니라 중요한 중간 산출물 직후 점진적으로 실행된다.
- [ ] 항상 통과하는 검토 단계가 있으면 결함 주입으로 살아 있는지 확인하고, 결함 입력을 `artifacts/evals/regression/`에 회귀 세트로 보관한다.
- [ ] `CLAUDE.md`에 자연어 요청을 Orchestrator Skill로 연결하는 규칙이 있다.
- [ ] Orchestrator description에 재실행, 업데이트, 수정, 보완, 이전 결과 기반, 특정 단계만 다시 같은 후속 작업 키워드가 있다.
- [ ] with/without 비교를 한다면 `light`, `targeted`, `full` 중 두께를 먼저 고르고, `artifacts/evals/iteration-N/{eval-name}/comparison.md`에 토큰·시간 대비 품질 향상을 근거로 남긴다.
- [ ] 트리거 검증에 경계가 애매한 near-miss should-not-trigger와 기존 Skill 충돌 확인이 포함된다.
- [ ] 애매한 요청에서 필요한 질문을 한다.
- [ ] 실패 위험 사례에서 추측을 단정하지 않는다.
- [ ] 외부 발송, 제출, 삭제, 결제, 개인정보 처리에는 사람 승인 지점이 있다.
- [ ] 승인 지점에서 실제로 사용자에게 승인을 요청하고 멈춘다. 라벨만 붙이거나 묻지 않고 통과하지 않는다(승인 게이트가 능동적으로 동작하는지 부정 테스트로 확인).
- [ ] Skill description에 써야 할 상황과 쓰면 안 되는 상황이 함께 있다.
- [ ] `.claude/commands/`를 새로 만들지 않았다.
- [ ] 개선할 점을 기록한다.

## Trigger 검증 — near-miss 중심

Skill과 Orchestrator의 description은 실제 사용자가 말할 법한 문장으로 검증한다. 핵심은 명백한 정답이 아니라, 경계가 애매한 near-miss를 가려내는 것이다.

| 테스트 | 권장 개수 | 기준 |
| --- | --- | --- |
| Should trigger | 8-10개 | 반드시 이 Skill 또는 Orchestrator가 실행되어야 하는 표현 |
| Should not trigger | 8-10개 | 키워드는 비슷하지만 다른 Skill이나 직접 응답이 맞는 near-miss 표현 |

### 쿼리 작성 기준

- 실제 사용자가 입력할 법한 구체적이고 자연스러운 문장으로 쓴다. 파일명, 회사명, 개인 맥락 같은 디테일을 넣는다.
- 톤(공식·캐주얼), 길이, 형식을 섞는다. 일부는 약어나 오타를 포함한다.
- 명백한 정답보다 경계 케이스에 집중한다.

### Should trigger 쿼리

- 같은 의도를 다른 표현으로 말한 경우(공식·캐주얼)
- 하네스나 산출물 종류를 직접 말하지 않지만 분명히 필요한 경우
- 비주류 사용 사례
- 다른 Skill과 경쟁하지만 이 하네스가 이겨야 하는 경우

### Should not trigger 쿼리 — near-miss가 핵심

- 키워드는 겹치지만 다른 도구나 직접 응답이 맞는 경우
- 명백히 무관한 문장("피보나치 함수 작성")은 테스트 가치가 없다
- 인접 도메인, 모호한 표현, 키워드는 같지만 맥락이 다른 경우

예시:

- 회의록 하네스라면 "회의록 작성"은 trigger, "완성된 회의록의 맞춤법만 고쳐줘"는 should not trigger다.
- 산출물 하네스라면 "매출 리포트 대시보드 만들어줘"는 trigger, "이 엑셀의 차트를 PNG로 추출만 해줘"는 다른 도구가 맞는 near-miss다.

### 기존 Skill 충돌 검증

새 하네스의 description이 기존 Skill의 트리거 영역과 겹치지 않는지 확인한다.

1. 기존 `.claude/skills/`의 description을 모은다.
2. 새 하네스의 should-trigger 쿼리가 기존 Skill을 잘못 트리거하지 않는지 본다.
3. 겹치면 description에 "쓰면 안 되는 상황"을 더 분명히 적어 경계를 만든다.

검증 결과는 `artifacts/evals/triggers.md`에 남긴다.

## 기존 하네스 감사 절차

1. `CLAUDE.md`에서 하네스 포인터와 자연어 라우팅 규칙을 확인한다.
2. `.claude/agents/` 목록을 확인한다.
3. `.claude/skills/` 목록과 Orchestrator Skill을 확인한다.
4. Orchestrator의 Agent 목록과 실제 Agent 파일, frontmatter `name`이 일치하는지 본다.
5. Orchestrator의 Skill 목록과 실제 Skill 폴더가 일치하는지 본다.
6. 각 Agent의 `tools`가 역할과 맞고 너무 넓지 않은지 본다.
7. 각 Skill의 `description`이 있고, frontmatter `name`을 쓴다면 폴더명과 충돌하지 않는지 본다.
8. Agent Team 하네스라면 팀 생성, 작업 등록, 메시지 규칙, 파일 산출물, 팀 정리 절차가 있는지 확인한다.
9. `artifacts/README.md`의 산출물 상태와 부분 재실행 기록을 확인한다.
10. 테스트 프롬프트, 실패 처리, 사람 승인 조건이 있는지 확인한다.
11. 오래된 Agent, 쓰이지 않는 Skill, 중복된 규칙을 표시한다.

## Drift 점검표

| 점검 항목 | 좋은 상태 | 위험 신호 |
| --- | --- | --- |
| `CLAUDE.md` 포인터 | 하네스 이름과 Orchestrator가 맞다 | 예전 Skill 이름을 가리킨다 |
| Agent 목록 | Orchestrator가 부르는 Agent가 실제 존재하고 `name`이 일치한다 | 삭제된 Agent를 아직 호출하거나 파일명과 `name`이 다르다 |
| Agent 권한 | `tools`가 역할별로 좁게 지정되어 있다 | 모든 Agent가 모든 도구를 가진다 |
| Skill 목록 | 작업 Skill과 Orchestrator 책임이 구분된다 | Orchestrator가 일반 작업까지 모두 직접 한다 |
| Agent Team 계약 | TeamCreate, TaskCreate, TaskUpdate, TaskGet, SendMessage, TeamDelete 흐름이 있다 | Agent 파일만 있고 팀 실행 절차가 없다 |
| 산출물 경로 | 단계별 파일명과 최신 상태가 정해져 있다 | 중간 결과가 대화에만 남거나 stale 결과를 그대로 쓴다 |
| 검증 | 테스트와 체크리스트가 있다 | "검토한다"만 있고 기준이 없다 |
| 승인 | 최종 산출물에 승인 상태가 표시되고 위험 행동 전에 멈춘다 | 외부 발송, 제출, 삭제를 자동으로 끝낸다 |
| 기록 | 변경 이력이 있다 | 언제 왜 바꿨는지 모른다 |

## 하네스 덜어내기 진단

하네스는 두꺼워지기만 하면 안 된다. 모든 Agent, Skill, 검증 단계는 "모델이 혼자서는 잘 못 하는 것"을 대신 채우는 장치다. 모델이 좋아지거나 업무가 단순해지면, 한때 필요했던 조각이 이제는 토큰만 쓰고 품질에는 기여하지 않을 수 있다. 운영/유지보수 점검에서는 추가뿐 아니라 제거 후보도 함께 찾는다.

진단 질문:

| 조각 | 남길 신호 | 덜어낼 신호 |
| --- | --- | --- |
| 특정 Agent | 빠지면 품질·안전이 눈에 띄게 떨어진다 | 다른 Agent나 Orchestrator 단계로 흡수해도 결과가 같다 |
| 특정 Skill | 반복 절차가 분명하고 여러 곳에서 쓴다 | 한 번만 쓰이고 본문이 일반 지시와 다를 바 없다 |
| 특정 검증 단계 | with/without에서 실제 오류를 잡아낸다 | 양쪽에서 항상 통과해 차별력이 없다 |
| 두꺼운 지시·제약 | 없으면 결과가 흔들린다 | 모델이 이미 일관되게 지키는 내용을 반복 지시한다 |

제거는 추측으로 하지 않는다. 의심되는 조각을 하나만 빼고 대표 프롬프트로 with/without 비교(`light` 두께면 충분)를 돌려 품질 영향을 확인한 뒤, 영향이 없으면 제거 후보로 표시한다. 한 번에 여러 조각을 빼면 어느 것이 영향을 줬는지 알 수 없으므로 하나씩 검증한다. 제거한 조각과 사유는 개선 기록과 변경 이력에 남겨, 나중에 모델이 약해지거나 업무가 복잡해질 때 되살릴 근거로 둔다.

## 개선 기록과 ADR 형식

```md
## 개선 기록

- 날짜:
- 실행한 요청:
- 기대한 결과:
- 실제 결과:
- 잘된 점:
- 막힌 점:
- 다음 버전에서 바꿀 규칙:
```

기존 하네스를 수정했다면 `CLAUDE.md` 또는 하네스 문서에 아래 표를 남긴다.

```md
## 하네스 변경 이력

| 날짜 | 변경 내용 | 대상 | 사유 |
| --- | --- | --- | --- |
| YYYY-MM-DD | Reviewer Skill 기준 보강 | `.claude/skills/reviewer/SKILL.md` | 검토 누락 반복 |
```

큰 구조 결정(Agent Team vs 단일 흐름, 하네스 두께, 패턴 선택, 역할 분리·병합, 검증 조각 추가·제거)은 변경 이력 한 줄로 끝내지 말고 ADR로 남긴다. 파일은 `artifacts/decisions/ADR-{번호}-{제목}.md`에 두거나 개선 기록 문서 안에 넣는다.

```md
# ADR-001: {결정 제목}

- 날짜: YYYY-MM-DD
- 상태: 제안 | 채택 | 폐기 | 대체됨(→ ADR-00N)

## 맥락
- 어떤 문제·제약 때문에 결정이 필요했는가.

## 결정
- 무엇으로 정했는가.

## 버린 대안과 이유
- 대안 A — 버린 이유.
- 대안 B — 버린 이유.

## 가정·트레이드오프
- 이 결정이 성립하는 전제와, 받아들인 비용.

## 재검토 조건
- 어떤 신호(모델 향상, 업무 변화, 품질 저하)가 보이면 이 결정을 다시 연다.
```

변경 이력은 "무엇이 언제 바뀌었나"(시간 순 추적)이고, ADR은 "왜 이렇고 무엇을 포기했나"(결정의 근거)이다. 역할이 다르므로 함께 쓴다. 특히 **재검토 조건**은 하네스 덜어내기 진단에서 각 조각의 제거 여부를 판단하는 직접 근거가 된다.
