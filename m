Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259A3C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 07:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2592610E6
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 07:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhJFHRn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 03:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhJFHRn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Oct 2021 03:17:43 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E77C061749
        for <linux-cifs@vger.kernel.org>; Wed,  6 Oct 2021 00:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=sCrikxKK4S8wpMkwU/Ix3CwW5MSAzEoUQnQmJB/qvoM=; b=wjJF1w9gSCF3XYavA/OSItVHcH
        woFk2ua85MImhaMpUG61gklwsxe6izTNEgbsyZI5WH61ho4eH8u3506syIqyLvxT8m84IqzxVaYoZ
        t+/DLSfOXyVvIn58OuIiVXtbNdliVlEgzM2GfIWfiolyztjndzWXLKOBeIMxw8LgOZGD42LO4xoXl
        4krN6R9Ir44qcT2k25qTpYIMLTYhZE+lHtTtM1a4mv5pPthz2U0ZAdQZEvJonQOv6pOrNdyniEllA
        mgmzUo3hCLiEkkVFBGMYAzjB5uCJzcoE4aGIjo2eaXgXPrI4BfvL52Zv7Q2EkR6eSH8jk2rvFLg5m
        WhVO6xu5NnWNCCMQBprPE14nernLrvY3Z7TIZto/ZS2xtJJLstd0g2jUd21M39e87u5wXKMBn2w55
        ZzkVpkpjoYxiPu0tOevdwt0iVneZMyjG5HK1aB3X/nEPM7Qs6EIwBsbc0qZzFWWSO6QjNtid0Dcsb
        Bxu3n85fHk72Pcf6VpGunoeQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mY19Y-001mh7-Jr; Wed, 06 Oct 2021 07:15:48 +0000
Message-ID: <de0ecb81-0313-266e-cc5b-94ec40201141@samba.org>
Date:   Wed, 6 Oct 2021 09:15:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] ksmbd: improve credits management
Content-Language: en-US
To:     Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
References: <20211005100026.250280-1-hyc.lee@gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <20211005100026.250280-1-hyc.lee@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------pRTcYut46j6YngkgznpjSTYH"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------pRTcYut46j6YngkgznpjSTYH
Content-Type: multipart/mixed; boundary="------------KX00A0NvhvGKu6gSuuQD5997";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>
Message-ID: <de0ecb81-0313-266e-cc5b-94ec40201141@samba.org>
Subject: Re: [PATCH] ksmbd: improve credits management
References: <20211005100026.250280-1-hyc.lee@gmail.com>
In-Reply-To: <20211005100026.250280-1-hyc.lee@gmail.com>

--------------KX00A0NvhvGKu6gSuuQD5997
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDUuMTAuMjEgdW0gMTI6MDAgc2NocmllYiBIeXVuY2h1bCBMZWU6DQo+ICogRm9yIGFu
IGFzeW5jaHJvbm91cyBvcGVyYXRpb24sIGdyYW50IGNyZWRpdHMNCj4gZm9yIGFuIGludGVy
aW0gcmVzcG9uc2UgYW5kIDAgY3JlZGl0IGZvciB0aGUNCj4gZmluYWwgcmVzcG9uc2UuDQoN
CmZ3aXcsIFNhbWJhIGFsc28gZG9lcyB0aGlzIGJ1dCB0aGlzIGNhbiBjYXVzZSBzaWduaWZp
Y2FudCBwcm9ibGVtcyBhcyBpdCANCm1lYW5zIHRoZSBzZXJ2ZXIgbG9vc2VzIGNvbnRyb2wg
b3ZlciB0aGUgcmVjZWl2ZSB3aW5kb3cgc2l6ZS4gV2UndmUgc2VlbiANCmFnZ3Jlc3NpdmUg
Y2xpZW50IGdvIG51dHMgYWJvdXQgdGhpcyBvdmVyd2hlbG1pbmcgdGhlIHNlcnZlciB3aXRo
IElPIA0KcmVxdWVzdHMgbGVhZGluZyB0byBkaXNjb25uZWN0cyAoaWlyYykuIFNvIHRoaXMg
bWF5IG5lZWQgY2FyZWZ1bCANCmNoZWNraW5nIGhvdyBXaW5kb3dzIGltcGxlbWVudHMgdGhp
cyBzZXJ2ZXIgc2lkZS4NCg0KQ2hlZXJzIQ0KLXNsb3cNCg0KLS0gDQpSYWxwaCBCb2VobWUs
IFNhbWJhIFRlYW0gICAgICAgICAgICAgICAgIGh0dHBzOi8vc2FtYmEub3JnLw0KU2VyTmV0
IFNhbWJhIFRlYW0gTGVhZCAgICAgIGh0dHBzOi8vc2VybmV0LmRlL2VuL3RlYW0tc2FtYmEN
Cg==

--------------KX00A0NvhvGKu6gSuuQD5997--

--------------pRTcYut46j6YngkgznpjSTYH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFdTSMFAwAAAAAACgkQqh6bcSY5nkbG
UQ//Ug7i4SCUAYfrjaw8wrTPiPHfvt79YNIdGmbo+4tRwx9Dwv9U9azp4a7ZMStG16E45JkdNEhp
Fn+6iiKdHbUgNqQZeupL89JXpbrIbJ/FOJif4xC9X0F8Sfpmdw2vwtexpYyE+VgDBFo39Xopfkdb
yBZCNDN+ZL8DYwDjwQjBUCDE1qOTXOBFRvQ3usG4Y1FX36JNNHkn3ahvzQ9m/HxnuHcsn8dRwN5g
Lu1QhzCWfqeYdcye8rq+YuyDLT5fdtbHu0LjRmIw8xOUavtRFVND57T1Cs4uXkJlxLbNhdVIYlrU
KFCeD6JS39NIZdOyCnU+mYDWWnSYg0WGWhPFbtuBK9GDRsukbwl5BVahFQsQWbHbvlpBm1pmdpS6
XbbRa+i2dL++O/WZWjoqxGIYzOGQLS8n68zOupIwCjcTYB2ycCOGclzGP4aPs9lwDJa/TVEJKh5A
7xfp8ent0ulqGligMJzHlBSUxD8alE6dfJKj/F9yM0/Z8YcIDRMNopBNpg9DBlBg9CL79q9Tl9HQ
dHM66c9mQvuG4+WfqfGBm2/U1LvLfSdV1dlxPuGkLo0bsrUCN/klKPsEVl+VLfzcGCy/hmlLwMft
2zbp4ksTV0uxLx06kx1Nvy6jDUOuOqhECwN9BtB26Q56foe9Fk9iW1JYM/bAXKtdIt4kc9Rle6lU
954=
=AmcC
-----END PGP SIGNATURE-----

--------------pRTcYut46j6YngkgznpjSTYH--
