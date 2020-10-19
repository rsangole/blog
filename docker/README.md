## Docker Image

Build the image using:

```sh
docker build . -t hatmatrix/blog:latest
docker push hatmatrix/blog:latest
```

Run the image using:

```sh
docker run 
    -d 
    -e PASSWORD=1234 
    -v ~/github/:/home/rstudio/projects/ 
    -p 3838:3838 
    -p 8787:8787 
    hatmatrix/blog:latest
```