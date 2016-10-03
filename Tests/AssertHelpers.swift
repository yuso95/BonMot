//
//  AssertHelpers.swift
//
//  Created by Brian King on 9/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import XCTest
import BonMot

func dataFromImage(image theImage: BONImage) -> Data {
    assert(theImage.size != .zero)
    #if os(OSX)
        let cgImgRef = theImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let bmpImgRef = NSBitmapImageRep(cgImage: cgImgRef!)
        let pngData = bmpImgRef.representation(using: .PNG, properties: [:])!
        return pngData
    #else
        return UIImagePNGRepresentation(theImage)!
    #endif
}

func BONAssert<T: Equatable>(attributes dictionary: StyleAttributes?, key: String, value: T, file: StaticString = #file, line: UInt = #line) {
    guard let dictionaryValue = dictionary?[key] as? T else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    XCTAssert(dictionaryValue == value, "\(key): \(dictionaryValue) != \(value)", file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, key: String, float: CGFloat, accuracy: CGFloat, file: StaticString = #file, line: UInt = #line) {
    guard let dictionaryValue = dictionary?[key] as? CGFloat else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    XCTAssertEqualWithAccuracy(dictionaryValue, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (BONFont) -> CGFloat, float: CGFloat, accuracy: CGFloat = 0.001, file: StaticString = #file, line: UInt = #line) {
    guard let font = dictionary?[NSFontAttributeName] as? BONFont else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let value = query(font)
    XCTAssertEqualWithAccuracy(value, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> CGFloat, float: CGFloat, accuracy: CGFloat, file: StaticString = #file, line: UInt = #line) {
    guard let paragraphStyle = dictionary?[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqualWithAccuracy(actualValue, float, accuracy: accuracy, file: file, line: line)
}

func BONAssert(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> Int, value: Int, file: StaticString = #file, line: UInt = #line) {
    guard let paragraphStyle = dictionary?[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
        XCTFail("value is not of expected type", file: file, line: line)
        return
    }
    let actualValue = query(paragraphStyle)
    XCTAssertEqual(value, actualValue, file: file, line: line)
}

#if swift(>=3.0)
    func BONAssert<T: RawRepresentable>(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> T, value: T, file: StaticString = #file, line: UInt = #line) where T.RawValue: Equatable {
        guard let paragraphStyle = dictionary?[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
            XCTFail("value is not of expected type", file: file, line: line)
            return
        }
        let actualValue = query(paragraphStyle)
        XCTAssertEqual(value.rawValue, actualValue.rawValue, file: file, line: line)
    }

    func BONAssertEqualImages(_ image1: BONImage, _ image2: BONImage, file: StaticString = #file, line: UInt = #line) {
        let data1 = dataFromImage(image: image1)
        let data2 = dataFromImage(image: image2)
        XCTAssertEqual(data1, data2, file: file, line: line)
    }

    func BONAssertNotEqualImages(_ image1: BONImage, _ image2: BONImage, file: StaticString = #file, line: UInt = #line) {
        let data1 = dataFromImage(image: image1)
        let data2 = dataFromImage(image: image2)
        XCTAssertNotEqual(data1, data2, file: file, line: line)
    }
#else
    func BONAssert<T: RawRepresentable where T.RawValue: Equatable>(attributes dictionary: StyleAttributes?, query: (NSParagraphStyle) -> T, value: T, file: StaticString = #file, line: UInt = #line) {
        guard let paragraphStyle = dictionary?[NSParagraphStyleAttributeName] as? NSParagraphStyle else {
            XCTFail("value is not of expected type", file: file, line: line)
            return
        }
        let actualValue = query(paragraphStyle)
        XCTAssertEqual(value.rawValue, actualValue.rawValue, file: file, line: line)
    }

    func BONAssertEqualImages(image1: BONImage, _ image2: BONImage, file: StaticString = #file, line: UInt = #line) {
        let data1 = dataFromImage(image: image1)
        let data2 = dataFromImage(image: image2)
        XCTAssertEqual(data1, data2, file: file, line: line)
    }

    func BONAssertNotEqualImages(image1: BONImage, _ image2: BONImage, file: StaticString = #file, line: UInt = #line) {
        let data1 = dataFromImage(image: image1)
        let data2 = dataFromImage(image: image2)
        XCTAssertNotEqual(data1, data2, file: file, line: line)
    }
#endif
