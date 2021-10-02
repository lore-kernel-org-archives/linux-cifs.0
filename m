Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D4EC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 12:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FD7F61A8F
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 12:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhJBMvj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 08:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbhJBMvj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 08:51:39 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9089BC0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 05:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=bdW5TUCh3unzyJIAlDP2so0WaIdnnVdmwqMitl6yL7E=; b=L3nEgA0szWgXS3zE73nP5DVHkL
        7Uk2EGAIETKRk/Us3mt018AK5uHT5fEUo4N66gmpU5/qGObhzqLVlcy2mHs0bvl7KlmMT9qy7Rgbx
        JVV8atpvZBkIj4Tr6wxLe7xCNg7NuUbAtXvkJBiHw6ha5kX48V4afINIp/k+MKtcC+37s92qS7m58
        y5DyQxCikOn4u51AB1rkEvuZO9Ig7IyFPlDJJ7YJYTTxO6K9WqQ74WBSkwYpfmqbOF0M/K6qRqpmF
        LZcDMRiVdqDSsCTwTFfcRuVlq+emFPgwx3flHlI9ZV5rCcp61yZ1PF7UCvUTV16f+/YWoyZ4UZuhp
        fd/B5lb3fJDog4SrIJ9zJTdiDEcDzMO+Rn3ME43IC23W6TeE3dKlz5Y2Xk5AQecPt+ivR565lRTvK
        lCGvsA56dshXyEz+3LnfDEaUg4bZRYAXMxFRZ1PEq5F68JoheyiPLGCloqMU1FBKsq8rekOmjTNiV
        Kx3+qgoBT+MqdID+YgGaxf5p;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeSc-001DVe-Vn; Sat, 02 Oct 2021 12:49:51 +0000
Message-ID: <965d1971-239c-0cfc-9abb-5b20c9b698e9@samba.org>
Date:   Sat, 2 Oct 2021 14:49:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 16/20] ksmbd: check PDU len is at least header plus
 body size in ksmbd_smb2_check_message()
Content-Language: en-US
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-17-slow@samba.org>
 <CANFS6bauPdTuE-QRuUwLDJD59C62M9dd6Kxoq-emUOib=xiysg@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CANFS6bauPdTuE-QRuUwLDJD59C62M9dd6Kxoq-emUOib=xiysg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------w4vHQPDwmmyLODtpx9Nd8KTJ"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------w4vHQPDwmmyLODtpx9Nd8KTJ
Content-Type: multipart/mixed; boundary="------------VDFFMtJ7B0xzvj0GXu0O0QlH";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Hyunchul Lee <hyc.lee@gmail.com>
Cc: linux-cifs <linux-cifs@vger.kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French <smfrench@gmail.com>
Message-ID: <965d1971-239c-0cfc-9abb-5b20c9b698e9@samba.org>
Subject: Re: [PATCH v5 16/20] ksmbd: check PDU len is at least header plus
 body size in ksmbd_smb2_check_message()
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-17-slow@samba.org>
 <CANFS6bauPdTuE-QRuUwLDJD59C62M9dd6Kxoq-emUOib=xiysg@mail.gmail.com>
In-Reply-To: <CANFS6bauPdTuE-QRuUwLDJD59C62M9dd6Kxoq-emUOib=xiysg@mail.gmail.com>

--------------VDFFMtJ7B0xzvj0GXu0O0QlH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDIuMTAuMjEgdW0gMTQ6NDUgc2NocmllYiBIeXVuY2h1bCBMZWU6DQo+IEhpIFJhbHBo
LA0KPiANCj4gMjAyMeuFhCAxMOyblCAx7J28ICjquIgpIOyYpO2bhCA5OjI1LCBSYWxwaCBC
b2VobWUgPHNsb3dAc2FtYmEub3JnPuuLmOydtCDsnpHshLE6DQo+Pg0KPj4gTm90ZTogd2Ug
YWxyZWFkeSBoYXZlIHRoZSBzYW1lIGNoZWNrIGluIGlzX2NoYWluZWRfc21iMl9tZXNzYWdl
KCksIGJ1dCB0aGVyZSBpdA0KPj4gb25seSBhcHBsaWVzIHRvIGNvbXBvdW5kIHJlcXVlc3Rz
LCBzbyB3ZSBoYXZlIHRvIHJlcGVhdCB0aGUgY2hlY2sgaGVyZSB0byBjb3Zlcg0KPj4gYm90
aCBjYXNlcy4NCj4+DQo+PiBDYzogTmFtamFlIEplb24gPGxpbmtpbmplb25Aa2VybmVsLm9y
Zz4NCj4+IENjOiBUb20gVGFscGV5IDx0b21AdGFscGV5LmNvbT4NCj4+IENjOiBSb25uaWUg
U2FobGJlcmcgPHJvbm5pZXNhaGxiZXJnQGdtYWlsLmNvbT4NCj4+IENjOiBTdGV2ZSBGcmVu
Y2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4NCj4+IENjOiBIeXVuY2h1bCBMZWUgPGh5Yy5sZWVA
Z21haWwuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogUmFscGggQm9laG1lIDxzbG93QHNhbWJh
Lm9yZz4NCj4+IC0tLQ0KPj4gICBmcy9rc21iZC9zbWIybWlzYy5jIHwgMyArKysNCj4+ICAg
MSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9m
cy9rc21iZC9zbWIybWlzYy5jIGIvZnMva3NtYmQvc21iMm1pc2MuYw0KPj4gaW5kZXggN2Vk
MjY2ZWI2YzVlLi41NDFiMzliN2E4NGIgMTAwNjQ0DQo+PiAtLS0gYS9mcy9rc21iZC9zbWIy
bWlzYy5jDQo+PiArKysgYi9mcy9rc21iZC9zbWIybWlzYy5jDQo+PiBAQCAtMzM4LDYgKzMz
OCw5IEBAIGludCBrc21iZF9zbWIyX2NoZWNrX21lc3NhZ2Uoc3RydWN0IGtzbWJkX3dvcmsg
KndvcmspDQo+PiAgICAgICAgICBpZiAoY2hlY2tfc21iMl9oZHIoaGRyKSkNCj4+ICAgICAg
ICAgICAgICAgICAgcmV0dXJuIDE7DQo+Pg0KPj4gKyAgICAgICBpZiAobGVuIDwgc2l6ZW9m
KHN0cnVjdCBzbWIyX3BkdSkgLSA0KQ0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiAxOw0K
Pj4gKw0KPiANCj4gRG8gd2UgbmVlZCB0aGlzIGNoZWNrIGJlZm9yZSBhY2Nlc3NpbmcgYW55
IGZpZWxkcyBvZiBzbWIyX2hkciBpbg0KPiBrc21iZF92ZXJpZnlfc21iX21lc3NhZ2UoKT8N
Cg0Kd2VsbCwgbXkgaWRlYSB3YXMgdG8gaGF2ZSB0aGUgY29yZSBQRFUgc2l6ZSBjaGVja2lu
ZyBsb2dpYyBpbiANCmtzbWJkX3NtYjJfY2hlY2tfbWVzc2FnZSgpIGFuZCBrc21iZF92ZXJp
Znlfc21iX21lc3NhZ2UoKSBtZXJlbHkgDQpzd2l0Y2hlcyBiZXR3ZWVuIFNNQjEvU01CMi4N
Cg0KLXNsb3cNCg0KLS0gDQpSYWxwaCBCb2VobWUsIFNhbWJhIFRlYW0gICAgICAgICAgICAg
ICAgIGh0dHBzOi8vc2FtYmEub3JnLw0KU2VyTmV0IFNhbWJhIFRlYW0gTGVhZCAgICAgIGh0
dHBzOi8vc2VybmV0LmRlL2VuL3RlYW0tc2FtYmENCg==

--------------VDFFMtJ7B0xzvj0GXu0O0QlH--

--------------w4vHQPDwmmyLODtpx9Nd8KTJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFYVW4FAwAAAAAACgkQqh6bcSY5nkY2
6A//dUCrwMfD3MffFJHBd6p1zUD/cjTQV1PZaAhANvpaX6w0B6jPxNtEMuboomZ0REUaQe+LvOuM
LAOUgd4dKldrpVNWvq4qmhVHxadaEknDkiQukS9PTVTnJxnhXg/VzSMmMaxllHZSDcKETzDjGOSA
yQzFXvaQ6flAYJLd+6DQAG0tuy5s2gjB0wbl0CPp3mLAGPT7Os59QJ8lig4htlmOWdohZfY7LOa1
txx1ASWafff5pBRb12qtaowDrHR22k9kEJPcPc5alJ9NGBrsXv/nGCqosnoqj+X45vLzlCEEdJXP
gYn59HEIR+Y3LYyWeClhYzE7GkU5yLue77Jro5Gug3IR5SPSlx8pQ+4+hsBv9mMFXvcJjey1oXbz
dvflMPKFmMFocsMlP1/B/dqdIBpxbqIkt4+q/2FeZvQ0HVVwSZeYtWkOYzgjFdgMgmYDxVMl1Yc2
LEYVSYXfEmqSbqJKOZ/LK3MaMXSyOc046rlBdsZ7xrY/tsptXsRIk2NQIBJDfRvcIrWlsGgWoKc/
+Z5amAClivBZUJGkbsMOrCargSbQDqR7ROMBf2D678jploC+k7o0LdLWAVIlQX+AjGANCfaqnlyt
NvIsseSH2Zx+qx8kVxr1zc9cEQZ3QLyJAk9X9lr3tmrr8lIOduE2OeFZepFUWPSJE3HvPREOy/kw
M74=
=K894
-----END PGP SIGNATURE-----

--------------w4vHQPDwmmyLODtpx9Nd8KTJ--
