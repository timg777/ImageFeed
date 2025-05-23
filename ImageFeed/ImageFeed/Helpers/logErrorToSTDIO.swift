func logErrorToSTDIO(
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line,
    errorDescription: String
) {
    print(
        "(\(fileID)) [\(function)] in line \(line): \(errorDescription)"
    )
    #warning("print here")
}
