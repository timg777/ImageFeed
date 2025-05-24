func logErrorToSTDIO(
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line,
    errorDescription: String
) {
    print(
        "\n(\(fileID)) [\(function)] in line \(line): \(errorDescription)\n"
    )
}
