//
//  errno.swift
//  ArgumentParser
//
//  Created by Antwan van Houdt on 11/06/2020.
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif

struct ErrorNumber {
	typealias RawValue = Int32
	let rawValue: RawValue
	init(rawValue: RawValue?) {
		guard let rawValue = rawValue else {
			self.rawValue = errno
			return
		}
		self.rawValue = rawValue
	}
}

extension ErrorNumber: Equatable, Hashable {}

extension ErrorNumber {
	static let ok = ErrorNumber(rawValue: 0)
	static let badFileDescriptor = ErrorNumber(rawValue: EBADF)
	static let addressInUse = ErrorNumber(rawValue: EADDRINUSE)
	static let alreadyBound = ErrorNumber(rawValue: EINVAL)
}

extension ErrorNumber {
	var displayString: String? {
		guard let errStr = strerror(self.rawValue) else {
			return nil
		}
		return String(cString: errStr)
	}
}
