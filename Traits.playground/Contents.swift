import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

// singGle의 onSuccess는 Observable의 onNext, onCompleted합친것과 동일하다.
// 네트워크환경에서 많이 사용됨(Observable만 사용해도 되지만 직관적이고 명시적으로 사용시에 사용됨)
print("------Single------")
Single<String>.just("check")
    .subscribe(
        onSuccess: {
            print($0)
         },
        onFailure: {
            print("error: \($0)")
        },
        onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

print("------Single2------")
Observable<String>
    .create { observer -> Disposable in
    observer.onError(TraitsError.single)
    return Disposables.create()
}
    .asSingle()
    .subscribe(
        onSuccess: {
            print($0)
        }, onFailure: {
            print("error: \($0.localizedDescription)")
        }, onDisposed: {
            print("disposed")
        }
    )
    .disposed(by: disposeBag)

print("------Single3------")
struct SomeJSON: Decodable {
    let name: String
}

enum JSSONError: Error {
    case DecodingError
}

let json1 = """
    {"name":"park"}
    """

let json2 = """
    {"my_name":"young"}
    """

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
                let json = try? JSONDecoder().decode(SomeJSON.self, from: data)
        else {
            observer(.failure(JSSONError.DecodingError))
            return Disposables.create()
        }
        
        observer(.success(json))
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe  {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

// json2로 받을경우 json 타입이 맞지않아 오류가 발생함
decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

// Single과 다르게 onCompleted까지 있음
print("------Maybe1------")
Maybe<String>.just("check")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onError: {
            print($0)
    }, onCompleted: {
        print("completed")
    }, onDisposed: {
        print("disposed")
    }
    ).disposed(by: disposeBag)

print("------Maybe2------")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(
    onSuccess: {
        print("성공: \($0)")
    }, onError: {
        print("에러: \($0)")
    }, onCompleted: {
        print("completed")
    }, onDisposed: {
        print("disposed")
    }
).disposed(by: disposeBag)

// 싱글과 메이비와 다름 onSuccess가 존재하지 않음
// Completable을 활용한 에러 방출
print("------Completable1------")
Completable.create { obsever -> Disposable in
    obsever(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("onCompleted")
    },
    onError: {
        print("error: \($0)")
    },
    onDisposed: {
        print("onCompleted")
    }
)
.disposed(by: disposeBag)

// Completable을 활용한 에러 방출
print("------Completable2------")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)
