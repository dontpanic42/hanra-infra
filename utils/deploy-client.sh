#!/bin/bash

# Script config
CLIENT_PKG_NAME="client.tar.gz"
CLIENT_DIR="../../client"
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
	-d|--deploy)
	DO_UPLOAD="yes"
	DO_DEPLOY="yes"
	shift
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
	echo " -d|--deploy 	Deploy to webserver (default: off)"
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

# Upload package

if [ ! -z "$DO_UPLOAD" ]; then
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

	echo "All done!"
fi

# Deploy packages
# Expects the 

if [ ! -z "$DO_DEPLOY" ]; then 
	echo ""
	echo "==========================================="
	echo "Deploying fronted"
	echo "==========================================="
	echo ""

	aws ssm send-command --document-name "AWS-RunShellScript" \
		--document-version "1" \
		--targets '[{"Key":"tag:Name","Values":["hanra-web-instance"]}]' \
		--parameters '{"workingDirectory":[""],"executionTimeout":["120"],"commands":["deploy-client"]}' \
		--timeout-seconds 600 --max-concurrency "50" \
		--max-errors "0" \
		--region eu-central-1
fi