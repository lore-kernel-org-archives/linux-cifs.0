Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35C5C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 12:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD68761AEE
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 12:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhJBMHC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 08:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbhJBMHC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 08:07:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6457CC061570
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 05:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=mReUEpmWVP5WcKjt8c0IlcG71ikZwRErutnu2kpdogY=; b=Q+hkrV6O1t0YdjJa5OBzb+a7vC
        rVUKWYGEQTfK/566v+4jS6vQx28E9WIJTD7ocapMpiP1YpgZ1QyWIbSme3NVj6QUaBE0lKEgx3C0u
        oIfLEzcR1Ib1CPW7uZBqST4cWGUiX04FbezkbRekEvr4JddTaamPjx/O/qZmlUhAer7IXtyF3+ZAu
        u1mvBynvFXhV+ski+aZXaopJ50f4Dv6mTsJbYpIgSKUwX2pk9vg+9fySNbvHSyrJ+cRnNN01FmAvX
        hRUCCtKYB/PSOtb6V5LtDm7EDAoU7XKcoxEKQ6WXtgI7muXE+NwrAzt3WJyPateO4B/ktBcr0HLXH
        2ElDWoUR4NEd5GvWJQFqZxao1P3sXdOXExW/zT8EfUiCO3Cfk5S6OAulo+w3wu3I3JNugM7PuIIKJ
        MVccdGSnmJNujsO2p5XVvkoUQdIlr3jba98YtxoEO2Cx4axUEzc6qTSHNEUFcO0MKGQDAiRh+Nh1R
        9pmzGd9OSOvNrcHTEjCCohy3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWdlR-001DKp-AY; Sat, 02 Oct 2021 12:05:13 +0000
Message-ID: <0853efa1-ef9f-7339-00e3-2f98ec383398@samba.org>
Date:   Sat, 2 Oct 2021 14:05:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 13/20] ksmbd: remove ksmbd_verify_smb_message()
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-14-slow@samba.org>
 <CAKYAXd-PsL4adDyK3wLRQGp51wvuH6QX0r6xW5rywyUT_+a+3g@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd-PsL4adDyK3wLRQGp51wvuH6QX0r6xW5rywyUT_+a+3g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lnDpabQzOKrTV85A5IC6qj16"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lnDpabQzOKrTV85A5IC6qj16
Content-Type: multipart/mixed; boundary="------------en04nv0vSQP7foC5Ges5qqS3";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>
Message-ID: <0853efa1-ef9f-7339-00e3-2f98ec383398@samba.org>
Subject: Re: [PATCH v5 13/20] ksmbd: remove ksmbd_verify_smb_message()
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-14-slow@samba.org>
 <CAKYAXd-PsL4adDyK3wLRQGp51wvuH6QX0r6xW5rywyUT_+a+3g@mail.gmail.com>
In-Reply-To: <CAKYAXd-PsL4adDyK3wLRQGp51wvuH6QX0r6xW5rywyUT_+a+3g@mail.gmail.com>

--------------en04nv0vSQP7foC5Ges5qqS3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDIuMTAuMjEgdW0gMDc6NDYgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0xMC0w
MSAyMTowNCBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
QW5vdGhlciBsZWZ0b3ZlciBmcm9tIFNNQjEgc3VwcG9ydC4gUmVtb3ZlIGl0IGFuZCB1c2UN
Cj4+IGtzbWJkX3ZlcmlmeV9zbWJfbWVzc2FnZSgpDQo+PiBkaXJlY3RseSBpbiBfX3Byb2Nl
c3NfcmVxdWVzdCgpLg0KPj4NCj4+IENjOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJu
ZWwub3JnPg0KPj4gQ2M6IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29tPg0KPj4gQ2M6IFJv
bm5pZSBTYWhsYmVyZyA8cm9ubmllc2FobGJlcmdAZ21haWwuY29tPg0KPj4gQ2M6IFN0ZXZl
IEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29tPg0KPj4gQ2M6IEh5dW5jaHVsIExlZSA8aHlj
LmxlZUBnbWFpbC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBSYWxwaCBCb2VobWUgPHNsb3dA
c2FtYmEub3JnPg0KPj4gLS0tDQo+PiAgIGZzL2tzbWJkL3NlcnZlci5jICAgICB8ICAyICst
DQo+PiAgIGZzL2tzbWJkL3NtYl9jb21tb24uYyB8IDI0IC0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPj4gICBmcy9rc21iZC9zbWJfY29tbW9uLmggfCAgMSAtDQo+PiAgIDMgZmlsZXMg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDI2IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYg
LS1naXQgYS9mcy9rc21iZC9zZXJ2ZXIuYyBiL2ZzL2tzbWJkL3NlcnZlci5jDQo+PiBpbmRl
eCAyYTJiMjEzNWJmZGUuLjMyOGM0MjI1Y2VjMSAxMDA2NDQNCj4+IC0tLSBhL2ZzL2tzbWJk
L3NlcnZlci5jDQo+PiArKysgYi9mcy9rc21iZC9zZXJ2ZXIuYw0KPj4gQEAgLTExNCw3ICsx
MTQsNyBAQCBzdGF0aWMgaW50IF9fcHJvY2Vzc19yZXF1ZXN0KHN0cnVjdCBrc21iZF93b3Jr
ICp3b3JrLA0KPj4gc3RydWN0IGtzbWJkX2Nvbm4gKmNvbm4sDQo+PiAgIAlpZiAoY2hlY2tf
Y29ubl9zdGF0ZSh3b3JrKSkNCj4+ICAgCQlyZXR1cm4gU0VSVkVSX0hBTkRMRVJfQ09OVElO
VUU7DQo+Pg0KPj4gLQlpZiAoa3NtYmRfdmVyaWZ5X3NtYl9tZXNzYWdlKHdvcmspKQ0KPj4g
KwlpZiAoa3NtYmRfc21iMl9jaGVja19tZXNzYWdlKHdvcmspKQ0KPj4gICAJCXJldHVybiBT
RVJWRVJfSEFORExFUl9BQk9SVDsNCj4+DQo+PiAgIAljb21tYW5kID0gY29ubi0+b3BzLT5n
ZXRfY21kX3ZhbCh3b3JrKTsNCj4+IGRpZmYgLS1naXQgYS9mcy9rc21iZC9zbWJfY29tbW9u
LmMgYi9mcy9rc21iZC9zbWJfY29tbW9uLmMNCj4+IGluZGV4IGUxZTVhMDcxNjc4ZS4uNGEy
ODNjZDZkNmUxIDEwMDY0NA0KPj4gLS0tIGEvZnMva3NtYmQvc21iX2NvbW1vbi5jDQo+PiAr
KysgYi9mcy9rc21iZC9zbWJfY29tbW9uLmMNCj4+IEBAIC0xMjIsMzAgKzEyMiw2IEBAIGlu
dCBrc21iZF9sb29rdXBfcHJvdG9jb2xfaWR4KGNoYXIgKnN0cikNCj4+ICAgCXJldHVybiAt
MTsNCj4+ICAgfQ0KPj4NCj4+IC0vKioNCj4+IC0gKiBrc21iZF92ZXJpZnlfc21iX21lc3Nh
Z2UoKSAtIGNoZWNrIGZvciB2YWxpZCBzbWIyIHJlcXVlc3QgaGVhZGVyDQo+PiAtICogQHdv
cms6CXNtYiB3b3JrDQo+PiAtICoNCj4+IC0gKiBjaGVjayBmb3IgdmFsaWQgc21iIHNpZ25h
dHVyZSBhbmQgcGFja2V0IGRpcmVjdGlvbihyZXF1ZXN0L3Jlc3BvbnNlKQ0KPj4gLSAqDQo+
PiAtICogUmV0dXJuOiAgICAgIDAgb24gc3VjY2Vzcywgb3RoZXJ3aXNlIC1FSU5WQUwNCj4+
IC0gKi8NCj4+IC1pbnQga3NtYmRfdmVyaWZ5X3NtYl9tZXNzYWdlKHN0cnVjdCBrc21iZF93
b3JrICp3b3JrKQ0KPj4gLXsNCj4+IC0Jc3RydWN0IHNtYjJfaGRyICpzbWIyX2hkciA9IGtz
bWJkX3JlcV9idWZfbmV4dCh3b3JrKTsNCj4+IC0Jc3RydWN0IHNtYl9oZHIgKmhkcjsNCj4+
IC0NCj4+IC0JaWYgKHNtYjJfaGRyLT5Qcm90b2NvbElkID09IFNNQjJfUFJPVE9fTlVNQkVS
KQ0KPj4gLQkJcmV0dXJuIGtzbWJkX3NtYjJfY2hlY2tfbWVzc2FnZSh3b3JrKTsNCj4+IC0N
Cj4+IC0JaGRyID0gd29yay0+cmVxdWVzdF9idWY7DQo+PiAtCWlmICgqKF9fbGUzMiAqKWhk
ci0+UHJvdG9jb2wgPT0gU01CMV9QUk9UT19OVU1CRVIgJiYNCj4+IC0JICAgIGhkci0+Q29t
bWFuZCA9PSBTTUJfQ09NX05FR09USUFURSkNCj4+IC0JCXJldHVybiAwOw0KPiBzbWIxIG5l
Z290aWF0ZSBpcyBuZWVkZWQgZm9yIHdpbmRvd3MgY29ubmVjdGlvbi4gSGF2ZSB5b3UgdGVz
dGVkIHdpdGgNCj4gd2luZG93cyBjbGllbnQgPw0KDQpkJ29oISBZb3UncmUgcmlnaHQuIEd1
ZXNzIEkgZ290IGluIGEgZnJlbnp5IHRvIHJlbW92ZSBtb3JlIFNNQjEgc3R1ZmYuIDopDQoN
Ci1zbG93DQoNCi0tIA0KUmFscGggQm9laG1lLCBTYW1iYSBUZWFtICAgICAgICAgICAgICAg
ICBodHRwczovL3NhbWJhLm9yZy8NClNlck5ldCBTYW1iYSBUZWFtIExlYWQgICAgICBodHRw
czovL3Nlcm5ldC5kZS9lbi90ZWFtLXNhbWJhDQo=

--------------en04nv0vSQP7foC5Ges5qqS3--

--------------lnDpabQzOKrTV85A5IC6qj16
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFYSvgFAwAAAAAACgkQqh6bcSY5nkb2
/Q/+MrAVD8004fKV/ZgpC+br+62gG8z6aqJkqTHgbHq705UN/ewsGOi9Fx1UYpcQk/lWiF4WLNPt
QqCLVDIKVzy+PseNrkFW8z8Fzs4KtEWJ+cK/DvV0VEjfEQUxJkdmXeGKdTVpMU5RJg8zfmshCFAj
NlpKtinZB/8UwW6HPx6i1h2Q64+so0RGLMDuUTlTyBZnpq1Ic8vPhOi5qMnq6iH69Xa8LA21hvod
8UWTGKdLOYe0k7NWj5tiA51Uawlfb2SZIkwiKeZXxwn5b9yDJVUDFyW0pBloG1C1KklJJ2WIfJTp
6WzlY1cYxn1WjXQ4F4eynvzVYXjA5FCWuhbVsHvaug0u+FxnZSzjU/PbslnALOpXcgVLAKFHl0NV
KpD4q8BNikwVs05y5w2xlsaWiLqHE0605CF1v08JIHLZt2vpcHBqzYZ8pS+rmkgE2ipwepgt039d
XRJaxYqdUH5rfuoCBgACWPjtSEJCo7BEL0STbJxJ+PZvvqmv7G+Urog5XZSklSVKCqTXE9v4PcxY
B6hB4rnnf+9axb48S1w/E37Ji+SlJJzx3wwCdJeE5xStolen0qf9wN/fai7r/IdTmaWTidnYAfaw
Plqw2WQwNKbyRQBKlez89G4FVZ6T0fPDaCv83pCZ+THYpsdIQ2r5BJzIbE96v6/t8kuiIVYX3sR2
8hk=
=haW6
-----END PGP SIGNATURE-----

--------------lnDpabQzOKrTV85A5IC6qj16--
