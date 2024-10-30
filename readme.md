# Neovim AWS Bedrock Integration

This repository contains a Lua module for integrating AWS Bedrock with Neovim. The main file, `bedrock.lua`, provides functionality to stream responses from AWS Bedrock directly into a Neovim buffer.

![bedrock](bedrock.gif)

## Dependencies

This project depends on the AWS Lambda Web Adapter for creating the endpoint for AWS Bedrock. The specific example used as a reference is the FastAPI response streaming example, which can be found at:

[https://github.com/awslabs/aws-lambda-web-adapter/tree/main/examples/fastapi-response-streaming](https://github.com/awslabs/aws-lambda-web-adapter/tree/main/examples/fastapi-response-streaming)

## Features

- Stream responses from AWS Bedrock directly into a Neovim buffer
- Use visual selection as input for the AWS Bedrock prompt
- Automatically create or open a file for the response
- Real-time updating of the response in the buffer

## Usage

The main functionality is provided by the `stream_response()` function. This function:

1. Gets the current visual selection as the prompt
2. Encodes the payload for the AWS Bedrock API
3. Creates or opens a file named `llm.md`
4. Streams the response from AWS Bedrock into this file

## Configuration

The module uses environment variables for configuration:

- `AWS_BEDROCK_URL`: The URL of your AWS Bedrock endpoint
- `AWS_BEDROCK_API_KEY`: Your AWS Bedrock API key

Make sure to set these environment variables before using the module.

## Note

This is a custom integration and requires proper setup of the AWS Lambda Web Adapter and AWS Bedrock. Ensure you have the necessary permissions and configurations in place before using this module.
