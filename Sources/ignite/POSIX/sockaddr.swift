//
//  sockaddr.swift
//  
//
//  Created by Antwan van Houdt on 10/06/2020.
//
#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Foundation

func newSockaddr(domain: Domain, port: Int) -> sockaddr {
	let port = UInt16(port)
	var address = sockaddr_in()
	address.sin_family = sa_family_t(UInt16(domain.rawValue))
	#if os(Linux)
	address.sin_port = htons(port)
	#else
	address.sin_port = CFSwapInt16HostToBig(port)
	#endif
	address.sin_addr.s_addr = INADDR_ANY
	return address.asAddr()
}

public extension sockaddr_in {
	///  Rebinds the memory to sockaddr struct type
	///  So swift isn't shocked by the fact that they kinda hacked this generic
	///  thing into C code back in the day.
	///
	/// - Returns: sockaddr
	func asAddr() -> sockaddr {
		var temp = self
		let addr = withUnsafePointer(to: &temp) {
			return UnsafeRawPointer($0)
		}
		return addr.assumingMemoryBound(to: sockaddr.self).pointee
	}
}

@inline(__always)
func makeSocketNonBlocking(_ fd: Int32) {
	let flags = fcntl(fd, F_GETFL, 0)
	assert(flags != -1)
	_ = fcntl(fd, F_SETFL, flags | O_NONBLOCK)
}
