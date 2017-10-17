#!/bin/bash

# geo-bridge
mkdir /home/rstudio/GitRepos/geo-bridge-stats
git clone https://bitbucket.com/ben_graeler/geo-bridge-stats.git

# pull app repositories
cd /home/rstudio/GitRepos/copulatheque
git pull

cd /home/rstudio/GitRepos/geo-bridge-stats
git pull

# VineCopula
cd /home/rstudio/GitRepos/VineCopula
git pull
cd ..
R CMD build --no-build-vignettes VineCopula
find ./ -name "VineCopula*.tar.gz" -cmin -5 -print0 | xargs -0 R CMD INSTALL

# spcopula
cd /home/rstudio/GitRepos/spcopula
git pull
cd ..
R CMD build --no-build-vignettes spcopula
find ./ -name "spcopula*.tar.gz" -cmin -5 -print0 | xargs -0 R CMD INSTALL

# from rstudio Dockerfile CMD
/usr/bin/shiny-server.sh
