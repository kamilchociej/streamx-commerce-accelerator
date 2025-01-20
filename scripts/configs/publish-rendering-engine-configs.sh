#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pdpRenderingContext='{
  "key": "pdp-rendering-context",
  "action": "publish",
  "eventTime": null,
  "properties": { },
  "payload": {
    "dev.streamx.blueprints.data.RenderingContext": {
      "rendererKey": { "string": "templates/pdp.html" },
      "dataKeyMatchPattern": { "string": "product:.*" },
      "outputKeyTemplate": { "string": "/products/{{slug}}.html" },
      "outputType": { "dev.streamx.blueprints.data.RenderingContext.OutputType": "PAGE" }
    }
  }
}'

categoryRenderingContext='{
  "key": "category-rendering-context",
  "action": "publish",
  "eventTime": null,
  "properties": { },
  "payload": {
    "dev.streamx.blueprints.data.RenderingContext": {
      "rendererKey": { "string": "category-renderer" },
      "dataKeyMatchPattern": { "string": "category:.*" },
      "outputKeyTemplate": { "string": "/categories/{{slug}}.html" },
      "outputType": { "dev.streamx.blueprints.data.RenderingContext.OutputType": "PAGE" }
    }
  }
}'

echo "Ingesting rendering engine configurations..."
sh "$SCRIPT_DIR/../ingestion/publish.sh" rendering-contexts "$pdpRenderingContext"  > /dev/null 2>&1
sh "$SCRIPT_DIR/../ingestion/publish.sh" rendering-contexts "$categoryRenderingContext" > /dev/null 2>&1
echo "Rendering engine configs successfully ingested"