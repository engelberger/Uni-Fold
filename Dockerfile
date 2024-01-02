FROM us-docker.pkg.dev/colab-images/public/runtime
RUN /usr/bin/python3.10 -m pip -q install git+https://github.com/sokrypton/ColabDesign.git@gamma
RUN apt-get install aria2

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install kalign
RUN apt-get install -y -qq kalign

# Install HHsuite
RUN wget -q https://github.com/soedinglab/hh-suite/releases/download/v3.3.0/hhsuite-3.3.0-AVX2-Linux.tar.gz && \
    tar xfz hhsuite-3.3.0-AVX2-Linux.tar.gz && \
    ln -s $(pwd)/bin/* /usr/bin

# Install Python packages
RUN pip3 -q install py3dmol gdown libmsym

# Set environment variables
ENV GIT_REPO='https://github.com/engelberger/Uni-Fold'
ENV UNICORE_URL='https://github.com/dptech-corp/Uni-Core/releases/download/0.0.2/unicore-0.0.1+cu118torch2.0.0-cp310-cp310-linux_x86_64.whl'
ENV PARAM_URL='https://github.com/dptech-corp/Uni-Fold/releases/download/v2.0.0/unifold_params_2022-08-01.tar.gz'
ENV UF_SYMM_PARAM_URL='https://github.com/dptech-corp/Uni-Fold/releases/download/v2.2.0/uf_symmetry_params_2022-09-06.tar.gz'

# UniFold setup
RUN wget ${UNICORE_URL} && \
    pip3 -q install "unicore-0.0.1+cu118torch2.0.0-cp310-cp310-linux_x86_64.whl" && \
    git clone -b main ${GIT_REPO} && \
    pip3 -q install ./Uni-Fold && \
    wget ${PARAM_URL} && \
    tar -xzf "unifold_params_2022-08-01.tar.gz" && \
    wget ${UF_SYMM_PARAM_URL} && \
    tar -xzf "uf_symmetry_params_2022-09-06.tar.gz"

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


