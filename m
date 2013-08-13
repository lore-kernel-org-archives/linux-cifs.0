From: Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org>
Subject: Re: DFS referrals
Date: Tue, 13 Aug 2013 11:00:08 +0200
Message-ID: <5209F598.1000101@gmx.ch>
References: <51DBD032.10305@gmx.ch> <20130709054702.15550964@tlielax.poochiereds.net> <51DBDDEA.9040702@gmx.ch> <20130709081027.450b1849@corrin.poochiereds.net> <51F664FB.5090507@gmx.ch> <20130729090759.62d15e2e@corrin.poochiereds.net> <51F6720C.3060500@gmx.ch> <20130729103445.6629cece@tlielax.poochiereds.net> <51F67EB0.40502@gmx.ch> <51F75300.9000703@gmx.ch> <51F7A513.1090806@gmx.ch> <20130730080116.76df98db@corrin.poochiereds.net> <51F7C67A.6020009@gmx.ch> <20130730101730.71549ec8@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020004020405050200060808"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130730101730.71549ec8-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dies ist eine kryptografisch unterzeichnete Nachricht im MIME-Format.

--------------ms020004020405050200060808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi again,

>>>>>>>>> On Mon, 29 Jul 2013 14:50:03 +0200
>>>>>>>>> Marcus Moeller <marcus.moeller-OI3hZJvNYWs@public.gmane.org> wrote:
>>>>>>>>>
>>>>>>>>>> [  124.607810] fs/cifs/cifssmb.c: negprot rc 0
>>>>>>>>>> [  124.607814] fs/cifs/connect.c: Security Mode: 0xf Capabilit=
ies:
>>>>>>>>>> 0x8001f3fc TimeAdjust: -7200
>>>>>>>>>> [  124.607817] fs/cifs/sess.c: sess setup type 4
>>>>>>>>>> [  124.607826] fs/cifs/cifs_spnego.c: key description =3D
>>>>>>>>>> ver=3D0x2;host=3Dd.ethz.ch;ip4=3D82.130.70.6;sec=3Dkrb5;uid=3D=
0xaf05;creduid=3D0xaf05;user=3Dmam4tst;pid=3D0x61a
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> [  124.803185] fs/cifs/sess.c: ssetup freeing small buf
>>>>>>>>>> ffff88022c31a000
>>>>>>>>>> [  124.803195] CIFS VFS: Send error in SessSetup =3D -126
>>>>>>>>>> [  124.803203] fs/cifs/connect.c: CIFS VFS: leaving
>>>>>>>>>> cifs_get_smb_ses (xid =3D 5) rc =3D -126
>>>>>>>>>> [  124.803212] fs/cifs/fscache.c:
>>>>>>>>>> cifs_fscache_release_client_cookie:
>>>>>>>>>> (0xffff88022a1b6000/0xffff88022a6430f0)
>>>>>>>>>> [  124.803368] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount=
 (xid
>>>>>>>>>> =3D 4) rc =3D -126
>>>>>>>>>> [  124.803374] CIFS VFS: cifs_mount failed w/return code =3D -=
126
>>>>>>>>>
>>>>>>>>> The only failure I see is the one above, and that's because it =
failed
>>>>>>>>> to upcall for the correct key. Are you sure you have krb5 creds=
 as
>>>>>>>>> that
>>>>>>>>> user?
>>>>>>>>
>>>>>>>> Yes, creds are there and it also works when mounting from one of=
 the
>>>>>>>> servers directly.
>>>>>>>>
>>>>>>>> Only mounting using the domainname does not work.
>>>>>>>>
>>>>>>>>
>>>>>>>>>> [  131.324798] fs/cifs/cifssmb.c: negprot rc 0
>>>>>>>>>> [  131.324804] fs/cifs/connect.c: Security Mode: 0xf Capabilit=
ies:
>>>>>>>>>> 0x8001f3fc TimeAdjust: -7200
>>>>>>>>>> [  131.324808] fs/cifs/sess.c: sess setup type 4
>>>>>>>>>> [  131.324821] fs/cifs/cifs_spnego.c: key description =3D
>>>>>>>>>> ver=3D0x2;host=3Dd.ethz.ch;ip4=3D172.31.65.62;sec=3Dkrb5;uid=3D=
0xaf05;creduid=3D0xaf05;user=3Dmam4tst;pid=3D0x62c
>>>>
>>>>>>>>>> [  131.384335] fs/cifs/transport.c: For smb_command 115
>>>>>>>>>> [  131.384344] fs/cifs/transport.c: Sending smb: smb_len=3D166=
6
>>>>>>>>>> [  131.387043] fs/cifs/connect.c: RFC1002 header 0xf9
>>>>>>>>>> [  131.387055] fs/cifs/misc.c: checkSMB Length: 0xfd,
>>>>>>>>>> smb_buf_length: 0xf9
>>>>>>>>>> [  131.387095] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3D=
115
>>>>>>>>>> mid=3D2 state=3D4
>>>>>>>>>> [  131.387100] fs/cifs/misc.c: Null buffer passed to
>>>>>>>>>> cifs_small_buf_release
>>>>>>>>>
>>>>>>>>> Here' the upcall for a similar set of creds worked fine. The on=
ly
>>>>>>>>> thing
>>>>>>>>> that seems to have changed in the key description is the IP add=
ress.
>>>>>>>>>
>>>>>>>>> Do you have cifs.upcall set up to use the --trust-dns flag? If =
so,
>>>>>>>>> why?
>>>>>>>>
>>>>>>>> A relict from the past. I have removed it from the config. Thank=
s for
>>>>>>>> pointing out.
>>>>
>>>> Sorry, I was wrong. Without the -t option I am not even able to moun=
t it
>>>> at all. The man page states a few words on that parameter, but I am
>>>> still not sure how it works when -t is not set.
>>>>
>>>> With -t set, the initial problem with the domain lookup works, when
>>>> reverse DNS is configured propably.
>>>>
>>>
>>> Ok, that makes sense then. The problem here is that the kernel needs =
to
>>> know what service principal name to use when contacting the server, a=
nd
>>> I suspect your krb5 configuration is not quite right.
>>>
>>> It looks like you're doing something like:
>>>
>>>       mount //d.ethz.ch/dfs /mnt/dfs -o sec=3Dkrb5...
>>>
>>> ...at this point, what happens is that the kernel needs to get a krb5=

>>> service ticket to talk to the CIFS service on the host.
>>>
>>> What it typically does is take the hostname in the UNC that you're
>>> trying to mount, prepend it with "cifs/" and then try to get a servic=
e
>>> ticket for that. In your case, it'll look something like this:
>>>
>>>       cifs/d.ethz.ch-ofn1FrHcITAsyahpCud6bTnlAmrJQu31@public.gmane.org
>>>
>>> ...now, typically if that fails, we'll give up. Trying to do anything=

>>> else is not considered safe since it's vulernable to DNS spoofing.
>>>
>>> If however, you add the '-t' flag to cifs.upcall, that tells it to tr=
y
>>> and guess the hostname part of that principal by reverse resolving it=
 in
>>> DNS. It takes the IP address to which you are connecting, does a
>>> reverse DNS lookup and then uses that in the SPN.
>>>
>>> This is less safe, since if your DNS server is compromised someone
>>> could redirect you to a malicious server, and your client wouldn't be=

>>> able to trivially detect that. So it in effect waters down krb5
>>> security.
>>>
>>> The correct fix is to ensure that the server(s) to which you are
>>> connecting have the ability to accept SPNs for the "hostnames" to whi=
ch
>>> you want to connect. That means that you need to add SPNs for
>>> cifs/d.ethz.ch and ensure that the server will accept them to talk to=

>>> its cifs service.
>>>
>>> Alternately, you can continue to use the '-t' flag and ensure that ea=
ch
>>> possible server accepts principals for the hostnames to which their I=
P
>>> addresses reverse-resolve, with the caveat that its less safe than
>>> doing that the "right way".
>>>
>>> As to how to add these principals and make the server accept them...i=
t
>>> depends on the server.
>>>
>>> Clear as mud?
>>
>> Hehe, thanks for pointing that out. One thing I am not yet aware of is=

>> where the SPN cifs/d.ethz.ch has to be set? On the DFS Servers and/or =
on
>> the servers which hold the shares? The latter ones are EMC and the DFS=

>> Servers are 2008R2.
>>
>> Greets
>> Marcus
>>
>
> Definitely on the first DFS server. On the others, they'll need to
> accept SPNs holding the hostnames that are in the DFS referrals. So if
> your DFS server gives you a referral that's something like this:
>
>      bar -> //foo.d.ethz.ch/bar
>
> ...then you'll need to ensure that foo.d.ethz.ch accepts SPNs that have=

> that hostname in them.

I have found some time to talk to our Active Directory Admins. They=20
mentioned that every DC in our setup is a DFS server and there is=20
nothing like a 'first DFS'. So is it possible to set the same SPN on all =

of these servers?

Greets
Marcus




--------------ms020004020405050200060808
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
oIIB9TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzA4MTMw
OTAwMDhaMCMGCSqGSIb3DQEJBDEWBBQLlcT5X7evexnGjISop5HCGJx2fTBsBgkqhkiG9w0B
CQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcN
AwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEE
AYI3EAQxgYMwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5j
YWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZI
hvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAw1DyzCBkwYLKoZIhvcNAQkQAgsxgYOggYAw
eTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIw
IAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBw
b3J0QGNhY2VydC5vcmcCAw1DyzANBgkqhkiG9w0BAQEFAASCAQANNngGJvWXczoRSi1PZyif
U6kN790DQXsO2nctN8P7pHFPkBTPCCQW2mJ2CPB8tLeXfGS2H2F8rDqJsjN6Xqks32Nqdkbu
AlVL1PmL3mIFBpEqde3snDm96aoVljjvDGLGapEUmY4UE2utnWWsdXSVKpA83OhcJ/gRDp0B
9Ux6J96o3YeufLGHI3oCQLJQFr6Kr8QbNQfIMTWEswqUJaKvq38ln25HqWMpZoofUw1ibCdZ
wdI4qZU0kfuObPmSTowhDE8ctWA3Wn1SJze4mhB/5oTw+45J6cVmgQBpFSfbEOg5+dqNLf0Z
9576UX/3y93SxVxyvCckEhFGv3fbkEviAAAAAAAA
--------------ms020004020405050200060808--
