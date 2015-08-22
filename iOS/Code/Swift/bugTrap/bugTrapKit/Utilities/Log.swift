//
//  Log.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/21/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import Foundation

struct Log {

	private static var printInfo: Bool {
		#if RELEASE
		return false
		#else
		return true // manually toggle this
		#endif
	}

	// MARK: - Info

	static func info<T : CustomStringConvertible>(object: T) {
		printInfoLn(" INFO: \(object.description)")
	}

	static func info<T : CustomDebugStringConvertible>(object: T) {
		printInfoLn(" INFO: \(object.debugDescription)")
	}

	static func info<T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(object: T) {
		printInfoLn(" INFO: \(object.debugDescription)")
	}



	static func info<T : CustomStringConvertible>(context: T, _ object: T) {
		printInfoLn(" INFO: [\(context)] \(object.description)")
	}

	static func info<Td : CustomDebugStringConvertible, T : CustomStringConvertible>(context: Td, _ object: T) {
		printInfoLn(" INFO: [\(context)] \(object.description)")
	}

	static func info<Td : protocol<CustomStringConvertible,CustomDebugStringConvertible>, T : CustomStringConvertible>(context: Td, _ object: T) {
		printInfoLn(" INFO: [\(context)] \(object.description)")
	}



	static func info<T : CustomDebugStringConvertible>(context: T, _ object: T) {
		printInfoLn(" INFO: [\(context)] \(object.debugDescription)")
	}

	static func info<Td : CustomStringConvertible, T : CustomDebugStringConvertible>(context: Td, _ object: T) {
		printInfoLn(" INFO: [\(context)] \(object.debugDescription)")
	}

	static func info<Td : protocol<CustomStringConvertible,CustomDebugStringConvertible>, T : CustomDebugStringConvertible>(context: Td, _ object: T) {
		printInfoLn(" INFO: [\(context)] \(object.debugDescription)")
	}



	static func info<T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: T, _ object: T) {
		printInfoLn(" INFO: [\(context)] \(object.debugDescription)")
	}

	static func info<Td : CustomStringConvertible, T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: Td, _ object: T) {
		printInfoLn(" INFO: [\(context)] \(object.debugDescription)")
	}

	static func info<Td : CustomDebugStringConvertible, T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: Td, _ object: T) {
		printInfoLn(" INFO: [\(context)] \(object.debugDescription)")
	}


	private static func printInfoLn (message: String) {
		if printInfo {
			print(message)
		}
	}




	// MARK: - Debug

	static func debug<T : CustomStringConvertible>(object: T) {
		printDebugLn("DEBUG: \(object.description)")
	}

	static func debug<T : CustomDebugStringConvertible>(object: T) {
		printDebugLn("DEBUG: \(object.debugDescription)")
	}

	static func debug<T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(object: T) {
		printDebugLn("DEBUG: \(object.debugDescription)")
	}



	static func debug<T : CustomStringConvertible>(context: T, _ object: T) {
		printDebugLn("DEBUG: [\(context)] \(object.description)")
	}

	static func debug<Td : CustomDebugStringConvertible, T : CustomStringConvertible>(context: Td, _ object: T) {
		printDebugLn("DEBUG: [\(context)] \(object.description)")
	}

	static func debug<Td : protocol<CustomStringConvertible,CustomDebugStringConvertible>, T : CustomStringConvertible>(context: Td, _ object: T) {
		printDebugLn("DEBUG: [\(context)] \(object.description)")
	}



	static func debug<T : CustomDebugStringConvertible>(context: T, _ object: T) {
		printDebugLn("DEBUG: [\(context)] \(object.debugDescription)")
	}

	static func debug<Td : CustomStringConvertible, T : CustomDebugStringConvertible>(context: Td, _ object: T) {
		printDebugLn("DEBUG: [\(context)] \(object.debugDescription)")
	}

	static func debug<Td : protocol<CustomStringConvertible,CustomDebugStringConvertible>, T : CustomDebugStringConvertible>(context: Td, _ object: T) {
		printDebugLn("DEBUG: [\(context)] \(object.debugDescription)")
	}



	static func debug<T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: T, _ object: T) {
		printDebugLn("DEBUG: [\(context)] \(object.debugDescription)")
	}

	static func debug<Td : CustomStringConvertible, T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: Td, _ object: T) {
		printDebugLn("DEBUG: [\(context)] \(object.debugDescription)")
	}

	static func debug<Td : CustomDebugStringConvertible, T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: Td, _ object: T) {
		printDebugLn("DEBUG: [\(context)] \(object.debugDescription)")
	}


	private static func printDebugLn (message: String) {
		#if DEBUG
		print(message)
		#endif
	}


	// MARK: - Warning

	static func warning<T : CustomStringConvertible>(object: T) {
		print("WARNING: \(object.description)")
	}

	static func warning<T : CustomDebugStringConvertible>(object: T) {
		print("WARNING: \(object.debugDescription)")
	}

	static func warning<T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(object: T) {
		print("WARNING: \(object.debugDescription)")
	}



	static func warning<T : CustomStringConvertible>(context: T, _ object: T) {
		print("WARNING: [\(context)] \(object.description)")
	}

	static func warning<Td : CustomDebugStringConvertible, T : CustomStringConvertible>(context: Td, _ object: T) {
		print("WARNING: [\(context)] \(object.description)")
	}

	static func warning<Td : protocol<CustomStringConvertible,CustomDebugStringConvertible>, T : CustomStringConvertible>(context: Td, _ object: T) {
		print("WARNING: [\(context)] \(object.description)")
	}



	static func warning<T : CustomDebugStringConvertible>(context: T, _ object: T) {
		print("WARNING: [\(context)] \(object.debugDescription)")
	}

	static func warning<Td : CustomStringConvertible, T : CustomDebugStringConvertible>(context: Td, _ object: T) {
		print("WARNING: [\(context)] \(object.debugDescription)")
	}

	static func warning<Td : protocol<CustomStringConvertible,CustomDebugStringConvertible>, T : CustomDebugStringConvertible>(context: Td, _ object: T) {
		print("WARNING: [\(context)] \(object.debugDescription)")
	}



	static func warning<T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: T, _ object: T) {
		print("WARNING: [\(context)] \(object.debugDescription)")
	}

	static func warning<Td : CustomStringConvertible, T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: Td, _ object: T) {
		print("WARNING: [\(context)] \(object.debugDescription)")
	}

	static func warning<Td : CustomDebugStringConvertible, T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: Td, _ object: T) {
		print("WARNING: [\(context)] \(object.debugDescription)")
	}




	// MARK: - Error

	static func error<T : CustomStringConvertible>(object: T) {
		print("ERROR: \(object.description)")
		Analytics.Shared.logError(object.description)
	}

	static func error<T : CustomDebugStringConvertible>(object: T) {
		print("ERROR: \(object.debugDescription)")
		Analytics.Shared.logError(object.debugDescription)
	}

	static func error<T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(object: T) {
		print("ERROR: \(object.debugDescription)")
		Analytics.Shared.logError(object.debugDescription)
	}


	static func error<T : CustomStringConvertible>(context: T, _ object: T) {
		print("ERROR: [\(context)] \(object.description)")
		Analytics.Shared.logError(object.description)
	}

	static func error<Td : CustomDebugStringConvertible, T : CustomStringConvertible>(context: Td, _ object: T) {
		print("ERROR: [\(context)] \(object.description)")
		Analytics.Shared.logError(object.description)
	}

	static func error<Td : protocol<CustomStringConvertible,CustomDebugStringConvertible>, T : CustomStringConvertible>(context: Td, _ object: T) {
		print("ERROR: [\(context)] \(object.description)")
		Analytics.Shared.logError(object.description)
	}



	static func error<T : CustomDebugStringConvertible>(context: T, _ object: T) {
		print("ERROR: [\(context)] \(object.debugDescription)")
		Analytics.Shared.logError(object.debugDescription)
	}

	static func error<Td : CustomStringConvertible, T : CustomDebugStringConvertible>(context: Td, _ object: T) {
		print("ERROR: [\(context)] \(object.debugDescription)")
		Analytics.Shared.logError(object.debugDescription)
	}

	static func error<Td : protocol<CustomStringConvertible,CustomDebugStringConvertible>, T : CustomDebugStringConvertible>(context: Td, _ object: T) {
		print("ERROR: [\(context)] \(object.debugDescription)")
		Analytics.Shared.logError(object.debugDescription)
	}



	static func error<T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: T, _ object: T) {
		print("ERROR: [\(context)] \(object.debugDescription)")
		Analytics.Shared.logError(object.debugDescription)
	}

	static func error<Td : CustomStringConvertible, T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: Td, _ object: T) {
		print("ERROR: [\(context)] \(object.debugDescription)")
		Analytics.Shared.logError(object.debugDescription)
	}

	static func error<Td : CustomDebugStringConvertible, T : protocol<CustomStringConvertible,CustomDebugStringConvertible>>(context: Td, _ object: T) {
		print("ERROR: [\(context)] \(object.debugDescription)")
		Analytics.Shared.logError(object.debugDescription)
	}
}