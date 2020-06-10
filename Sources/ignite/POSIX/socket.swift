//
//  File.swift
//  
//
//  Created by Antwan van Houdt on 10/06/2020.
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif

struct SocketOption {
	typealias RawValue = Int32
	var rawValue: RawValue
	init(rawValue: RawValue) { self.rawValue = rawValue }
}

extension SocketOption {
	static let reuseAddress = SocketOption(rawValue: SO_REUSEADDR)
}

enum Domain: Int32 {
	case unix = 1
	case IPv4 = 2
	case IPv6 = 10
}

enum SocketType: Int32 {
	case tcp = 1
	case udp = 2
}

extension FileDescriptor {
	func setSocketOption(_ option: Int32, value: Int32) {
		var value = value
		setsockopt(self, SOL_SOCKET, option, &value, UInt32(MemoryLayout<Int32>.size))
	}
}

func socket(domain: Domain, type: SocketType) -> FileDescriptor {
	#if os(Linux)
	return Glibc.socket(domain.rawValue, type.rawValue, 0)
	#else
	return Darwin.socket(domain.rawValue, type.rawValue, 0)
	#endif
}
