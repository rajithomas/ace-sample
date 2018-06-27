FROM ibmcom/ace:latest

ENV BAR1=AccountEnquiry.bar

# Copy in the bar file to a temporary directory
COPY --chown=aceuser $BAR1 /tmp

# Unzip the BAR file; need to use bash to make the profile work
RUN bash -c 'mqsibar -w /home/aceuser/ace-server -a /tmp/$BAR1 -c'
RUN bash -c 'mqsisetdbparms -w /home/aceuser/ace-server -n jdbc::aceuser@localhost -u aceuser -p passw0rd'


# Switch off the admin REST API for the server run, as we won't be deploying anything after start
# RUN sed -i 's/adminRestApiPort/#adminRestApiPort/g' /home/aceuser/ace-server/server.conf.yaml 
RUN sed -i 's/resourceStatsReportingOn: false/resourceStatsReportingOn: true/g' /home/aceuser/ace-server/server.conf.yaml
RUN sed -i 's/StatsSnapPublicationOn: inactive/StatsSnapPublicationOn: active/g' /home/aceuser/ace-server/server.conf.yaml
RUN sed -i 's/StatsSnapNodeDataLevel: none/StatsSnapNodeDataLevel: advanced/g' /home/aceuser/ace-server/server.conf.yaml
RUN sed -i 's/StatsSnapOutputFormat: "usertrace"/StatsSnapOutputFormat: "json"/g' /home/aceuser/ace-server/server.conf.yaml

# We inherit the command from the base layer
