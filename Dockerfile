# This file creates a container that runs a jupyter notebook server on Raspberry Pi
#
# Author: Preetham Lokesh
# Date 14/01/2021
#
# Originally from: https://github.com/preethaml7/raspberrypi-jupyter-lab
#

FROM balenalib/raspberrypi3-python:3.7.4-build
MAINTAINER Preetham Lokesh <preetham.l@icloud.com>

WORKDIR /root

# Update pip and install jupyter
RUN apt-get update -y && apt-get install -y libncurses5-dev libzmq-dev libfreetype6-dev libpng-dev

RUN python -m ensurepip --upgrade
RUN pip3 install --upgrade pip
RUN pip3 install cython readline ipywidgets jupyter jupyterlab

# Configure jupyter
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter serverextension enable --py jupyterlab
RUN jupyter notebook --generate-config
RUN mkdir notebooks
RUN sed -i "/c.NotebookApp.open_browser/c c.NotebookApp.open_browser = False" /root/.jupyter/jupyter_notebook_config.py \
        && sed -i "/c.NotebookApp.ip/c c.NotebookApp.ip = '*'" /root/.jupyter/jupyter_notebook_config.py \
        && sed -i "/c.NotebookApp.notebook_dir/c c.NotebookApp.notebook_dir = '/root/notebooks'" /root/.jupyter/jupyter_notebook_config.py

VOLUME /root/notebooks

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION 0.19.0
ENV CFLAGS="-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37"

ADD https://github.com/krallin/tini/archive/v${TINI_VERSION}.tar.gz /root/v${TINI_VERSION}.tar.gz
RUN apt-get install -y cmake
RUN tar zxvf v${TINI_VERSION}.tar.gz \
        && cd tini-${TINI_VERSION} \
        && cmake . \
        && make \
        && cp tini /usr/bin/. \
        && cd .. \
        && rm -rf "./tini-${TINI_VERSION}" \
        && rm "./v${TINI_VERSION}.tar.gz"


# Install usefull python packages for data scientists
RUN apt-get install -y libhdf5-dev liblapack-dev gfortran
RUN pip3 install requests numpy scipy scikit-learn nltk pandas seaborn tables ipywidgets matplotlib

ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888

CMD ["jupyter", "lab", "--allow-root"]


