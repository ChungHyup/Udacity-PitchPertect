# PitchPertect
PitchPerfect 어플리케이션은 Udacity에 있는 "Intro to iOS APP development with swift" 강좌에서 제공하는 코드로 만들 수 있는 앱으로, 해당 리퍼지토리는 기존 PitchPerfect 에 추가 기능을 추가한 PitchPerfect_ChunghyupOh 를 관리하고 있습니다.

## 기본 기능
PitchPerfect는 음성을 녹음하고 6가지 다른 소리로 변조하여 재생 할 수 있는 기능을 가지고 있습니다.
2개의 scene으로 구성되서 하나의 scene에서 음성을 녹음하고, 다음 scene에서 6가지 다른 소리로 변조하서 재생을 할 수 있습니다.
6가지 다른 소리는 빠르게, 느리게, 음의 높이를 높게, 낮게, echo, reverb 가 있습니다.

## 추가 기능
PitchPerfect_ChunghyupOh는 기존 PitchPerfect에 Audio player와 같은 기능을 넣음으로써 사용자가 PitchPerfect의 기능을 즐기기에 더욱 편리하도록 추가기능을 구현하였습니다. 구현 내용은 아래 목록과 같습니다.
1. Stack view

  두번째 화면 뿐만 아니라 첫번쨰 화면 역시 stackView로 구성을 하였습니다.

1. Duration

  녹음 버튼을 누를시 녹음이 시작부터 흐른 시간을 mm:ss 형식으로 보여줍니다.

1. Pause recording

  언제든지 녹음을 일시정지한 후 이어서 녹음을 계속 할 수 있습니다.

1. Slider

  현재 재생중인 오디오의 상태를 "currentTime(mm:ss) : totalDuration(mm : ss)" 의 포멧으로 보여주며, 슬라이더를 이동할 경우 currentTime 값이 변화하여 사용자가 이동하고자 하는 시간대를 비교적 정확하게 이동 할 수 있도록 도와줍니다. 오디오가 재생중인 상태에서는 슬라이더를 이동 시 이동된 위치에서 바로 재생되며 일시정지가 된 상태에서는 재생 버튼을 눌러야만 재생이 됩니다.</br>
  또한 재생중에도 mm:ss뿐만 아니라 slider가 함께 움직여 사용자가 현재 재생중인 부분이 전체 오디오에서 어느 부분을 재생중인 것인지 확인 할 수 있습니다.

1. play, pause

  오디오가 재생중에도 slider를 통해 재생 위치를 변경 할 수 있지만, 사용자가 원할 경우 일시정지 버튼을 통해 오디오를 멈춘후 슬라이더를 조작 할 수 있습니다.

## 스크린샷
<img src="/image/image1.png" width="200"/></br>
앱을 실행하였을 시 화면입니다. </br>
<img src="/image/image2.png" width="200"/></br>
녹음을 시작 할 시 녹음중인 audio의 길이를 표시해줍니다.</br>
일시정지 버튼을 통해 일시정지 후 이어서 녹음할 수 있습니다. </br>
<img src="/image/image3.png" width="200"/></br>
녹을을 완료 할 경우 위와 같은 화면이 나타납니다. </br>
<img src="/image/image4.png" width="200"/></br>
위 6개의 버튼중 하나를 선택시 위와 같이 재생이 됩니다. </br>
<img src="/image/image5.png" width="200"/></br>
재생 중 일시정지 버튼을 누를 경우 위와 같이 화면이 표시됩니다.</br>
slider, 재생, 일시정지를 통해 실행중인 오디오를 조작할 수 있습니다.</br>
