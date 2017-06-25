//
//  JsonHelper.swift
//  Siscofa
//
//  Created by Glaubert Moreira Schult on 28/02/17.
//  Copyright © 2017 GMS. All rights reserved.
//

import Foundation


class JSONHelper {
    
    class func JSONStringify(_ value: AnyObject, prettyPrinted: Bool = false) -> String {
        
        if JSONSerialization.isValidJSONObject(value) {
            do {
                
                if let data : Data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
                    if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        return string as String
                    }
                }
                
            } catch {
                print("JSONHelper: Erro ao converter o Objeto para JSON")
            }
            
        }
        return ""
    }
    
    
    func JSONParseArray(_ jsonString: String) -> [AnyObject] {
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                if let array =  try JSONSerialization.jsonObject(with: data, options: .allowFragments )  as? [AnyObject] {
                    return array
                }
            } catch {
                print("Erro na conversao do JSON na Classe JsonHelper")
            }
        }
        return [AnyObject]()
    }
    
    static func JSONParseDictionary(_ jsonString: String) -> [String: AnyObject] {
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                if let dictionary =  try JSONSerialization.jsonObject(with: data, options: .allowFragments )  as? [String: AnyObject] {
                    return dictionary
                }
            } catch {
                print("Erro na conversao do JSON na Classe JsonHelper")
            }
            
        }
        return [String: AnyObject]()
    }
    
}
