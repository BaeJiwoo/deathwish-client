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

### Windows

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

### Linux

.NET 10 SDK가 필요합니다. 다음 명령은 서버와 클라이언트 저장소가 `~/deathwish` 아래에 있는 경우입니다.

1. 터미널 A에서 서버를 실행하고 `Listening on`이 표시되면 터미널을 열어 둡니다.

   ```bash
   cd ~/deathwish/deathwish-server
   SERVER_ROOM_COUNT=2 dotnet run --project src/DeathWish.Server -- 127.0.0.1 17779
   ```

2. 터미널 B에서 MockClient를 실행합니다.

   ```bash
   cd ~/deathwish/deathwish-server
   dotnet run --project mockclient/DeathWish.MockClient.Console -- 127.0.0.1 17779
   ```

3. `Connected.`가 표시되면 실행 중인 MockClient에 `/join 2`를 입력하고, `World ready`가 표시된 뒤 `/wasd`를 입력합니다.
4. Unity에서 `SyncTestScene`을 열고 **Play**를 누릅니다. Host `127.0.0.1`, Port `17779`, Room `2`로 접속하면 **Players: 2**가 표시됩니다. MockClient 터미널에서 W/A/S/D를 눌러 상대 캐릭터의 이동을 확인합니다.
5. Linux 터미널의 `/wasd`에서는 W/A/S/D 입력으로 이동하며, 마지막 키 입력 후 약 250ms가 지나면 정지합니다. 키를 계속 누르면 터미널의 키 반복으로 이동합니다. **Space**로 즉시 정지하고, **Esc**로 정지한 뒤 명령 모드로 돌아갑니다. 종료할 때는 `/quit`을 입력하고 서버 터미널에서 `Ctrl+C`를 누릅니다.

Linux 터미널은 키를 놓은 시점을 전달하지 않으므로 이동 정지에 지연이 있고, 키 반복이 시작될 때 잠시 멈출 수 있습니다. `/wasd`는 입력과 출력이 리다이렉트되지 않은 대화형 터미널에서 사용합니다. 대안인 `/move 1 0`은 한 번의 입력만 전송하며 새 입력이 없으면 만료됩니다.

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
| MockClient에서 `/wasd`를 사용할 수 없음 | Windows에서는 위 런처가 여는 독립 Console Host를 사용합니다. Linux에서는 대화형 터미널을 사용합니다. 그 외에는 `/join 2` 후 `/move 1 0`으로 이동 입력을 확인합니다. |

## Unity Animator 걷기 재생

1. 서버와 Unity 클라이언트에서 `codex/server-authoritative-animation` 브랜치를 함께 사용합니다. 서버 주소와 포트를 입력하고 방 1에 입장한 뒤 **Capture input**을 누릅니다.
2. WASD로 이동하면 Animator가 서버의 보행 주기에 맞춰 전진 걷기 동작을 재생하고 몸은 카메라의 수평 방향을 향합니다. 키를 놓거나 PhysicsLab의 벽을 향해 계속 이동하면 정지 자세로 표시됩니다.
3. 같은 방의 두 번째 Unity나 MockClient를 움직여 원격 캐릭터의 위치와 관절도 함께 바뀌는지 확인합니다. 서버 프레임이 잠시 멈추면 원격 캐릭터는 마지막 수신 자세를 유지합니다.

**Use Server Animation**은 `SyncTestController` Inspector의 연결 설정입니다. 위치 스냅샷만 지원하는 서버에 접속할 때는 설정을 끈 뒤 연결합니다.

Unity는 입장 모드 4로 위치·보행 상태와 카메라 조준 방향을 담은 20번 스냅숏을 받습니다. 원격 캐릭터의 위치·조준 방향·보행 주기를 100ms 지연 타임라인에서 함께 보간하고 Bob의 Animator에서 `ShooterWalk`와 `ShooterStand`를 전환합니다. 전진 클립에는 원본의 골반 상하 움직임, 발목과 발가락 회전이 포함됩니다. 루트 모션은 꺼져 있고 이동·충돌·레이캐스트는 서버가 담당합니다. Bob이 없는 설치본은 같은 상태와 주기로 단순 박스 리그를 표시합니다. 서버는 기존 기준인 수평 이동 5m당 한 주기를 사용하며 원본 FBX의 보폭은 약 1.81m이므로, 걷는 동안 발이 지면에서 미끄러져 보일 수 있습니다.

두 Unity 클라이언트로 같은 방에 접속합니다. 한쪽에서 **Capture input**을 누르고 WASD를 놓은 채 마우스만 움직입니다. 로컬 Bob은 즉시 좌우로 돌아서고, 위아래로 볼 때는 두 발을 수평으로 둔 채 상체와 AR 소총의 총구가 카메라 방향을 따릅니다. 오른손은 손잡이를 쥐고 왼손은 총의 앞쪽을 받칩니다. 상대 화면에서도 같은 동작을 확인합니다. D나 S를 누르고 이동하면서 다른 방향을 바라보거나 Q로 어깨를 바꾸어도 조준 방향은 화면 중앙의 카메라 레이와 평행합니다. 벽을 향해 클릭한 직후 옆으로 이동하면 궤적이 클릭 당시 총구 소켓에서 서버 명중점으로 이어집니다.

같은 방에서 한 명이 서 있는 채로 좌클릭한 다음 옆으로 걸으며 두 번 더 클릭합니다. 발사자 화면에서 클릭할 때마다 상체와 AR이 반동 후 조준 자세로 돌아오고, 관찰자 화면에서도 같은 캐릭터가 발사하는지 확인합니다. 빗맞혀도 사격 동작은 보입니다. 관찰자가 나중에 입장하면 그 뒤에 발생한 발사부터 표시됩니다.

Inspector의 **Show Position Gizmos**는 기본으로 켜져 있습니다. 자홍색 원은 최신 수신 서버 틱 위치, 청록색 마름모는 현재 렌더링한 보간 위치를 표시합니다. 두 위치가 다르면 연결선이 나타납니다.
