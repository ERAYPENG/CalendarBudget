//
//  FirebaseManager.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/3/6.
//

import UIKit
import Firebase

//Singleton Pattern
//only one instance, 通常叫 shared
class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    let loadingIndicator = LoadingIndicator()
    
    typealias DataSnapshotHandler = (Result<DataSnapshot>) -> Void
    
    typealias DataSnapshotsHandler = (Result<[DataSnapshot]>) -> Void
    
    typealias ImageHandler = (UIImage?, Error?) -> Void

}

enum Result<T> {
    
    case success(T)
    
    case error(Error)
}

//MARK: Datebase
extension FirebaseManager {

    //Read = GET
    func getDataSnapshot(ref: DatabaseReference, completion: @escaping ((Result<DataSnapshot>) -> Void)) {
        
        self.loadingIndicator.start()
        //Firebase API
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.loadingIndicator.stop()
            
            if snapshot.exists() {
                
                completion(.success(snapshot))
                
            } else {
                
//                completion(.error(NetworkError.emptyData))
            }
        })
    }
    
//    func getDataSnapshots(ref: DatabaseReference, completion: @escaping (DataSnapshotsHandler)) {
//        
//        self.loadingIndicator.start()
//        
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            self.loadingIndicator.stop()
//            
//            ref.removeAllObservers()
//            
//            if snapshot.exists() {
//                
//                guard
//                    let snaps = snapshot.children.allObjects as? [DataSnapshot]
//                    else
//                {
////                    completion(.error(NetworkError.parseError))
//                    return }
//                
//                completion(.success(snaps))
//                
//            } else {
//                
////                completion(.error(NetworkError.emptyData))
//            }
//        })
//    }
    
    //Create = POST
//    func createActivityData(value: [String: Any], completion: (()->())?) {
//
//        let uuid = value[Config.Firebase.Activity.Keys.activityID] as! String
//
//        self.updateAvtivityData(value: value, childID: uuid, completion: completion)
//    }
    
//    func updateAvtivityData(value: [String: Any], childID: String, completion: (()->())?) {
//
//        let ref = Database.database().reference().child(Config.Firebase.Activity.nodeName)
//
//        self.loadingIndicator.start()
//
//        ref.child(childID).updateChildValues(value, withCompletionBlock: { (err, _) in
//
//            self.loadingIndicator.stop()
//
//            if err != nil {
//                return
//            } else {
//                if let completion = completion {
//                    completion()
//                }
//            }
//        })
//    }
        
    //update = PUT
    func updateData(value: [String: Any], ref: DatabaseReference, childNode: String, completion: ((Error?)->())?) {
        
        self.loadingIndicator.start()
        
        ref.child(childNode).updateChildValues(value, withCompletionBlock: { (err, _) in
            
            self.loadingIndicator.stop()
            
            if err != nil {
                if let completion = completion {
                    completion(err)
                }
                return
            } else {
                if let completion = completion {
                    completion(nil)
                }
            }
        })
    }
    
    //Delete = DELETE
    func deleteData(ref: DatabaseReference, completion: (()->())?) {
        
        self.loadingIndicator.start()
        
        ref.removeValue { (error, ref) in
            
            self.loadingIndicator.stop()
            
            if let completion = completion {
                completion()
            }
        }
    }
}

//MARK: Image Storage
extension FirebaseManager {
    
    func getImage(from url: String, completion: @escaping ImageHandler) {
        
        let storageRef = Storage.storage().reference()
        
        let islandRef = storageRef.child(url)
        
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(nil, error)
            } else {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            }
        }
    }
}

