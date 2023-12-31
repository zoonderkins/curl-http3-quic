# curl-http3-quic

[![](https://img.shields.io/docker/pulls/ookangzheng/curl-http3?style=flat-square)](https://hub.docker.com/r/ookangzheng/curl-http3)


This repo is based on https://github.com/yurymuski/curl-http3

The only different is swith from Ubuntu 20 to Alpine Linux.

## Usage

```bash
docker run -it --rm ookangzheng/curl-http3 curl -svo /dev/null --http3 https://cloudflare-quic.com/
```

## Bash Integration

To add this as a local command you can add the following to your `.bashrc` or `.zshrc`

```
alias curl3="docker run --rm -it ookangzheng/curl-http3 curl"
```

Example after add alias to `.zshrc` then, `source ./zshrc`

```
curl3 --http3 https://cloudflare-quic.com -I
```

```
docker run -it --rm ookangzheng/curl-http3 curl --http3 https://cloudflare-quic.com -I
```

## Version

```
$ docker run -it --rm ookangzheng/curl-http3 curl -V

curl 8.4.0-DEV (x86_64-pc-linux-musl) libcurl/8.4.0-DEV BoringSSL quiche/0.18.0
Release-Date: [unreleased]
Protocols: dict file ftp ftps gopher gophers http https imap imaps mqtt pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS HSTS HTTP3 HTTPS-proxy IPv6 Largefile NTLM SSL threadsafe UnixSockets
```

## Build

```
docker buildx build --platform linux/amd64 -t "ookangzheng/curl-http3:latest" -f Dockerfile .

docker push ookangzheng/curl-http3:latest
```
