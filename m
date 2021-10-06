Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E102EC433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 09:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78A561154
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 09:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbhJFJLm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 05:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhJFJLm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Oct 2021 05:11:42 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F47FC061749
        for <linux-cifs@vger.kernel.org>; Wed,  6 Oct 2021 02:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:To:From:Date:Message-ID;
        bh=Aq0AQtBcr4TxjVJdQeuIptpavJQXQ/B7iOaQfMFemBg=; b=TNNiwgGN+fdoy3WhaYdOlFL/e/
        +/x7B/zfilwc9z7klqUmV+sUpoYYFS3anfIDuTbojgYjNsN+/crkVwww7mDXiqyjXKnq6erMN8xRD
        CHU+asCE8962l4pbuptw2cZwIXL1QGsknDr4n9cmFMt6Nh6hmzITZbWLUieJD9lYV73ug69PZS3zs
        IBzuEBC0q1HuRz3SwbVBMbZUc+b6Zb3IoRGzNU6CvW6LvXST0z1IVvttyIrqwN23u3EF2aIf0N2eX
        Cr9KIopuPOdsK6Fngb6ja7N6fjE1k4GDMww0186gfS47A85H5YVlWGulD84Q2OFbnOqtI1q0cwpzb
        oWQkrrNErA1xgYPLio5RZYRXztoCV1ReibOmmNfSo34pYA2USTA3IYCNJIGrEbQ5EoIQeR21tHeNS
        tWNHlac0+tsb+gNIeQTImMP29FixPcRSipmK+dZhl+aBEH+ZOAfhS6aZUiTwjxpIuqLxNB82jaA1A
        PArlnEq9KbFFJSHLmvw7fgjc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mY2vr-001nQS-R0; Wed, 06 Oct 2021 09:09:47 +0000
Message-ID: <acc7e8fa-5049-83b4-20e3-21430c361019@samba.org>
Date:   Wed, 6 Oct 2021 11:09:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] ksmbd: improve credits management
Content-Language: en-US
From:   Ralph Boehme <slow@samba.org>
To:     Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
References: <20211005100026.250280-1-hyc.lee@gmail.com>
 <de0ecb81-0313-266e-cc5b-94ec40201141@samba.org>
 <CANFS6basCNTcN7Myz0bAd_LTXEji43HiqLE0B8McpaemUjSp8Q@mail.gmail.com>
 <64519e7d-d82f-91f6-5c8c-ce9aa8935b30@samba.org>
In-Reply-To: <64519e7d-d82f-91f6-5c8c-ce9aa8935b30@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lD0AqLLwRZxBr2RTCtJVyPey"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lD0AqLLwRZxBr2RTCtJVyPey
Content-Type: multipart/mixed; boundary="------------aVu9zM8lwB8r5XkB2024KZh4";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Hyunchul Lee <hyc.lee@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs <linux-cifs@vger.kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>
Message-ID: <acc7e8fa-5049-83b4-20e3-21430c361019@samba.org>
Subject: Re: [PATCH] ksmbd: improve credits management
References: <20211005100026.250280-1-hyc.lee@gmail.com>
 <de0ecb81-0313-266e-cc5b-94ec40201141@samba.org>
 <CANFS6basCNTcN7Myz0bAd_LTXEji43HiqLE0B8McpaemUjSp8Q@mail.gmail.com>
 <64519e7d-d82f-91f6-5c8c-ce9aa8935b30@samba.org>
In-Reply-To: <64519e7d-d82f-91f6-5c8c-ce9aa8935b30@samba.org>

--------------aVu9zM8lwB8r5XkB2024KZh4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDYuMTAuMjEgdW0gMTA6NTAgc2NocmllYiBSYWxwaCBCb2VobWU6DQo+IEFtIDA2LjEw
LjIxIHVtIDEwOjQzIHNjaHJpZWIgSHl1bmNodWwgTGVlOg0KPj4gT2theSwgSSB3aWxsIGRy
b3AgdGhpcyBpbiB0aGUgcGF0Y2guIEFuZCBjb3VsZCB5b3UgZWxhYm9yYXRlDQo+PiBvbiB0
aGUgc2l0dWF0aW9uIHRoYXQgY2xpZW50cyBjYXVzZSB0aGUgcHJvYmxlbT8NCj4gDQo+IHRo
ZSBjbGllbnQgd2lsbCBqdXN0IHN3YW1wLi4uDQoNCm1vcmUgcHJlY2lzZWx5OiB0aGUgY2xp
ZW50ICptYXkqIHN3YW1wIHlvdS4gSWlyYyB3ZSd2ZSBzZWVuIHRoaXMgd2l0aCBhIA0KY2xp
ZW50IHdoZXJlIHRoZSAoaWlyYyBMaW51eCkgYXBwbGljYXRpb24gd2FzIHdyaXRpbmcgc29t
ZSBkYXRhIHRoYXQgaXQgDQpnZW5lcmF0ZWQgdmVyeSBxdWlja2x5ICppbiBtZW1vcnkqLg0K
DQotc2xvdw0KDQotLSANClJhbHBoIEJvZWhtZSwgU2FtYmEgVGVhbSAgICAgICAgICAgICAg
ICAgaHR0cHM6Ly9zYW1iYS5vcmcvDQpTZXJOZXQgU2FtYmEgVGVhbSBMZWFkICAgICAgaHR0
cHM6Ly9zZXJuZXQuZGUvZW4vdGVhbS1zYW1iYQ0K

--------------aVu9zM8lwB8r5XkB2024KZh4--

--------------lD0AqLLwRZxBr2RTCtJVyPey
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFdZ9oFAwAAAAAACgkQqh6bcSY5nkYA
+w//QmHvJTYMkDwOxre82vFbWZ8US9/FMLP/a7IfVQ4hVQRXI+f0FNz1xC7aL7CVJOA/3jQv9ijg
VrkHyeEhP0bMVkxt6V1bFu9d62Dkgiw+f92IJNIHDu6OH4eJkr9eAWCUwub90S5+3BOyVwPW1zbb
i6vnh+6bd07WDU9aaw6KqMbMgVydNKX0pkuaiVVmUI6HN5FkKICFCeRCJPL8FzZ4aWdQBJ4Cbymj
OuUyFvjpIwjjwsRVwSPTMWger3fxEPQW+67yOa9ghQ/fUQq1+1KdaGDp9FBdIQIES1QbAF7v22Z6
kKFLdkLc0mnvTc2EDzjf+ymPTkh/sBFRr65I2nABSepdVJcQNi/tQUhAPApZEjuBMm2nlQin1/B0
L1GdMWApGGjAt+wXgbU7XXjbWRa2u0cgkj7JqetopcsKbxVLHL+1c1m1tXVftxv+hqdpL/kY35yc
vvF76jqH2X2TVgTF1ehkM32BtnXt3xxAZ/T+Yxj5f6bSs+R7CCvp8yMQbAGBx+qFyX6mHHHpio5e
iZX6fEqpoBcQwA0dtAhaDWb60j74y0ndcgCcJtIkJmt6YZyKdd7ryBtLr+H9JtAmz0D/bcJWeN2g
6CKsL468F+s4C8fRjCKV1HJrxa0VSIRbDyENQ8FYEOPbA3D/NHqECRC59Hmwy6dDe6q0dl1QL5NE
uas=
=BJ2F
-----END PGP SIGNATURE-----

--------------lD0AqLLwRZxBr2RTCtJVyPey--
