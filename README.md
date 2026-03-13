:mechanical_arm: Static curl :mechanical_arm:
-----------

These are a couple simple scripts to build a fully static curl binary using alpine linux docker containers.  Currently it is a featureful build with OpenSSL, libssh2, nghttp2, and zlib, supporting most protocols.  Tweak configure options in [build.sh](build.sh#L50) if you need something else (and/or suggest or PR).

Grab the [latest release](https://github.com/moparisthebest/static-curl/releases/latest) from one of these links, by CPU architecture:
  - [curl-amd64](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-amd64)
  - [curl-i386](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-i386)
  - [curl-aarch64](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-aarch64)
  - [curl-armv7](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-armv7)
  - [curl-armhf](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-armhf)
  - [curl-ppc64le](https://github.com/moparisthebest/static-curl/releases/latest/download/curl-ppc64le)

Static binaries for windows are provided directly by [curl](https://curl.haxx.se/windows/) itself.

Development
-----------

File explanation:
  - [build.sh](build.sh) - runs inside an alpine docker container, downloads curl, verifies it with gpg, and builds it
  - [mykey.asc](mykey.asc) - Daniel Stenberg's [GPG key](https://daniel.haxx.se/address.html) used for signing/verifying curl releases

All unique flags across all three `./configure` variants in `build.sh`, with ✅ marking those used in the **active build** (line 54):

## Static Linking

| Flag | Active | Meaning |
|---|:---:|---|
| `--disable-shared` | ✅ | Don't build `libcurl.so` |
| `--enable-static` | ✅ | Build `libcurl.a` |

## Dependencies / Backends

| Flag | Active | Meaning |
|---|:---:|---|
| `--with-ssl` | ✅ | Use OpenSSL as TLS backend |
| `--with-libssh2` | ✅ | Enable SSH/SFTP/SCP via libssh2 |
| `--without-libpsl` | ✅ | Skip Public Suffix List (not available as static lib in Alpine) |
| `--without-ssl` | — | Disable TLS entirely (minimal build only) |
| `--without-brotli` | — | Disable brotli content-encoding decompression |
| `--without-zlib` | — | Disable gzip/deflate decompression |
| `--without-ngtcp2` | — | Disable HTTP/3 via ngtcp2 |
| `--without-nghttp2` | — | Disable HTTP/2 via nghttp2 |

## Docs / Build Output

| Flag | Active | Meaning |
|---|:---:|---|
| `--disable-docs` | ✅ | Skip building man pages |
| `--disable-manual` | ✅ | Remove `--manual` text from binary (size reduction) |
| `--disable-libcurl-option` | — | Don't generate `--libcurl` C code output option |

## Protocols — Enabled

| Flag | Active | Meaning |
|---|:---:|---|
| `--enable-ipv6` | ✅ | Enable IPv6 support |
| `--enable-unix-sockets` | ✅ | Enable Unix domain sockets |
| `--enable-websockets` | ✅ | Enable `ws://`/`wss://` WebSocket support |

## Protocols — Disabled (size/attack surface reduction)

| Flag | Active | Meaning |
|---|:---:|---|
| `--disable-ldap` | ✅ | Remove LDAP/LDAPS |
| `--disable-ftp` | — | Remove FTP |
| `--disable-dict` | — | Remove DICT protocol |
| `--disable-file` | — | Remove `file://` access |
| `--disable-gopher` | — | Remove Gopher protocol |
| `--disable-imap` | — | Remove IMAP |
| `--disable-smtp` | — | Remove SMTP |
| `--disable-pop3` | — | Remove POP3 |
| `--disable-rtsp` | — | Remove RTSP streaming protocol |
| `--disable-telnet` | — | Remove Telnet |
| `--disable-tftp` | — | Remove TFTP |
| `--disable-smb` | — | Remove SMB/CIFS |
| `--disable-mqtt` | — | Remove MQTT |

## Features — Disabled

| Flag | Active | Meaning |
|---|:---:|---|
| `--disable-threaded-resolver` | — | Use synchronous DNS instead of threaded async resolver |
| `--disable-ntlm-wb` | — | Disable NTLM auth via winbind helper |
| `--disable-tls-srp` | — | Disable TLS-SRP authentication |
| `--disable-crypto-auth` | — | Disable HMAC-based auth (Digest, CRAM-MD5, NTLM) |
| `--disable-alt-svc` | — | Disable `Alt-Svc` HTTP header handling |

---

**Recommendation summary**: The active line 54 strikes the best balance — static, OpenSSL TLS, SSH support, IPv6, Unix sockets, WebSockets, with docs/manual stripped. The fully commented-out minimal build (line 50) disables almost everything including TLS, suitable only for the smallest possible binary where protocols beyond HTTPS aren't needed.