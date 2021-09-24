//
//  DataProvider.swift
//  URLSession
//
//  Created by Артем Хребтов on 24.09.2021.
//

import UIKit

class DataProvider: NSObject {
    
    var downloadTask: URLSessionDownloadTask!
    var locationFile: ((URL) -> ())?
    var total: ((Double) -> ())?
    
    //создаем сессию которая будет работать в бекграунде
    private lazy var bgSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "slothCoder.Inc.URLSession")
        //позволяет системе планировать загрузку
        configuration.isDiscretionary = true
        //перезапускает приложение когда загрузка кончилась
        configuration.sessionSendsLaunchEvents = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    //начинаем скачивать файл
    func startDownload(){
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin"){
            downloadTask = bgSession.downloadTask(with: url)
            //Добавляем задержку перед началом скачивания
            downloadTask.earliestBeginDate = Date().addingTimeInterval(1)
            //Кол-во байтов которое клиент должен отправить
            downloadTask.countOfBytesClientExpectsToSend = 512
            //Кол-во байтов которое должно скачаться (файл на 100 мегабайт)
            downloadTask.countOfBytesClientExpectsToReceive = 100*1024*1024
        }
    }
    //останавливаем скачивание
    func stopDownload(){
        downloadTask.cancel()
    }
}
extension DataProvider: URLSessionDelegate {
    //метод синхронизации сессий
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let complitionHandler = appDelegate.bgSessionCompletionHandler else { return }
            //обнуляем идентификатор сессии так как загрузка завершена и возвращаем исходный идентификатор
            appDelegate.bgSessionCompletionHandler = nil
            complitionHandler()
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    //завершена загрузка и лежит по временному пути
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finished download: \(location.absoluteString)")
        DispatchQueue.main.async {
            //Передаем путь на скачанный файл через комплишн
            self.locationFile?(location)
        }
    }
    //Получаем статус загрузки сколько байтов скачано и сколько всего
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        let progress = Double(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
        DispatchQueue.main.async {
            self.total?(progress)
        }
    }
}
