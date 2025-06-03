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


**3.RUN:**
- The RUN instruction will execute any commands to create a new layer on top of the current image. The added layer is used in the next step in the Dockerfile.
- **Ex:** 
    - Shell form:
      RUN [OPTIONS] <command> ...
    - Exec form:
      RUN [OPTIONS] [ "<command>", ... ]
    - Shell form : 
      RUN <<EOF
      apt-get update
      apt-get install -y curl
      EOF     


**4.CMD:**   
 - The CMD instruction sets the command to be executed when running a container from an image.(Execute at the time of container creation)   
 - There can only be one CMD instruction in a Dockerfile. If you list more than one CMD, only the **last one takes effect**.
 - The purpose of a CMD is to provide defaults for an executing container.These defaults can include an executable, or they can omit the executable, in which case you must specify an ENTRYPOINT instruction as well.
 - If you would like your container to run the same executable every time, then you should consider using ENTRYPOINT in combination with CMD.
 - CMD can be overridden, but ENTRYPOINT can't be overridden.


 **5.ENTRYPOINT:**
 - An ENTRYPOINT allows you to configure a container that will run as an executable.
 - ENTRYPOINT has two possible forms:

         The exec form, which is the preferred form: ENTRYPOINT ["executable", "param1", "param2"]
         The shell form: ENTRYPOINT command param1 param2


 **NOTE:**
  - Command line arguments to docker run <image> will be appended after all elements in an exec form ENTRYPOINT, and will override all elements specified using 
    CMD.
  - You can override the ENTRYPOINT instruction using the **docker run --entrypoint** flag.      
  - Only the last ENTRYPOINT instruction in the Dockerfile will have an effect. 
  - what command is executed for different ENTRYPOINT / CMD combinations: 

          ENTRYPOINT exec_entry p1_entry         -- /bin/sh -c exec_entry p1_entry
          ENTRYPOINT ["exec_entry", "p1_entry"]  -- exec_entry p1_entry


**6.LABEL:**    
  - The LABEL instruction adds metadata to an image. A LABEL is a key-value pair.
  - An image can have more than one label. You can specify multiple labels on a single line.
     
     **Ex:**

          LABEL "com.example.vendor"="ACME Incorporated"
          LABEL com.example.label-with-value="foo"
          LABEL version="1.0"
          LABEL description="This text illustrates \
          that label-values can span multiple lines."     

  - To view images labels -- docker image inspect --format='{{json .Config.Labels}}' myimage      