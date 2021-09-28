Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD767C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 16:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD5FA61058
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 16:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbhI1Qfa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 12:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbhI1Qfa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Sep 2021 12:35:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D251C06161C
        for <linux-cifs@vger.kernel.org>; Tue, 28 Sep 2021 09:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=2bxhAGumW7OLFjS2UAXyPFklnPIqzVs0bSE7ae5JInw=; b=gUlPVGT0hhsJGIrLwSP+BqXfLd
        2mfJsupNfhyA9/8FfdoyQ9scCXiqvX1KFYnY5WDtVWsTwsl4Ad1irSuHrNxYOnGk058G3n0SN4bZQ
        PD5n8+LM6el2WRETBWL8WYe9ag2YXQz1V/lCwZLkvgY0NaSWk+mWO00pVGca2oqnhBO20aiBq0MMY
        K9hN2KBzOPop/eTb1PU7T3T0kr1owLsC0c/K10DoK9qclJqo3Bavq8GZ7s+S2BL6/lFmoLADV+59N
        xyxeoOzouqyZh/4tObWyKPguJx2cz1dEOnBbl42x2ODzX/uoehIvHCQXt751xb+IrIKufEkJiu7vd
        ElOKrJ9dSSI9B8G2k8FDEO7lPr+8xhm+QLoE83Vy0GklYcg4HPFJbaMTqezNGuwTylTiaO67FDy7Q
        AMxzSjcooKAwJWbtHlqgI8bzZ2ZPC38O3w+iXzoqksnSCeuolxPpHJbLqv8/XZYMYeNWrhfutMl3z
        1GAlTrTFz4eG9EyDutysQODH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVG39-000WIh-AG; Tue, 28 Sep 2021 16:33:47 +0000
Message-ID: <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org>
Date:   Tue, 28 Sep 2021 18:33:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
 <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
 <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------25ZIEEWeNIX2NIGqDYW4fgIA"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------25ZIEEWeNIX2NIGqDYW4fgIA
Content-Type: multipart/mixed; boundary="------------9MDhPkTo5XinNqTRYBrDMuAJ";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
 <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
 <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
In-Reply-To: <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>

--------------9MDhPkTo5XinNqTRYBrDMuAJ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMjguMDkuMjEgdW0gMTY6MjMgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0wOS0y
OCAyMjo0MyBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
QW0gMjguMDkuMjEgdW0gMDU6MjYgc2NocmllYiBSYWxwaCBCb2VobWU6DQo+Pj4gYm90aDog
dGhlcmUgYXJlIGlzc3VlcyB3aXRoIHRoZSBwYXRjaCBhbmQgSSBoYXZlIGNoYW5nZXMgb24t
dG9wLiA6KSBJdA0KPj4+IGp1c3QgdGFrZXMgYSBiaXQgb2YgdGltZSBkdWUgdG8gb3RoZXIg
c3R1ZmYgZ29pbmcgb24gY3VycmVudGx5IGxpa2UgU0RDLg0KPj4NCj4+IGZpbmFsbHkuLi4g
OikNCj4+DQo+PiBQbGVhc2UgY2hlY2sgbXkgYnJhbmNoDQo+PiA8aHR0cHM6Ly9naXRodWIu
Y29tL3Nsb3dmcmFua2xpbi9zbWIzLWtlcm5lbC9jb21taXRzL2tzbWJkLWZvci1uZXh0LXBl
bmRpbmc+DQo+Pg0KPj4gZm9yIGFkZGVkIGNvbW1pdHMgYW5kIHR3byBTUVVBU0hlcy4gUmVt
YWluaW5nIGNvbW1pdHMgcmV2aWV3ZWQtYnk6IG1lLg0KPiBZZXAsIGxvb2tzIGdvb2QsIEkg
d2lsbCB1cGRhdGUgdGhlbSBpbiBwYXRjaGVzLiBBbmQgdGhhbmtzIGZvciB5b3VyIHJldmll
dyENCg0KdGhhbmtzIQ0KDQo+PiBPaCwgYW5kIEkgYWxzbyBzcGxpdCBvdXQgdGhlIHNldGlu
Zm8gYmFzaWMgaW5mb2xldmVsIGNoYW5nZXMgaW50byBpdHMNCj4+IG93biBjb21taXQuDQo+
IElmIHlvdSB3YW50IHRvIGFkZCBjbGVhbi11cCBwYXRjaCBmaXJzdCwgd2UgY2FuIGNoYW5n
ZQ0KPiBnZXRfZmlsZV9iYXNpY19pbmZvKCkgdG9nZXRoZXIgaW4gcGF0Y2guIEkgd2lsbCB1
cGRhdGUgaXQgYWxzby4NCj4+DQo+PiBMZXQgbWUga25vdyB3aGF0IHlvdSB0aGluayBvZiB0
aGUgYWRkaXRpb25hbCBjaGVja3MgSSd2ZSBhZGRlZC4NCj4gWW91IHNob3VsZCBzdWJtaXQg
cGF0Y2hlcyB0byB0aGUgbGlzdCB0byBiZSBjaGVja2VkIGJ5IG90aGVyIGRldmVsb3BlcnMu
DQoNCmV2ZXJ5b25lIGNhbiBmZXRjaCBmcm9tIHRoYXQgYnJhbmNoLiBBbmQgYXMgSSdtIG5v
dCBtZXJlbHkgZG9pbmcgcGF0Y2ggDQpyZXZpZXcsIGJ1dCBhbSBjaGFuZ2luZywgZXhwYW5k
aW5nLCBmaXhpbmcgcGF0Y2hlcywgYW4gZW1haWwgcGF0Y2ggDQp3b3JrZmxvdyBkb2Vzbid0
IHdvcmsuDQoNCk9uY2UgdGhlIHBhdGNoc2V0IGhhcyBzdGFiaWxpemVkIGVub3VnaCwgaXQg
Y2FuIGdvIHRvIHRoZSBsaXN0Lg0KDQpUaGFua3MhDQotc2xvdw0KDQotLSANClJhbHBoIEJv
ZWhtZSwgU2FtYmEgVGVhbSAgICAgICAgICAgICAgICAgaHR0cHM6Ly9zYW1iYS5vcmcvDQpT
ZXJOZXQgU2FtYmEgVGVhbSBMZWFkICAgICAgaHR0cHM6Ly9zZXJuZXQuZGUvZW4vdGVhbS1z
YW1iYQ0K

--------------9MDhPkTo5XinNqTRYBrDMuAJ--

--------------25ZIEEWeNIX2NIGqDYW4fgIA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFTQ+oFAwAAAAAACgkQqh6bcSY5nkYh
VxAAj7YbT/JCboosHX6tAHf1NREDWToM6TS4wkp4ofy7PoSltGobvhTq0I4C2kpMQ3C6JsLkZSQt
sjlDukv0tvKrQucvQJNap7diZtVUY6QBabx9ByhiSBOD4MKA5m87k0iN+UnmM0Hd6o2RDv3lqKJn
svM+iB4/1m/lhenDSx8eWwK9oZwsaATCnrLhb+EJE7d+3bLQwSInOxQ7tzeJrUcB6680Xt+j7SVt
y1mAo5qah94u554geFr5wYfDjaRCK77JDpD2TOKokqphL2UeawFucrjaJDWPemBZtehMqlLQvMC/
L1vrpvpOVbHdN8J9wee6KM1RKUY1T0M1kjP7S3plUBKgWtTKFp8lsvtuy0APlW91g14ADlZBYE1W
dBn6pOyCS8HWLjY0fofNDRlEGj4xjiCHNMFA/f92zVqL8cJLNFTH2lu/8HpodmD5M5/aVsK9YvMT
vTq2g1g2dKFEJhPBNB46Ci6H+VS9x9xxAHYl5pVvcwjd92qd3LR9W/VRxGoyS2tS3fmS+Gi02rMm
h89ZXIyo8vn6gVfoafjJFUwmy7MHDXP7LsPxewXxbX0450frnt7DzhDCChleudYx0R4GVslBU04q
EKrswoN0SZELD0SPaV8Jle0XLxPJlN8AC3FdELTTD2Zoi+8rMRzB3u1JiA9SyfVwqjpVBqaSRFbe
UUE=
=XRTI
-----END PGP SIGNATURE-----

--------------25ZIEEWeNIX2NIGqDYW4fgIA--
