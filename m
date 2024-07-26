Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909A52B9C4
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jul 2024 06:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721974710; cv=none; b=UT3kmg3QTO5d6rq6qL56N1gw94A5IplTJAoVaNDxljs1IbzvFKCARDExOy4KrDSfhih4LichlY8x2lWqmyxUKn5K6py59Uui17+0wt3B2C+Pn0obUtm19S1G8pZ5BVqWkVAr9lR3YrdKx4hPq0FrVMcc9y34qw9iEDH8XM0q7i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721974710; c=relaxed/simple;
	bh=0VhCKA5jfvo/H6WtQvJYtTKpd2FcUTAm6ezVN5h3o5g=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=aBlNYFlxTizSgO2Akhlh5/gClBoYg+gi5Wtm6U680H+zBe1i4wNMFfC84P+QF99Q+qvduTDpcoHRCdWJuvx/TqhfQ2TnWT2xWdTXC0scuZWmaAUEayLdpAshdCMav+lE/nwrxcM4zVYb4YUwr4XGl5GFfdi6JoUM5xQYbDcE+kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hImA1DYm; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hImA1DYm"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f0271b0ae9so10479781fa.1
        for <linux-cifs@vger.kernel.org>; Thu, 25 Jul 2024 23:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721974706; x=1722579506; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wGIDKTYm6T97Ux4wAeKYKfGvhOaNuObEt2k58ikX804=;
        b=hImA1DYmF20A228T39gUlzDt44FbX4xfAgJmXJRyEhWnsNACUth1mNOpT+89zK0eId
         YwVnTOPFB7hhWuAna3ffCY9t5RWKuhDGPceZ0kiS3k3H1fZmap2vnPwfF4NyPyT0+un8
         1cS1M6bIfG0Gj89P33zGyMNYewdOfMopHQ3Ctsl4+d9ge3gLBy4MQX+vpb7V0xYSQo1g
         fOnfKimJbRo3nRWluoZcWDX8wS2+RTzqvnZXVyH4Ug3TWoTeyRMMeH5uB9Nra4MzLZgx
         EWbuZXFrteB+s5C6lb8uMBCJ082O0THTmd+NVn9Iogx8GMQaxGxzGgzi7ByP52Ea0Cud
         E5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721974706; x=1722579506;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wGIDKTYm6T97Ux4wAeKYKfGvhOaNuObEt2k58ikX804=;
        b=o5MradhbxjUCVmKGDaxnyzrRhqnislIEF3svSXgtyqUg0hYfiwBMnULwcWQHRTsJja
         NyzgLJGGnoGr4HeGjELVo825i8XViaFLUBzT30mZAEWMZMD+f91q72L5mHYTTYWI2wdm
         jt9i6nQ84PzBv69okskOc0KTYgISQmBdrG/I2k2XAqhGaQyD48241z0JD6aVP1FkUrqd
         zrLYXBI1Kxgdane6mlvsqvpMg5uKogiB9Q4/4qsxrSxTyIicBAQKurOrJPLYpLnvtCBg
         X7mZ+pwq4hfSFLTzvjdZL+C7kloa1G67zXprxnViErSWNRP4E2oyx3djv4CvoBeUsUDL
         u69Q==
X-Gm-Message-State: AOJu0YzhdFz6Uzp6coKp2WqHyAc9GsyDaN0unToiwZ6FXj+09SZIUBdB
	Yo2O0wuTQABznuOtrrina08kGu8eN32qV/3HyIaFmNmD86J0l8Smaq4+/ymL+/eIGtx0aC2DJjH
	qNdoXIedL6nY6b2IysHtROh9QtG4MNnCD
X-Google-Smtp-Source: AGHT+IHuSVGIPgoir0qJy9dE2hUgH/MtP26+Qi7TWjyRTu/JXBqokHny1zuL0UVOM/3C8gyPSrUqYu5ynH6M3cORJe4=
X-Received: by 2002:a2e:9ed9:0:b0:2ee:5ed4:792f with SMTP id
 38308e7fff4ca-2f039c8f224mr36506011fa.2.1721974706015; Thu, 25 Jul 2024
 23:18:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 26 Jul 2024 01:18:14 -0500
Message-ID: <CAH2r5mvhrx52pZNWQ-ieKKBoa6mugLewPgXgL8ss=xE=Zh-4TQ@mail.gmail.com>
Subject: [PATCH][SMB3 client] add dynamic trace point for session setup
 password expired failures
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000aa2cff061e207a3e"

--000000000000aa2cff061e207a3e
Content-Type: multipart/alternative; boundary="000000000000aa2cfe061e207a3c"

--000000000000aa2cfe061e207a3c
Content-Type: text/plain; charset="UTF-8"

There are cases where services need to remount (or change their
credentials files) when keys have expired, but it can be helpful
to have a dynamic trace point to make it easier to notify the
service to refresh the storage account key.

Here is sample output, one from mount with bad password, one
from a reconnect where the password has been changed or expired
and reconnect fails (requiring remount with new storage account key)

       TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
          | |         |   |||||     |         |

  mount.cifs-11362  [000] .....  6000.241620: smb3_key_expired:
    rc=-13 user=testpassu conn_id=0x2 server=localhost addr=127.0.0.1:445
  kworker/4:0-8458  [004] .....  6044.892283: smb3_key_expired:
    rc=-13 user=testpassu conn_id=0x3 server=localhost addr=127.0.0.1:445

See attached patch

-- 
Thanks,

Steve

--000000000000aa2cfe061e207a3c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">There are cases where services need to remount (or change =
their<br>credentials files) when keys have expired, but it can be helpful<b=
r>to have a dynamic trace point to make it easier to notify the<br>service =
to refresh the storage account key.<br><br>Here is sample output, one from =
mount with bad password, one<br>from a reconnect where the password has bee=
n changed or expired<br>and reconnect fails (requiring remount with new sto=
rage account key)<br><br>=C2=A0 =C2=A0 =C2=A0 =C2=A0TASK-PID =C2=A0 =C2=A0 =
CPU# =C2=A0||||| =C2=A0TIMESTAMP =C2=A0FUNCTION<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 | | =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 ||||| =C2=A0 =C2=A0 | =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 |<br><br>=C2=A0 mount.cifs-11362 =C2=A0[000] ..=
... =C2=A06000.241620: smb3_key_expired:<br>=C2=A0 =C2=A0 rc=3D-13 user=3Dt=
estpassu conn_id=3D0x2 server=3Dlocalhost addr=3D<a href=3D"http://127.0.0.=
1:445">127.0.0.1:445</a><br>=C2=A0 kworker/4:0-8458 =C2=A0[004] ..... =C2=
=A06044.892283: smb3_key_expired:<br>=C2=A0 =C2=A0 rc=3D-13 user=3Dtestpass=
u conn_id=3D0x3 server=3Dlocalhost addr=3D<a href=3D"http://127.0.0.1:445">=
127.0.0.1:445</a><div><br></div><div>See attached patch<br clear=3D"all"><d=
iv><br></div><span class=3D"gmail_signature_prefix">-- </span><br><div dir=
=3D"ltr" class=3D"gmail_signature" data-smartmail=3D"gmail_signature">Thank=
s,<br><br>Steve</div></div></div>

--000000000000aa2cfe061e207a3c--
--000000000000aa2cff061e207a3e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-add-dynamic-trace-point-for-session-setup-key-e.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-trace-point-for-session-setup-key-e.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lz2b9rfv0>
X-Attachment-Id: f_lz2b9rfv0

RnJvbSBkOTQyMTMzY2MwYThmYWU2YmRkYWIzYTE5NGIwMDY4NmI4NWExZDQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IEZyaSwgMjYgSnVsIDIwMjQgMDE6MDY6MjAgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgZHluYW1pYyB0cmFjZSBwb2ludCBmb3Igc2Vzc2lvbiBzZXR1cCBrZXkgZXhwaXJl
ZAogZmFpbHVyZXMKClRoZXJlIGFyZSBjYXNlcyB3aGVyZSBzZXJ2aWNlcyBuZWVkIHRvIHJlbW91
bnQgKG9yIGNoYW5nZSB0aGVpcgpjcmVkZW50aWFscyBmaWxlcykgd2hlbiBrZXlzIGhhdmUgZXhw
aXJlZCwgYnV0IGl0IGNhbiBiZSBoZWxwZnVsCnRvIGhhdmUgYSBkeW5hbWljIHRyYWNlIHBvaW50
IHRvIG1ha2UgaXQgZWFzaWVyIHRvIG5vdGlmeSB0aGUKc2VydmljZSB0byByZWZyZXNoIHRoZSBz
dG9yYWdlIGFjY291bnQga2V5LgoKSGVyZSBpcyBzYW1wbGUgb3V0cHV0LCBvbmUgZnJvbSBtb3Vu
dCB3aXRoIGJhZCBwYXNzd29yZCwgb25lCmZyb20gYSByZWNvbm5lY3Qgd2hlcmUgdGhlIHBhc3N3
b3JkIGhhcyBiZWVuIGNoYW5nZWQgb3IgZXhwaXJlZAphbmQgcmVjb25uZWN0IGZhaWxzIChyZXF1
aXJpbmcgcmVtb3VudCB3aXRoIG5ldyBzdG9yYWdlIGFjY291bnQga2V5KQoKICAgICAgIFRBU0st
UElEICAgICBDUFUjICB8fHx8fCAgVElNRVNUQU1QICBGVU5DVElPTgogICAgICAgICAgfCB8ICAg
ICAgICAgfCAgIHx8fHx8ICAgICB8ICAgICAgICAgfAoKICBtb3VudC5jaWZzLTExMzYyICBbMDAw
XSAuLi4uLiAgNjAwMC4yNDE2MjA6IHNtYjNfa2V5X2V4cGlyZWQ6CiAgICByYz0tMTMgdXNlcj10
ZXN0cGFzc3UgY29ubl9pZD0weDIgc2VydmVyPWxvY2FsaG9zdCBhZGRyPTEyNy4wLjAuMTo0NDUK
ICBrd29ya2VyLzQ6MC04NDU4ICBbMDA0XSAuLi4uLiAgNjA0NC44OTIyODM6IHNtYjNfa2V5X2V4
cGlyZWQ6CiAgICByYz0tMTMgdXNlcj10ZXN0cGFzc3UgY29ubl9pZD0weDMgc2VydmVyPWxvY2Fs
aG9zdCBhZGRyPTEyNy4wLjAuMTo0NDUKClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3Rm
cmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9zbWIvY2xpZW50L3NtYjJwZHUuYyB8ICA4ICsr
KysrKystCiBmcy9zbWIvY2xpZW50L3RyYWNlLmggICB8IDQwICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgNDcgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jIGIvZnMv
c21iL2NsaWVudC9zbWIycGR1LmMKaW5kZXggOWZjNWIxMWMwYjZjLi4zZGQ1YTdhMDIyODggMTAw
NjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jCisrKyBiL2ZzL3NtYi9jbGllbnQvc21i
MnBkdS5jCkBAIC0xNTYyLDggKzE1NjIsMTQgQEAgU01CMl9zZXNzX3NlbmRyZWNlaXZlKHN0cnVj
dCBTTUIyX3Nlc3NfZGF0YSAqc2Vzc19kYXRhKQogCWNpZnNfc21hbGxfYnVmX3JlbGVhc2Uoc2Vz
c19kYXRhLT5pb3ZbMF0uaW92X2Jhc2UpOwogCWlmIChyYyA9PSAwKQogCQlzZXNzX2RhdGEtPnNl
cy0+ZXhwaXJlZF9wd2QgPSBmYWxzZTsKLQllbHNlIGlmICgocmMgPT0gLUVBQ0NFUykgfHwgKHJj
ID09IC1FS0VZRVhQSVJFRCkgfHwgKHJjID09IC1FS0VZUkVWT0tFRCkpCisJZWxzZSBpZiAoKHJj
ID09IC1FQUNDRVMpIHx8IChyYyA9PSAtRUtFWUVYUElSRUQpIHx8IChyYyA9PSAtRUtFWVJFVk9L
RUQpKSB7CisJCWlmIChzZXNzX2RhdGEtPnNlcy0+ZXhwaXJlZF9wd2QgPT0gZmFsc2UpCisJCQl0
cmFjZV9zbWIzX2tleV9leHBpcmVkKHNlc3NfZGF0YS0+c2VydmVyLT5ob3N0bmFtZSwKKwkJCQkJ
ICAgICAgIHNlc3NfZGF0YS0+c2VzLT51c2VyX25hbWUsCisJCQkJCSAgICAgICBzZXNzX2RhdGEt
PnNlcnZlci0+Y29ubl9pZCwKKwkJCQkJICAgICAgICZzZXNzX2RhdGEtPnNlcnZlci0+ZHN0YWRk
ciwgcmMpOwogCQlzZXNzX2RhdGEtPnNlcy0+ZXhwaXJlZF9wd2QgPSB0cnVlOworCX0KIAogCW1l
bWNweSgmc2Vzc19kYXRhLT5pb3ZbMF0sICZyc3BfaW92LCBzaXplb2Yoc3RydWN0IGt2ZWMpKTsK
IApkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC90cmFjZS5oIGIvZnMvc21iL2NsaWVudC90cmFj
ZS5oCmluZGV4IGJjNGY4YjNhZDZmZi4uMjVlMjljNjYyNjcyIDEwMDY0NAotLS0gYS9mcy9zbWIv
Y2xpZW50L3RyYWNlLmgKKysrIGIvZnMvc21iL2NsaWVudC90cmFjZS5oCkBAIC0xMjgxLDYgKzEy
ODEsNDYgQEAgREVGSU5FX0VWRU5UKHNtYjNfY29ubmVjdF9lcnJfY2xhc3MsIHNtYjNfIyNuYW1l
LCAgXAogCiBERUZJTkVfU01CM19DT05ORUNUX0VSUl9FVkVOVChjb25uZWN0X2Vycik7CiAKK0RF
Q0xBUkVfRVZFTlRfQ0xBU1Moc21iM19zZXNzX3NldHVwX2Vycl9jbGFzcywKKwlUUF9QUk9UTyhj
aGFyICpob3N0bmFtZSwgY2hhciAqdXNlcm5hbWUsIF9fdTY0IGNvbm5faWQsCisJCWNvbnN0IHN0
cnVjdCBfX2tlcm5lbF9zb2NrYWRkcl9zdG9yYWdlICpkc3RfYWRkciwgaW50IHJjKSwKKwlUUF9B
UkdTKGhvc3RuYW1lLCB1c2VybmFtZSwgY29ubl9pZCwgZHN0X2FkZHIsIHJjKSwKKwlUUF9TVFJV
Q1RfX2VudHJ5KAorCQlfX3N0cmluZyhob3N0bmFtZSwgaG9zdG5hbWUpCisJCV9fc3RyaW5nKHVz
ZXJuYW1lLCB1c2VybmFtZSkKKwkJX19maWVsZChfX3U2NCwgY29ubl9pZCkKKwkJX19hcnJheShf
X3U4LCBkc3RfYWRkciwgc2l6ZW9mKHN0cnVjdCBzb2NrYWRkcl9zdG9yYWdlKSkKKwkJX19maWVs
ZChpbnQsIHJjKQorCSksCisJVFBfZmFzdF9hc3NpZ24oCisJCXN0cnVjdCBzb2NrYWRkcl9zdG9y
YWdlICpwc3MgPSBOVUxMOworCisJCV9fZW50cnktPmNvbm5faWQgPSBjb25uX2lkOworCQlfX2Vu
dHJ5LT5yYyA9IHJjOworCQlwc3MgPSAoc3RydWN0IHNvY2thZGRyX3N0b3JhZ2UgKilfX2VudHJ5
LT5kc3RfYWRkcjsKKwkJKnBzcyA9ICpkc3RfYWRkcjsKKwkJX19hc3NpZ25fc3RyKGhvc3RuYW1l
KTsKKwkJX19hc3NpZ25fc3RyKHVzZXJuYW1lKTsKKwkpLAorCVRQX3ByaW50aygicmM9JWQgdXNl
cj0lcyBjb25uX2lkPTB4JWxseCBzZXJ2ZXI9JXMgYWRkcj0lcElTcHNmYyIsCisJCV9fZW50cnkt
PnJjLAorCQlfX2dldF9zdHIodXNlcm5hbWUpLAorCQlfX2VudHJ5LT5jb25uX2lkLAorCQlfX2dl
dF9zdHIoaG9zdG5hbWUpLAorCQlfX2VudHJ5LT5kc3RfYWRkcikKKykKKworI2RlZmluZSBERUZJ
TkVfU01CM19TRVNfU0VUVVBfRVJSX0VWRU5UKG5hbWUpICAgICAgICBcCitERUZJTkVfRVZFTlQo
c21iM19zZXNzX3NldHVwX2Vycl9jbGFzcywgc21iM18jI25hbWUsICBcCisJVFBfUFJPVE8oY2hh
ciAqaG9zdG5hbWUsCQlcCisJCWNoYXIgKnVzZXJuYW1lLAkJCVwKKwkJX191NjQgY29ubl9pZCwJ
CQlcCisJCWNvbnN0IHN0cnVjdCBfX2tlcm5lbF9zb2NrYWRkcl9zdG9yYWdlICphZGRyLAlcCisJ
CWludCByYyksCQkJXAorCVRQX0FSR1MoaG9zdG5hbWUsIHVzZXJuYW1lLCBjb25uX2lkLCBhZGRy
LCByYykpCisKK0RFRklORV9TTUIzX1NFU19TRVRVUF9FUlJfRVZFTlQoa2V5X2V4cGlyZWQpOwor
CiBERUNMQVJFX0VWRU5UX0NMQVNTKHNtYjNfcmVjb25uZWN0X2NsYXNzLAogCVRQX1BST1RPKF9f
dTY0CWN1cnJtaWQsCiAJCV9fdTY0IGNvbm5faWQsCi0tIAoyLjQzLjAKCg==
--000000000000aa2cff061e207a3e--
