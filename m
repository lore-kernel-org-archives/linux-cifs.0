Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EFDC433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 14:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 491AC60FC1
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 14:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhIZO3d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Sep 2021 10:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbhIZO3d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 26 Sep 2021 10:29:33 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB982C061570
        for <linux-cifs@vger.kernel.org>; Sun, 26 Sep 2021 07:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=UKU/7J6zt0z0L5fS4oKC35dlynxHUs72b5ElbxJBRZ4=; b=Fx5euXydJj3XpDr+eg2+Ahvdkp
        RcaJ4McbIMu3pLgSeIFnKUgmSu3LykYJzqqtsWzD05tljXlzeZZsW6/QPFNWQh18hgxVyF2fZCnon
        /AXLHh714PLytCye0p8BoRUeG9fn0gQcnQNrmYVGGdo6JASZFdbdIpYbHNxE0t30y4YcNp5OOwkri
        VWjXMt58rg7Cfb4t6FV5ckP8ps3jmcc+q75JlsRH+bc3gXjJ9WnLA4FsjCEGcIP3SQF1lvb13YRKR
        sJeAnJOOhLjhMsE+hx3en39i79/qdBViohcljXT3SbwFLXwygwfYSsHEck8lEMkjAqFKl00ZbcWTO
        48QJs825FfLQFVc78Osh8l3aPc7/sFuD7KAv+c/8ch5sUhGqSjVqF6el6/hsFwcDevdQEx64zUQ7M
        4FJzvMp8jgcZYorSmt+xw3odyfxjlSzCcBTIgi1gQWJje5D1KYqCZ2/FfIfEhwG0WhOwG3Z+LFbVc
        Rc+vRFyIeyQEQv5JX3B31Lg/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mUV8E-000B5s-9C; Sun, 26 Sep 2021 14:27:54 +0000
Message-ID: <a1fc90f5-3e35-98f7-b932-7eee62200de0@samba.org>
Date:   Sun, 26 Sep 2021 16:27:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
References: <20210926135543.119127-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <20210926135543.119127-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------aFYhstO2sDwwhykpcoHEMhsL"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------aFYhstO2sDwwhykpcoHEMhsL
Content-Type: multipart/mixed; boundary="------------RddRDTrQ0Np650ff170tCq0I";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Message-ID: <a1fc90f5-3e35-98f7-b932-7eee62200de0@samba.org>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
References: <20210926135543.119127-1-linkinjeon@kernel.org>
In-Reply-To: <20210926135543.119127-1-linkinjeon@kernel.org>

--------------RddRDTrQ0Np650ff170tCq0I
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMjYuMDkuMjEgdW0gMTU6NTUgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gQ2M6IFRvbSBU
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
ICAgICBrc21iZF9zbWIyX2NoZWNrX21lc3NhZ2UoKS4NCg0KbG9va3MgbGlrZSB5b3UgaGF2
ZW4ndCBwdXNoZWQgdGhvc2UgdG8gZ2l0aHViIHlldD8gQXQgbGVhc3QgSSBkb24ndCBzZWUg
DQphbiB1cGRhdGUgdG8ga3NtYmQtZm9yLW5leHQtcGVuZGluZy4NCg0KSSdkIHByZWZlciBm
ZXRjaGluZyBmcm9tIGdpdCB0byByZXZpZXcgdGhlIHBhdGNoZXMuIEkgYWxzbyBoYXZlIGEg
ZmV3IA0KcGF0Y2hlcyBvbiB0b3AuDQoNClRoYW5rcyENCi1zbG93DQoNCi0tIA0KUmFscGgg
Qm9laG1lLCBTYW1iYSBUZWFtICAgICAgICAgICAgICAgICBodHRwczovL3NhbWJhLm9yZy8N
ClNlck5ldCBTYW1iYSBUZWFtIExlYWQgICAgICBodHRwczovL3Nlcm5ldC5kZS9lbi90ZWFt
LXNhbWJhDQo=

--------------RddRDTrQ0Np650ff170tCq0I--

--------------aFYhstO2sDwwhykpcoHEMhsL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFQg2kFAwAAAAAACgkQqh6bcSY5nkZs
Ig/+I0Qjv0IGoEljmv2ivfc1EWb5USC6eIhbIB8BKdHU47Hm+eo1PL9J8pZmDw5SrT/hgEklsrRg
iysMzhvnLlgEpFhkSTpn7bvLbAV8Lrb0CzqEZ/YVeeoVQ+W0gS/abG+SeHiTZlaG9m4jHXEg1TJf
t0kXRrpALrqGPnXeskjcpzOzXNFgiR4qrimr9u2LUUG3vtrHtxY1KF5RmOjfUrXjjfgIh44gfLHf
2tclNVPAAFLEI7lIKrgeRl46qf20pSxs1uP+zmV+kK+HGYz9z/BX/L8aPd2eQy0EJplfEQkU1LLb
RYpABBsTRsbqHgXZS7isFKUlPbHBCX7OuU5DAyb5tN0Ck7nVZpOtaSyeBcKpsR6EQD4BwnaWrxSY
/VF7w9GTnRbY3kDcYff56mrU2DiCQx9WvDMTA4y/xIkgj7S1DwtkPq/IlzNQIH6mdFe8Nj1PpBGb
hVYayO2J7kqpNA3SNXzyicreBgQ+kgAvXttFlXCRuZnhgmJktrEU4gtSIqfDWXum7VWxQnG5PMqy
13gYQQbFqdyLcPGfYit0QehpYU66/LrhTl0ZwpwmlZz4tOKzuTdHUn9EDagWL72XlfYg+1UvqTM2
gpaxlapUDvjpIlmlKl96UfV+VFV29zoBMmJkC5GUR0lNt20BaLOffvjk+yQk32sQ2NlK02qoFWGy
l0E=
=Kk/Z
-----END PGP SIGNATURE-----

--------------aFYhstO2sDwwhykpcoHEMhsL--
