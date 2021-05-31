//
//  RouterHelper.swift
//  TestWithings
//
//  Created by Romain on 31/05/2021.
//

import Foundation

class RouterHelper {
  private static var separator = ","
  
  class func prepareKeywordsForQuery(_ query: String) -> String {
    query.replacingOccurrences(of: RouterHelper.separator, with: "+")
  }
}
