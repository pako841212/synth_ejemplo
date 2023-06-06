FROM islasgeci/base:1.0.0
COPY . /workdir
RUN Rscript -e "install.packages(c('kernlab', 'optimx', 'rgenoud'), repos='http://cran.rstudio.com')"
RUN Rscript -e "remotes::install_github('pako841212/LR')"
RUN Rscript -e "remotes::install_github('pako841212/synth')"
RUN Rscript -e "install.packages('gsynth', repos = 'http://cran.us.r-project.org')"