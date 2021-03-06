#!/usr/bin/env bash

set -x

download_schema()
{
  from=$1
  to=$2

  for run in {1..5}
  do
    curl -sf --compressed ${from} > ${to}
    result=$?
    if [ $result -eq 0 ]; then break; fi
    sleep 1
  done

  if [ $result -ne 0 ]; then exit $result; fi
}

schemadir="${1:-.schemacache}"

FILES=( \
  "errors/error.json" \
  "metricsets/sample.json" \
  "metricsets/metricset.json" \
  "sourcemaps/payload.json" \
  "spans/span.json" \
  "transactions/mark.json" \
  "transactions/transaction.json" \
  "context.json" \
  "metadata.json" \
  "process.json" \
  "request.json" \
  "service.json" \
  "stacktrace_frame.json" \
  "system.json" \
  "tags.json" \
  "timestamp_epoch.json" \
  "user.json" \
)

mkdir -p \
  ${schemadir}/errors \
  ${schemadir}/transactions \
  ${schemadir}/spans \
  ${schemadir}/metricsets \
  ${schemadir}/sourcemaps

for i in "${FILES[@]}"; do
  download_schema https://raw.githubusercontent.com/elastic/apm-server/master/docs/spec/${i} ${schemadir}/${i}
done
echo "Done."
