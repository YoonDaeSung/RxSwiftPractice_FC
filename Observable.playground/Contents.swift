import UIKit
import RxSwift

// 구독을 해야 방출이 진행됨(subscribe)
var whatIsOvservable = "Ovservable은 구독되기전까지 아무것도 방출하지 않음, 그냥 정의된 상태일뿐"

// 어떤 타입의 이밴트를 방출할것인지 제네릭<> 타입설정
// just 오직하나의 이벤트만 방출
print("------Just------")
Observable<Int>.just(1)
	.subscribe(onNext: {
		print($0)
	})

// of 하나 이상의 옵저버블을 내뱉는 시퀀스 생성 순차적으로 발생
print("------Of1------")
Observable<Int>.of(1, 2, 3, 4, 5)
	.subscribe(onNext: {
		print($0)
	})

// Observable은 배열에 담긴 요소로 타입추론을 함
// 각각의 요소를 방출하고 싶으면 array로 넣지말고 of 연산을 활용
// 배열로 묶을경우 하나의 array만 방출
print("------Of2------")
Observable.of([1,2,3,4,5]) // 하나의 array만 방출하기 때문에 just와 동일 Observable.just([1,2,3,4,5])
	.subscribe(onNext: {
		print($0)
	})

// From은 오직 array요소만 받아서 of와 다르게 배열의 요소를 하나씩 꺼내서 방출하게됨
print("------From------")
Observable.from([1,2,3,4,5])
	.subscribe(onNext: {
		print($0)
	})

// onNext없이 subscribe할경우 어떤 이벤트에 쌓여있는지까지 표시됨, completed발생된 여부도 확인됨
print("------subscribe1------")
Observable.of(1, 2, 3)
	.subscribe {
		print($0)
	}

// 요소(element)가 있으면 방출해줘
// onNext를 썼던것처럼 요소만 방출됨
print("------subscribe2------")
Observable.of(1,2,3)
	.subscribe {
		if let element = $0.element {
			print(element)
		}
	}

// 제일 평범한 subscribe 구독
print("------subscribe3------")
Observable.of(1,2,3)
	.subscribe(onNext: {
		print($0)
	})

// 요소를 하나도 가지지않는 Observable 하나도없는것을 만들때 empty를 사용
// 아무런 이벤트를 방출하지 않음, 타입을 Void로 설정시에 Complete만 확인 가능
// Observable이 타입추론할것이 없어서 타입을 명시적으로 해줘야함
// 사용 용도는 즉시종료할 Observable을 리턴하고 싶을때, 의도적으로 0개의 값을 리턴할 때
print("------empty------")
Observable<Void>.empty()
	.subscribe {
		print($0)
}

print("------empty와 동일한 코드------")
Observable.empty()
	.subscribe(onNext: {
		
	},
	onCompleted: {
		print("Completed!")
	}
)

// 탑입을 기재하든 안하든 어떠한 이벤트를 방출하지않음
// 코드가 잘동작되는지 확인은 debug연산을 통해 확인가능
print("------never------")
Observable<Void>.never()
		.debug("never debug")
		.subscribe(
				onNext: {
						print($0)
				},
				onCompleted: {
						print("Completed!")
				}
		)

// start값부터 count수만큼 반복
print("------range------")
Observable.range(start: 1, count: 9)
		.subscribe(onNext: {
				print("2*\($0)=\(2*$0)")
		})


// 구독했던것을 종료함
var whatIsDispose = "구독됬던 Observable을 반대로 종료하여 취소하는 것"

// 구독한 이벤트를 방출 이후 종료
// 현재 코드는 3가지의 요소가 있어서 사용할 필요가 없지만 무한요소가 들어간다면 dipose를 호출해야 completed됨
print("------dispose------")
Observable.of(1,2,3)
		.subscribe {
				print($0)
		}
		.dispose()

// 각 구독에 대해서 일일이 하나씩 구독해제가아닌 묶어서 한번에 헤제하도록 Bag을 만들어 사용
// 구독해제를 하지 않으면 메모리 누수가 일어남
print("------disposeBag------")
let disposeBag = DisposeBag()

Observable.of(1,2,3)
		.subscribe {
				print($0)
		}
		.disposed(by: disposeBag)

// create는 @escaping클로져이다
print("------create1------")
Observable.create { observer -> Disposable in
		observer.onNext(1)
		observer.onCompleted()
		observer.onNext(2) // onNext(2)난 이미 위에서 종료되었기 때문에 방출되지 않음
		return Disposables.create()
}
.subscribe{
		print($0)
}
.disposed(by: disposeBag)

print("------create2------")
enum MyError: Error {
		case anError
}

// observer로 받고 return을 Disposable로 해주는 타입
Observable<Int>.create { observer -> Disposable in
		observer.onNext(1)
		observer.onError(MyError.anError)
		observer.onCompleted()
		observer.onNext(2)
		return Disposables.create()
}
.subscribe(
		onNext: {
				print($0)
		},
		onError: {
				print($0.localizedDescription)
		},
		onCompleted: {
				print("disposed")
		},
		onDisposed: {
				
		}
)
.disposed(by: disposeBag)

// Observable을 감싸는 Observable -> Observable내에 Observable생성가능
print("------deferred1------")
Observable.deferred {
		Observable.of(1,2,3)
}
.subscribe {
		print($0)
}
.disposed(by: disposeBag)


// deferred는 어떨때 사용할까?
// 뒤집기라는 Bool타입에 따라 if조건문을 활용하여 상황에 따른 Observable을 내뱉는다.
print("------deferred2------")
var 뒤집기: Bool = false

let factory: Observable<String> = Observable.deferred {
		뒤집기 = !뒤집기
		
		if 뒤집기 {
				return Observable.of("가위")
		} else {
				return Observable.of("주먹")
		}
}

for _ in 0...3 {
		factory.subscribe(onNext: {
				print($0)
		})
		.disposed(by: disposeBag)
}
