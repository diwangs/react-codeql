import javascript
import semmle.javascript.security.dataflow.ExternalAPIUsedWithUntrustedDataQuery

from ExternalApiUsedWithUntrustedData externalApi
select externalApi, count(externalApi.getUntrustedDataNode()) as numberOfUses,
    externalApi.getNumberOfUntrustedSources() as numberOfUntrustedSources order by
        numberOfUntrustedSources desc
