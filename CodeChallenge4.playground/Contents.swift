import Foundation
import XCTest

enum VoucherStatus: String {
    case Activated = "Activated"
    case Available = "Available"
    case Redeemed = "Redeemed"
    case Expired = "Expired"
    
    private var sortOrder: Int {
        switch self {
        case .Activated:
            return 0
        case .Available:
            return 1
        case .Redeemed:
            return 2
        case .Expired:
            return 3
        }
    }
    
    static func ==(lhs: VoucherStatus, rhs: VoucherStatus) -> Bool { return lhs.sortOrder == rhs.sortOrder }
    
    static func <(lhs: VoucherStatus, rhs: VoucherStatus) -> Bool { return lhs.sortOrder < rhs.sortOrder }
}

struct Voucher: Equatable {
    let expiryDate: String
    let status: VoucherStatus
    let id: String
}

func convertVouchersStringToVoucherArray(_ vouchersString: String) -> [Voucher] {
    return vouchersString.components(separatedBy: ",")
        .compactMap { $0.components(separatedBy: ":") }
        .compactMap { voucherComponents -> Voucher? in
            guard let status = VoucherStatus(rawValue: voucherComponents[1]) else { return nil }
            return Voucher(expiryDate: voucherComponents[0], status: status, id: voucherComponents[2])
    }
}

func sortVouchersByDateThenTypeThenId(_ vouchers: [Voucher]) -> [Voucher] {
    return vouchers.sorted { (lhs, rhs) -> Bool in
        if lhs.expiryDate < rhs.expiryDate {
            return true
        }
        if lhs.expiryDate == rhs.expiryDate {
            if lhs.status < rhs.status {
                return true
            }
            if lhs.status == rhs.status {
                if lhs.id < rhs.id {
                    return true
                }
            }
        }
        return false
    }
}

func sortVouchers(_ vouchersString: String) -> String {
    let vouchers = convertVouchersStringToVoucherArray(vouchersString)
    let sortedActiveVouchers = sortVouchersByDateThenTypeThenId(vouchers.filter {$0.status == .Activated || $0.status == .Available})
    let sortedRedeemedVouchers = sortVouchersByDateThenTypeThenId(vouchers.filter {$0.status == .Redeemed || $0.status == .Expired})
    let sortedVouchers = sortedActiveVouchers + sortedRedeemedVouchers
    return sortedVouchers.map{ return $0.expiryDate + ":" + $0.status.rawValue + ":" + $0.id }.joined(separator: ",")
}

sortVouchers("190112:Available:aaaa,190112:Activated:bbbb,190111:Available:cccc,190110:Redeemed:dddd,190110:Expired:eeee,190111:Activated:ffff,190111:Expired:gggg,190111:Redeemed:hhhh")

class CodeChallenge4Tests: XCTestCase {
    func test_convertsValidStringToArray() {
        let convertedString = convertVouchersStringToVoucherArray("190112:Available:aaaa")
        let expectedObject = Voucher(expiryDate: "190112", status: .Available, id: "aaaa")
        
        XCTAssertEqual(convertedString, [expectedObject])
    }
    
    func test_convertStringWhereStatusIsInvalidReturnsEmptyArray() {
        let convertedString = convertVouchersStringToVoucherArray("190112:Invalid:aaaa")
        
        XCTAssertEqual(convertedString, [])
    }
    
    func test_convertStringWithMultipleVouchers_SomeValid_SomeInvalid() {
        let convertedString = convertVouchersStringToVoucherArray("190112:Invalid:aaaa,190112:Available:aaaa,190112:Activated:bbbb,190112:Redeemed:cccc,190112:Expired:dddd")
        let expectedArray = [Voucher(expiryDate: "190112", status: .Available, id: "aaaa"), Voucher(expiryDate: "190112", status: .Activated, id: "bbbb"), Voucher(expiryDate: "190112", status: .Redeemed, id: "cccc"), Voucher(expiryDate: "190112", status: .Expired, id: "dddd")]
        
        XCTAssertEqual(convertedString, expectedArray)
    }
    
    func test_sortVouchers_returnsVouchersSortedByExpiryDate() {
        let voucher1 = Voucher(expiryDate: "190113", status: .Available, id: "aaaa")
        let voucher2 = Voucher(expiryDate: "190111", status: .Available, id: "bbbb")
        let voucher3 = Voucher(expiryDate: "190112", status: .Available, id: "cccc")
        let sortedVouchers = sortVouchersByDateThenTypeThenId([voucher1, voucher2, voucher3])
        
        XCTAssertEqual(sortedVouchers[0], voucher2)
        XCTAssertEqual(sortedVouchers[1], voucher3)
        XCTAssertEqual(sortedVouchers[2], voucher1)
    }
    
    func test_sortVouchers_voucher_returnsVouchersSortedByStatus_WhenExpiryDateIsEqual_ActivatedAvailableRedeemedExpired() {
        let voucher1 = Voucher(expiryDate: "190113", status: .Expired, id: "dddd")
        let voucher2 = Voucher(expiryDate: "190113", status: .Activated, id: "bbbb")
        let voucher3 = Voucher(expiryDate: "190113", status: .Available, id: "aaaa")
        let voucher4 = Voucher(expiryDate: "190113", status: .Redeemed, id: "cccc")
        let sortedVouchers = sortVouchersByDateThenTypeThenId([voucher1, voucher2, voucher3, voucher4])
        
        XCTAssertEqual(sortedVouchers[0], voucher2)
        XCTAssertEqual(sortedVouchers[1], voucher3)
        XCTAssertEqual(sortedVouchers[2], voucher4)
        XCTAssertEqual(sortedVouchers[3], voucher1)
    }
    
    func test_sortVouchers_voucher_returnsVouchersSortedById_WhereDateAndStatusEqual() {
        let voucher1 = Voucher(expiryDate: "190113", status: .Activated, id: "dddd")
        let voucher2 = Voucher(expiryDate: "190113", status: .Activated, id: "bbbb")
        let voucher3 = Voucher(expiryDate: "190113", status: .Activated, id: "aaaa")
        let voucher4 = Voucher(expiryDate: "190113", status: .Activated, id: "cccc")
        let sortedVouchers = sortVouchersByDateThenTypeThenId([voucher1, voucher2, voucher3, voucher4])
        
        XCTAssertEqual(sortedVouchers[0], voucher3)
        XCTAssertEqual(sortedVouchers[1], voucher2)
        XCTAssertEqual(sortedVouchers[2], voucher4)
        XCTAssertEqual(sortedVouchers[3], voucher1)
    }
    
    func test_sortVouchers_string_returnsSortedString_WithActiveAvailableThenRedeemedExpired() {
        let unsortedString = "190112:Available:aaaa,190112:Activated:bbbb,190111:Available:cccc,190110:Redeemed:dddd,190110:Expired:eeee,190111:Activated:ffff,190111:Activated:gggg"
        let expectedSortedString = "190111:Activated:ffff,190111:Activated:gggg,190111:Available:cccc,190112:Activated:bbbb,190112:Available:aaaa,190110:Redeemed:dddd,190110:Expired:eeee"
        let sortedString = sortVouchers(unsortedString)
        
        XCTAssertEqual(sortedString, expectedSortedString)
    }
    
    func test_long() {
        let unsorted = "190112:Available:aaaa,190112:Activated:bbbb,190111:Available:cccc,190110:Redeemed:dddd,190110:Expired:eeee,190111:Activated:ffff,190111:Expired:gggg,190111:Redeemed:hhhh"
        let sorted = ""
        XCTAssertEqual(unsorted, sorted)
    }
}

class TestObserver: NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
CodeChallenge4Tests.defaultTestSuite.run()


