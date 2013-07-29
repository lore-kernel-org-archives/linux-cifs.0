From: Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org>
Subject: Re: DFS referrals
Date: Mon, 29 Jul 2013 15:45:48 +0200
Message-ID: <51F6720C.3060500@gmx.ch>
References: <51DBD032.10305@gmx.ch> <20130709054702.15550964@tlielax.poochiereds.net> <51DBDDEA.9040702@gmx.ch> <20130709081027.450b1849@corrin.poochiereds.net> <51F664FB.5090507@gmx.ch> <20130729090759.62d15e2e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040102030303030405010705"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130729090759.62d15e2e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dies ist eine kryptografisch unterzeichnete Nachricht im MIME-Format.

--------------ms040102030303030405010705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 29.07.2013 15:07, schrieb Jeff Layton:
> I generally don't do 1:1 support unless you're paying me, so cc'ing
> linux-cifs ml:

Ok, replying to the list as well.

> [...]
>
> On Mon, 29 Jul 2013 14:50:03 +0200
> Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org> wrote:
>
>> [  124.607810] fs/cifs/cifssmb.c: negprot rc 0
>> [  124.607814] fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8=
001f3fc TimeAdjust: -7200
>> [  124.607817] fs/cifs/sess.c: sess setup type 4
>> [  124.607826] fs/cifs/cifs_spnego.c: key description =3D ver=3D0x2;ho=
st=3Dd.ethz.ch;ip4=3D82.130.70.6;sec=3Dkrb5;uid=3D0xaf05;creduid=3D0xaf05=
;user=3Dmam4tst;pid=3D0x61a
>> [  124.803185] fs/cifs/sess.c: ssetup freeing small buf ffff88022c31a0=
00
>> [  124.803195] CIFS VFS: Send error in SessSetup =3D -126
>> [  124.803203] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (=
xid =3D 5) rc =3D -126
>> [  124.803212] fs/cifs/fscache.c: cifs_fscache_release_client_cookie: =
(0xffff88022a1b6000/0xffff88022a6430f0)
>> [  124.803368] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid =3D=
 4) rc =3D -126
>> [  124.803374] CIFS VFS: cifs_mount failed w/return code =3D -126
>
> The only failure I see is the one above, and that's because it failed
> to upcall for the correct key. Are you sure you have krb5 creds as that=

> user?

Yes, creds are there and it also works when mounting from one of the=20
servers directly.

Only mounting using the domainname does not work.


>> [  131.324798] fs/cifs/cifssmb.c: negprot rc 0
>> [  131.324804] fs/cifs/connect.c: Security Mode: 0xf Capabilities: 0x8=
001f3fc TimeAdjust: -7200
>> [  131.324808] fs/cifs/sess.c: sess setup type 4
>> [  131.324821] fs/cifs/cifs_spnego.c: key description =3D ver=3D0x2;ho=
st=3Dd.ethz.ch;ip4=3D172.31.65.62;sec=3Dkrb5;uid=3D0xaf05;creduid=3D0xaf0=
5;user=3Dmam4tst;pid=3D0x62c
>> [  131.384335] fs/cifs/transport.c: For smb_command 115
>> [  131.384344] fs/cifs/transport.c: Sending smb: smb_len=3D1666
>> [  131.387043] fs/cifs/connect.c: RFC1002 header 0xf9
>> [  131.387055] fs/cifs/misc.c: checkSMB Length: 0xfd, smb_buf_length: =
0xf9
>> [  131.387095] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3D115 mi=
d=3D2 state=3D4
>> [  131.387100] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_re=
lease
>
> Here' the upcall for a similar set of creds worked fine. The only thing=

> that seems to have changed in the key description is the IP address.
>
> Do you have cifs.upcall set up to use the --trust-dns flag? If so, why?=


A relict from the past. I have removed it from the config. Thanks for=20
pointing out.

Greets
Marcus




--------------ms040102030303030405010705
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Kryptografische Unterschrift

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFvTCC
BbkwggOhoAMCAQICAw1DyzANBgkqhkiG9w0BAQUFADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xMzA1
MjMwODU0MzRaFw0xNTA1MjMwODU0MzRaMGUxFzAVBgNVBAMTDk1hcmN1cyBNb2VsbGVyMSQw
IgYJKoZIhvcNAQkBFhVtYXJjdXMubW9lbGxlckBnbXguY2gxJDAiBgkqhkiG9w0BCQEWFW1h
aWxAbWFyY3VzbW9lbGxlci5jaDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALIV
a7K9tFzUNGmvyXzEMYY4SS7WPfvKjqswJ+Gd4WkhYsNkwBDNRteJB8t4eidHEM6Dc75AZb62
NHrTqpQ+3wWgzJtv2EW35XtiIxKGCkAuI80szBhwNgPSJpuaaSkcM3PIPEjxmg5KBOzYh0F+
myHjzgsuOgoSYSk+Ta0T5s3dL0PZlyEHoZf981nl5pN/K60Nc8q3XVimR1F3dcc4QB6UCFyI
Nshnph4iecKsje0AsoUmSsRbGPlsKAB4UxZIV2KFZHdefkG6pO0vai0wqJi/Wo2S2Xo60t+N
jcMW7qgyYQ5Pjz+ViCW0vBTAwRc1Kx/45qQaNP8m57NQMZaT3RsCAwEAAaOCAVwwggFYMAwG
A1UdEwEB/wQCMAAwVgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0
ZSBmb3IgRlJFRSBoZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMA4GA1UdDwEB
/wQEAwIDqDBABgNVHSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisG
AQQBgjcKAwMGCWCGSAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6
Ly9vY3NwLmNhY2VydC5vcmcwMQYDVR0fBCowKDAmoCSgIoYgaHR0cDovL2NybC5jYWNlcnQu
b3JnL3Jldm9rZS5jcmwwNwYDVR0RBDAwLoEVbWFyY3VzLm1vZWxsZXJAZ214LmNogRVtYWls
QG1hcmN1c21vZWxsZXIuY2gwDQYJKoZIhvcNAQEFBQADggIBAF5iT90wb8r/9weOFQQ2rRK2
Bowrd3LA7TtAZdmRebgfAZoS4wVQJnvlp8sKN9J/WkaLyOmwHcMlFgJVLVTZERpPF/fsf95T
EKBHjxQIn4VH1zfIy/W7hURS7BFh2AFHktQ/O0zUiWJ1h1icdlxp4hjIkiUvVKZWnYy2THp/
3DTgH52pIUBFtc+kKRPiip/KTcD9X8I7QLGzBJMdpw8mA3PkxT0I4aW564xN0Hxx0ds/ksBl
X9IBRA+J2D977E6+/buuLXQbGWZla2Pr8ClHZ0uq0NMYg6+E+SxFcNGZZXUznUSv/J882ZWN
wvrmSvB/zLFH393w+NO5cZ5+hwx1ClS/CuLW0ej4qRGeFD9FD5HDNzMg/E4MDTESe5d1B4D+
hCqrNpaKROdPQoCN6MUsWhjJmsHN1WeyTC/ZD9gYsInGe5e9g9sCRoWd9ZcY8xG4pf1jmPFD
c0ef3/Rl+ho1kZi/J//VudbkPrRAkDqhev+Na28qDbyNU1OAIwBpxgmaMBlwR9FGYQhfipMo
8wR8wpnHy5/7ne/Hhr/69cpxb68dmcOpswuJYEg8Ie895P+58hjdXqrTTer9gfBQY/ZX1/bW
aq90Shrc3LA27rKmdVT0gPvI2W/rR5y+yO3wrdEb7qVuKUqJN3veNnTZQ+HzGfaJv3waq1u+
LhKkPY+6cM9zMYIDoTCCA50CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMV
aHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9y
aXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAw1DyzAJBgUrDgMCGgUA
oIIB9TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzA3Mjkx
MzQ1NDhaMCMGCSqGSIb3DQEJBDEWBBSsP9JP+sPxvfq0GwntySxwzHgRODBsBgkqhkiG9w0B
CQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcN
AwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEE
AYI3EAQxgYMwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5j
YWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZI
hvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAw1DyzCBkwYLKoZIhvcNAQkQAgsxgYOggYAw
eTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIw
IAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBw
b3J0QGNhY2VydC5vcmcCAw1DyzANBgkqhkiG9w0BAQEFAASCAQA0UA/NKuU9XRVnFlZSXQZy
tzdrDY/ZczYHQYptAHXz0P20fJRiYdZ9wzwKVuW/xN4/a4Bbb559G8NqaPGPTTGDMn7BD8nW
xadjwgKvp7kUtfKy+K/3NUFk8qUjMBHd9TzuwV8pr/VXfKXbQlVfUOmj8/4CBQ9PKoXBiMj4
/JD1LKHvQIKuILIzuIUVFIv1BlZ/HYGTt+kzuJt/2xv0bDFUoUHhpmubc42psev//6U4IjPV
FGm2LeaMMsCD3f7xlyiKE230umkrAr2ZtodnSt42P94uUzgFlOGS226T+TJY5sgej0ReReHl
pQFXKGxFP/LDqjUMZVxqUZB2fmm6TUeuAAAAAAAA
--------------ms040102030303030405010705--
