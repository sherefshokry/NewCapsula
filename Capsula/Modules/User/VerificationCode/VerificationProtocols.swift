//
//  VerificationProtocols.swift
//  Mansour
//
//  Created SherifShokry on 11/25/19.
//  Copyright © 2019 BlueCrunch. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation
import UIKit


protocol ViewToPresenterVerificationProtocol: class {
    var view : PresenterToViewVerificationProtocol? {get set}
    var interactor : PresenterToIntetractorVerificationProtocol? {get set}
    var router : PresenterToRouterVerificationProtocol? {get set}
    var signUpRequest : RegisterRequest { get set }
    func sendVerificationCode()
    func verifyCode(code : String)
    func setPhoneNumber(phone : String)
}

protocol PresenterToViewVerificationProtocol: class {
     func changeState(state : State)
}

protocol PresenterToIntetractorVerificationProtocol: class {
    var presenter: InteractorToPresenterVerificationProtocol? { get set }
     func verifyCode(code : String)
     func sendVerificationCode(phone : String)
     func register(registerRequest  : RegisterRequest)
     func completeProfile(registerRequest: RegisterRequest) 
}

protocol PresenterToRouterVerificationProtocol: class  {
    static func createModule(request : RegisterRequest) -> UIViewController
    static func createModule(phone : String) -> UIViewController
    func openForgetPasswordSecondStepScreen(from sourceView: PresenterToViewVerificationProtocol?, phone : String,firebaseToken: String)
    func openAddAddress(from sourceView: PresenterToViewVerificationProtocol?)
  
}

protocol InteractorToPresenterVerificationProtocol: class {
    func phoneNumberVerified(firebaseToken :  String)
    func codeNotValid(error : String)
    func codeSentSuccessfully()
    func codeFailedToSent(error : String)
    func userRegisteredSuccessfully()
    func userFailedToRegister(error : String)
    
}
