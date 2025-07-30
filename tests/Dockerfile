# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget build-essential cmake libgmp-dev zlib1g-dev libssl-dev

# Install GLPK
RUN wget http://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz && \
    tar -xzf glpk-5.0.tar.gz && \
    cd glpk-5.0 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf glpk-5.0 glpk-5.0.tar.gz


# Install necessary packages and add repositories for SWI-Prolog and GCC 11
RUN apt-get update && \
    apt-get install -y wget build-essential cmake libgmp-dev zlib1g-dev libssl-dev software-properties-common && \
    add-apt-repository ppa:swi-prolog/stable && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y swi-prolog gcc-11 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11


# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /workspace

# Copy the project files into the Docker image
COPY . .

# Default command to run when the container starts
CMD ["/bin/bash"]
