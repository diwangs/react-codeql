/**
 * @kind path-problem
 */

import javascript
import DataFlow::PathGraph

class SinkTrackingConfig extends TaintTracking::Configuration {
    SinkTrackingConfig() { this = "SinkTrackingConfig" }

    override predicate isSource(DataFlow::Node d) {
        d.getFile().getRelativePath().matches("%ReactHooks%")
    }

    override predicate isSink(DataFlow::Node d) {
        // Error: supposed to detect the "dispatch" in e.g. `mountReducer`
        d.asExpr().(ArrayExpr).getElement(1).(VarRef).getName() = "dispatch"
    }
}

from SinkTrackingConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Path"
