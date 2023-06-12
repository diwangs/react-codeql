import javascript

/* These two has no sinks */
// import semmle.javascript.security.dataflow.XssThroughDomCustomizations
// import semmle.javascript.security.dataflow.ExceptionXssCustomizations

import semmle.javascript.security.dataflow.DomBasedXssCustomizations
// import semmle.javascript.security.dataflow.StoredXssCustomizations       // the same sinks as above?
// import semmle.javascript.security.dataflow.ReflectedXssCustomizations    // subset of the above

from DomBasedXss::Sink sink
where not sink.getFile().getRelativePath().matches("%test%")
    and not sink.getFile().getRelativePath().matches("%fixtures%")
    and not sink.getFile().getRelativePath().matches("%devtools%")
select sink, sink.getFile().getRelativePath(), sink.getStartLine()