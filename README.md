# raspberrypi-jupyter-lab

JupyterLab Server on Raspberry Pi. 
Read more about [Jupyterlab](https://github.com/jupyterlab/jupyterlab)

Your own Jupyter Notebook Server on [Raspberry Pi](https://www.raspberrypi.org).

----------
This is a Dockerfile for building __raspberrypi-jupyter-lab__. The image was built on a Raspberry Pi 4B running Raspberry Pi OS](http://blog.hypriot.com/). It is a minimal notebook server with [balenalib/raspberrypi3-python](https://hub.docker.com/r/balenalib/raspberrypi3-python) as base image without additional packages.  


### Installing
Go to [Hypriot OS](http://blog.hypriot.com/) and follow the steps to get the Raspberry Pi docker ready. Then, run the following:

    docker pull preethaml7/raspberrypi-jupyter-lab

### Running in detached mode
    docker run -d -p 8888:8888 preethaml7/raspberrypi-jupyter-lab 

Now you can access your notebook at `http://<docker host IP address>:8888`

### Configuration
If you would like to change some config, create your own jupyter_notebook_config.py on the docker host and run the following:

    docker run -it -p <host port>:<dest port> -v <path to your config file>:/root/.jupyter/jupyter_notebook_config.py preethaml7/raspberrypi-jupyter-lab

This maps a local config file to the container.

The following command gives you a bash session in the running container, so you could do more:

    docker exec -it <container id> /bin/bash