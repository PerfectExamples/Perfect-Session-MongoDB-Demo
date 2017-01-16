//
//  main.swift
//  Perfect Session MongoDB Demo
//
//  Created by Jonathan Guthrie on 2017-01-05.
//	Copyright (C) 2017 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 20176 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//



import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectSession
import PerfectSessionMongoDB
import MongoDBStORM

let server = HTTPServer()

SessionConfig.name = "TestingMongoDBDrivers"
SessionConfig.idle = 60
SessionConfig.mongoCollection = "perfectsessions"

// Optional
SessionConfig.cookieDomain = "localhost"
SessionConfig.IPAddressLock = true
SessionConfig.userAgentLock = true
SessionConfig.CSRF.checkState = true

SessionConfig.CORS.enabled = true
SessionConfig.CORS.acceptableHostnames.append("http://www.test-cors.org")
//SessionConfig.CORS.acceptableHostnames.append("*.test-cors.org")
SessionConfig.CORS.maxAge = 60


MongoDBConnection.host = "localhost"
MongoDBConnection.database = "perfect_testing"

let sessionDriver = SessionMongoDBDriver()

server.setRequestFilters([sessionDriver.requestFilter])
server.setResponseFilters([sessionDriver.responseFilter])

server.addRoutes(makeWebDemoRoutes())
server.serverPort = 8181

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
