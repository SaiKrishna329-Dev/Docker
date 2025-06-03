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
  **Ex:** 

       Shell form: RUN [OPTIONS] <command> ...
       Exec form: RUN [OPTIONS] [ "<command>", ... ]
       Shell form : 
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
  - Command line arguments to **docker run image** will be appended after all elements in an exec form ENTRYPOINT, and will override all elements specified using 
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


**7.EXPOSE:**    
  - The EXPOSE instruction informs Docker that the container listens on the specified network ports at runtime. You can specify whether the port listens on TCP  
  or UDP, and the default is TCP if you don't specify a protocol.
  - The EXPOSE instruction doesn't actually publish the port. It functions as a type of documentation between the person who builds the image and the person who runs the container, about which ports are intended to be published.
   **Ex:**

           EXPOSE 80/tcp
           EXPOSE 80/udp


**8.ENV:**  
 - The ENV instruction sets the environment variable **key** to the **value**. This value will be in the environment for all subsequent instructions in the build stage and can be replaced inline in many as well. 
 - The environment variables set using ENV will persist when a container is run from the resulting image. You can view the values using docker inspect, and change them using **docker run --env key=value**

    **Ex:**     

           ENV MY_NAME="John Doe"
           ENV MY_DOG=Rex\ The\ Dog
           ENV MY_CAT=fluffy   

      Or, in a single line

           ENV MY_NAME="John Doe" MY_DOG=Rex\ The\ Dog \
           MY_CAT=fluffy   

  - If an environment variable is only needed during build, and not in the final image, consider setting a value for a single command instead: 

           RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ...  
           OR
           ARG DEBIAN_FRONTEND=noninteractive
           RUN apt-get update && apt-get install -y ...       


**9.ADD or COPY:**   
- ADD and COPY are functionally similar. COPY supports basic copying of files into the container, from the build context or from a stage in a multi-stage build. ADD supports features for fetching files from remote HTTPS and Git URLs, and extracting tar files automatically when adding files from the build context.

  **Ex:**     

           ADD file1.txt file2.txt /usr/src/things/.                            
           ADD https://example.com/archive.zip /usr/src/things/
           ADD git@github.com:user/repo.git /usr/src/things/ 

- COPY accepts a flag **--from=name** that lets you specify the source location to be a build stage, context, or image. The following example copies files from a stage named build:  

  **Ex:**

           FROM golang AS build
           WORKDIR /app
           RUN --mount=type=bind,target=. go build -o /myapp ./cmd
           COPY --from=build /myapp /usr/bin/


**10.USER:**
- The USER instruction sets the user name (or UID) and optionally the user group (or GID) to use as the default user and group for the remainder of the current stage. The specified user is used for RUN instructions and at runtime, runs the relevant ENTRYPOINT and CMD commands.
- Note that when specifying a group for the user, the user will have only the specified group membership. Any other configured group memberships will be ignored.

  **Ex:**

           USER <user>[:<group>]
           USER <UID>[:<GID>]


**11.WORKDIR:**     
- The WORKDIR instruction sets the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow it in the Dockerfile. If the WORKDIR doesn't exist, it will be created even if it's not used in any subsequent Dockerfile instruction.
- The WORKDIR instruction can be used multiple times in a Dockerfile. If a relative path is provided, it will be relative to the path of the previous WORKDIR instruction      

  **Ex:**

             WORKDIR /a
             WORKDIR b
             WORKDIR c
             RUN pwd   

- The output of the final pwd command in this Dockerfile would be /a/b/c.


**12.ONBUILD:**
- The ONBUILD instruction adds to the image a trigger instruction to be executed at a later time, when the image is used as the base for another build. The trigger will be executed in the context of the downstream build, as if it had been inserted immediately after the FROM instruction in the downstream Dockerfile.
  **HOW it Works:**
     - When it encounters an ONBUILD instruction, the builder adds a trigger to the metadata of the image being built. The instruction doesn't otherwise affect the current build.
     - At the end of the build, a list of all triggers is stored in the image manifest, under the key OnBuild. They can be inspected with the docker inspect command.
     - Later the image may be used as a base for a new build, using the FROM instruction. As part of processing the FROM instruction, the downstream builder looks for ONBUILD triggers, and executes them in the same order they were registered. If any of the triggers fail, the FROM instruction is aborted which in turn causes the build to fail. If all triggers succeed, the FROM instruction completes and the build continues as usual.
     - Triggers are cleared from the final image after being executed. In other words they aren't inherited by "grand-children" builds.

     **Ex:**

             ONBUILD ADD . /app/src
             ONBUILD RUN /usr/local/bin/python-build --dir /app/src


**13.STOPSIGNAL:**  
- The STOPSIGNAL instruction sets the system call signal that will be sent to the container to exit. This signal can be a signal name in the format SIG<NAME>, for instance SIGKILL, or an unsigned number that matches a position in the kernel's syscall table, for instance 9. The default is SIGTERM if not defined.

             STOPSIGNAL signal