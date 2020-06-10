//
//  Socket.swift
//  
//
//  Created by Antwan van Houdt on 10/06/2020.
//

// Get rid of this later
#if os(Linux)
import Glibc
#else
import Darwin
#endif

final class Socket {
	let fd: FileDescriptor

	init(_ fd: FileDescriptor) {
		self.fd = fd
	}

	init?(host: String, port: Int) {
		fd = socket(domain: .IPv4, type: .tcp)
		var address = newSockaddr(domain: .IPv4, port: port)
		fd.setSocketOption(SO_REUSEADDR, value: 1)
		fd.setSocketOption(TCP_NODELAY, value: 1)
		let rc = bind(fd, &address, UInt32(MemoryLayout<sockaddr_in>.size))
		let err = ErrorNumber(rawValue: rc)
		guard err == .ok else {
			return nil
		}
		makeSocketNonBlocking(fd)
	}

	deinit {
		fd.release()
	}
}
