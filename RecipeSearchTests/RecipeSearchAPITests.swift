//
//  RecipeSearchAPITests.swift
//  RecipeSearchTests
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import XCTest
@testable import RecipeSearch

class RecipeSearchAPITests: XCTestCase {
    
    func testSearchChristmasCookies() {
        // arrange
        // convert string to a url friendly string
        let searchQuery = "christmas cookies".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        /* need! */       let exp = XCTestExpectation(description: "searches found")
        let recipeEndPointURL = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(SecretKey.appId)&app_key=\(SecretKey.appKey)&from=0&to=50"
        
        let request = URLRequest(url: URL(string: recipeEndPointURL)!)
        
        // act
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("appError: \(appError)")
            case .success(let data):
                /* Need!*/               exp.fulfill()
                // assert
                XCTAssertGreaterThan(data.count, 800000, "data should be greater than \(data.count)")
            }
        }
        /* need! */        wait(for: [exp], timeout: 5.0)
    }
    
    
    // 3. TODO: write an asynchronous test to validate you do get back 50 recipes for the "christmas cookies" search
    
    func testGetRecipes() {
        // arrange
        let expectedRecipesCount = 50
        // when you have a test you NEED an expectation
        let exp = XCTestExpectation(description: "recipes found")
        let searchQuery = "christmas cookies"
        
        // act
        RecipeSearchAPI.getRecipe(for: searchQuery) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("appError \(appError)")
            case .success(let recipes):
                exp.fulfill()
                XCTAssertEqual(recipes.count, expectedRecipesCount)
            }
        }
        wait(for: [exp], timeout: 5.0)
    }
    
}
