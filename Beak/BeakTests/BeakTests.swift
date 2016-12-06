//
//  BeakTests.swift
//  BeakTests
//
//  Created by 马进 on 2016/12/5.
//  Copyright © 2016年 马进. All rights reserved.
//

import Beak

class BeakTests {
    
    func test(){
        let client = BBBPCClient()
        client.server = "http://localhost:8080"
        client.urlPath = "/invoke"
        
        let testMethod = BPCTestMethod(method: "test.scenic.search", client: client)
        testMethod.send().callback{scenics, error in
            print(scenics)
        }
        
    }
    
    
}
