//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Chen Hai Teng on 8/6/21.
//

import XCTest
import Combine

extension XCTestCase {
    func await<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}

class Tests_iOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func fetchFontList() throws -> AnyPublisher<WebFontList, Error> {
        try FontService.fetchData()
            .decode(type: WebFontList.self, decoder: WebFontList.decoder).eraseToAnyPublisher()
    }
    
    func testFontService() throws {
        let prefix = "https://www.googleapis.com/webfonts/v1/webfonts?key"
        
        let requestUrl = FontService.requestUrl
        if let url = requestUrl {
            XCTAssertTrue(url.absoluteString.hasPrefix(prefix)) // check path combination correct
            // Check connect to service success
            do {
                // Check get data from service
                let result = try `await`(FontService.fetchData())
                XCTAssertFalse(result.isEmpty)
                
                // verify webfont coadable
                let list = try `await`(fetchFontList())
                XCTAssertEqual(list.kind, "webfonts#webfontList")
                XCTAssertFalse(list.items.isEmpty)
                for item in list.items {
                    XCTAssertEqual(item.kind, "webfonts#webfont")
                }
            } catch {
                XCTFail("\(error)")
            }
        } else {
            XCTFail("create url failed")
        }
    }
    
    func buildDictionary(@DictionaryBuilder<String, String> _ builder:()->Dictionary<String, String>) ->  Dictionary<String, String> {
        return builder()
    }
    
//    func buildString(@DictionaryBuilder<String, String> _ builder:()->String) -> String {
//        return builder()
//    }
    
    func testDictionaryBuilder() throws {
        typealias DICT =  Dictionary<String, String>
        let flagTrue = true
        let flagFalse = false
        
        let result_empty: DICT = buildDictionary {
        }
        XCTAssertTrue(result_empty.isEmpty)
        
        let result_dict_1: DICT = buildDictionary {
            ["first" : "1st"]
        }
        let result_tuple_1: DICT = buildDictionary {
            ("first", "1st")
        }
        XCTAssertEqual(result_dict_1, ["first" : "1st"])
        XCTAssertEqual(result_dict_1, result_tuple_1)
        
        let result_duplicate = buildDictionary {
            ["first" : "1st"]
            ("first", "2nd")
        }
        // duplicated key should keep the last value.
        XCTAssertEqual(result_duplicate.count, result_dict_1.count)
        XCTAssertNotEqual(result_duplicate, result_dict_1)
        
        let result_selection_true = buildDictionary {
            if flagTrue {
                ("first", "1st")
            }
        }
        XCTAssertEqual(result_selection_true, result_dict_1)
        let result_selection_false = buildDictionary {
            if flagFalse {
                ("first", "1st")
            }
        }
        XCTAssertTrue(result_selection_false.isEmpty)
        
        let result_selection_true_multiple = buildDictionary {
            if flagTrue {
                ("first", "1st")
                ["second": "2nd"]
            }
        }
        XCTAssertEqual(result_selection_true_multiple.count, 2)
        
        let result_if_else_first = buildDictionary {
            if flagTrue {
                ("1", "1st")
                ("2", "2nd")
                ["3": "3rd"]
            } else {
                ("4", "4th")
            }
        }
        XCTAssertEqual(result_if_else_first.count, 3)
        
        let result_if_else_second = buildDictionary {
            if flagFalse {
                ("1", "1st")
                ("2", "2nd")
                ["3": "3rd"]
            } else {
                ("4", "4th")
            }
        }
        XCTAssertEqual(result_if_else_second.count, 1)
        
        let reuslt_string = buildDictionary {
            ("1", "1st")
        }
        
        XCTAssertEqual(reuslt_string.toQuery(), "1=1st")
        
        let result_string_2 = buildDictionary {
            ["1":"a",
             "2":"b"]
        }.toQuery()
        // The dictionary is unorderd, use other statement to ensure the result
//        XCTAssertEqual(result_string_2, "1=a&2=b")
        let possible_result = "1=a&2=b"
        XCTAssertEqual(result_string_2.count, possible_result.count)
        let index = result_string_2.firstIndex(of:"&")
        XCTAssertNotNil(index)
        XCTAssertEqual(index!, possible_result.firstIndex(of: "&"))
    }
    
//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
