FROM ummsbiocore/dolphinnext-docker:latest
MAINTAINER Alper Kucukural <alper.kucukural@umassmed.edu>
 
RUN echo "Alper"
RUN add-apt-repository -y ppa:opencpu/opencpu-2.1
RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80  --recv-key E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -
RUN add-apt-repository 'deb https://ftp.ussg.iu.edu/CRAN/bin/linux/ubuntu xenial/'
RUN apt-get -y install r-base r-base-dev opencpu-server rstudio-server \
    libudunits2-dev pandoc libmariadb-client-lgpl-dev texlive texlive-latex-extra

RUN R -e 'install.packages(c("devtools", "knitr", "RCurl", "plotly", "webshot", "rmarkdown"))'
RUN R -e 'devtools::install_github("umms-biocore/markdownapp")'
RUN R -e 'webshot::install_phantomjs()'
RUN mv /root/bin/phantomjs /usr/bin/.

RUN sed -i "s|\"rlimit.as\": 4e9|\"rlimit.as\": 12e9|" /etc/opencpu/server.conf
RUN sed -i "s|\"rlimit.fsize\": 1e9|\"rlimit.fsize\": 8e9|" /etc/opencpu/server.conf
RUN sed -i "s|\"timelimit.get\": 60|\"timelimit.get\": 900|" /etc/opencpu/server.conf
RUN sed -i "s|\"timelimit.post\": 90|\"timelimit.post\": 900|" /etc/opencpu/server.conf

RUN tutorial_url="https://galaxyweb.umassmed.edu/pub/dnext_data/tutorial/" && \
    wget -l inf -nc -nH --cut-dirs=3 -R 'index.html*' -r --no-parent --directory-prefix=/data $tutorial_url

RUN singularity_dir="/data/.dolphinnext/singularity" && \
    wget --directory-prefix=$singularity_dir https://galaxyweb.umassmed.edu/pub/dnext_data/singularity/UMMS-Biocore-initialrun-07.01.2020.simg && \
    wget  https://galaxyweb.umassmed.edu/pub/dnext_data/singularity/UMMS-Biocore-rna-seq-1.0.simg -O $singularity_dir/dolphinnext-rnaseq-1.0.simg
RUN echo 'NXF_SINGULARITY_CACHEDIR="/data/.dolphinnext/singularity"' >> /etc/profile
RUN chmod 777 -R /data

RUN STAR_url="https://github.com/alexdobin/STAR/archive/2.6.1a.tar.gz" && \
    wget $STAR_url -O /data/2.6.1a.tar.gz && \
    cd /data && \
    tar xfv 2.6.1a.tar.gz && \
    cd STAR-2.6.1a/source && \
    make
ENV PATH /data/STAR-2.6.1a/source/:$PATH

RUN mkdir /data/genome_data/mousetest/mm10/refseq_170804/StarIndex && \
    STAR --runMode genomeGenerate  --genomeDir /data/genome_data/mousetest/mm10/refseq_170804/StarIndex/  --genomeFastaFiles /data/genome_data/mousetest/mm10/main/genome.fa --sjdbGTFfile /data/genome_data/mousetest/mm10/refseq_170804/genes/genes.gtf

RUN echo "DONE!"

