# amplify-linux-container
Build AWS Amplify Python app inside Linux container. This is useful when your app has packages that are platform- or architecture-specific, and a build on one platform (e.g. Mac/ARM) doesn’t work on another (e.g. linux/amd64).

### Setup
1. Setup env vars: `PROJECT_NAME`, `PROJECT_DIR`, `AWS_REGION` and `AWS_PROFILE` in `Makefile`.    
    - AWS credentials are mounted from `~/.aws` in the host machine to `/root/.aws` in the container.

2. Build docker image with all dependencies like amplify, awscli, node, python etc:
    ```
    make build
    ```

3. Enter amplify container shell:
    ```
    make ssh
    ```    

4. Build and push your changes project:
    - Your project is volume mounted to `/app/${PROJECT_NAME}` in the container.     
    - You can `cd` into it and run usual amplify commands.
    - Confirm you have your existing environments: `amplify env list`.

    Build and push your changes:
    ```
    amplify push
    ```


