FROM rocker/rstudio-stable:latest

LABEL maintainer = "Ben Graeler"
LABEL maintainer.email = "b.graeler@52north.org"

# add shiny server
RUN export ADD=shiny && bash /etc/cont-init.d/add

RUN sudo apt-get update
RUN sudo apt-get install -y nano
RUN sudo apt-get install -y libgsl0-dev
RUN sudo apt-get install -y build-essential
RUN sudo apt-get install -y libgdal20
RUN sudo apt-get install -y libudunits2-dev

# add spatial R packages from CRAN
RUN sudo su -c "R -e \"install.packages('sp', repos='https://cran.rstudio.com/')\""
RUN sudo su -c "R -e \"install.packages('sf', repos='https://cran.rstudio.com/')\""
RUN sudo su -c "R -e \"install.packages('spacetime', repos='https://cran.rstudio.com/')\""
RUN sudo su -c "R -e \"install.packages('gstat', repos='https://cran.rstudio.com/')\""
RUN sudo su -c "R -e \"install.packages('rgdal', repos='https://cran.rstudio.com/')\""
RUN sudo su -c "R -e \"install.packages('leaflet', repos='https://cran.rstudio.com/')\""

# install copula packages
RUN sudo su -c "R -e \"install.packages('copula', repos='https://cran.rstudio.com/')\""

# add dev R packages
RUN sudo apt-get install -y zlib1g-dev
RUN sudo su -c "R -e \"install.packages('devtools', repos='https://cran.rstudio.com/')\""
COPY initPackages.R /home/rstudio/initPackages.R
RUN sudo su -c "R -e \"source('/home/rstudio/initPackages.R')\""
# set-up GitRepos
RUN sudo -i -u rstudio mkdir /home/rstudio/GitRepos
RUN sudo -i -u rstudio mkdir /home/rstudio/GitRepos/demos

# clone copula repos - will be pulled on startup of the container
RUN sudo -i -u rstudio git clone https://github.com/BenGraeler/spcopula /home/rstudio/GitRepos/spcopula
RUN sudo -i -u rstudio git clone https://github.com/BenGraeler/VineCopula /home/rstudio/GitRepos/VineCopula

RUN sudo -i -u rstudio git clone https://bitbucket.com/ben_graeler/geo-bridge-stats.git /home/rstudio/GitRepos/geo-bridge-stats
RUN sudo -i -u rstudio git clone https://github.com/BenGraeler/copulatheque.git /home/rstudio/GitRepos/copulatheque
RUN sudo -i -u rstudio git clone https://github.com/BenGraeler/demos.git /home/rstudio/GitRepos/demos

COPY initPackages.sh /home/rstudio/initPackages.sh
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

RUN chmod +777 /home/rstudio/initPackages.sh

CMD "/home/rstudio/initPackages.sh"