import RxSwift

let disposeBag = DisposeBag()

// toArray로 먹일경우 Single로 만들어주고 Array로 내뱉어줌
// of로 넣었는데 just로 넣은것처럼 배열로 내뱉어줌
print("------toArray------")
Observable.of("A", "B", "C")
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------map------")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------flatMap------")
protocol 선수 {
    var 점수: BehaviorSubject<Int> { get }
}

struct 양궁선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 🇰🇷국가대표 = 양궁선수(점수: BehaviorSubject<Int>(value: 10))
let 🇺🇸국가대표 = 양궁선수(점수: BehaviorSubject<Int>(value: 8))

let 올림픽경기 = PublishSubject<선수>()

올림픽경기
    .flatMap { 선수 in
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// 선수 출전
올림픽경기.onNext(🇰🇷국가대표)
// 두번째 점수
🇰🇷국가대표.점수.onNext(10)

// 선수 출전
올림픽경기.onNext(🇺🇸국가대표)
🇺🇸국가대표.점수.onNext(9)

print("------flatMapLatest------")
struct 높이뛰기선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 서울 = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 7))
let 제주 = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 6))

let 전국체전 = PublishSubject<선수>()

전국체전
    .flatMap { 선수 in
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// 선수출전
전국체전.onNext(서울)
서울.점수.onNext(9)

// 선수출전
전국체전.onNext(제주)
서울.점수.onNext(10)
제주.점수.onNext(8)
