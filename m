Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C66CC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 17:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B274461465
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 17:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345016AbhI2R4x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 13:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343932AbhI2R4x (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 13:56:53 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C438EC06161C
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 10:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=iu30AcryEOxre2ddZnuhxIZM/XQzypLDtyC5bc2+hQ0=; b=yL7T5u6+MtFme2mIRUy8xGqxih
        m32aPiqGyMjxrbTxS4H9uFALkSE+dURJizPBZhuaRXa5/SWblouwc6Y0AUv8NPJdXbuKqlXCFTZgE
        B85Q6fsUGnV3bBJgrxOb6OUmqjH16XAI3nLKQYLqcOzHux4wFFNzpEhK7D9fohcfu+mVYWjYme8Fi
        7vgMdq8d2/hgAprU/xfXZ4cLz6fY3GaTt8d9GiMBxa8W9JRJbHsFEn0IAjCwfGfqE8bdYKuREYSI6
        e6DZc6dYQXiufta01e84VenUPkdiRBZw09fQIaavLbbfcavFaGrhfdu9iTohYAB1UeEKjv15779Sd
        mrUfD85LEclzmY4Onh6QvYNPLwRlVvciRNAk8nKH7gQd8SdCdxjaC0dGD/e0GNqdHH0Ef7+9xIVvD
        gl24bzDcIqMrGj/Z0uqrbYwptnpN2xTQYCt2P5FY0o574n8O1sDqmbfcvzbf29XEBvfwKFkvDLgvI
        v4mD1VZvMG1SrvEj1o2h+v3M;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVdnQ-000jsA-GF; Wed, 29 Sep 2021 17:55:08 +0000
Message-ID: <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
Date:   Wed, 29 Sep 2021 19:55:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <20210929084501.94846-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------siGJo1TZDDiAOhoLq1l110Xu"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------siGJo1TZDDiAOhoLq1l110Xu
Content-Type: multipart/mixed; boundary="------------QZw4fyJPfz7R1jnliOr86bwU";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
Subject: Re: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
References: <20210929084501.94846-1-linkinjeon@kernel.org>
In-Reply-To: <20210929084501.94846-1-linkinjeon@kernel.org>

--------------QZw4fyJPfz7R1jnliOr86bwU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMjkuMDkuMjEgdW0gMTA6NDQgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gQ2M6IFRvbSBU
YWxwZXkgPHRvbUB0YWxwZXkuY29tPg0KPiBDYzogUm9ubmllIFNhaGxiZXJnIDxyb25uaWVz
YWhsYmVyZ0BnbWFpbC5jb20+DQo+IENjOiBSYWxwaCBCw7ZobWUgPHNsb3dAc2FtYmEub3Jn
Pg0KPiBDYzogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+DQo+IENjOiBIeXVu
Y2h1bCBMZWUgPGh5Yy5sZWVAZ21haWwuY29tPg0KPiBDYzogU2VyZ2V5IFNlbm96aGF0c2t5
IDxzZW5vemhhdHNreUBjaHJvbWl1bS5vcmc+DQo+IA0KPiB2MjoNCj4gICAgLSB1cGRhdGUg
Y29tbWVudHMgb2Ygc21iMl9nZXRfZGF0YV9hcmVhX2xlbigpLg0KPiAgICAtIGZpeCB3cm9u
ZyBidWZmZXIgc2l6ZSBjaGVjayBpbiBmc2N0bF9xdWVyeV9pZmFjZV9pbmZvX2lvY3RsKCku
DQo+ICAgIC0gZml4IDMyYml0IG92ZXJmbG93IGluIHNtYjJfc2V0X2luZm8uDQo+IA0KPiB2
MzoNCj4gICAgLSBhZGQgYnVmZmVyIGNoZWNrIGZvciBCeXRlQ291bnQgb2Ygc21iIG5lZ290
aWF0ZSByZXF1ZXN0Lg0KPiAgICAtIE1vdmVkIGJ1ZmZlciBjaGVjayBvZiB0byB0aGUgdG9w
IG9mIGxvb3AgdG8gYXZvaWQgdW5uZWVkZWQgYmVoYXZpb3Igd2hlbg0KPiAgICAgIG91dF9i
dWZfbGVuIGlzIHNtYWxsZXIgdGhhbiBuZXR3b3JrX2ludGVyZmFjZV9pbmZvX2lvY3RsX3Jz
cC4NCj4gICAgLSBnZXQgY29ycmVjdCBvdXRfYnVmX2xlbiB3aGljaCBkb2Vzbid0IGV4Y2Vl
ZCBtYXggc3RyZWFtIHByb3RvY29sIGxlbmd0aC4NCj4gICAgLSBzdWJ0cmFjdCBzaW5nbGUg
c21iMl9sb2NrX2VsZW1lbnQgZm9yIGNvcnJlY3QgYnVmZmVyIHNpemUgY2hlY2sgaW4NCj4g
ICAgICBrc21iZF9zbWIyX2NoZWNrX21lc3NhZ2UoKS4NCj4gDQo+IHY0Og0KPiAgICAtIHVz
ZSB3b3JrLT5yZXNwb25zZV9zeiBmb3Igb3V0X2J1Zl9sZW4gY2FsY3VsYXRpb24gaW4gc21i
Ml9pb2N0bC4NCj4gICAgLSBtb3ZlIHNtYjJfbmVnIHNpemUgY2hlY2sgdG8gYWJvdmUgdG8g
dmFsaWRhdGUgTmVnb3RpYXRlQ29udGV4dE9mZnNldA0KPiAgICAgIGZpZWxkLg0KPiAgICAt
IHJlbW92ZSB1bm5lZWRlZCBkaWFsZWN0IGNoZWNrcyBpbiBzbWIyX3Nlc3Nfc2V0dXAoKSBh
bmQNCj4gICAgICBzbWIyX2hhbmRsZV9uZWdvdGlhdGUoKS4NCj4gICAgLSBzcGxpdCBzbWIy
X3NldF9pbmZvIHBhdGNoIGludG8gdHdvIHBhdGNoZXMoZGVjbGFyaW5nDQo+ICAgICAgc21i
Ml9maWxlX2Jhc2ljX2luZm8gYW5kIGJ1ZmZlciBjaGVjaykNCg0KaXQgbG9va3MgbGlrZSB5
b3UgZHJvcHBlZCBhbGwgbXkgcGF0Y2hlcyBhbmQgZGlkbid0IGNvbW1lbnQgb24gdGhlIA0K
U1FVQVNIRVMgdGhhdCBwb2ludGVkIGF0IHNvbWUgaXNzdWVzLg0KDQpEaWQgSSBtaXNzIGFu
eXRoaW5nIHdoZXJlIHlvdSBleHBsYWluZWQgd2h5IHlvdSBkaWQgdGhpcz8NCg0KVGhlIGNo
YW5nZXMgSSBtYWRlIGltaG8gY29uc29saWRhdGVkIHRoZSBTTUIyIFBEVSBwYWNrZXQgc2l6
ZSBjaGVja2luZyANCmxvZ2ljLiBXaXRoIHlvdXIgY2hhbmdlcyB0aGUgY2hlY2sgZm9yIHZh
bGlkIFNNQjIgUERVIHNpemVzIG9mIGNvbXBvdW5kIA0Kb2Zmc2V0cyBpcyBzcHJlYWQgYWNy
b3NzIHRoZSBuZXR3b3JrIHJlY2VpdmUgbGF5ZXIgYW5kIHRoZSBjb21wb3VuZCANCnBhcnNp
bmcgbGF5ZXIuDQoNClRoZSBjaGFuZ2VzIEkgbWFkZSwgYWRkaW5nIGEgbmljZSBoZWxwZXIg
ZnVuY3Rpb24gYWxvbmcgdGhlIHdheSwgbW92ZWQgDQp0aGUgY29yZSBQRFUgdmFsaWRhdGlv
biBpbnRvIHRoZSBmdW5jdGlvbiB3ZXJlIGl0IHNob3VsZCBiZSBkb25lOiBpbnNpZGUgDQpr
c21iZF9zbWIyX2NoZWNrX21lc3NhZ2UoKS4NCg0KWW91IGFsc28gZHJvcHBlZCB0aGUgZml4
IGZvciB0aGUgcG9zc2libGUgaW52YWxpZCByZWFkIGluIA0Ka3NtYmRfdmVyaWZ5X3NtYl9t
ZXNzYWdlKCkgb2YgdGhlIHByb3RvY29sX2lkIGZpZWxkLg0KDQpJIG1pZ2h0IGJlIG1pc3Np
bmcgc29tZXRoaW5nIGJlY2F1c2UgSSdtIHN0aWxsIG5ldyB0byB0aGUgY29kZS4gQnV0IA0K
Z2VuZXJhbGx5IHdlIHJlYWxseSBzYW5pdGl6ZSB0aGUgbG9naWMgd2hpbGUgd2UncmUgYXQg
aXQgbm93IGluc3RlYWQgb2YgDQphZGRpbmcgYmFuZCBhaWRzIGV2ZXJ5d2hlcmUuDQoNClRo
YW5rcyENCi1zbG93DQoNCi0tIA0KUmFscGggQm9laG1lLCBTYW1iYSBUZWFtICAgICAgICAg
ICAgICAgICBodHRwczovL3NhbWJhLm9yZy8NClNlck5ldCBTYW1iYSBUZWFtIExlYWQgICAg
ICBodHRwczovL3Nlcm5ldC5kZS9lbi90ZWFtLXNhbWJhDQo=

--------------QZw4fyJPfz7R1jnliOr86bwU--

--------------siGJo1TZDDiAOhoLq1l110Xu
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFUqHsFAwAAAAAACgkQqh6bcSY5nkay
rBAAwMJkllKlW9IlMeX+gTlPdWsT/LXffMFuSO+D9J3X+2zrDjgvAQCaRZlxHxuD5tL1mTw7+31p
mGf+ljLXYKqEGbRTK+qhv91Uizn+UUz3Pn7eIZ8maSAZ0hut4R3CPE+cEccSGzgKlzlrT/+QnqcN
LDB38xr9MzkOZmFjV/zznqngfg2EneaD9nMrF3xFdFkkDQSrepvAkZBa+5Hq8CtuawKRLdoULo3e
TzcLKItmK9A6s7A2V5eY/XUHCtS2iCf9mN889TWjfHV7Ox5Yw2GaSnog0jzWALdjzrj+HzGdj0ei
F10L7irKlhEw9qi5i4s/ppVlXy6Q5WeCV6TmTyXJtE4U0W8dIUzMzKHM54iUjOHRf1yEYLgv/poY
aDDrNX7ruYzKh5BUMUN+sKVbhefH4BgHquDQDvFkb4T7KDDjfPt5Osm2MoVVcHpnmRpHFIdNTaI6
dzYfoZwSjfsmnEcrUjV2iPoJ6EvyQMEn9Oyv0+aSz9zd9PEllmaBcseJ3bAAeL1nYge6r24XE1Ou
M2mRkhgxbZf6xiLLvQavxB6vuRjWKi8sFz02HfE2XeHt3hGi2Rpojt+muIVTQsAZUD3mkeI/TCxu
0MMNOKCmyNP8FTG50pkTbLuCjl37VHRkOxwVLDkTze1glqN8I2okzOjl0kRsEKITQUM3ZqVr2GBo
OMo=
=BTIE
-----END PGP SIGNATURE-----

--------------siGJo1TZDDiAOhoLq1l110Xu--
