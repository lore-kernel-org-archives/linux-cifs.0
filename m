From: =?UTF-8?B?QXVyw6lsaWVu?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Making shares unaccessible at root level mountable (aka
 solving bsc#8950 ...again)
Date: Thu, 9 Jun 2016 18:50:27 +0200
Message-ID: <20160609185027.7349f260@aaptelpc>
References: <20160527194346.08416d79@aaptelpc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/q/Xeh73uQKQHFCIlg8/S1P6"; protocol="application/pgp-signature"
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Marcus Hoffmann <marcus.hoffmann-j/7cz5qe3tpn68oJJulU0Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160527194346.08416d79@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Sig_/q/Xeh73uQKQHFCIlg8/S1P6
Content-Type: multipart/mixed; boundary="MP_/Pd8flJDunsggELdjpVhzZE6"

--MP_/Pd8flJDunsggELdjpVhzZE6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Small update: I've written a powershell script to reproduce the problem
(attached). If you're wondering I'm not using samba see my notes
about it [1].

On the window server:
- Edit $Dir (script will create parent dirs)
- Edit $LimitedUser/$AdminUser to an existing one
- Run the script as admin

On the linux client:
- Mount the share sub dir with the limited user credentials:
  mount //lutze/bug8950/sub/dir' /mnt \
        -o 'domain=3DLURCH,ip=3D10.160.5.42,username=3Dbill,password=3D****=
*,rw'

My second solution fails for the case when the dir *containing* the
shared dir restricts the limited user. See "HARD MODE" at the end
of the script.

1: http://diobla.info/stuff/bugs/bsc799133/#sec-4

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG
N=C3=BCrnberg)

--MP_/Pd8flJDunsggELdjpVhzZE6
Content-Type: application/octet-stream; name=repro-8950.ps1
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=repro-8950.ps1

I1JFUVVJUkVTIC1WZXJzaW9uIDMuMA0KDQojDQojIHBvd2Vyc2hlbGwgc2NyaXB0IHRvIHJlcHJv
ZHVjZSAjODk1MA0KIw0KDQojIE9uIHRoZSBzZXJ2ZXI6DQojIC0gRWRpdCAkRGlyIChzY3JpcHQg
d2lsbCBjcmVhdGUgcGFyZW50IGRpcnMpDQojIC0gRWRpdCAkTGltaXRlZFVzZXIgdG8gYW4gZXhp
c3Rpbmcgb25lDQojIC0gUnVuIHRoZSBzY3JpcHQNCg0KIyBPbiB0aGUgbGludXggY2xpZW50Og0K
IyAtIE1vdW50IHRoZSBzaGFyZSBzdWIgZGlyIHdpdGggdGhlIGxpbWl0ZWQgdXNlciBjcmVkZW50
aWFsczoNCiMgICBtb3VudCAvL2x1dHplL2J1Zzg5NTAvc3ViL2RpcicgL21udCBcDQojICAgICAg
ICAgLW8gJ2RvbWFpbj1MVVJDSCxpcD0xMC4xNjAuNS40Mix1c2VybmFtZT1iaWxsLHBhc3N3b3Jk
PSoqKioqLHJ3Jw0KDQoNCiREaXIgPSAiQzpcc2hhcmVzXGJ1Zzg5NTBcc2hhcmUiDQokRGlyMSA9
ICJzdWIiDQokRGlyMiA9ICJkaXIiDQokTGltaXRlZFVzZXIgPSAiTFVSQ0hcYmlsbCINCiRBZG1p
blVzZXIgPSAiTFVSQ0hcQWRtaW5pc3RyYXRvciINCiRTaGFyZSA9ICJidWc4OTUwIg0KDQokU3Vi
RGlyID0gJERpciArICJcIiArICREaXIxICsgIlwiICsgJERpcjINCg0KDQppZiAoVGVzdC1QYXRo
ICREaXIpIHsNCiAgICBSZW1vdmUtU01CU2hhcmUgLU5hbWUgJFNoYXJlIC1Gb3JjZQ0KICAgIGlj
YWNscy5leGUgJERpciAvZ3JhbnQ6ciAgICIkKCRBZG1pblVzZXIpOihGKSINCiAgICBpY2FjbHMu
ZXhlICREaXIgL2dyYW50OnIgICAiJCgkQWRtaW5Vc2VyKTooRikiIC9UDQogICAgR2V0LUNoaWxk
SXRlbSAtUmVjdXJzZSAtUGF0aCAkRGlyIHwgUmVtb3ZlLUl0ZW0gLVJlY3Vyc2UgLUZvcmNlDQog
ICAgUmVtb3ZlLUl0ZW0gLVJlY3Vyc2UgLUZvcmNlICREaXINCn0NCg0KTmV3LUl0ZW0gJFN1YkRp
ciAtVHlwZSBkaXJlY3RvcnkgLUZvcmNlDQoiYmxhaGJsYWJoIiA+ICRTdWJEaXJcZmlsZS50eHQN
Ck5ldy1TTUJTaGFyZSAtTmFtZSAkU2hhcmUgLVBhdGggJERpcg0KDQoNCg0KaWNhY2xzLmV4ZSAk
RGlyIC9kZW55ICAgICIkKCRMaW1pdGVkVXNlcik6KEYpIg0KaWNhY2xzLmV4ZSAkRGlyIC9ncmFu
dDpyICAgIiQoJEFkbWluVXNlcik6KEYpIg0KDQppY2FjbHMuZXhlICREaXJcJERpcjEgL2Rlbnkg
ICAgIiQoJExpbWl0ZWRVc2VyKTooRikiDQppY2FjbHMuZXhlICREaXJcJERpcjEgL2dyYW50OnIg
ICAiJCgkQWRtaW5Vc2VyKTooRikiDQoNCmljYWNscy5leGUgJFN1YkRpciAvZ3JhbnQ6ciAiJCgk
TGltaXRlZFVzZXIpOihGKSINCmljYWNscy5leGUgJFN1YkRpciAvZ3JhbnQ6ciAgICIkKCRBZG1p
blVzZXIpOihGKSINCmljYWNscy5leGUgJERpciAvaW5oZXJpdGFuY2U6ciAvVA0KDQojIEhBUkQg
TU9ERSBtYWtlIG1vdW50aW5nIHdvcmsgd2l0aCB0aGlzOg0KaWNhY2xzLmV4ZSAkRGlyXC4uIC9y
ZW1vdmUgICRMaW1pdGVkVXNlcg0KaWNhY2xzLmV4ZSAkRGlyXC4uIC9kZW55ICAgICIkKCRMaW1p
dGVkVXNlcik6KEYpIg0K

--MP_/Pd8flJDunsggELdjpVhzZE6--

--Sig_/q/Xeh73uQKQHFCIlg8/S1P6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXWZ5jAAoJEDIGO5Hchq/80/sP/3ifxo9XhF1FU0Emjq3ZI6Ez
sFnoah34NOZ+cdnKxxRjNIQO56hhisKBXb6jJSglM9mBCUWM7x7OFZPDP54ULSqL
rBmvtyLSAfoDUWWXRsutTYdWlPH1uak3BR7GWVwVf9bp6+gpGs5OnZJvnDN4cqd9
xkUREMWHqRxhSl6vfneoXo3K3J6bjjKlgFrahUbR0iH5UtABKtVsbRinqP5+NXJ2
NZG+5To13wYACYuUv9WpVf9kmxexokRmNvpCTHOxGsY2vGtHGb/iygbUBxez0mU2
87fixyx+TFAhvogl79E3SJpnw7AnL+fCnUIM8I/u1dNDng6I//kc3kgthBQz/GkV
Jg+2aE7Tnz4a6ih48EzOFKkYNSPbmR5gOWw4mp3k9JONBXdzHcDJKCi6ryTO9Oiy
1Q4QAnD9IotkR182bOWsfuF4VFZiqF4XN0mp3dPntkX45q7n/ETHNQ0TKweDcyeX
TVM2nRyrXhcDJ0apTWPfD7xESJt7FVKIG7CKNEf4Jcd2LiVv71wxwi4m3ZbzmmTO
CI+Z2n6E+2HWmsGdCbfMC3YOw8DeRqXNJ+3mmxGtT5EYb/tmjmSjuGida3U5BhxL
saYXhEpWpkeHqRgyTDY3Wpsgd4c92oEa565zzrhJiv3EHtLw8T2FI2IOAbPPDuZY
oeY9ja8swPZTcL/Ds4P5
=HyN9
-----END PGP SIGNATURE-----

--Sig_/q/Xeh73uQKQHFCIlg8/S1P6--
