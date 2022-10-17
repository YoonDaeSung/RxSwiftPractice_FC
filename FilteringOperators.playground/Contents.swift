import RxSwift

let disposeBag = DisposeBag()

// ignore는 onNext이벤트를 무시하므로 아무것도 방출하지 않는다.
// 마지막에 completed이벤트만 받고 방출함
print("------ignoreElements------")
let 취침모드 = PublishSubject<String>()

취침모드
    .ignoreElements()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

취침모드.onNext("🔔")
취침모드.onNext("🔔")
취침모드.onNext("🔔")

취침모드.onCompleted()

print("------elementAt------")
let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("🔔")
두번울면깨는사람.onNext("🔔")
두번울면깨는사람.onNext("😀")
두번울면깨는사람.onNext("🔔")

// 필터를 넣어 짝수만 고르고싶다 등의 필터링 기능
print("------filter------")
Observable.from([1,2,3,4,5,6,7,8])
    .filter { $0 % 2 == 0 } // 조건부를 걸어 필터함
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// skip에 5을 넣을경우 5까지 무시하고 6부터 방출함
print("------skip------")
Observable.of(1,2,3,4,5,6)
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// 모든연산을 필터하는 Filter연산자와달리 처음부터 스킵하다가 조건 로직이 False가 될때부터 방출함
// Filter와 반대되는 성질
// 동메달이 아니면 스킵하다가 동메달 만나는순간 방출
print("------skipWhile------")
Observable.of("🥇", "🥈", "🥉", "🏊🏾‍♂️", "🏊🏻‍♀️")
    .skip(while: {
        $0 != "🥉"
    })
    .subscribe ( onNext: {
      print($0)
    })
    .disposed(by: disposeBag)

// 특정구간까지 skip하고 지정된 이벤트가 방출한다음부터 skip헤제
// 특정 Observable이 onNext되기 전까지 skip함
print("------skipUntil------")
let customer = PublishSubject<String>()
let openTime = PublishSubject<String>()

customer
    .skip(until: openTime)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

customer.onNext("1문이 안열었네?")
customer.onNext("2문이 안열었네?")

openTime.onNext("Open!!")
customer.onNext("문이 열렸구나")

// skip과는 반대인 개념, 처음부터 take(3) 3개의 값만 가져와서 방출함
print("------take------")
Observable.of("🥇", "🥈", "🥉", "🏊🏾‍♂️", "🏊🏻‍♀️")
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
 
// skipWhile처럼 동작, 하지만 takeWhile은 처음부터 가저오다가 false조건 만나면 방출종료
// 동메달이 아니면 가져오다가 같은 동메달 만나면 종료
print("------takeWhile------")
Observable.of("🥇", "🥈", "🥉", "🏊🏾‍♂️", "🏊🏻‍♀️")
    .take(while: {
        $0 != "🥉"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// takeWhile등을 사용하여 확인할때 index값과 index까지 같이 표현해줌
print("------enumerated------")
Observable.of("🥇", "🥈", "🥉", "🏊🏾‍♂️", "🏊🏻‍♀️")
    .enumerated()
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// until이 발생한 시점전까지 방출하다가 until 발생시점이후 방출종료
print("------takeUntil------")
let courseOpen = PublishSubject<String>()
let courseClose = PublishSubject<String>()
let student = PublishSubject<String>()

courseOpen
    .take(until: courseClose)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

courseOpen.onNext("1수강신청 가능하다!")
courseOpen.onNext("2수강신청 가능하다!")

courseClose.onNext("수강종료")
courseOpen.onNext("지금이라도 수강신청 가능한가?")

// '연달아서' 같은값이 나올때 중복되는 값을 막아주는 역할을 함
print("------distinctUntilChanged------")
Observable.of("앵무새","저는","저는","앵무새","앵무새","앵무새","앵무새","입니다","입니다","입니다")
    .distinctUntilChanged()
    .subscribe( onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
