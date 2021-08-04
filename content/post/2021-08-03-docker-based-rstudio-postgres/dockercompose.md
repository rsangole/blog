---
title: Docker based RStudio & Postgres
author: Rahul
date: '2021-08-03'
slug: docker-based-rstudio-postgres
categories:
  - R
tags:
  - docker
  - postgres
output: 
  github_document:
    toc: true
    toc_depth: 1
---



This is part one of the two part post related to Docker, Postgres databases and Anomaly data-sets.

# Background

In recent LinkedIn posts ( [Mine]() and [Rami's Repost](https://www.linkedin.com/posts/rami-krispin_anomalydetection-data-timeseries-activity-6825126331672612864-MEks)) and Tweet, I asked the internet for their favorite datasets for anomaly detection problems, particularly in the time-series domain.

<!--html_preserve--><blockquote class="twitter-tweet" data-width="550" data-lang="en" data-dnt="true" data-theme="light"><p lang="en" dir="ltr">What are some of your favorite publicly available data sets useful for anomaly detection problems? <br><br>I’m interested in applying some ML and DL anomaly detection algorithms to new datasets.<a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a> <a href="https://twitter.com/hashtag/datascience?src=hash&amp;ref_src=twsrc%5Etfw">#datascience</a> <a href="https://twitter.com/hashtag/analytics?src=hash&amp;ref_src=twsrc%5Etfw">#analytics</a> <a href="https://twitter.com/hashtag/python?src=hash&amp;ref_src=twsrc%5Etfw">#python</a> <a href="https://twitter.com/hashtag/machinelearning?src=hash&amp;ref_src=twsrc%5Etfw">#machinelearning</a></p>&mdash; Rahul (@rsangole) <a href="https://twitter.com/rsangole/status/1418418477329620993?ref_src=twsrc%5Etfw">July 23, 2021</a></blockquote>
<!--/html_preserve-->

I'll layout the two posts like so:

1.  Part I - This post will teach you how to setup a simple reproducible Docker based workflow for a personal Postgres Database with code development in RStudio.
2.  Part II - This will teach you how to setup your own anomaly database.

# Why should you read this?

At the end of this tutorial, you'll be able to rapidly setup a Docker based personal Postgres database. You will learn how to quickly deploy Postgres & RStudio using `docker-compose`. You will be able to access the DB in R / RStudio and begin development immediately. The process will be fully reproducible as it inherits all the benefits of working in Docker.

*This text assumed you're familiar with Docker and RStudio in a Docker environment. If you're not, I recommend reading [Reproducible Work in R](https://rsangole.netlify.app/post/2020/10/10/reproducible-work-in-r/) first.*

# Overview

You will be launching two docker images:

1.  A Postgres image. I choose [`postgres:13.3`](https://hub.docker.com/_/postgres/)
2.  An RStudio image. I choose [`hatmatrix/blog:base`](https://hub.docker.com/r/hatmatrix/blog/tags?page=1&ordering=last_updated) (equivalent: [`rocker/rstudio`](https://hub.docker.com/r/rocker/rstudio) )

To permanently store your data beyond the life of the containers, you will have two mounted volumes, one for each container. In the example below, I choose:

1.  For the Postgres database: `$HOME/docker/volumes/postgres`
2.  For RStudio & R Projects: `$HOME/github`

![](docker-compose.png)

None of these paths or docker images are special. You can customize them to your liking.

I use `docker-compose` to launch both postgres and RStudio services together. It's convenient while also ensuring the postgres service runs first followed by RStudio. It's very easy to get all the services up and pull them down using a few commands.

# First Time Setup

You need to run these steps the first time you're setting up the postgres database. I've stored these steps in [`00-postgres-init.sh`.](https://github.com/rsangole/postgres/blob/master/00-postgres-init.sh)

### Directory Setup

You need a directory to store the postgres database in. While I chose `$HOME/docker/volumes/postgres`, you can choose any directory you'd like. Lines 3-10 take care of this for you:

``` {.zsh}
# create directory if does not exist
if [ -d "$HOME/docker/volumes/postgres" ] 
then
    echo "Directory $HOME/docker/volumes/postgres exists." 
else
    echo "Error: Directory $HOME/docker/volumes/postgres does not exists."
    mkdir -p $HOME/docker/volumes/postgres
fi
```

### Postgres Setup

Now it's time to setup the database. You need two steps at a minimum to get started:

1.  A new 'role' (akin to a login) with rights to create new databases.
2.  At least one database to work in. In my script, I'm making two, `work` and `anomaly`.

To manipulate the database, you need a `postgres` server running to process the `psql` commands. You'll launch one using `docker run …`. You need the correct volume mounted using `-v`. Next, we create the role and databases by piping `psql` commands into `docker exec ...`. Then, we stop the container.

    # launch the postgres image called 'post_setup',
    # attach it to the local volume
    docker run --rm --name post_setup \
      -e POSTGRES_USER=postgres \
      -e POSTGRES_PASSWORD=docker \
      -d \
      -p 5432:5432 \
      -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data \
      postgres:13.3

    # create a new role, and two databases
    echo "CREATE ROLE rahul WITH PASSWORD 'pass' CREATEDB LOGIN;
    CREATE DATABASE work; CREATE DATABASE anomaly;" | \
     docker exec -i post_setup \
     psql -U postgres

    # stop the docker container
    docker stop post_setup

# Daily Workflow

### How to get started? 

1.  Store [`docker-compose.yml`](https://github.com/rsangole/postgres/blob/master/docker-compose.yml) in a local directory
2.  Modify it if you've changed any of the default images/directories I've configured.
3.  In shell, run `docker-compose up -d`

*protip*: to launch a browser directly into RStudio as well, run:

    docker-compose up -d; firefox localhost:8787

### Breakdown

We're creating two services, one called `db` and the other `rstudio`.

Let's look at `db` first. Most of the arguments will look familiar if you're familiar with `docker run` args. What's new here is the `restart: unless-stopped` arg which tells docker to only start postgres if it's currently stopped.

*Note: change the `source` directory if you've customized it in your setup script above.*

    version: "3.3"
    services:
      db:
        image: postgres:13.3
        restart: unless-stopped
        environment:
          POSTGRES_DB: "anomaly"
          POSTGRES_USER: "rahul"
          POSTGRES_PASSWORD: "pass"
        ports:
          - "5432:5432"
        volumes:
          - type: "bind"
            source: "$HOME/docker/volumes/postgres"
            target: "/var/lib/postgresql/data"

Now, the 2nd service called `rstudio`. Again, typical arguments you would have passed to `docker run`. The interesting argument here is `depends_on` which tells docker compose to only run this image *after* the database is up and running. Fantastic!

      rstudio:
        image: hatmatrix/blog:base
        ports:
          - "8787:8787"
          - "3838:3838"
        environment:
          DISABLE_AUTH: "true"
        volumes:
          - type: "bind"
            source: "$HOME/github"
            target: "/home/rstudio"
        depends_on:
          - "db"

## Connecting via R

Use [`postgres.R`](https://github.com/rsangole/postgres/blob/master/postgres.R) to test your connection. Run your `DBI::` commands you would normally, *except* for one key difference. In the connection object, make sure the name of the `host` is the name of the database service you've chosen in `docker-compose.yml`.

    con <- DBI::dbConnect(
      drv = RPostgres::Postgres(),
      dbname = "anomaly",
      host = "db", # this needs to be the name of the postgres service
                   # (line 3 in docker-compose.yml)
      user = "rahul",
      password = "pass",
      port = 5432
    )
