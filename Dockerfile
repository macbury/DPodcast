FROM phusion/baseimage:latest

ENV RAILS_ENV production
ENV TZ 'Europe/Warsaw'

RUN apt-add-repository ppa:brightbox/ruby-ng && apt-get update
RUN apt-get install -y ruby-switch ruby2.5 ruby2.5-dev
RUN ruby-switch --set ruby2.5

RUN apt-get update && apt-get -y install git build-essential libxslt-dev libxml2-dev zlib1g-dev libpq-dev curl wget python python-pip libtag1-dev ffmpeg apt-transport-https
RUN echo $TZ > /etc/timezone && \
      apt-get update && apt-get install -y tzdata && \
      rm /etc/localtime && \
      ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
      dpkg-reconfigure -f noninteractive tzdata && \
      apt-get clean


ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

WORKDIR $GOPATH
RUN wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz
RUN tar -xvf go1.12.6.linux-amd64.tar.gz
RUN mv go /usr/local

RUN go get -u github.com/ipfs/ipfs-update
RUN ipfs-update install latest 

RUN gem install bundler

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install

COPY requirements.txt /app
RUN pip install -r requirements.txt

COPY . /app

RUN mkdir /etc/service/puma
ADD bin/server /etc/service/puma/run
RUN chmod +x /etc/service/puma/run

RUN mkdir /etc/service/workers
ADD bin/workers /etc/service/workers/run
RUN chmod +x /etc/service/workers/run

HEALTHCHECK --interval=60s --timeout=30s --start-period=300s --retries=3 CMD curl -f http://localhost:5000/ || exit 1
STOPSIGNAL 9

EXPOSE 5000

CMD ["/sbin/my_init"]