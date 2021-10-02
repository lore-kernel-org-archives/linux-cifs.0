Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577C1C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 12:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31DFB61B00
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 12:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhJBMKb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 08:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbhJBMKb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 08:10:31 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68497C061570
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 05:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=b+pivfOcaHYd5ylFcy9U4sPa1nwGY13pDl2Q+y/9UIk=; b=WpJmWIup/nYt3nmcI+sGuX74tB
        AHZV3ldiUqCWfN7x87/qdPuMTqeIhB2lOIqwh4zO0uqB+8nq1Yp2mcnWgBVNkBUZeRiVqjKzT+p5g
        E2W3Q889RdJpoZq760fo38vkIj6z8omSCPk1NnfBfuhh2AahlcSuJl52dCv2/iFN2qq4DOyUqzMYC
        NHFc3gANB1gIxGbryRL8koiZeQr9Eh+VE1PnO616wGZBmdeh1/8fLeI87nSrCn5B5CKwvKYmKBlxq
        NPrTsouXl7KBi5xt+51CUgKVejKneAZZve0qnj20DpeXTh2lklZjCknE7NSASDWp+dx09y89Hb+Ea
        w8X3AbL1G87BBs/72kWLPVcDvhOUkWsHc3J2SiY6wL0VxTuU2aJdMXqds1F36D4qpTybF1ohdTi1K
        7D/lA0BsyOtmlfOX+7VQfbzeVDhNi8KTFcp3wcufRMfiq8A7Tz9+lYBnkyuD8Mg2WiMHbdD7on9NF
        Ny1t1xsMCrVqwcDkTYUjGbpz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWdop-001DLp-IV; Sat, 02 Oct 2021 12:08:43 +0000
Message-ID: <be4f8694-ba18-8f4f-3568-aac74b9545dc@samba.org>
Date:   Sat, 2 Oct 2021 14:08:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 19/20] ksmbd: make smb2_check_user_session() callabe
 for compound PDUs
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-20-slow@samba.org>
 <CAKYAXd83=qxkzrzO_72U4tQsRzWks0CdYLGLnZqQXoXqQ67Vbw@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd83=qxkzrzO_72U4tQsRzWks0CdYLGLnZqQXoXqQ67Vbw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------5Nl3Q5GfLmjMqEbA8LWFKUJS"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------5Nl3Q5GfLmjMqEbA8LWFKUJS
Content-Type: multipart/mixed; boundary="------------SJ0HZ9JOS9a0RqeY7GEUeDOx";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>
Message-ID: <be4f8694-ba18-8f4f-3568-aac74b9545dc@samba.org>
Subject: Re: [PATCH v5 19/20] ksmbd: make smb2_check_user_session() callabe
 for compound PDUs
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-20-slow@samba.org>
 <CAKYAXd83=qxkzrzO_72U4tQsRzWks0CdYLGLnZqQXoXqQ67Vbw@mail.gmail.com>
In-Reply-To: <CAKYAXd83=qxkzrzO_72U4tQsRzWks0CdYLGLnZqQXoXqQ67Vbw@mail.gmail.com>

--------------SJ0HZ9JOS9a0RqeY7GEUeDOx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDIuMTAuMjEgdW0gMDg6MDEgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0xMC0w
MSAyMTowNCBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
Q2M6IE5hbWphZSBKZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+DQo+PiBDYzogVG9tIFRh
bHBleSA8dG9tQHRhbHBleS5jb20+DQo+PiBDYzogUm9ubmllIFNhaGxiZXJnIDxyb25uaWVz
YWhsYmVyZ0BnbWFpbC5jb20+DQo+PiBDYzogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFp
bC5jb20+DQo+PiBDYzogSHl1bmNodWwgTGVlIDxoeWMubGVlQGdtYWlsLmNvbT4NCj4+IFNp
Z25lZC1vZmYtYnk6IFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+DQo+PiAtLS0NCj4+
ICAgZnMva3NtYmQvc21iMnBkdS5jIHwgMTMgKysrKysrKysrKy0tLQ0KPj4gICAxIGZpbGUg
Y2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZm
IC0tZ2l0IGEvZnMva3NtYmQvc21iMnBkdS5jIGIvZnMva3NtYmQvc21iMnBkdS5jDQo+PiBp
bmRleCA1YjFmZWFkMDVjNDkuLmVmNTUxZTM2MzNkYiAxMDA2NDQNCj4+IC0tLSBhL2ZzL2tz
bWJkL3NtYjJwZHUuYw0KPj4gKysrIGIvZnMva3NtYmQvc21iMnBkdS5jDQo+PiBAQCAtNDEx
LDcgKzQxMSw2IEBAIHN0YXRpYyB2b2lkIGluaXRfY2hhaW5lZF9zbWIyX3JzcChzdHJ1Y3Qg
a3NtYmRfd29yaw0KPj4gKndvcmspDQo+PiAgIAkJd29yay0+Y29tcG91bmRfcGZpZCA9DQo+
PiAgIAkJCWxlNjRfdG9fY3B1KCgoc3RydWN0IHNtYjJfY3JlYXRlX3JzcCAqKXJzcCktPg0K
Pj4gICAJCQkJUGVyc2lzdGVudEZpbGVJZCk7DQo+PiAtCQl3b3JrLT5jb21wb3VuZF9zaWQg
PSBsZTY0X3RvX2NwdShyc3AtPlNlc3Npb25JZCk7DQo+PiAgIAl9DQo+Pg0KPj4gICAJbGVu
ID0gZ2V0X3JmYzEwMDJfbGVuKHdvcmstPnJlc3BvbnNlX2J1ZikgLSB3b3JrLT5uZXh0X3Nt
YjJfcnNwX2hkcl9vZmY7DQo+PiBAQCAtNTkyLDYgKzU5MSw4IEBAIGludCBzbWIyX2NoZWNr
X3VzZXJfc2Vzc2lvbihzdHJ1Y3Qga3NtYmRfd29yayAqd29yaykNCj4+ICAgCXVuc2lnbmVk
IGxvbmcgbG9uZyBzZXNzX2lkOw0KPj4NCj4+ICAgCXdvcmstPnNlc3MgPSBOVUxMOw0KPj4g
Kwl3b3JrLT5jb21wb3VuZF9zaWQgPSAwOw0KPj4gKw0KPj4gICAJLyoNCj4+ICAgCSAqIFNN
QjJfRUNITywgU01CMl9ORUdPVElBVEUsIFNNQjJfU0VTU0lPTl9TRVRVUCBjb21tYW5kIGRv
IG5vdA0KPj4gICAJICogcmVxdWlyZSBhIHNlc3Npb24gaWQsIHNvIG5vIG5lZWQgdG8gdmFs
aWRhdGUgdXNlciBzZXNzaW9uJ3MgZm9yDQo+PiBAQCAtNjA0LDExICs2MDUsMTcgQEAgaW50
IHNtYjJfY2hlY2tfdXNlcl9zZXNzaW9uKHN0cnVjdCBrc21iZF93b3JrICp3b3JrKQ0KPj4g
ICAJaWYgKCFrc21iZF9jb25uX2dvb2Qod29yaykpDQo+PiAgIAkJcmV0dXJuIC1FSU5WQUw7
DQo+Pg0KPj4gLQlzZXNzX2lkID0gbGU2NF90b19jcHUocmVxX2hkci0+U2Vzc2lvbklkKTsN
Cj4+ICsJaWYgKHJlcV9oZHItPkZsYWdzICYgU01CMl9GTEFHU19SRUxBVEVEX09QRVJBVElP
TlMpDQo+PiArCQlzZXNzX2lkID0gd29yay0+Y29tcG91bmRfc2lkOw0KPiBzYW1lIGNvbW1l
bnQgd2l0aCBwcmV2aW91cyB0cmVlIGlkIHBhdGNoLg0KDQpzYW1lIGFuc3dlci4gOikNCg0K
LXNsb3cNCg0KLS0gDQpSYWxwaCBCb2VobWUsIFNhbWJhIFRlYW0gICAgICAgICAgICAgICAg
IGh0dHBzOi8vc2FtYmEub3JnLw0KU2VyTmV0IFNhbWJhIFRlYW0gTGVhZCAgICAgIGh0dHBz
Oi8vc2VybmV0LmRlL2VuL3RlYW0tc2FtYmENCg==

--------------SJ0HZ9JOS9a0RqeY7GEUeDOx--

--------------5Nl3Q5GfLmjMqEbA8LWFKUJS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFYS8oFAwAAAAAACgkQqh6bcSY5nkYp
bxAApudhG9TEJ2yrgFG4IifAC5/SMoMCp+El1rHSPJ5e+CCDOb7ibVzToBEKtBZFPtDAHUccsja4
Id4fZgC4mSW0eizJ6609OcsieiPT1PPql0i11rufY/QgxTgOogkjFxnE2oT0eQe1f620928zXF/1
V1clm2GpN2arerTk/DM/nAGABNhtonSmIV0WUuC+7DW3gKgBhFdNJM5CFx2R3r3ifi9PVNmvkIg4
Q7cIWzGjB9jE0qS03nhekWOISC+6THtaqaBkHEsYuoAVAuZQ0ZNtqnBUeCPKFZgrdBj9/mpQNUFZ
VHHIdx5gENtofvhvmvls6fxRAVVJ2hJerOvkRwGsQcn+ZhIrKADiW3xfYpYNZIjIaKN3oVFzFDNL
STkW+P4DzEWiOXeBhqpgVsfVOVYzp40H/7Dq3xO3koFwVUbvDifXmkykvSiQTcls+cbofCZj7ZjN
Qn7boNJkiKDRIz5DrU19znECl3QWJgzPGkVOeatMU/yW0UFE0qdaPpuEMey1hRSlvDeBt27KeA4l
bjPOmqxMOVyBjUaS1vHcSRUP8Ekkn+DQ95OLa56tMgY4easpWrCYUJ+n4s+kNrg7Ck2Rc0cC5Ex+
yIxfrzX1hwNJMblKau5RKE3YTgk/zM1JrqZ7n26nNhRv++VUpgqQGNFz4jX8wyQ7knYohTdquWuQ
Kgk=
=nFF0
-----END PGP SIGNATURE-----

--------------5Nl3Q5GfLmjMqEbA8LWFKUJS--
