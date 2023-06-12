import javascript
import DataFlow

DataFlow::SourceNode myType(TypeBackTracker t) {
    t.start() and
    result = (/* argument to track */).getALocalSource()
    or
    exists(TypeBackTracker t2 |
        result = myType(t2).backtrack(t2, t)
    )
}

SourceNode myType() {
    result = myType(TypeBackTracker::end())
}