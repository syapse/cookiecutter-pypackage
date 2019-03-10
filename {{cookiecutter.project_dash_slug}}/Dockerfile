##
# base
#
# The base image creates a minimal runtime container.
#
FROM python:3.7-slim-stretch as prod

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
RUN mkdir -p /srv/{{cookiecutter.project_slug}}

# Install the package with pip.
RUN pip install /srv[prod]

# Copy the entrypoint files for booting the application.
COPY --chown=user:user docker-entrypoint.sh /srv/

# Set the command executed first when the container run
ENTRYPOINT ["./docker-entrypoint.sh"]

##
# dev
#
# The dev image installs development-level dependencies in the container and
# the project to be mounted in the container.
#
FROM prod as dev

# Copy required project files into the WORKDIR.
#COPY --chown=user:user . /srv/

# Install the package with pip.
RUN pip install /srv[dev,test]

# Mount a volume at /srv so code can be changed on the fly
VOLUME /srv

##
# test
#
# The `test` image provides a dedicated container for running the application
# test suite. It is based on the `src` image so that a developer will have
# diagnostic tools available in the event of a failure.
#
FROM dev as test

# Copy bin scripts locally
COPY --chown=user:user bin /srv/bin

# Copy test configuration(s)
COPY --chown=user:user .coveragerc /srv/.coveragerc

# Copy the test suite
COPY --chown=user:user tests /srv/tests

# Install the test reporter for code climate
ENV CC_REPORTER_URL=https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64
ADD --chown=user:user "$CC_REPORTER_URL" /srv/cc-test-reporter

# Install the package with pip.
RUN pip install /srv[test]
