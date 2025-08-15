#!/usr/bin/env bash
set -e

PROTO_DIR=proto
OUT_DIR=proto

# Path for googleapis
GAPI_PKG=$(go list -m -f '{{.Dir}}' github.com/googleapis/googleapis)

# Generate gRPC code only
protoc -I${PROTO_DIR} -I${GAPI_PKG} \
  --go_out=${OUT_DIR} --go_opt=paths=source_relative \
  --go-grpc_out=${OUT_DIR} --go-grpc_opt=paths=source_relative \
  ${PROTO_DIR}/*.proto

# Generate Envoy descriptor (.pb) for REST transcoding
protoc -I${PROTO_DIR} -I${GAPI_PKG} \
  --include_imports --descriptor_set_out=${OUT_DIR}/hello.pb \
  ${PROTO_DIR}/*.proto

# Optional: Copy .pb to .desc for Envoy if needed
cp ${OUT_DIR}/hello.pb ${OUT_DIR}/hello.desc

echo "✅ gRPC code, Envoy descriptor (.pb) and .desc file generated successfully."
