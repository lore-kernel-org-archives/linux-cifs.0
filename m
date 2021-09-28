Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88CFC433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 03:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91C6B61052
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 03:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbhI1D2j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Sep 2021 23:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238805AbhI1D2i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Sep 2021 23:28:38 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5250C061575
        for <linux-cifs@vger.kernel.org>; Mon, 27 Sep 2021 20:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=t7CC5qgEWZI2rs5uyAh4yeMYQ9ToerVtC9nsUPdPcQ8=; b=tC1828aUMPtGFIxcxhInXsWPcA
        KPcFQw51rvn+YZ0lB+hX5LWoyaWpdtyhgoObakJPP/iJUfVZJ9v5AWuFzgkK64KEIOpy1ATscSOh8
        Hw54ojInI57Fw5XbZHGBojHro7hcvLzuA4fpdBcLiZCbOKZ8Bj7byWUgCxaCble0B756jw27UadBJ
        /kFTXj84apmxu6Hx4SF/lg3KCb+9mrMvGHTshHk5sK0e7lucZqM+PnsNbuvV05Rvrzl/s1hnH91As
        e+vAj8lqfFztm7pUVb74y6vguZCcD0zX6aHLYaEkADn0iSUcaVvF6UHVpx0fMYEZnas2dWVojqln3
        BE+w9b0a4fKCLIzJ0BIOmB1Xe55/cjJH+49tg6oNZFpLh3YHVMnzG51m8ur8s973AgdZmzrbQQdbK
        Sj8ewXTJGviAJIC4mo2KyyWZnl00uo+yRtilKzYrmVGWKnxFtGkVE6kHYihwQnwUsYf/d3YDPmPKQ
        x/XyWgvIN5SbL+X5oON8VKGR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mV3lg-000PJe-Q9; Tue, 28 Sep 2021 03:26:56 +0000
Message-ID: <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
Date:   Tue, 28 Sep 2021 05:26:55 +0200
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
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------efHs6SjPZUT82QVPZvn66EA9"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------efHs6SjPZUT82QVPZvn66EA9
Content-Type: multipart/mixed; boundary="------------ijDovqrn42ZkSUVTfeM0p20X";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
 <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
In-Reply-To: <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>

--------------ijDovqrn42ZkSUVTfeM0p20X
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMjguMDkuMjEgdW0gMDE6NTcgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0wOS0y
OCAwOjQyIEdNVCswOTowMCwgUmFscGggQm9laG1lIDxzbG93QHNhbWJhLm9yZz46DQo+PiBI
aSBOYW1qYWUNCj4gSGkgUmFscGgsDQo+IA0KPj4NCj4+IEFtIDI2LjA5LjIxIHVtIDE1OjU1
IHNjaHJpZWIgTmFtamFlIEplb246DQo+Pj4gQ2M6IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXku
Y29tPg0KPj4+IENjOiBSb25uaWUgU2FobGJlcmcgPHJvbm5pZXNhaGxiZXJnQGdtYWlsLmNv
bT4NCj4+PiBDYzogUmFscGggQsO2aG1lIDxzbG93QHNhbWJhLm9yZz4NCj4+PiBDYzogU3Rl
dmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+DQo+Pj4gQ2M6IEh5dW5jaHVsIExlZSA8
aHljLmxlZUBnbWFpbC5jb20+DQo+Pj4gQ2M6IFNlcmdleSBTZW5vemhhdHNreSA8c2Vub3po
YXRza3lAY2hyb21pdW0ub3JnPg0KPj4+DQo+Pj4gdjI6DQo+Pj4gICAgIC0gdXBkYXRlIGNv
bW1lbnRzIG9mIHNtYjJfZ2V0X2RhdGFfYXJlYV9sZW4oKS4NCj4+PiAgICAgLSBmaXggd3Jv
bmcgYnVmZmVyIHNpemUgY2hlY2sgaW4gZnNjdGxfcXVlcnlfaWZhY2VfaW5mb19pb2N0bCgp
Lg0KPj4+ICAgICAtIGZpeCAzMmJpdCBvdmVyZmxvdyBpbiBzbWIyX3NldF9pbmZvLg0KPj4+
DQo+Pj4gdjM6DQo+Pj4gICAgIC0gYWRkIGJ1ZmZlciBjaGVjayBmb3IgQnl0ZUNvdW50IG9m
IHNtYiBuZWdvdGlhdGUgcmVxdWVzdC4NCj4+PiAgICAgLSBNb3ZlZCBidWZmZXIgY2hlY2sg
b2YgdG8gdGhlIHRvcCBvZiBsb29wIHRvIGF2b2lkIHVubmVlZGVkIGJlaGF2aW9yDQo+Pj4g
d2hlbg0KPj4+ICAgICAgIG91dF9idWZfbGVuIGlzIHNtYWxsZXIgdGhhbiBuZXR3b3JrX2lu
dGVyZmFjZV9pbmZvX2lvY3RsX3JzcC4NCj4+PiAgICAgLSBnZXQgY29ycmVjdCBvdXRfYnVm
X2xlbiB3aGljaCBkb2Vzbid0IGV4Y2VlZCBtYXggc3RyZWFtIHByb3RvY29sDQo+Pj4gbGVu
Z3RoLg0KPj4+ICAgICAtIHN1YnRyYWN0IHNpbmdsZSBzbWIyX2xvY2tfZWxlbWVudCBmb3Ig
Y29ycmVjdCBidWZmZXIgc2l6ZSBjaGVjayBpbg0KPj4+ICAgICAgIGtzbWJkX3NtYjJfY2hl
Y2tfbWVzc2FnZSgpLg0KPj4NCj4+IEkgdGhpbmsgdGhlcmUgYXJlIGEgZmV3IGlzc3VlcyB3
aXRoIHRoaXMgcGF0Y2hzZXQuIEknbSB3b3JraW5nIG9uIGZpeGVzDQo+PiBhbmQgaW1wcm92
ZW1lbnRzIGFuZCB3aWxsIHB1c2ggbXkgYnJhbmNoIHRvIG15IGdpdGh1YiBjbG9uZSBvbmNl
IEknbQ0KPj4gcmVhZHkuIEkgZ3Vlc3MgaXQncyBnb2luZyB0byB0YWtlIGEgZmV3IGRheXMu
DQo+IEl0IHNvdW5kcyBsaWtlIHlvdSdyZSBtYWtpbmcgYSBwYXRjaCBiYXNlZCBvbiB0aGlz
IHBhdGNoLXNldC4gSWYgdGhlcmUNCj4gaXMgbWlzc2luZyBzb21ldGhpbmcgZm9yIGJ1ZmZl
ciBjaGVjaywgWW91IGNhbiBhZGQgYSBwYXRjaCBvbiB0b3Agb2YNCj4gdGhpcywgYnV0IGlm
IHRoZXJlIGFyZSB3cm9uZyBjb2RlcyBpbiBwYXRjaC1zZXQsIEl0IGlzIHJpZ2h0IHRvIGxl
YXZlDQo+IGEgcmV2aWV3IGNvbW1lbnQgdG8gdXBkYXRlIHRoaXMgcGF0Y2gtc2V0Lg0KDQpi
b3RoOiB0aGVyZSBhcmUgaXNzdWVzIHdpdGggdGhlIHBhdGNoIGFuZCBJIGhhdmUgY2hhbmdl
cyBvbi10b3AuIDopIEl0IA0KanVzdCB0YWtlcyBhIGJpdCBvZiB0aW1lIGR1ZSB0byBvdGhl
ciBzdHVmZiBnb2luZyBvbiBjdXJyZW50bHkgbGlrZSBTREMuDQoNCi1zbG93DQoNCi0tIA0K
UmFscGggQm9laG1lLCBTYW1iYSBUZWFtICAgICAgICAgICAgICAgICBodHRwczovL3NhbWJh
Lm9yZy8NClNlck5ldCBTYW1iYSBUZWFtIExlYWQgICAgICBodHRwczovL3Nlcm5ldC5kZS9l
bi90ZWFtLXNhbWJhDQo=

--------------ijDovqrn42ZkSUVTfeM0p20X--

--------------efHs6SjPZUT82QVPZvn66EA9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFSi38FAwAAAAAACgkQqh6bcSY5nkaY
2g/+OSZaJMBGwqFqhxs0h59wMM1qGHdNrDDCbrlZ9bQIyCfm7NRFa5XIiMYNyz9BDmEKG0G5F0VH
jOIqi/nkP07AKYBZoQARVlSgKGzkGsgWrhAaY+21oDGQ/DHqia2KgFk7hy9DP1PnH0lviIkLleHc
O1wFJgr0vzbMlCFYRX5fW/HJuUbIYlY+b6BgJHmsaH8OreFFOfr/oCT+bzqVH7EXz6+4gOJBYIQ7
X2GDvIDVneMC5/uSabVBf4V/Af1qVyleLYyCxFamr1JA+kaiMh5aRe8Q5w9w9G0fG98OMKiuGtQT
pI3lnp48sMDsK++HpNXAWauWl11Z9c/KeggrylUypkVz8d3093RRaZG19kvZMp+VAYmr3RjwUERH
LZ+KdCF3Bdk3d0hIaA+pW8lsRgSA4fdqRmYOd9PUBX28/dRilJ8WfVo5Bgf72dCZIVohYrQ6oJ8P
YbJsEH0q713h42yX2TLluWktEU3avNCRpUu4ipT16O72zl1ONhN0bRJPRjOu2VsQ3Qx0BNza5ayl
79uCIBZv2aoZvvhvfE9be64NBigmwRDC7OegowpebgiwtGjhZYCbEE4w3gdy0TBxymAUhCawoKji
gZlGK32kgaYXM+VwtZr5jymoJMoO9Bow3R+1MbD8r3wjBhGsBXaJbkd6tOz4b6DB+8eeWPMphtcL
Fjs=
=tZWw
-----END PGP SIGNATURE-----

--------------efHs6SjPZUT82QVPZvn66EA9--
