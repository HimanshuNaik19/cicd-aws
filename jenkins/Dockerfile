FROM jenkins/jenkins:lts

# Install plugins
RUN jenkins-plugin-cli --plugins \
    git \
    workflow-aggregator \
    docker-workflow \
    configuration-as-code \
    credentials-binding

# Skip setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

USER root

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean

USER jenkins
