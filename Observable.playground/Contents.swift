import UIKit
import RxSwift

var greeting = "Hello, playground"

// 어떤 타입의 이밴트를 방출할것인지 제네릭<> 타입설정
// just 오직하나의 이벤트만 방출
print("Just")
Observable<Int>.just(1)


// of 하나 이상의 옵저버블을 내뱉는 시퀀스 생성 순차적으로 발생
print("Of1")
Observable<Int>.of(1, 2, 3, 4, 5)


// Observable은 배열에 담긴 요소로 타입추론을 함
// 각각의 요소를 방출하고 싶으면 array로 넣지말고 of 연산을 활용
// 배열로 묶을경우 하나의 array만 방출
print("Of2")
Observable.of([1,2,3,4,5]) // 하나의 array만 방출하기 때문에 just와 동일 Observable.just([1,2,3,4,5])

// From은 array요소만 받아서 of와 다르게 배열의 요소를 하나씩 빼서 방출
print("From")
Observable.from([1,2,3,4,5])
