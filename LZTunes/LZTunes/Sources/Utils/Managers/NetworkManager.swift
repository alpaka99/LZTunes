//
//  NetworkManager.swift
//  LZTunes
//
//  Created by user on 8/10/24.
//

import Foundation

import RxCocoa
import RxSwift

final class NetworkManager: NSObject {
    static let shared = NetworkManager()
    override private init() {
        super.init()
        bind()
    }
    
    let disposeBag = DisposeBag()
    
    var router: PublishSubject<Router> = PublishSubject()
    
    private var buffer: Data = Data()
    
    private var downloadStatus: PublishSubject<(status: DownloadStatus, buffer: Data)> = PublishSubject()
    
    var completeStatus: PublishSubject<CompleteStatus> = PublishSubject()
    
    func bind() {
        router
            .debug()
            .bind(with: self) { owner, router in
                owner.requestCall(router: router)
            }
            .disposed(by: disposeBag)
        
        downloadStatus
            .map { downloadStatus in
                var result: Result<Data, Error>?
                switch downloadStatus.status {
                case .downLoading:
                    result = nil // 현재는 download 중에는 nil처리
                case .error:
                    result =  .failure(DownloadError.error)
                case .completed:
                    result =  .success(downloadStatus.buffer)
                }
                return result
            }
            .subscribe(with: self) { owner, result in
                if let result = result {
                    switch result {
                    case .success(let data):
                        owner.completeStatus.onNext(.complete(data))
                    case .failure(let error):
                        owner.completeStatus.onNext(.error(error))
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func requestCall(router: Router) {
        let urlRequest = router
            .build()
        if let urlRequest = urlRequest {
            let session = URLSession(
                configuration: .default,
                delegate: self,
                delegateQueue: .current
            )
            
            let dataTask = session.dataTask(with: urlRequest)
            dataTask.resume()
        }
    }
}

extension NetworkManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
            print("allowed")
            buffer = Data()
            return .allow
        } else {
            print("not allowed")
            buffer = Data()
            downloadStatus.onNext((.error, buffer))
            return .cancel
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        print("downloading...")
        downloadStatus.onNext((.downLoading, buffer))
        buffer.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        guard error == nil else {
            print("URLSession Data Task Error: \(String(describing: error))")
            downloadStatus.onNext((.error, buffer))
            return
        }
        
        downloadStatus.onNext((.completed, buffer))
    }
}


enum DownloadStatus {
    case downLoading
    case error
    case completed
}

enum CompleteStatus {
    case complete(Data)
    case error(Error)
}

enum DownloadError: Error {
    case notDownloading
    case error
}
