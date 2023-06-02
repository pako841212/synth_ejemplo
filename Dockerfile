FROM islasgeci/base:1.0.0
COPY . /workdir
RUN Rscript -e "install.packages(c('kernlab', 'optimx', 'rgenoud'), repos='http://cran.rstudio.com')"
RUN Rscript -e "remotes::install_github('pako841212/LR')"
RUN Rscript -e "remotes::install_github('pako841212/synth')"