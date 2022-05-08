FROM python:3.9.6 as base-image
LABEL maintainer='p-geon'

WORKDIR /work
USER root
CMD ["/bin/bash"]