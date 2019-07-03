FROM r-base:latest

MAINTAINER VP Nagraj "nagraj@nagraj.net"

# Install dependencies and Download and install shiny server
RUN apt-get update && apt-get install -y -t unstable \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libsodium-dev \
    libssl-dev \
    libsasl2-dev \
    libxml2-dev \
    r-cran-rmysql \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    git \
    libxt-dev && \
    wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cran.rstudio.com/')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    rm -rf /var/lib/apt/lists/*

# install R packages
RUN R -e "install.packages(c('BiocManager', 'DT', 'rlang', 'shinyjs', 'plotly', 'devtools', 'shinyWidgets', 'sodium', 'shinyBS'), repos='http://cran.rstudio.com/')" -e "BiocManager::install(c('GenomicRanges', 'LOLA', 'IRanges'))" -e "devtools::install_github('databio/simpleCache')" -e "devtools::install_github('databio/GenomicDistributions')" -e "devtools::install_github('tidyverse/ggplot2')" -e "devtools::install_github('databio/shinyqueue')"
