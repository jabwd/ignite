//
//  imports.swift
//  
//
//  Created by Antwan van Houdt on 10/06/2020.
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif

typealias PID = pid_t
typealias FileDescriptor = Int32

extension FileDescriptor {
	func release() {
		close(self)
	}
}
