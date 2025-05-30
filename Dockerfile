Important Dockerfile Instructions:

FROM:

The FROM instruction in a Dockerfile specifies the base image for building your Docker image. It is usually the first instruction in a Dockerfile.

How it works:

It tells Docker which existing image to use as the starting point.
You can use official images (like ubuntu, node, python, etc.) or your own images.
You can specify a tag (like python:3.11) or a digest for more control over the version.

Example: FROM ubuntu:20.04

Key points:
Every Dockerfile must start with a FROM (except for multi-stage builds, where later stages can use FROM again).
You can use multiple FROM instructions for multi-stage builds.

Gotcha:
If you omit the tag (e.g., FROM ubuntu), Docker uses the latest tag by default, which can lead to unpredictable builds if the base image updates. Always specify a tag for reproducibility.

