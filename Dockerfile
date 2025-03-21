FROM mcr.microsoft.com/dotnet/sdk:8.0 AS base

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV AGENT_VERSION=4.252.0
ENV AZP_URL=https://dev.azure.com/shar1217
ENV AGENT_WORK=/azp/work

# Create a non-root user
RUN useradd -m agentuser && mkdir -p $AGENT_WORK && chown -R agentuser $AGENT_WORK

USER agentuser
WORKDIR /home/agentuser

# Download and extract Azure DevOps agent
RUN curl -LsS https://vstsagentpackage.azureedge.net/agent/$AGENT_VERSION/vsts-agent-linux-x64-$AGENT_VERSION.tar.gz | tar -xz

# Expose working directory
VOLUME ["/azp"]

# Copy the startup script
COPY entrypoint.sh .

# Make entrypoint executable
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
