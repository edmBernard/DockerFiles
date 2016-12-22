FROM ubuntu:opencv_numba:latest
MAINTAINER Erwan BERNARD

# configure bash
RUN ln -snf /bin/bash /bin/sh
RUN echo 'force_color_prompt=yes' >> /home/dev/.bashrc && \
    cat /root/.bashrc >> /home/dev/.bashrc && \
    echo 'PS1="\[\033[31;1m\]$BOX_NAME\[\033[00m\] $PS1" ' >> /home/dev/.bashrc

# configure jupyter
# the default for this hash is "pass" 
RUN jupyter notebook --generate-config && \
    echo "c.NotebookApp.password = u'sha1:eb9f67ab8656:cb5ee4b6bfd15a0fa315e395e37585283cf985e7'" >> ~/.jupyter/jupyter_notebook_config.py
    echo "alias jup='jupyter notebook --port=8888 --no-browser --ip=0.0.0.0'" >> /home/dev/.bashrc
EXPOSE 8888

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0"]

CMD ["/bin/bash"]
