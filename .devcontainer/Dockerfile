FROM ubuntu:latest

RUN apt-get update && \
  apt-get install -y git zsh curl python3 python3-pip build-essential ca-certificates libpq-dev postgresql-client && \
  curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && \
  export NVM_DIR="$HOME/.nvm" && \
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
  nvm install v16 && \
  npm install yarn -g

COPY requirements.txt /tmp/pip-tmp/
# COPY oc-49-linux-x86_64.tar.gz /tmp/

RUN /usr/bin/pip install \
  --disable-pip-version-check \
  --no-cache-dir \
  --trusted-host=pypi.python.org \
  --trusted-host=pypi.org \
  --trusted-host=files.pythonhosted.org \
  -r /tmp/pip-tmp/requirements.txt && \
  rm -rf /tmp/pip-tmp

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
