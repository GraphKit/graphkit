/*
 * Copyright (C) 2015 - 2016, CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import CoreData
import XCTest
@testable import Graph

class GraphTests : XCTestCase {
    var asyncException: XCTestExpectation?
    
    override func setUp() {
		super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testContext() {
        let g1 = Graph()
        XCTAssertTrue(g1.context.isKindOfClass(NSManagedObjectContext))
        XCTAssertEqual(Storage.name, g1.name)
        XCTAssertEqual(Storage.type, g1.type)
        XCTAssertEqual(Storage.location, g1.location)
        
        let g2 = Graph("marketing")
        XCTAssertTrue(g2.context.isKindOfClass(NSManagedObjectContext))
        XCTAssertEqual("marketing", g2.name)
        XCTAssertEqual(Storage.type, g2.type)
        XCTAssertEqual(Storage.location, g2.location)

        asyncException = expectationWithDescription("[GraphTests Error: Async tests failed.]")
        
        var g3: Graph!
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [weak self] in
            g3 = Graph("async")
            XCTAssertTrue(g3.context.isKindOfClass(NSManagedObjectContext))
            XCTAssertEqual("async", g3.name)
            XCTAssertEqual(Storage.type, g3.type)
            XCTAssertEqual(Storage.location, g3.location)
            self?.asyncException?.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        
        XCTAssertTrue(g3.context.isKindOfClass(NSManagedObjectContext))
        XCTAssertEqual("async", g3.name)
        XCTAssertEqual(Storage.type, g3.type)
        XCTAssertEqual(Storage.location, g3.location)
    }
}