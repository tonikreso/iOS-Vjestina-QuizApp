//
//  QuizRepositoryProtocol.swift
//  QuizApp
//
//  Created by Kompjuter on 29/05/2021.
//

protocol QuizRepositoryProtocol {
    
    func fetchRemoteData() throws
    func fetchLocalData(filter: FilterSettings) -> [Quiz]
    func deleteLocalData(withId id: Int)
}
