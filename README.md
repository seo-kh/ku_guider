# ku_guider

## 고려대학교 세종캠퍼스에서 개발한 Flutter APP입니다.


### 요약
> 인공지능을 이용한 캠퍼스 건물 소개앱입니다.
 
> 카메라로 건물 이미지를 자체제작한 인공지능모델에 입력시켜, 모델은 해당 이미지가 어떤 건물으 나타내는지 판별합니다.

> `mobilenet`을 전이학습(transfer learning)하여 모델을 학습시켰고, 90%이상의 건물 판별 성능 정확도를 보였습니다.

### 기술 스택
1. Tensorflow
2. Flutter

### 역할
- 건물 판별을 위한 인공지능(AI)모델 구축 및 학습 진행
- Flutter를 이용한 UI 설계 및 구현, 기능 추가, tensorflow모델을 앱에 이식작업 진행

### 트러블 슈팅
- 학교 건물 데이터 획득후, 데이터 전처리과정에 따라 인공지능모델의 성능이 차이가 많이 나타나게 되었다.(건물 판별 능력) / 해결: 학습에 방해가 될 데이터를 과감히 배제했다.
- flutter와 tensorflow모델 결합작업중에 사용한, `tensorflowlite` 패키지의 버전 호환성 문제 발생, 앱 동작 장애가 되었다. / 해결: flutter공식 사이트, stackoverflow등의 자료를 참고해 해결


* 아래 이미지를 클릭사히면 영상링크로 접속할 수 있습니다.
 ___ 
 
[![Demo Video](https://img.youtube.com/vi/YgPFp3gZ2mo/0.jpg)](https://www.youtube.com/watch?v=YgPFp3gZ2mo&list=PLSVTDKPoVTAL8_sSf79vTE71pKdUAD7LF&index=1)
