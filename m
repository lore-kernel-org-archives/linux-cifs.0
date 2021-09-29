Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8231C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 17:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC61261288
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 17:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343495AbhI2RKB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 13:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345188AbhI2RKA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 13:10:00 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E6EC06161C
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 10:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=LwZxU5IWy/NLigcgVzS9XoMR3xOoD+U/MqS2nqfXvww=; b=Cy/8kIUNXokn/I+QR0AK6SSQwn
        9fgyMcBxe619KBv/h8AawErVI31kjMNO8rUZR9kZHOOb5J6wIGMe7e9CQ8ptQE9GCplGKNJRTzzzH
        S6uzjcLArPtl00WZZSPx84UidaHDRf1gVJlDz8PVaAQpsUExuxPz6aAB14SycDbSyJOPvQVdCd7sz
        KJCBxhCKaa/+Mgf5W9xNJyBBTc4/nfsS0IpawBprzlNqd/aKn9d6dEn9xg3Ze9l+MzwDATnKfhckX
        sojSxT7/q1Bm0qakw3RwIipRwpYfzKQgzui2Nk/EijsNb3oW+wZfwW45L+Gh/8x0YuCm3LITSUN75
        9rAoz5CKlS7znEOoC6Gw1R7TPigS1w7ktxjI87uSAnnF5esqwG9k/kbS0EiYH1VaQYBWTOvCL0u22
        ULl74GFq97w5HoeWTxOqgF9sNOBR0S5sHnugy7M/VHgLGL9AQkN45MAQQQ0osxM0UU9z3Bz2Ek5uR
        5nZv5JJhET3kWH6jkV14KXBv;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVd43-000jRz-HP; Wed, 29 Sep 2021 17:08:15 +0000
Message-ID: <4f8d93dd-8771-86a3-0cd9-ae1b1e9c77b0@samba.org>
Date:   Wed, 29 Sep 2021 19:08:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
Content-Language: en-US
To:     Tom Talpey <tom@talpey.com>, Jeremy Allison <jra@samba.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
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
 <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org>
 <YVNR6w7dq0HMIcFA@jeremy-acer>
 <76fcdc45-0a94-d9e6-14c8-1c638d0bd00f@talpey.com>
 <YVSJWPa8dalyzsl0@jeremy-acer>
 <ce52c130-74de-feaa-6995-6a0d947816a6@samba.org>
 <27908e3e-140e-8c7a-e792-414fec5b5190@talpey.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <27908e3e-140e-8c7a-e792-414fec5b5190@talpey.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------MFf6QPql5mM6IDfyGQnC2KEP"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------MFf6QPql5mM6IDfyGQnC2KEP
Content-Type: multipart/mixed; boundary="------------vIQwx9CoanZqi9323aAKdocp";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Tom Talpey <tom@talpey.com>, Jeremy Allison <jra@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <4f8d93dd-8771-86a3-0cd9-ae1b1e9c77b0@samba.org>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
 <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
 <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
 <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org>
 <YVNR6w7dq0HMIcFA@jeremy-acer>
 <76fcdc45-0a94-d9e6-14c8-1c638d0bd00f@talpey.com>
 <YVSJWPa8dalyzsl0@jeremy-acer>
 <ce52c130-74de-feaa-6995-6a0d947816a6@samba.org>
 <27908e3e-140e-8c7a-e792-414fec5b5190@talpey.com>
In-Reply-To: <27908e3e-140e-8c7a-e792-414fec5b5190@talpey.com>

--------------vIQwx9CoanZqi9323aAKdocp
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMjkuMDkuMjEgdW0gMTg6NDUgc2NocmllYiBUb20gVGFscGV5Og0KPiBPbiA5LzI5LzIw
MjEgMTI6MzggUE0sIFJhbHBoIEJvZWhtZSB3cm90ZToNCj4+IHdlbGwsIGlmIEkgY291bGQg
aGF2ZSBpdCB0aGUgd2F5IEkgd2FudGVkLCB0aGVuIHRoaXMgd291bGQgYmUgaXQuIEJ1dCAN
Cj4+IEkgdW5kZXJzdGFuZCB0aGF0IGFkb3B0aW5nIG5ldyB3b3JrZmxvd3MgaXMgbm90IHNv
bWV0aGluZyBJIGNhbiBpbXBvc2UgDQo+PiAtLSBhdCBsZWFzdCBub3Qgd2l0aG91dCBwYXlp
bmcgZm9yIGFuIGluc2FuZSBhbW91bnQgb2YgDQo+PiBMYWtyaXR6LUdpdGFycmVuIHRoYXQg
SSB0ZW5kIHRvIHVzZSB0byBicmliZSBtZXR6ZSBpbnRvIGRvaW5nIA0KPj4gc29tZXRoaW5n
IEkgd2FudCBoaW0gdG8gZG8uIDopDQo+IA0KPiBJJ20gaW4gZm9yIGdpdGh1YiBpZiB5b3Ug
c2VuZCBtZSBzb21lIHRvbyENCj4gDQo+IGh0dHBzOi8vd3d3Lmd1dHNjaG1lY2tlci5jb20v
cHJvZHVrdC9oYWV2eS1tZXRhbC1zYWx6aWdlLWdpdGFycmVuLTEwLXgtMTUwLWctdHVldGUv
IA0KDQpyb2ZsDQoNCkkgaGF2ZSB0byBib29rbWFyayB0aGlzLCBsb29rcyBsaWtlIG9uZSBv
ZiB0aG9zZSB3b3VsZCBidXkgbWUgYXQgbGVhc3QgYSANCjEwMC1yZXZpZXdzLWdyYW50ZWQg
cGFja2FnZSBmcm9tIG1ldHplLiA6KSkpDQoNCi1zbG93DQoNCi0tIA0KUmFscGggQm9laG1l
LCBTYW1iYSBUZWFtICAgICAgICAgICAgICAgICBodHRwczovL3NhbWJhLm9yZy8NClNlck5l
dCBTYW1iYSBUZWFtIExlYWQgICAgICBodHRwczovL3Nlcm5ldC5kZS9lbi90ZWFtLXNhbWJh
DQo=

--------------vIQwx9CoanZqi9323aAKdocp--

--------------MFf6QPql5mM6IDfyGQnC2KEP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFUnX4FAwAAAAAACgkQqh6bcSY5nkY2
4Q/+JIbycFst6WGYSMEHOfEZy/c5N1kfAnN9oiKKhZRe2shW9A121T9B93pUsdLEd2PAiPfnRQOZ
BtFcePU4L/6Dig6+k3isJE8zDT4hccaWNDo3ep/wTopLrG8Xf/xCPDKptNk93v0arsyMVvu48JeF
c9LXcDSEpAVFDjmkt6aziTVX4kLqa4RQs9SN2XioWodm3Vd42ua7zvo0xG2gqVbEJn9BEqwZg2mb
0ULPB1SKanDYUui6kzfFo48OADObvg9uQ1YWogSgbfU8wNDRJPLLYPoZW3hNG9bxjlbwGOXffJF/
IsUhc7uHeAkDAIz4snCYibuZOo3mHQuf+sV7hvpiLnFjMKO5aVCwV3yAuXD33a4u5a5vZKZH1aKg
DdtnW6+M1mCu2gDDm8MpoZTQHe0J05KST29ZIiK2ocw8RoPD3rHVK7Q44uJSSsemb69r/uhdiJm7
ueAQ21XwebQnvumLaa/7mCWDF6TFZlcizud0GzYw3CNi+XGON8b7IGWXdJ1NX4bfxuDoMtXZTHe3
H1CduaubQpQImkxGF0FNo6mP5/tPEltlnX311SSjH+CS0H8epepDVO3N2xtEYxeEkB2bO05yULwT
ARz9thC0cLluGoyhgPC8aYMEb0trGMl99PTBcxVKfyVg3k3jxD6kc36UBICb0HG/BgPVpxiZj9FD
+K4=
=ICE3
-----END PGP SIGNATURE-----

--------------MFf6QPql5mM6IDfyGQnC2KEP--
