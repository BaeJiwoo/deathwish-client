# Unity 클라이언트 테스트

## 실행 환경

[빠른 실행](../README.md#빠른-실행)에 따라 서버와 클라이언트를 켭니다. 아래 예제는 한 PC에서 방 두 개를 열고 `127.0.0.1:17779`의 **2번 방(PhysicsLab)**에 접속하는 경우입니다. 서버 기본 포트는 `7777`입니다. 다른 포트로 기동했다면 Unity의 Port와 MockClient의 `-Port`를 서버의 `Listening on` 값에 맞춥니다.

## 어깨 시점과 맵 확인

**Capture input**을 누르면 연결 패널이 닫히고 화면 중앙에 조준선이 나타납니다. 기본 설정에서 캐릭터는 왼쪽에 보입니다. Q로 어깨를 바꾼 뒤 같은 목표물을 조준선에 놓고 좌클릭해 양쪽 시점의 명중 결과를 확인합니다. Esc를 누르면 설정 패널이 열립니다. **Shoulder** 버튼으로도 전환할 수 있으며, 재실행하면 마지막 설정을 복원합니다.

PhysicsLab에서 경사로 양옆, 발판 바깥과 구멍 둘레, 바닥과 벽의 경계를 따라 검정·노랑 사선이 이어지는지 확인합니다. 일반 방에서는 바닥 외곽을 확인합니다.

## 사격 효과와 카메라 설정

1. 벽을 조준해 좌클릭합니다. 캐릭터 앞에서 뻗는 탄 궤적 끝에 주황 링이 나타납니다. 상대 플레이어를 맞히면 붉은 링이 나타납니다. 하늘을 향해 빗맞히면 탄 궤적만 보입니다.
2. Unity **Scene** 뷰의 **Gizmos**를 켭니다. 발사 후 4초 동안 카메라 레이와 시작점이 표시됩니다. 명중점에는 구가 추가되고 빗나간 레이는 청록색입니다. 컨트롤러의 **Show Raycast Gizmos**로 끌 수 있습니다.
3. Esc로 설정 패널을 열고 **Side**, **Height**, **Back**을 변경합니다. 기본은 각각 0.9 m, 1.55 m, 3.3 m입니다. Q로 어깨를 전환하면 좌우 간격만 반전됩니다. 벽 옆에서 카메라가 당겨지고, 멀어지면 설정한 거리로 돌아오는지 확인합니다.
4. 설정 범위는 좌우 간격 0–1.6 m, 높이 0.6–2.3 m, 뒤쪽 거리 1–5 m입니다. 범위를 벗어난 값은 최솟값 또는 최댓값으로 맞춥니다. 재실행하면 마지막 확정 값을 복원합니다.

## MockClient와 같은 방에서 확인

1. 서버를 실행한 터미널은 열어 두고, **서버 저장소 루트**에서 두 번째 PowerShell을 엽니다.

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\mockclient\Start-MockClient.ps1 -Port 17779
   ```

2. 새로 열린 **MockClient 콘솔**에 다음 두 줄을 차례로 입력합니다. `World ready`는 방 입장이 끝났다는 뜻입니다.

   ```text
   /join 2
   /wasd
   ```

3. Unity도 같은 방에 접속하면 다른 접속자가 없는 상태에서 **Players: 2**가 표시됩니다. MockClient 창에서 W를 누르면 Unity에서 노란색 상대 캡슐이 이동합니다. 파란색은 본인입니다. 상대를 찾으려면 Scene 뷰에서 **Gizmos**를 켜고 `PLAYER` 표식을 확인합니다.
4. Unity의 Game 뷰에서 **Capture input**을 누르고 다음 항목을 확인합니다.

   | 입력 | 기대 결과 |
   | --- | --- |
   | 평지에서 Space | Y가 약 1.8m 상승했다가 착지함. 공중에서 한 번 더 눌러도 다시 뛰지 않음 |
   | 지형이나 상대 플레이어를 화면 중앙에 두고 좌클릭 | 상태창과 Unity Console에 서버가 판정한 충돌 대상, 월드 좌표, 거리(m)가 표시됨 |
   | 최대 거리 100m 안에 충돌 대상이 없는 방향으로 좌클릭 | `Raycast miss`가 표시됨 |

5. MockClient 창에서 Esc로 명령 모드에 돌아가 `/quit`을 입력합니다. Unity의 Players가 1로 줄고 노란색 캡슐이 사라지는지 확인합니다. Unity에서는 Esc로 커서를 해제한 뒤 **Disconnect**를 누릅니다.

## 서버 연동 파일 갱신

이 브랜치에는 실행에 필요한 DLL과 씬이 들어 있습니다. 프로토콜이나 공용 통신 코드가 바뀌었거나 예전 클라이언트를 갱신할 때는 Unity를 닫고 **호환되는 서버 저장소 루트**에서 실행합니다.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\integrations\Unity\Install.ps1 -UnityProject ..\deathwish-client
```

예제는 두 저장소가 같은 부모 폴더 아래에 있는 경우입니다. 다른 위치라면 `-UnityProject`에 클라이언트 루트의 실제 경로를 지정합니다. 설치기는 통신 DLL, `SyncTestClient.cs`, PhysicsLab 데이터와 셰이더를 갱신하고, 기본 씬은 새 HUD가 포함된 버전으로 업그레이드합니다. 직접 수정한 씬은 보존하며, 이 경우 설치기에 표시된 안내에 따라 새 HUD와 설정 버튼을 연결합니다.

## 문제 해결

| 증상 | 확인할 항목 |
| --- | --- |
| 연결 거부 또는 시간 초과 | 서버 콘솔의 주소·포트와 Unity 입력값. 다른 PC에서 접속한다면 서버가 수신 중인 LAN 주소 사용 |
| 빈 화면 또는 접속 버튼 없음 | Project 창에서 [SyncTestScene](../Assets/DeathWishMovement/Scenes/SyncTestScene.unity)을 열고 Play |
| 접속했지만 조작되지 않음 | `Connected`와 Player ID 확인 후 Game 뷰에서 **Capture input** 클릭. Player Settings의 **Active Input Handling**은 **Input Manager (Old)** 또는 **Both** |
| 두 명이 접속했는데 Players가 1 | 서버 주소·포트·방 번호 일치 여부 확인. 방을 바꾸려면 Disconnect 후 다시 입장 |
| 이동은 되지만 점프·좌클릭 시 연결 종료 | 서버와 클라이언트가 모두 점프·레이캐스트 패킷을 지원하는 버전인지 확인 후 연동 파일 갱신 |
| MockClient에서 `/wasd`를 사용할 수 없음 | 위 런처가 여는 독립 Windows Console Host 사용. VS Code 통합 터미널에서는 `/join 2` 후 `/move 1 0`으로 이동 입력 확인 |

## 서버 권위 걷기 애니메이션

1. 서버와 Unity 클라이언트에서 `codex/server-authoritative-animation` 브랜치를 함께 사용합니다. 서버 주소와 포트를 입력하고 방 1에 입장한 뒤 **Capture input**을 누릅니다.
2. WASD로 이동하면 서버가 계산한 방향과 관절로 캐릭터가 걷습니다. 키를 놓거나 PhysicsLab의 벽을 향해 계속 이동하면 정지 자세로 표시됩니다.
3. 같은 방의 두 번째 Unity나 MockClient를 움직여 원격 캐릭터의 위치와 관절도 함께 바뀌는지 확인합니다. 서버 프레임이 잠시 멈추면 마지막 수신 자세에서 멈춥니다.

**Use Server Animation**은 `SyncTestController` Inspector의 연결 설정입니다. 위치 스냅샷만 지원하는 서버에 접속할 때는 설정을 끈 뒤 연결합니다.

DeathWish는 11본 리그와 1초 길이의 제자리 걷기를 사용합니다. 서버의 위치와 자세는 100ms 지연 타임라인에서 보간합니다. 부위별 박스 10개는 포즈를 따라 움직이고, 레이캐스트는 기존 서버 충돌체를 사용합니다.
