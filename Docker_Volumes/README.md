# Docker Volumes:
Volumes are persistent data stores for containers, created and managed by Docker. You can create a volume explicitly using the docker volume create command, or Docker can create a volume during container or service creation.

**How Its different from Bind Mounts:**
  - Volumes are managed by Docker and are isolated from the core functionality of the host machine. Whereas bind mounts are dependent on the directory structure and OS of the host machine.
  - Volumes are not a good choice if you need to access the files from the host. Use bind mounts if you need to access files or directories from both containers and the host.
  - Volumes use rprivate (recursive private) bind propagation, and bind propagation isn't configurable for volumes.
  - Volumes are often a better choice than writing data directly to a container:
         - volume doesn't increase the size of the containers
         - Using a volume is also faster
         - Writing into a container's writable layer requires a storage driver to manage the filesystem - reduces performance as compared to volumes.

**When to Use VOLUMES:**
  - Volumes are easier to back up or migrate than bind mounts.
  - You can manage volumes using Docker CLI commands or the Docker API.
  - Volumes work on both Linux and Windows containers.
  - Volumes can be more safely shared among multiple containers.
  - New volumes can have their content pre-populated by a container or build.
  - When your application requires high-performance I/O.

**Volume Lifecycle:**  
 - A volume's contents exist outside the lifecycle of a given container. When a container is destroyed, the writable layer is destroyed with it. Using a volume ensures that the data is persisted even if the container using it is removed.
 - A given volume can be mounted into multiple containers simultaneously. When no running container is using a volume, the volume is still available to Docker and isn't removed automatically. You can remove unused volumes using **docker volume prune**.

**Mounting a volume over existing data:** 
 - If you mount a non-empty volume into a directory in the container in which files or directories exist, the pre-existing files are obscured by the mount.
 - If you mount an empty volume into a directory in the container in which files or directories exist, these files or directories are propagated (copied) into the volume by default.
 - To prevent Docker from copying a container's pre-existing files into an empty volume, use the **volume-nocopy** option

**Named and anonymous volumes:**
 - A volume may be named or anonymous. Anonymous volumes are given a random name that's guaranteed to be unique within a given Docker host. Just like named volumes, anonymous volumes persist even if you remove the container that uses them, except if you use the --rm flag when creating the container, in which case the anonymous volume associated with the container is destroyed.

  **Ex:** To automatically remove anonymous volumes, use the --rm option. For example, this command creates an anonymous /foo volume. When you remove the container, the Docker Engine removes the /foo volume but not the awesome volume.

         docker run --rm -v /foo -v awesome:/bar busybox top 

 - If you create multiple containers consecutively that each use anonymous volumes, each container creates its own volume. Anonymous volumes aren't reused or shared between containers automatically. To share an anonymous volume between two or more containers, you must mount the anonymous volume using the random volume ID. 

**Syntax:**

 - To mount a volume with the docker run command, you can use either the --mount or --volume flag.

                         docker run --mount type=volume,src=volume-name,dst=mount-path
                         docker run --volume volume-name:mount-path 


 - You can create a volume directly outside of Compose using docker volume create and then reference it inside compose.yaml as follows:   


                 services:
                   frontend:
                     image: node:lts
                     volumes:
                         - myapp:/home/node/app
                 volumes:
                     myapp:
                       external: true                 
