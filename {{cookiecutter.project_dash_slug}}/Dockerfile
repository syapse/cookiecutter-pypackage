FROM python:3.7-slim-stretch

ENV PATH=$PATH:/home/user/.local/bin \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIPENV_COLORBLIND=true \
    PIPENV_NOSPIN=true \
    PIP_NO_CACHE_DIR=off \
    PIP_USER=1

WORKDIR /srv

# Run as a non-root user.
RUN useradd -ms /bin/bash user \
 && chown -R user:user /srv
USER user

# Install the newest pip and setuptools
RUN python -m pip install --upgrade --user pip setuptools

# Copy required project files into the WORKDIR.
COPY --chown=user:user setup.py setup.cfg /srv/

# Create a dummy service directory for the dependency installation.
RUN mkdir -p /srv/sypy

# Copy the entrypoint files for booting the application.
COPY --chown=user:user docker-entrypoint.sh /srv/

# Copy required project files into the WORKDIR.
COPY --chown=user:user . /srv/

# Install the package with pip.
RUN pip install /srv

# Mount a volume at /srv so code can be changed on the fly
VOLUME /srv

# Install the test reporter for code climate
ENV CC_REPORTER_URL=https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64
ADD --chown=user:user "$CC_REPORTER_URL" /srv/cc-test-reporter

# Set the command executed first when the container run
ENTRYPOINT ["./docker-entrypoint.sh"]
