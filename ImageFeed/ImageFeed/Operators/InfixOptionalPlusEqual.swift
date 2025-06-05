// MARK: - Infix operator & function (+=?)
infix operator +=? : AssignmentPrecedence

func +=?(lhs: inout Int?, rhs: Int) {
    lhs = (lhs ?? 0) + rhs
}
