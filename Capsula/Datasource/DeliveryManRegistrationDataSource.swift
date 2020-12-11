//
//  DeliveryDataSource.swift
//  Capsula
//
//  Created by SherifShokry on 6/30/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
import Foundation
import Moya

public enum DeliveryManRegistrationDataSource {
    case getTermsAndConditions
    case getNationalities
    case getRegistrationBasicData
    case getCarModels(Int)
    case deliveryManRegister(DeliveryManRegisterRequest)
    case deliveryManLogin(LoginRequest)
    case updateDeliveryData(DeliveryRequest)
    case updateLocation(LocationRequest)
    case resetPassword(String , String, String)
    case checkPhoneIsExist(String,String)
    case changeDeliveryManStatus(Bool)
}

extension DeliveryManRegistrationDataSource : TargetType {
    
    public var baseURL: URL {
        
        switch self {
        case .checkPhoneIsExist(let phoneNumber, let email):
            return URL(string: "\(Constants.BASE_URL)/DeliveryManRegisteration/CheckUserExist?PhoneNumber=\(phoneNumber)&email=\(email)")!
        default:
            return URL(string: "\(Constants.BASE_URL)/DeliveryManRegisteration")!
        }
    }
    
    
    public var path: String {
        switch self {
        case  .getTermsAndConditions : return "/GetTermsAndConditions"
        case .getNationalities: return "/GetNationalities"
        case .getRegistrationBasicData: return "/GetRegisterBasicData"
        case .getCarModels(let carTypeId): return "/GetCarModels/\(carTypeId)"
        case .deliveryManRegister(_): return "/Register"
        case .deliveryManLogin(_): return "/Login"
        case .updateDeliveryData(_): return "/Update"
        case .updateLocation: return "/UpdateLocation"
        case .resetPassword :  return "/ForgetPassword"
        case .checkPhoneIsExist(_,_): return ""
        case .changeDeliveryManStatus(let status):
            return "/OutService/\(status)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getTermsAndConditions : return .get
        case .getNationalities: return .get
        case .getRegistrationBasicData: return .get
        case .getCarModels(_): return .get
        case .deliveryManRegister(_): return .post
        case .deliveryManLogin(_): return .post
        case .updateDeliveryData(_): return .put
        case .updateLocation(_): return .put
        case .resetPassword(_,_,_):  return .post
        case .checkPhoneIsExist(_,_):  return .get
        case .changeDeliveryManStatus(_): return .put
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .checkPhoneIsExist(_,_): return .requestPlain
        case .getTermsAndConditions : return .requestPlain
        case .getNationalities: return .requestPlain
        case .getRegistrationBasicData: return .requestPlain
        case .getCarModels(_): return .requestPlain
        case .deliveryManRegister(let request):
            return .requestParameters(parameters: request.getParams(), encoding: JSONEncoding.default)
        case .deliveryManLogin(let request):
            return .requestParameters(parameters: request.getParams(), encoding: JSONEncoding.default)
        case .updateDeliveryData(let request):
            return .requestParameters(parameters: request.getParams(), encoding: JSONEncoding.default)
        case .updateLocation(let request):
            return .requestParameters(parameters: request.getParams(), encoding: JSONEncoding.default)
        case .resetPassword(let mobile,let password,let token):
            var params = [String : Any]()
            params["phoneNumber"] = mobile
            params["newPassword"] = password
            params["token"] = token
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .changeDeliveryManStatus(_): return .requestPlain
        }
    }
    
    
    func getImageData(image : UIImage?)->Data?{
        if image != nil{
            return image!.jpegData(compressionQuality: 0.90)
        }
        return nil
    }
    
    public var headers: [String: String]? {
        return BaseDataSource.getDeliveryHeader() as? [String : String] ?? [:]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
