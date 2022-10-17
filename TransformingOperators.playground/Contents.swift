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

// flatMapLatest 가장 최근에 Observle을 받기때문에
// 전국체전.onNext(제주)가 된 순간부터 서울 시퀀스는 헤제됨, 서울이 점수를 아무리내도 받아주지 않음 (가장 최근의 제주것만 받아들임)
// 네트워킹 조작에서 가장흔하게 사용됨
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

// 토끼선수가 부정출발(Error)를 낸이후에 아무리 점수를 내어도 점수가 발생되지 않음
print("------materialize and dematerialize------")
enum 반칙: Error {
	case 부정출발
}

struct 달리기선수: 선수 {
	var 점수: BehaviorSubject<Int>
}

let 김토끼 = 달리기선수(점수: BehaviorSubject<Int>(value: 0))
let 박치타 = 달리기선수(점수: BehaviorSubject<Int>(value: 1))

let 달리기100M = BehaviorSubject(value: 김토끼) // 첫번째 선수

달리기100M
	.flatMapLatest { 선수 in
		선수.점수
			.materialize() // materialize속성을 사용하면 점수만 받지않고 어떤이벤트가 발생되는지 함께 확인가능
	}
	// filter를 사용하여 event가 error를가지면 filter를 통과하고 error를 표시해줘 에러없으면 통과시키지마
	.filter {
		guard let error = $0.error else {
			return true
		}
		print(error)
		return false
	}
	.dematerialize() // materialze로 이벤트까지 함께 방출했던것을 값만 방출하도록 원복
	.subscribe(onNext: {
		print($0)
	})
	.disposed(by: disposeBag)

김토끼.점수.onNext(1)
김토끼.점수.onError(반칙.부정출발)
김토끼.점수.onNext(2)

달리기100M.onNext(박치타)

print("------전화번호 11자리------")
let input = PublishSubject<Int?>()

let list: [Int] = [1]

input
	.flatMap {
		$0 == nil
		? Observable.empty()
		: Observable.just($0)
	}
	.map { $0! } // skipWhile을 사용해서 시작번호가 0이아니면 계속 skip
	.skip(while: { $0 != 0 })
	.take(11) // 11자리만 받아!
	.toArray() // 숫자를 배열로 한번 묶어줄예정
	.asObservable() // toArray로 인하여 Single로 변환된것을 다시 Observable로 변환
	.map {
		$0.map { "\($0)" }
	}
	.map { numbers in
		var numberList = numbers
		numberList.insert("-", at: 3) // 3번째 idx에 -을 추가해!
		numberList.insert("-", at: 8) // 8번째 idx에 -을 추가해!
		let number = numberList.reduce(" ", +)
		return number
	}
	.subscribe(onNext: {
		print($0)
	})
	.disposed(by: disposeBag)

// 전화번호를 하나씩 누른다고 생각
input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(3)
input.onNext(nil)
input.onNext(1)
input.onNext(8)
input.onNext(9)
input.onNext(4)
input.onNext(9)
input.onNext(1)

