enum JSONDecodeError : Error {
    case invalidFormat(json: Any)
    case invalidResponse(object: Any)
    case missingValue(key: String, actualValue: Any?)
}
