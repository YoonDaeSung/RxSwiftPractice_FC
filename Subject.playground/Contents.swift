import RxSwift

let disposeBag = DisposeBag()

// publishSubject 구독하기 이전에 발생한 이벤트는 방출하지않음
print("------PublichSubject------")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("1여러분 안녕?")

let 구독자1 = publishSubject
    .subscribe(onNext: {
        print("두번째 구독자: \($0)")
    })

publishSubject.onNext("2들리세요?")
publishSubject.onNext("3안들리세요?")

구독자1.dispose()

let 구독자2 = publishSubject
    .subscribe(onNext: {
        print("첫번째 구독자: \($0)")
    })

publishSubject.onNext("4여보세요")
publishSubject.onCompleted()

publishSubject.onNext("5끝났나요")

구독자2.dispose()

// complete되고 난이후에 구독 재시작시에도 방출하지않음
publishSubject
    .subscribe {
        print("세번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

publishSubject.onNext("6찍힐까요?")

// behaviorSubject는 반드시 초기값을 갖고 시작함
// 구독한 시점의 직전 이벤트도 방출함 (publishSubject는 구독한 시점부터 이벤트 방출)
//
print("------BehaviorSubject------")
enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "initValue")
behaviorSubject.onNext("1firstValue")

behaviorSubject.subscribe {
    print("첫번째 구독", $0.element ?? $0)
}
.disposed(by: disposeBag)

//behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("두번째 구독", $0.element ?? $0)
}
.disposed(by: disposeBag)

// behaviorSubject는 value값을 꺼내서 쓸수 있음
// Rx에서는 거의 사용하지않지만 value뽑아내는 방법도 있음
let haviorValue = try? behaviorSubject.value()
print(haviorValue) // 에러를 방출하여 종료되지 않았다면 가장 최신의 onNext를 가져옴

// creata로 생성하여 몇개의 이벤트 buffer(임시 저장공간)를 가질것인지 선언가능
// buffer사이즈에 따라 onNext를 방출 1일경우 '3어렵지만' 의 마지막 이벤트만 방출
print("------ReplaySubject------")
let replaySubject = ReplaySubject<String>.create(bufferSize: 3)

replaySubject.onNext("1여러분")
replaySubject.onNext("2힘내세요")
replaySubject.onNext("3어렵지만")

replaySubject.subscribe{
    print("첫번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe{
    print("두번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4할수있어요")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

// 이미 dispose된 상태에서 구독을 하니 Rx오류가발생
replaySubject.subscribe {
    print("세번째 구독:", $0.element ?? $0)
}
.disposed(by: disposeBag)
