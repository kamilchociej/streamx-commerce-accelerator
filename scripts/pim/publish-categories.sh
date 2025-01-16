#!/bin/bash
echo "Ingesting categories into StreamX..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
input_file="$SCRIPT_DIR/categories.json"

json_data=$(cat "$input_file")

categories_count=$(echo "$json_data" | jq 'length')
batch_size=100

for ((i=0; i<categories_count; i+=batch_size)); do
    batch=$(echo "$json_data" | jq ".[$i:$(($i + $batch_size))]")
    processed_categories=""
    counter=0

    echo "$batch" | jq -c '.[]' | while IFS= read -r category; do
        counter=$((counter + 1))
        id=$(echo "$category" | jq -r '.id')

        processed_category=$(jq -n --arg id "$id" --argjson category "$category" --arg prefix "cat:" \
        '{
            "key": ($prefix + $id),
            "action": "publish",
            "eventTime": null,
            "properties": {},
            "payload": {
              "dev.streamx.blueprints.data.Data": {
                "content": {
                  "bytes": ($category | @json)
                }
              }
            }
        }')

        processed_categories+="$processed_category"
        next_batch_end=$((i + batch_size))

        if [ $counter -eq $batch_size ] || [ $next_batch_end -ge $categories_count ]; then
            sh "$SCRIPT_DIR/../ingestion/publish.sh" data "$processed_categories" > /dev/null 2>&1
            processed_categories=""
            counter=0
        fi
    done
done

echo "Categories successfully ingested"
