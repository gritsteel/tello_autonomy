# FFCA-YOLO
The corresponding paper title for this project is “FFCA-YOLO for Small Object Detection in Remote Sensing Images”.
In the future, various data and codes in the paper will gradually be opened up.

# FFCA-YOLO connection

실시간 추론에 필요한 FFCA-YOLO 소스와 가중치는 `tello_autonomy/ffca_yolo` 안에 포함한다.
학습 스크립트와 데이터셋 전체는 포함하지 않으므로 재학습은 원본 FFCA-YOLO 프로젝트에서
진행하고, 완료된 `best.pt`만 아래 weights 경로로 교체한다.

```text
C:\dev\tello-RTSP-drone\
├─ tello_autonomy\
│  ├─ ffca_detector.py
│  ├─ detectors.py
│  └─ ffca_yolo\
│     ├─ models\
│     ├─ utils\
│     ├─ data\AITOD.yaml
│     └─ weights\best.pt
├─ requirements_tello_windows.txt
├─ setup_tello_windows.ps1
├─ run_tello_sim.ps1
└─ run_tello_observe.ps1
```

## TEST(하방 반사경 아이디어 + @)
```
thingiverse.com/thing:2911427
```

## Tello EDU autonomous object detection

Tello EDU용 코드와 FFCA-YOLO 추론 런타임은 모두 `tello_autonomy` 패키지에 있다.
`bebop_camera_inference.py`와 pyparrot은 필요하지 않다. 기본 실행은 실제 프로펠러를
돌리지 않는 폐루프 시뮬레이션이다.

```powershell
powershell -ExecutionPolicy Bypass -File .\setup_tello_windows.ps1
powershell -ExecutionPolicy Bypass -File .\run_tello_sim.ps1
```

시뮬레이션은 비행물리 전체가 아니라 카메라 좌표계에서 탐지-제어 폐루프가 수렴하는지
검증한다. 결과는 `outputs/tello_sim`의 MP4, JSON 요약, CSV 추적으로 저장된다.

실제 드론은 먼저 영상·탐지만 확인한다. 이 명령은 이륙 또는 RC 명령을 보내지 않는다.

```powershell
powershell -ExecutionPolicy Bypass -File .\run_tello_observe.ps1
```

실제 이륙 모드는 별도의 `fly` 하위 명령과 명시적 arm token을 요구한다. 프로펠러 제거
연결 시험, 배터리·영상 지연·탐지 클래스 확인을 마친 뒤에만 사용한다. 전체 설계와 단계별
안전 체크리스트는 `TELLO_AUTONOMY_PLAN.md`를 참고한다.

```powershell
.\.venv-tello\Scripts\python.exe -m tello_autonomy fly `
  --arm-token TELLO_EDU `
  --duration 30 `
  --min-height 40 `
  --max-height 180
```

기본 TS-RPST 체크포인트는 항공영상 AI-TOD로 학습되어 Tello 전방 카메라와 시점·배경이
다르다. 따라서 실제 추적 비행 전에는 `observe`로 Tello 영상을 수집·라벨링하고 해당
시점으로 재학습한 체크포인트를 사용하는 것이 권장된다.
