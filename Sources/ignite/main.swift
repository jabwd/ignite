#if os(Linux)
import Glibc
#else
import Darwin
#endif
import Runloop
import ArgumentParser

struct IgniteOptions: ParsableCommand {
	@Flag(name: .customShort("d"), help: "Launch as a child process")
	var isChild: Bool
	
	@Option(name: .shortAndLong, default: 7050, help: "Port number to bind on")
	var port: Int
	
	@Option(name: .shortAndLong, default: -1, help: "FD")
	var fileDescriptor: Int32
}
let pathToExecutable = CommandLine.arguments[0]
let options = IgniteOptions.parseOrExit()

if (options.isChild) {
	print("Hello World from child process!", options.fileDescriptor)
	exit(0)
}

let socket = Socket(host: "0.0.0.0", port: options.port)!
let pid = try spawn(pathToExecutable, args: ["-d", "-f", "\(socket.fd)"])
print("PID child: \(pid)")

Runloop().run()
