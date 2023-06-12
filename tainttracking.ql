/**
 * @kind path-problem
 */

import javascript
import DataFlow::PathGraph

class SinkTrackingConfig extends TaintTracking::Configuration {
    SinkTrackingConfig() { this = "SinkTrackingConfig"}

    override predicate isSource(DataFlow::Node d) {
        // Find exportable functions in the same statement (no `function f(); export f`)
        // d.asExpr().(SimpleParameter).getParent().getParent() instanceof ExportDeclaration

        // For now, just file-based
        d.getFile().getRelativePath().matches("%ReactFiberHooks%")
    }

    override predicate isSink(DataFlow::Node d) {
        // For Flow
        // d.asExpr().(ParExpr).getExpression().(Identifier).getName() = "html" 

        // For TypeScript
        d.asExpr().(TypeAssertion).getExpression().(VarRef).getName() = "html"
    }
}

from SinkTrackingConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Path"