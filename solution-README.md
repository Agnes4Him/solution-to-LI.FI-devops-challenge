## A documentation of the steps and results obtained from executing the tasks in the README.md file in this project

This task was approached using the following steps:

1. The original GitHub repository was forked into my GitHub account - public

2. This was cloned locally, and the APIs were built by running the Makefiles in each API directory using the command (ran from each directory):

```bash
make
```

3. The APIs were ran by running the binary file for each. This showed the relationship between the 2 APIs:

```bash
./getBird
```

```bash
./getBirdImage
```

4. Dockerfile was created for each API.

5. With the Dockerfile, the docker image of each API was built and push to Docker registry using the proceeding commands:

```bash
docker build -t <docker-registry-username>/bird-api:1.0 .

docker build -t <docker-registry-username>/birdimage-api:1.0 .
```

```bash
docker login
```

```bash
docker push <docker-registry-username>/birdimage-api:1.0

docker push <docker-registry-username>/birdimage-api:1.0
``` 