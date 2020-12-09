#!/bin/bash

# Script config
CLIENT_PKG_NAME="client.tar.gz"
SERVER_PKG_NAME="server.tar.gz"
CLIENT_DIR="../../client"
SERVER_DIR="../../server"
UPLOAD_BUCKET_NAME="hanra-ansible-transfer"

# Script/directory setup
BASE_DIR="$( cd "$(dirname "$0")" > /dev/null 2>&1; pwd -P )"
OUTPUT_DIR="$BASE_DIR/out"
mkdir -p "$OUTPUT_DIR"
rm -rf "$OUTPUT_DIR/*.tar.gz"

# Parse command line args

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    SHOW_HELP="yes"
    shift # past argument
    ;;
    -u|--upload)
    DO_UPLOAD="yes"
    shift # past argument
    ;;
    *)    # unknown option
	SHOW_HELP="yes"
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Show help

if [ -n "$SHOW_HELP" ]; then
	echo ""
	echo "Build and package helper"
	echo "==================================="
	echo ""
	echo " -h|--help	This help message"
	echo " -u|--upload	Upload packages to s3 (default: off)"
	exit 0
fi

# Build & package
echo ""
echo "==========================================="
echo "Build & package client"
echo "==========================================="
echo ""

cd "$CLIENT_DIR"

NODE_ENV=production npm run build

if [[ "$?" -ne 0 ]]; then
	echo "Error! Client build script did not run sucessfully!"
	exit 1
fi

if [[ ! -d "dist" ]]; then
	echo "Error! Build ran successfully, but no 'dist' directory found in $(pwd)"
	exit 1
fi

tar -zcvf "$OUTPUT_DIR/$CLIENT_PKG_NAME" "dist"
cd "$BASE_DIR"

# Package server

echo ""
echo "==========================================="
echo "Build & package server"
echo "==========================================="
echo ""

cd "$SERVER_DIR"

# Server does not have a build command like the client, we just need to pack
# everything that's in the dir that's not in the gitignore

tar -zcvf "$OUTPUT_DIR/$SERVER_PKG_NAME" $(git ls-tree --full-tree --name-only HEAD | xargs)

if [[ "$?" -ne 0 ]]; then
	echo "Error! Unknown error during packaing of server."
	exit 1
fi

cd "$BASE_DIR"

# Upload packages

if [ -n "$DO_UPLOAD" ]; then
	echo ""
	echo "==========================================="
	echo "Uploading to S3 ($UPLOAD_BUCKET_NAME)"
	echo "==========================================="
	echo ""
	
	# Upload client package
	aws s3 cp "$OUTPUT_DIR/$CLIENT_PKG_NAME" "s3://$UPLOAD_BUCKET_NAME/$CLIENT_PKG_NAME"
	if [[ "$?" -ne 0 ]]; then
		echo "Error! Uploading client package to s3 failed"
		exit 1
	fi	

	# Upload server package
	aws s3 cp "$OUTPUT_DIR/$SERVER_PKG_NAME" "s3://$UPLOAD_BUCKET_NAME/$SERVER_PKG_NAME"
	if [[ "$?" -ne 0 ]]; then
		echo "Error! Uploading server package to s3 failed"
		exit 1
	fi	

	echo "All done!"
fi