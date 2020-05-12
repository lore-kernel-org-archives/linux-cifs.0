Return-Path: <SRS0=F8lF=62=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F77BCA90AF
	for <linux-cifs@archiver.kernel.org>; Tue, 12 May 2020 16:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EB1520714
	for <linux-cifs@archiver.kernel.org>; Tue, 12 May 2020 16:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgELQuN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 May 2020 12:50:13 -0400
Received: from mail.nwra.com ([72.52.192.72]:57224 "EHLO mail.nwra.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgELQuN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 12 May 2020 12:50:13 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2020 12:50:11 EDT
Received: from barry.cora.nwra.com (inferno.cora.nwra.com [204.134.157.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by mail.nwra.com (Postfix) with ESMTPS id 839B834074F
        for <linux-cifs@vger.kernel.org>; Tue, 12 May 2020 09:43:29 -0700 (PDT)
To:     linux-cifs@vger.kernel.org
From:   Orion Poplawski <orion@nwra.com>
Subject: Sporadic resource temporarily unavailable errors
Organization: NWRA
Message-ID: <8d69e5bb-1271-1fe6-d8ad-4c7aad913bd9@nwra.com>
Date:   Tue, 12 May 2020 10:43:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010601060104060401040903"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010601060104060401040903
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

We are seeing periodic resource temporarily unavailable errors on our cif=
s
mounts.  An example:

svnadmin: E000011: Can't open file '/cifs/mount/...': Resource temporaril=
y
unavailable

At the same time a (successful cifs.upcall message is generated:

May 12 03:20:31 client cifs.upcall[47418]: key description:
cifs.spnego;0;0;39010000;ver=3D0x2;host=3Dserver;ip4=3DX.X.X.X;sec=3Dkrb5=
;uid=3D0x0;creduid=3D0x77f9;user=3Droot;pid=3D0xb924
May 12 03:20:31 client cifs.upcall[47418]: ver=3D2
May 12 03:20:31 client cifs.upcall[47418]: host=3Dserver
May 12 03:20:31 client cifs.upcall[47418]: ip=3DX.X.X.X
May 12 03:20:31 client cifs.upcall[47418]: sec=3D1
May 12 03:20:31 client cifs.upcall[47418]: uid=3D0
May 12 03:20:31 client cifs.upcall[47418]: creduid=3D30713
May 12 03:20:31 client cifs.upcall[47418]: user=3Droot
May 12 03:20:31 client cifs.upcall[47418]: pid=3D47396
May 12 03:20:31 client cifs.upcall[47418]: get_cachename_from_process_env=
:
pathname=3D/proc/47396/environ
May 12 03:20:31 client cifs.upcall[47418]: get_existing_cc: default ccach=
e is
KEYRING:persistent:30713:30713
May 12 03:20:31 client cifs.upcall[47418]: handle_krb5_mech: getting serv=
ice
ticket for server
May 12 03:20:31 client cifs.upcall[47418]: handle_krb5_mech: obtained ser=
vice
ticket
May 12 03:20:31 client cifs.upcall[47418]: Exit status 0

In this case it occurred about 65 minutes after the initial mount.

Client is Fedora 31, kernel 5.6.8-200

//server/backup on /cifs/mount type cifs
(rw,relatime,vers=3D3.1.1,sec=3Dkrb5,cruid=3D30713,cache=3Dstrict,multius=
er,uid=3D0,noforceuid,gid=3D0,noforcegid,addr=3DX.X.X.X,file_mode=3D0755,=
dir_mode=3D0755,soft,nounix,serverino,mapposix,nobrl,noperm,rsize=3D41943=
04,wsize=3D4194304,bsize=3D1048576,echo_interval=3D60,actimeo=3D1)

Also seen with CentOS 7.8 client, same server.

Server is a Synology NAS.  samba isn't logging much there so hard to tell=
 what
might have happened on the server side.

Is there any way to prevent this?  Preemptive service ticket renewal?

Thanks,
   Orion

--=20
Orion Poplawski
Manager of NWRA Technical Systems          720-772-5637
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion@nwra.com
Boulder, CO 80301                 https://www.nwra.com/


--------------ms010601060104060401040903
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CjYwggTpMIID0aADAgECAgRMDow4MA0GCSqGSIb3DQEBBQUAMIG0MRQwEgYDVQQKEwtFbnRy
dXN0Lm5ldDFAMD4GA1UECxQ3d3d3LmVudHJ1c3QubmV0L0NQU18yMDQ4IGluY29ycC4gYnkg
cmVmLiAobGltaXRzIGxpYWIuKTElMCMGA1UECxMcKGMpIDE5OTkgRW50cnVzdC5uZXQgTGlt
aXRlZDEzMDEGA1UEAxMqRW50cnVzdC5uZXQgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgKDIw
NDgpMB4XDTExMTExMTE1MzgzNFoXDTIxMTExMjAwMTczNFowgaUxCzAJBgNVBAYTAlVTMRYw
FAYDVQQKEw1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BTIGlz
IGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1c3Qs
IEluYy4xIjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0EwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQDEMo1C0J4ZnVuQWhBMtRAAIbkHSN6uboDW/xRQBuh1r2tG
juelT63DjLD6e+AZkf3wY61xSfOoHB+rNBkgTktU6QCTvnAIMd6JU6xXvCTvKo9C1PfqlSVd
FHbSzacS+huytFxhQL1f3VebRFXYxYkZPGU9uejUpS3CLNPqgzGiCDxeWa4SLioKjF7zszGu
Cq1+7LBJCfynLiIeaGQ0nRbjpj0DMUAW95T2Sxk0yZfmIpxI3mSggwtYBZjEIkaJBf2jvvZJ
TGEDFqT4Cpkc4sDGfmkCMleQA68AlKG53M6v7/R8GM4wC8qH+NVfH1lR2IsLuTjGWMJTfNom
1NvyvZDNAgMBAAGjggEOMIIBCjAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIB
ADAzBggrBgEFBQcBAQQnMCUwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLmVudHJ1c3QubmV0
MDIGA1UdHwQrMCkwJ6AloCOGIWh0dHA6Ly9jcmwuZW50cnVzdC5uZXQvMjA0OGNhLmNybDA7
BgNVHSAENDAyMDAGBFUdIAAwKDAmBggrBgEFBQcCARYaaHR0cDovL3d3dy5lbnRydXN0Lm5l
dC9ycGEwHQYDVR0OBBYEFAmRpbrp8i4qdd/Nfv53yvLea5skMB8GA1UdIwQYMBaAFFXkgdER
gL7YibkIozH5oSQJFrlwMA0GCSqGSIb3DQEBBQUAA4IBAQAKibWxMzkQsSwJee7zG22odkq0
w3jj5/8nYTTMSuzYgu4fY0rhfUV6REaqVsaATN/IdQmcYSHZPk3LoBr0kYolpXptG7lnGT8l
M9RBH2E/GCKTyD73w+kP51j0nh9O45/h1d83uvyx7YA2ZmaFJlditeJusIJq0KwjE9EXFUYJ
WXbOp3CniB5xJz4d3tnqnQiKfyuW8oubFH/KRXJPCi1bv865e+iMiEyP114JkKDnyPmAPq3B
MrJGw/3NDAzlwv1PCbeCIJK802SfBzFN9s81aTek70c/JSt7Dt+bO7JxPSfOlC57Jq1InwR/
nxuHzHodsSCQFQiuAhHTwwA9qOtHMIIFRTCCBC2gAwIBAgIQF5XJg+ffrZoAAAAATDX/LTAN
BgkqhkiG9w0BAQsFADCBpTELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4x
OTA3BgNVBAsTMHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5jb3Jwb3JhdGVkIGJ5IHJlZmVy
ZW5jZTEfMB0GA1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5jLjEiMCAGA1UEAxMZRW50cnVz
dCBDbGFzcyAyIENsaWVudCBDQTAeFw0xNzEyMTUxNzE3MTBaFw0yMDEyMTUxNzQ3MDBaMIGT
MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEm
MCQGA1UEChMdTm9ydGhXZXN0IFJlc2VhcmNoIEFzc29jaWF0ZXMxNTAWBgNVBAMTD09yaW9u
IFBvcGxhd3NraTAbBgkqhkiG9w0BCQEWDm9yaW9uQG53cmEuY29tMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAop24yyNf/vYlUdWtgHFHWcittcBFeMIWS5GJxcDDYSjYfHUY
hiEq8D4eMrktwirxZqnGTwMdN+RCqrnNZSR/YOsHSwpsW+9eOtAAlHMPCbaPsS+X0xxZX3VR
SdxXulwELCE6Saik1UMQ0MWHts1TwNuDrAXlvmoxCHgXSgcs4ukfNSOAs49Ol09tOt5xI5NA
Cz2sDjAiwonIm2ccuqbc5zJZiL2YOVTzOq9Aa/i38tRldTYkJH80WgnpmMZTSgGLua8kwA/u
4Lmax2VEcoRMw9zzmJav8gFNpQDbVnO3Ik2nlreJ/FX9+JmUa7zDn4FS0rT37ZJ7rOA3N968
CwBHAwIDAQABo4IBfzCCAXswDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMC
BggrBgEFBQcDBDBCBgNVHSAEOzA5MDcGC2CGSAGG+mwKAQQCMCgwJgYIKwYBBQUHAgEWGmh0
dHA6Ly93d3cuZW50cnVzdC5uZXQvcnBhMGoGCCsGAQUFBwEBBF4wXDAjBggrBgEFBQcwAYYX
aHR0cDovL29jc3AuZW50cnVzdC5uZXQwNQYIKwYBBQUHMAKGKWh0dHA6Ly9haWEuZW50cnVz
dC5uZXQvMjA0OGNsYXNzMnNoYTIuY2VyMDQGA1UdHwQtMCswKaAnoCWGI2h0dHA6Ly9jcmwu
ZW50cnVzdC5uZXQvY2xhc3MyY2EuY3JsMBkGA1UdEQQSMBCBDm9yaW9uQG53cmEuY29tMB8G
A1UdIwQYMBaAFAmRpbrp8i4qdd/Nfv53yvLea5skMB0GA1UdDgQWBBSU5GXZh96BMn8UDBnI
wT0CYlbijTAJBgNVHRMEAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQAj5E9g5NtdnH5bR1qKtyUG
L9Rd6BIZBrVIMoEkpXi6rRwhfeAV2cU5T/Te94+pv5JkBQfJQAakeQM+VRvSHtODHTPot12I
pX/Dm9oxhKXpWIveNjC/6Qbx+/E6iNvUGTtTTtCfwwpmyzVpUnJUN0B9XSHy78+fjJkDUIv6
byrBSC/zW0MxSd0HKtr2Do3FYZgEmFiEchDzwJeTmpJiJN/IVk/gtfJXSYQFOA0QawovCSvG
gZy/0fRY5y8h1MDWmVBRrHBRoL+ot9Q6nbhMyszvEGIVYVvWleE3Zcpu0teQ5WDv7WYs6ZZe
xIkGhIIW65NWIa1rG+UYok993UqK2FGnMYIEXzCCBFsCAQEwgbowgaUxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BT
IGlzIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1
c3QsIEluYy4xIjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEBeVyYPn362a
AAAAAEw1/y0wDQYJYIZIAWUDBAIBBQCgggJ1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTIwMDUxMjE2NDMyOFowLwYJKoZIhvcNAQkEMSIEIP9tGt04XZyt
d0Dduko58RAyhIcxToeRi+/sQGCzEzBbMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgcsGCSsGAQQBgjcQBDGBvTCBujCBpTELMAkG
A1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsTMHd3dy5lbnRydXN0
Lm5ldC9DUFMgaXMgaW5jb3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0GA1UECxMWKGMpIDIw
MTAgRW50cnVzdCwgSW5jLjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAyIENsaWVudCBDQQIQ
F5XJg+ffrZoAAAAATDX/LTCBzQYLKoZIhvcNAQkQAgsxgb2ggbowgaUxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BT
IGlzIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1
c3QsIEluYy4xIjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEBeVyYPn362a
AAAAAEw1/y0wDQYJKoZIhvcNAQEBBQAEggEAgXdwwhGkEHZYBU9nz/oZQ0SYwsU4H+lcrvQ6
cVeH1GCQS1lgPoFXMQsPETE2rxpSI6nJ2MKWUb0TknTvLFPDLOD0hBO7O8aKNzi/3Coue7T/
jgcR/4PGmcEFFiBwDdgWWEBxuInjL4N6Rqd7jqLyNJdupO90GecR0GeMqztpWRw6Q/4WUWuB
DHYow4kLk6pYrK3/4AxyDXGCpVk/FYW5T0r7ZadKoZRAj6rDDjQ2Kz2RNRNLB/5+ZGzybNj+
SxY8lqkqS7AC97eT1fN/ymjQIgua0D7HZKiais7X8j8fAHBvdR9Dl7boM4Dk86N8RF/HMQct
CpUyu6nYgYGz2kkFfwAAAAAAAA==
--------------ms010601060104060401040903--
