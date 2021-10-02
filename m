Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73692C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 11:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53B6461AED
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 11:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhJBL4g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 07:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhJBL4f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 07:56:35 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF28DC061570
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 04:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=GgXatO0zKH8dUxHucDwPBdpoQ+Z/hPcIiZdrzlJSEJU=; b=JeP0tv+7+LAEqoi6nIQUiLWyLr
        cIoPv9F/57bJrhOW3mlVwtLznk5cDp4jxkWdAB7WJZN0HLOrhlz5DIL5wO8sk+3rRcOBKiV92+KWm
        0Bu/F/HH76IPMdUtIak/QHYJiBIlioamAc6ZvB2TfntGbwPVS5HWodaj91Vw6qshGjuUa/Q3nCdVS
        dlqf2CXloXEes6pXTJH/QSmC0DPt+X7ya12i1/kVy655zBTi938cavVUhcyvJ7e1sPeJq09VasrZ9
        SkJZuiDfsZZBvdl8qL7Hs4SH/PbzZD7myD18Inr/H6HvBDRxZ+0zObqdK4fz7/N+ZNj//fT6+TMv1
        PtZSgEF+e3DEZU1xMXLBCSWaj6saZjl0ZwJ2VyAXnbjmrKHl3T4B6mNfh3ifm9ldS6/sXb1/g1uCX
        zAAyp1cb+PpxIAXzpWx+AzQzCEB14qilMFyszApABrnZCDGTTfIrnGSja1tmerAEVgOIzmz76IsmE
        ltBVSxn0P1GWnx897s0gdiyH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWdbK-001DHi-Ua; Sat, 02 Oct 2021 11:54:47 +0000
Message-ID: <3d8ac96d-f996-3e22-8a73-7d5083953d8b@samba.org>
Date:   Sat, 2 Oct 2021 13:54:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 16/20] ksmbd: check PDU len is at least header plus
 body size in ksmbd_smb2_check_message()
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-17-slow@samba.org>
 <CAKYAXd8UH+LBDFSNCOHJOEFco=9CTzFmTzP9D+u_h1USm1bj1Q@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd8UH+LBDFSNCOHJOEFco=9CTzFmTzP9D+u_h1USm1bj1Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0y1Oz2huduH2AVPlvbRchum0"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0y1Oz2huduH2AVPlvbRchum0
Content-Type: multipart/mixed; boundary="------------UGHPC7x0lS6jslcm72czMS9X";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>
Message-ID: <3d8ac96d-f996-3e22-8a73-7d5083953d8b@samba.org>
Subject: Re: [PATCH v5 16/20] ksmbd: check PDU len is at least header plus
 body size in ksmbd_smb2_check_message()
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-17-slow@samba.org>
 <CAKYAXd8UH+LBDFSNCOHJOEFco=9CTzFmTzP9D+u_h1USm1bj1Q@mail.gmail.com>
In-Reply-To: <CAKYAXd8UH+LBDFSNCOHJOEFco=9CTzFmTzP9D+u_h1USm1bj1Q@mail.gmail.com>

--------------UGHPC7x0lS6jslcm72czMS9X
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDIuMTAuMjEgdW0gMDc6NTUgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0xMC0w
MSAyMTowNCBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
Tm90ZTogd2UgYWxyZWFkeSBoYXZlIHRoZSBzYW1lIGNoZWNrIGluIGlzX2NoYWluZWRfc21i
Ml9tZXNzYWdlKCksIGJ1dCB0aGVyZQ0KPj4gaXQNCj4+IG9ubHkgYXBwbGllcyB0byBjb21w
b3VuZCByZXF1ZXN0cywgc28gd2UgaGF2ZSB0byByZXBlYXQgdGhlIGNoZWNrIGhlcmUgdG8N
Cj4+IGNvdmVyDQo+PiBib3RoIGNhc2VzLg0KPj4NCj4+IENjOiBOYW1qYWUgSmVvbiA8bGlu
a2luamVvbkBrZXJuZWwub3JnPg0KPj4gQ2M6IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29t
Pg0KPj4gQ2M6IFJvbm5pZSBTYWhsYmVyZyA8cm9ubmllc2FobGJlcmdAZ21haWwuY29tPg0K
Pj4gQ2M6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29tPg0KPj4gQ2M6IEh5dW5j
aHVsIExlZSA8aHljLmxlZUBnbWFpbC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBSYWxwaCBC
b2VobWUgPHNsb3dAc2FtYmEub3JnPg0KPj4gLS0tDQo+PiAgIGZzL2tzbWJkL3NtYjJtaXNj
LmMgfCAzICsrKw0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+Pg0K
Pj4gZGlmZiAtLWdpdCBhL2ZzL2tzbWJkL3NtYjJtaXNjLmMgYi9mcy9rc21iZC9zbWIybWlz
Yy5jDQo+PiBpbmRleCA3ZWQyNjZlYjZjNWUuLjU0MWIzOWI3YTg0YiAxMDA2NDQNCj4+IC0t
LSBhL2ZzL2tzbWJkL3NtYjJtaXNjLmMNCj4+ICsrKyBiL2ZzL2tzbWJkL3NtYjJtaXNjLmMN
Cj4+IEBAIC0zMzgsNiArMzM4LDkgQEAgaW50IGtzbWJkX3NtYjJfY2hlY2tfbWVzc2FnZShz
dHJ1Y3Qga3NtYmRfd29yayAqd29yaykNCj4+ICAgCWlmIChjaGVja19zbWIyX2hkcihoZHIp
KQ0KPj4gICAJCXJldHVybiAxOw0KPj4NCj4+ICsJaWYgKGxlbiA8IHNpemVvZihzdHJ1Y3Qg
c21iMl9wZHUpIC0gNCkNCj4+ICsJCXJldHVybiAxOw0KPiB3aGVuIG9ubHkgdGhpcyBwYXRj
aCBpcyBhcHBsaWVkLCBob3cgY2FuIHlvdSBndWFyYW50ZWUgdGhhdCBzZXNzaW9uIGlkDQo+
IGFuZCB0cmVlIGlkIG9mIHNtYjIgaGVhZGVyIGFyZSB2YWlsZCA/DQoNCndoYXQgZG8geW91
IG1lYW4/IFRoaXMganVzdCBjaGVja3MgdGhlIGFjdHVhbCBwYWNrZXQgbGVuZ2h0IGlzIGxh
cmdlIA0KZW5vdWdoIHRvIGFjY2VzcyB0aGUgaGVhZGVyIGFuZCB0aGUgYm9keSBsZW5naHQg
ZmllbGQuDQoNCi1zbG93DQoNCi0tIA0KUmFscGggQm9laG1lLCBTYW1iYSBUZWFtICAgICAg
ICAgICAgICAgICBodHRwczovL3NhbWJhLm9yZy8NClNlck5ldCBTYW1iYSBUZWFtIExlYWQg
ICAgICBodHRwczovL3Nlcm5ldC5kZS9lbi90ZWFtLXNhbWJhDQo=

--------------UGHPC7x0lS6jslcm72czMS9X--

--------------0y1Oz2huduH2AVPlvbRchum0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFYSIYFAwAAAAAACgkQqh6bcSY5nkbH
dg/8CgmHFJfpm9wE6tA4xHz1NQyHZgefg3SKqRMiQWvnjtOwXyCDEOliGX3T86nzaXwmuVp2HhrU
HlfzftzwFhuoactZcyDB36SANzk6c0iCq0UzBZ0H8G9XfLSCO6YXQF/0DxMgJWlX/Y/qfqJD+cpz
LnU9+sNYUiKm9kZU4eV06bhxCrgisgN1Ui5I+6VkH7L0HQklMzpBDnRrAzaxC7NC4omRwgELmcep
744ilcAc4uYqDlB++/42nsnsIwDoJob1q4Vvp6Fky2u7YPllDafF8BtGX2CUb4NWhIzXkR4thPzz
NL9GG65DUW0ApeQXj9kAnVH/vcQ6W+3bpHTImSOnyG+NqrHNuGqmMCtYs+hqreaaKUvkA3kuhOhc
aOZ7BBCc6rIjZi5/k9WC3umNjPY7CMuNjDBrDacOaClFjngW1Qyva9Y6hRoOq+az1AVHpJhXPRlb
uB4xQdV0GN5grphSrcnnUnaNlApF48e13vOTHdTYlSWRpiSgeOekD0NJlJj3yJ9GL1iYLDhXsTyr
az8sQU+cv9irI2zPhf9VFD7lN1JL8BMJVvGNzQWONQUymXXKzIIi1e15x0mO6VR3b05D+gtrR7jd
GVmD0HtCYSyXYaNqdvgyH7rKGgn43oGPAGmU3Kjw/v9bM5yvlwZBydsjCR9V1axmg1qD0TK6CP37
n9M=
=kbJh
-----END PGP SIGNATURE-----

--------------0y1Oz2huduH2AVPlvbRchum0--
