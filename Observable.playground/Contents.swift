import UIKit
import RxSwift

// 구독을 해야 방출이 진행됨(subscribe)
var whatIsOvservable = "Ovservable은 구독되기전까지 아무것도 방출하지 않음, 그냥 정의된 상태일뿐"

// 어떤 타입의 이밴트를 방출할것인지 제네릭<> 타입설정
// just 오직하나의 이벤트만 방출
print("Just")
Observable<Int>.just(1)
	.subscribe(onNext: {
		print($0)
	})

// of 하나 이상의 옵저버블을 내뱉는 시퀀스 생성 순차적으로 발생
print("Of1")
Observable<Int>.of(1, 2, 3, 4, 5)
	.subscribe(onNext: {
		print($0)
	})

// Observable은 배열에 담긴 요소로 타입추론을 함
// 각각의 요소를 방출하고 싶으면 array로 넣지말고 of 연산을 활용
// 배열로 묶을경우 하나의 array만 방출
print("Of2")
Observable.of([1,2,3,4,5]) // 하나의 array만 방출하기 때문에 just와 동일 Observable.just([1,2,3,4,5])
	.subscribe(onNext: {
		print($0)
	})

// From은 오직 array요소만 받아서 of와 다르게 배열의 요소를 하나씩 꺼내서 방출하게됨
print("From")
Observable.from([1,2,3,4,5])
	.subscribe(onNext: {
		print($0)
	})

// onNext없이 subscribe할경우 어떤 이벤트에 쌓여있는지까지 표시됨, completed발생된 여	부도 확인됨
print("subscribe1")
Observable.of(1, 2, 3)
	.subscribe {
		print($0)
	}

// 요소(element)가 있으면 방출해줘
// onNext를 썼던것처럼 요소만 방츨됨
print("subscribe2")
Observable.of(1,2,3)
	.subscribe {
		if let element = $0.element {
			print(element)
		}
	}

// 제일 평범한 subscribe 구독
print("subscribe3")
Observable.of(1,2,3)
	.subscribe(onNext: {
		print($0)
	})

// 요소를 하나도 가지지않는 Observable 하나도없는것을 만들때 empty를 사용
// 아무런 이벤트를 방출하지 않음, 타입을 Void로 설정시에 Complete만 확인 가능
print("empty")
Observable<Void>.empty()
	.subscribe {
		print($0)
	}

print("print와 동일한 코드")
Observable.empty()
	.subscribe(onNext: {
		
	},
  onCompleted: {
		print("Completed")
	}
	)
