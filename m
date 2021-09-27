Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5F5C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Sep 2021 15:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0AB760F94
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Sep 2021 15:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhI0Pn6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Sep 2021 11:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbhI0Pn4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Sep 2021 11:43:56 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6ACDC06176D
        for <linux-cifs@vger.kernel.org>; Mon, 27 Sep 2021 08:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=F5LGV3jqj82jyKigh4ypOSKJJQVmzisvcHOz3e43xbE=; b=fmJ4AnNlMU6YOpClDtoUCleF3g
        7yIhhIXb8EJ45ow6ZBrd3y/cpYPDthV/Rysg6nqQNGKZNpmY9HozKby4f4bwb02GSxS27O3ofUNSe
        6R1Webmkfv92UdonjaPezX3KeoVCx9rndy/0h59k5k0IVDWo/pfxz34pa+rzd7yJceBqgbWS/GGde
        5ch+mF7msnnOztlkpMBYxc6emh4hexGCcQEZo+5LdJrKMTIYw2WlIq4UXSInlSu9+9iXchziluPk6
        9FQZxZJfFeWuf/xs0ERP3u7b0DPGfFRlnlHK/Tqe8iOfEijKRPjsGBUKDWDLDgVhaGG9itM30F+ug
        +b/zld6W9P9fTIX5xlYxzGpiv/lRc1Jg1PPyiYgySf7X+Wkp6SBoAh+yColHuuk09g88ncY+EhfNH
        h9pveXJk3+C/xPXbFVBkUhrPWwBPL0cDRPoqdjDEDNT4xJLrJAr+nYliSEZRGyHfmPKYYQ5BtUoDU
        1NX2tTII4qGbXydjN+O4GqM1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mUslf-000K9c-G9; Mon, 27 Sep 2021 15:42:11 +0000
Message-ID: <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
Date:   Mon, 27 Sep 2021 17:42:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <20210926135543.119127-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BnGd6GnnXCpOkgIBBjlSeUIO"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BnGd6GnnXCpOkgIBBjlSeUIO
Content-Type: multipart/mixed; boundary="------------bHEQSgOl0cjbp9QMWLMImVX8";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
References: <20210926135543.119127-1-linkinjeon@kernel.org>
In-Reply-To: <20210926135543.119127-1-linkinjeon@kernel.org>

--------------bHEQSgOl0cjbp9QMWLMImVX8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgTmFtamFlDQoNCkFtIDI2LjA5LjIxIHVtIDE1OjU1IHNjaHJpZWIgTmFtamFlIEplb246
DQo+IENjOiBUb20gVGFscGV5IDx0b21AdGFscGV5LmNvbT4NCj4gQ2M6IFJvbm5pZSBTYWhs
YmVyZyA8cm9ubmllc2FobGJlcmdAZ21haWwuY29tPg0KPiBDYzogUmFscGggQsO2aG1lIDxz
bG93QHNhbWJhLm9yZz4NCj4gQ2M6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29t
Pg0KPiBDYzogSHl1bmNodWwgTGVlIDxoeWMubGVlQGdtYWlsLmNvbT4NCj4gQ2M6IFNlcmdl
eSBTZW5vemhhdHNreSA8c2Vub3poYXRza3lAY2hyb21pdW0ub3JnPg0KPiANCj4gdjI6DQo+
ICAgIC0gdXBkYXRlIGNvbW1lbnRzIG9mIHNtYjJfZ2V0X2RhdGFfYXJlYV9sZW4oKS4NCj4g
ICAgLSBmaXggd3JvbmcgYnVmZmVyIHNpemUgY2hlY2sgaW4gZnNjdGxfcXVlcnlfaWZhY2Vf
aW5mb19pb2N0bCgpLg0KPiAgICAtIGZpeCAzMmJpdCBvdmVyZmxvdyBpbiBzbWIyX3NldF9p
bmZvLg0KPiANCj4gdjM6DQo+ICAgIC0gYWRkIGJ1ZmZlciBjaGVjayBmb3IgQnl0ZUNvdW50
IG9mIHNtYiBuZWdvdGlhdGUgcmVxdWVzdC4NCj4gICAgLSBNb3ZlZCBidWZmZXIgY2hlY2sg
b2YgdG8gdGhlIHRvcCBvZiBsb29wIHRvIGF2b2lkIHVubmVlZGVkIGJlaGF2aW9yIHdoZW4N
Cj4gICAgICBvdXRfYnVmX2xlbiBpcyBzbWFsbGVyIHRoYW4gbmV0d29ya19pbnRlcmZhY2Vf
aW5mb19pb2N0bF9yc3AuDQo+ICAgIC0gZ2V0IGNvcnJlY3Qgb3V0X2J1Zl9sZW4gd2hpY2gg
ZG9lc24ndCBleGNlZWQgbWF4IHN0cmVhbSBwcm90b2NvbCBsZW5ndGguDQo+ICAgIC0gc3Vi
dHJhY3Qgc2luZ2xlIHNtYjJfbG9ja19lbGVtZW50IGZvciBjb3JyZWN0IGJ1ZmZlciBzaXpl
IGNoZWNrIGluDQo+ICAgICAga3NtYmRfc21iMl9jaGVja19tZXNzYWdlKCkuDQoNCkkgdGhp
bmsgdGhlcmUgYXJlIGEgZmV3IGlzc3VlcyB3aXRoIHRoaXMgcGF0Y2hzZXQuIEknbSB3b3Jr
aW5nIG9uIGZpeGVzIA0KYW5kIGltcHJvdmVtZW50cyBhbmQgd2lsbCBwdXNoIG15IGJyYW5j
aCB0byBteSBnaXRodWIgY2xvbmUgb25jZSBJJ20gDQpyZWFkeS4gSSBndWVzcyBpdCdzIGdv
aW5nIHRvIHRha2UgYSBmZXcgZGF5cy4NCg0KQ2hlZXJzIQ0KLXNsb3cNCg0KLS0gDQpSYWxw
aCBCb2VobWUsIFNhbWJhIFRlYW0gICAgICAgICAgICAgICAgIGh0dHBzOi8vc2FtYmEub3Jn
Lw0KU2VyTmV0IFNhbWJhIFRlYW0gTGVhZCAgICAgIGh0dHBzOi8vc2VybmV0LmRlL2VuL3Rl
YW0tc2FtYmENCg==

--------------bHEQSgOl0cjbp9QMWLMImVX8--

--------------BnGd6GnnXCpOkgIBBjlSeUIO
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFR5lIFAwAAAAAACgkQqh6bcSY5nka/
6hAAk+Xg83tW0gyAqJ/dvAL+zD7jDpfY9dZu6c0nkpVGwJaBbPCT5Hxwr199L3kUdjfiwEr4pRSL
NJvNFEAmTfWep+1Xv8GrZ/fGVvOT2a+LVXbWRoEY6jvBJ/VKxwvKLSOdHg7KExFUi6CUGp0JamS+
wfe5ZjeRab3DX8747DSIDb71TyOlmvr+Htt51BdZzaLR19yAHy/QqHi0QkrTV5eKNXmH8btqiUea
jO5jvBDsClehIFCtIxZyvH3Vjtz7+A6mC8TYPgqqBdk/H+fN8vmgbX9eGzBXLrqPCEiWQgmrnsaD
lFD0yl417xyMxxMFH0WufWOAXDKEWcQ8pOPK/Et4I1WkooQScFFMA04PhUErxrpkk3oWmqVNdqTJ
R8tQdYmo2uPWk2K/BkTnKTdpHonwTN0P4UpI+34HfVWUiLatSa1mqKhFVcU62ZXgluMxw3iAc0ab
oyDpVw4/merVQFFk2Mj8TrTHWcO+nL/qblj/dtsno1wFNTiA5NPyThacA9C/PhaHnnkH6eXl5glV
griXkAzI1kMSDd/JxWKxxiqpXDjECardohzaU8yYz9szt/jtHU4lIgPPVA+WeGlUstRk4yDgcVKt
GHdW56QANF6FOQcBJyEMvk53Rf9NVb+YOZFzyxvJJ6gxuJy/ERDIZFTQ3Pf/7mVbqQVa6P9RJa2d
vN8=
=qQhN
-----END PGP SIGNATURE-----

--------------BnGd6GnnXCpOkgIBBjlSeUIO--
