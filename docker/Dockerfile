FROM rocker/tidyverse:4.0.0

LABEL maintainer="Rahul S <rahul.sangole@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
        libgit2-dev \
        libxml2-dev \
        libudunits2-dev \
        libgdal-dev \
        libcairo2-dev \
        libxt-dev \
        libv8-dev \
        r-cran-rcpp \
        r-cran-inline \
        r-cran-rcpp \
        libpoppler-cpp-dev \
        libtesseract-dev \
        libleptonica-dev \
        tesseract-ocr-eng \
        libmagick++-dev \
        libavfilter-dev \
        libzmq3-dev \
    	mesa-common-dev \
    	libglu1-mesa-dev \
        cargo \
        curl \
        tree \
        jq \
        htop \
        texinfo \
        vim \
        man-db \
        less

ENV MRAN_BUILD_DATE=2020-09-01

# Install Basic Utility R Packages
RUN install2.r -r https://cran.microsoft.com/snapshot/${MRAN_BUILD_DATE} \
	--error \
	rgl \
	data.table \
	reprex \
	clipr \
	httr \
	curl \
	RCurl \
	here \
	janitor \
	qs \
	future.callr \
	tsibble \
	profvis \
	bookdown \
	blogdown

# Analysis Packages
RUN install2.r -r https://cran.microsoft.com/snapshot/${MRAN_BUILD_DATE} \
	--error \
	randomForest \
	feasts \
	prophet \
	qcc \
	MSQC \
	Rtsne \
	strucchange \
	robfilter \
	bfast \
	tsmp \
	anomalize \
	slider \
	dtwclust \
	fpp3 \
	astsa \
	cluster \
	dendextend \
	rpart \
	party \
	partykit

# Plotting Packages
RUN install2.r -r https://cran.microsoft.com/snapshot/${MRAN_BUILD_DATE} \
	--error \
	lattice \
	ggplot2 \
	GGally \
	ggfortify \
	ggExtra \
	DiagrammeR \
	patchwork \
	plotly


# Shiny Packages
RUN install2.r -r https://cran.microsoft.com/snapshot/${MRAN_BUILD_DATE} \
	--error \
	shiny \
	shinyWidgets \
	reactable \
 	kableExtra \
 	waiter

RUN mkdir dotdotfiles
COPY dotfiles dotfiles/

RUN mkdir -p /home/rstudio/.R/snippets \
	&& mkdir -p /home/rstudio/.R/rstudio/keybindings \
	&& cp -r dotfiles/.Rprofile /home/rstudio/ \
	&& cp -r dotfiles/r.snippets /home/rstudio/.R/snippets/ \
	&& cp -r dotfiles/user-settings /home/rstudio/.rstudio/monitored/user-settings/ \
	&& cp dotfiles/keybindings/*.* /home/rstudio/.R/rstudio/keybindings/
