//
//  spawn.swift
//  
//
//  Created by Antwan van Houdt on 10/06/2020.
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif

enum POSIXError: Error {
	case nonZeroStatus(Int32)
}

func spawn(_ path: String, args: [String]) throws -> PID {
	let completeArgs = [path] + args
	let unsafeArgs = completeArgs.map { $0.withCString(strdup) } + [nil]
	var pid: PID = -1
	let rc = posix_spawn(&pid, path, nil, nil, unsafeArgs, nil)
	guard rc == 0 else {
		throw POSIXError.nonZeroStatus(rc)
	}
	return pid
}
