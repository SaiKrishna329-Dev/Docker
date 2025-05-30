# **Important Dockerfile Instructions:**

**1.FROM:**

- The FROM instruction in a Dockerfile specifies the base image for building your Docker image. It is usually the first 
  instruction in a Dockerfile.
- It tells Docker which existing image to use as the starting point.
- The syntax is: `FROM <image>[:<tag>]`
  - `<image>` is the name of the base image.
  - `<tag>` is an optional tag that specifies a version or variant of the image. If omitted, Docker defaults to the `latest` tag.
- Example: `FROM ubuntu:20.04`


**NOTE:**
- Every Dockerfile must start with a FROM (except for multi-stage builds, where later stages can use FROM again).
- You can use multiple FROM instructions for multi-stage builds.
- If you omit the tag (e.g., FROM ubuntu), Docker uses the latest tag by default, which can lead to unpredictable builds - if the base image updates. Always specify a tag for reproducibility.

**2.ARG:**
- The ARG instruction defines a variable that users can pass at build-time to the Dockerfile with the docker build command using the --build-arg <varname>=<value> flag.
- It is used to define build-time variables that can be accessed during the image build process.
- The syntax is: `ARG <name>[=<default_value>]`
  - `<name>` is the name of the variable.
  - `<default_value>` is an optional default value for the variable.
- Example: `ARG VERSION=1.0`
- ARG variables are not available in the final image, only during the build process.
- An ARG declared before a FROM is outside of a build stage, so it can't be used in any instruction after a FROM. To use 
  the default value of an ARG declared before the first FROM use an ARG instruction without a value inside of a build stage.
  ```dockerfile
    ARG VERSION=latest
    FROM busybox:$VERSION
    ARG VERSION
    RUN echo $VERSION > image_version
    ```
- You can use ARG variables in other instructions like RUN, ENV, or LABEL.
- Example usage in a Dockerfile:
  ```dockerfile
  FROM ubuntu:20.04
  ARG VERSION=1.0
  RUN echo "Building version $VERSION"
  ```
- To pass a value for the ARG variable during build, use:
  ```bash
    docker build --build-arg VERSION=2.0 -t myimage .
    ```
- Note: ARG variables are not available in the final image, only during the build process. If you need to set environment variables that persist in the final image, use the ENV instruction instead.