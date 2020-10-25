//
//  ErrorMessage.swift
//  Flickr
//
//  Created by matt_spb on 29.03.2020.
//  Copyright © 2020 matt_spb_dev. All rights reserved.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidData        = "Invalid Data"
    case unableToComplete   = "Unabale to complete request"
    case unableToDecode     = "Decoding error"
    case invalidResponse    = "Invalid response from the server. Please try again"
}
