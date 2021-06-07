FROM amazon/aws-cli

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN kubectl version --client

COPY src/updater.sh /opt
RUN chmod u+x /opt/updater.sh
ENTRYPOINT /opt/updater.sh
