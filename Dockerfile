FROM rocker/rstudio-stable:latest

LABEL maintainer = "Ben Graeler"
LABEL maintainer.email = "b.graeler@52north.org"

# add shiny server
RUN export ADD=shiny && bash /etc/cont-init.d/add

RUN sudo apt-get update
RUN sudo apt-get install -y nano
RUN sudo apt-get install -y libgsl0-dev
RUN sudo apt-get install -y build-essential

# add spatial R packages from CRAN
RUN sudo su -c "R -e \"install.packages('sp', repos='https://cran.rstudio.com/')\""
RUN sudo su -c "R -e \"install.packages('spacetime', repos='https://cran.rstudio.com/')\""
RUN sudo su -c "R -e \"install.packages('gstat', repos='https://cran.rstudio.com/')\""
RUN sudo su -c "R -e \"install.packages('rgdal', repos='https://cran.rstudio.com/')\""

# install copula packages
RUN sudo su -c "R -e \"install.packages('copula', repos='https://cran.rstudio.com/')\""
RUN sudo su -c "R -e \"install.packages('VineCopula', repos='https://cran.rstudio.com/')\""

# add dev R packages
RUN sudo su -c "R -e \"install.packages('devtools', repos='https://cran.rstudio.com/')\""
COPY initPackages.R /home/rstudio/initPackages.R
RUN sudo su -c "R -e \"source('/home/rstudio/initPackages.R')\" "

RUN sudo -i -u rstudio mkdir /home/rstudio/GitRepos
RUN sudo -i -u rstudio git clone  https://github.com/BenGraeler/spcopula.git /home/rstudio/GitRepos/spcopula
RUN sudo R CMD build --no-build-vignettes /home/rstudio/GitRepos/spcopula
RUN sudo R CMD INSTALL spcopula_0.2-4.tar.gz
RUN sudo -i -u rstudio git clone  https://bitbucket.com/ben_graeler/geo-bridge-stats.git /home/rstudio/GitRepos/geo-bridge-stats
RUN sudo -i -u rstudio git clone  https://github.com/BenGraeler/copulatheque.git /home/rstudio/GitRepos/copulatheque

COPY   shiny-server.conf /etc/shiny-server/shiny-server.conf