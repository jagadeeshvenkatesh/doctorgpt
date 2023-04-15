FROM golang:1.20.2-alpine3.17 as builder

WORKDIR /

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./
RUN mkdir ./testlogs
COPY testlogs/* ./testlogs/.

RUN go test
RUN go build -o /doctorgpt

FROM golang:1.20.3-alpine3.17 as runner

COPY --from=builder /doctorgpt /usr/bin/doctorgpt

ARG OPENAI_KEY
ARG LOGFILE
ARG CONFIGFILE
ARG OUTDIR
ARG BUNDLINGTIMESECONDS
ARG DEBUG
ARG BUFFERSIZE
ARG MAXTOKENS
ARG GPTMODEL

ENV OPENAI_KEY=$OPENAI_KEY
ENV LOGFILE=$LOGFILE
ENV CONFIGFILE=$CONFIGFILE
ENV OUTDIR=$OUTDIR
ENV BUNDLINGTIMESECONDS=$BUNDLINGTIMESECONDS
ENV DEBUG=$DEBUG
ENV BUFFERSIZE=$BUFFERSIZE
ENV MAXTOKENS=$MAXTOKENS
ENV GPTMODEL=$GPTMODEL

CMD /usr/bin/doctorgpt --logfile=$LOGFILE --configfile=$CONFIGFILE --outdir=$OUTDIR --budlingtimeoutseconds=$BUNDLINGTIMESECONDS --debug=$DEBUG --buffersize=$BUFFERSIZE --maxtokens=$MAXTOKENS --gptmodel=$GPTMODEL
