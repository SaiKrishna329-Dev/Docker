Important Dockerfile Instructions:

FROM:

The FROM instruction in a Dockerfile specifies the base image for building your Docker image. It is usually the first instruction in a Dockerfile.
It tells Docker which existing image to use as the starting point.
Example: FROM ubuntu:20.04

NOTE:
Every Dockerfile must start with a FROM (except for multi-stage builds, where later stages can use FROM again).
You can use multiple FROM instructions for multi-stage builds.
If you omit the tag (e.g., FROM ubuntu), Docker uses the latest tag by default, which can lead to unpredictable builds if the base image updates. Always specify a tag for reproducibility.

