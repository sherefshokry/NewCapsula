//
//  RegisterProtocols.swift
//  Capsula
//
//  Created SherifShokry on 12/25/19.
//  Copyright © 2019 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation
import UIKit

protocol ViewToPresenterRegisterProtocol: class {
    var view : PresenterToViewRegisterProtocol? {get set}
    var interactor : PresenterToIntetractorRegisterProtocol? {get set}
    var router : PresenterToRouterRegisterProtocol? {get set}
    func setNameField(name : String)
    func setPasswordField(password : String)
    func setEmailField(email : String)
    func setPhoneFiled(phone : String)
    func clearRegisterRequest()
    func checkIfPhoneExist(phone : String)
}

protocol PresenterToViewRegisterProtocol: class {
    func changeState(state : State)
    
}

protocol PresenterToIntetractorRegisterProtocol: class {
    var presenter: InteractorToPresenterRegisterProtocol? { get set }
    func checkIfPhoneExist(phone : String,email :String)
}

protocol PresenterToRouterRegisterProtocol: class  {
    static func createModule() -> UIViewController
    func openVerificationScreen(from sourceView: PresenterToViewRegisterProtocol?, request : RegisterRequest)
}

protocol InteractorToPresenterRegisterProtocol: class {
    func phoneIsExist()
    func phoneNotExist()
}