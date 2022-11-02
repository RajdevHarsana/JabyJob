/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
class CountrysModal {
    var created_at: String? //= "2022-02-02T01:46:07.000000Z";
    var id : Int?
    var name: String?
    var phonecode : Int?
    var sortname : String?
    var updated_at : String?
    var isSelect = false
    
    convenience init(_ attibutes: [AnyHashable:Any]) {
        self.init()
        self.created_at = attibutes["created_at"] as? String ?? ""
        self.id = attibutes["id"] as? Int ?? 0
        self.name = attibutes["name"] as? String ?? ""
        self.phonecode = attibutes["phonecode"] as? Int ?? 0
        self.sortname = attibutes["sortname"] as? String ?? ""
        self.updated_at = attibutes["updated_at"] as? String ?? ""
        
    }
    
}



// MARK: - CountryModal
struct CountryModal: Codable {
    var status: Bool?
    var message: String?
    var data: [CountryData]?
}

// MARK: - Datum
struct CountryData: Codable {
    var isSelect = false
    var id: Int?
    var sortname, name: String?
    var phonecode: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, sortname, name, phonecode
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
