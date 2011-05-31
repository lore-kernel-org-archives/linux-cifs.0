From: Darren Salt <linux-Ym6Ivm/Ks7B65+NM0QMiFAbYiX8G1TQY9dF7HbQ/qKg@public.gmane.org>
Subject: [3.0-rc1] CIFS ACL build failure without CONFIG_KEYS
Date: Tue, 31 May 2011 17:23:54 +0000
Message-ID: <51E1844698%linux@youmustbejoking.demon.co.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="1001750892--2062166408--1767141629"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This message is in MIME format.

--1001750892--2062166408--1767141629
Content-Type: text/plain; charset=us-ascii

In 3.0-rc1, without CONFIG_KEYS, cifs-acl.c compilation fails with various
errors, including one about trying to dereference an incomplete type (struct
keys, defined in <linux/key.h>).

I'm including two patches for this since I don't know which way to go on this
one: pick whichever is more correct :-)

-- 
| Darren Salt  | linux or ds at  | nr. Ashington, |  _  ASCII ribbon
| using Debian | youmustbejoking | Northumberland | ( ) campaign against
| GNU/Linux    | ,demon,co,uk    |                |  X  HTML e-mail
                                                    / \ www.asciiribbon.org
Live every day like it's your last, because one day you'll be right.


--1001750892--2062166408--1767141629
Content-Type: application/octet-stream; name="cifs-acl-key-v1.patch"
Content-Disposition: attachment; filename="cifs-acl-key-v1.patch"
Content-Transfer-Encoding: base64

RnJvbTogRGFycmVuIFNhbHQgPGxpbnV4QHlvdW11c3RiZWpva2luZy5kZW1vbi5jby51az4K
U3ViamVjdDogQ0lGUyBBQ0wgc3VwcG9ydCBuZWVkcyBDT05GSUdfS0VZUywgc28gc2VsZWN0
IGl0CgpTaWduZWQtb2ZmLWJ5OiBEYXJyZW4gU2FsdCA8bGludXhAeW91bXVzdGJlam9raW5n
LmRlbW9uLmNvLnVrPgoKLS0tIGEvZnMvY2lmcy9LY29uZmlnLmJhc2UJMjAxMS0wNS0zMCAw
MTo0MzozNi4wMDAwMDAwMDAgKzAxMDAKKysrIGIvZnMvY2lmcy9LY29uZmlnCTIwMTEtMDUt
MzEgMTc6MDU6MjEuNjk5NDIxMDM4ICswMTAwCkBAIC0xNDksNiArMTQ5LDcgQEAKIGNvbmZp
ZyBDSUZTX0FDTAogCSAgYm9vbCAiUHJvdmlkZSBDSUZTIEFDTCBzdXBwb3J0IChFWFBFUklN
RU5UQUwpIgogCSAgZGVwZW5kcyBvbiBFWFBFUklNRU5UQUwgJiYgQ0lGU19YQVRUUgorCSAg
c2VsZWN0IEtFWVMKIAkgIGhlbHAKIAkgICAgQWxsb3dzIHRvIGZldGNoIENJRlMvTlRGUyBB
Q0wgZnJvbSB0aGUgc2VydmVyLiAgVGhlIERBQ0wgYmxvYgogCSAgICBpcyBoYW5kZWQgb3Zl
ciB0byB0aGUgYXBwbGljYXRpb24vY2FsbGVyLgo=

--1001750892--2062166408--1767141629
Content-Type: application/octet-stream; name="cifs-acl-key-v2.patch"
Content-Disposition: attachment; filename="cifs-acl-key-v2.patch"
Content-Transfer-Encoding: base64

RnJvbTogRGFycmVuIFNhbHQgPGxpbnV4QHlvdW11c3RiZWpva2luZy5kZW1vbi5jby51az4K
U3ViamVjdDogQ0lGUyBBQ0wgc3VwcG9ydCBuZWVkcyBDT05GSUdfS0VZUywgc28gZGVwZW5k
IG9uIGl0CgpCdWlsZCBmYWlscyBpZiBDT05GSUdfS0VZUyBpcyBub3Qgc2VsZWN0ZWQuCgpT
aWduZWQtb2ZmLWJ5OiBEYXJyZW4gU2FsdCA8bGludXhAeW91bXVzdGJlam9raW5nLmRlbW9u
LmNvLnVrPgoKLS0tIGEvZnMvY2lmcy9LY29uZmlnLmJhc2UJMjAxMS0wNS0zMCAwMTo0Mzoz
Ni4wMDAwMDAwMDAgKzAxMDAKKysrIGIvZnMvY2lmcy9LY29uZmlnCTIwMTEtMDUtMzEgMTc6
MTQ6MTAuNDM1ODcwODA4ICswMTAwCkBAIC0xNDgsNyArMTQ4LDcgQEAKIAogY29uZmlnIENJ
RlNfQUNMCiAJICBib29sICJQcm92aWRlIENJRlMgQUNMIHN1cHBvcnQgKEVYUEVSSU1FTlRB
TCkiCi0JICBkZXBlbmRzIG9uIEVYUEVSSU1FTlRBTCAmJiBDSUZTX1hBVFRSCisJICBkZXBl
bmRzIG9uIEVYUEVSSU1FTlRBTCAmJiBDSUZTX1hBVFRSICYmIEtFWVMKIAkgIGhlbHAKIAkg
ICAgQWxsb3dzIHRvIGZldGNoIENJRlMvTlRGUyBBQ0wgZnJvbSB0aGUgc2VydmVyLiAgVGhl
IERBQ0wgYmxvYgogCSAgICBpcyBoYW5kZWQgb3ZlciB0byB0aGUgYXBwbGljYXRpb24vY2Fs
bGVyLgo=

--1001750892--2062166408--1767141629--
