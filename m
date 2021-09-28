Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1E4C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 13:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11BB760FE8
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 13:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240848AbhI1NpK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 09:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbhI1NpK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Sep 2021 09:45:10 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7507C061575
        for <linux-cifs@vger.kernel.org>; Tue, 28 Sep 2021 06:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:To:From:Date:Message-ID;
        bh=DWu9AqyBjkkHBq5lfFayusEvI0ve6DW8MSS4/TbcN+o=; b=LrdPBhCnN55YxgYEX+5xOlwQMI
        qGdAT3vdLH1kjbBuTTghRPvRQ9DFEBcBMzLGzX3ti4YIgzgZaOjakHGWK8sUbADiY9glOI3+ehpOQ
        vcRwraAY6XbN9eeB53Jg4H/FWtpHYKY+cFx6RV1BZXaMQMcWuNi/lVa7YpMBsg1Z7uuh4Jxc2Lbn2
        6S42TI9DepLBOD56XaXHRA9i0o2ZZ3RBOhQDgMEXLFYDw2mRoGOgZnDNRYz0OiYxyGj8f3YzNJd9p
        WwPw1/WDcAaZeML4W9zfi0SP56RDmgDNywlmqySpJ4CRRcjuYv35Ed4q//yAyNSOmzZUlQ3Ku9ntU
        d1p0LASiyYC4PE91ILd6jDjN9vPaojFoI8iXuhOP7gpTI8BY8QEzSiyMRtMa6RHIvD6aOzlVCjKr8
        w6Vo6kcpGAjd5OVWR2LR0zr+A3i9LlWSTIBQMkuNFUTPsLd2fS91g6iTxbY6dNdiT8tnmBpU4s+Qu
        KnggHzBV701MOQUa3oS8lFB9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVDOH-000V47-7h; Tue, 28 Sep 2021 13:43:25 +0000
Message-ID: <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
Date:   Tue, 28 Sep 2021 15:43:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
Content-Language: en-US
From:   Ralph Boehme <slow@samba.org>
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
In-Reply-To: <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Xa81XfDFtFK7U5BS5HXuCNq0"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Xa81XfDFtFK7U5BS5HXuCNq0
Content-Type: multipart/mixed; boundary="------------mmXirPYJdrT0AiM1KwdSzR0N";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
 <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
In-Reply-To: <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>

--------------mmXirPYJdrT0AiM1KwdSzR0N
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMjguMDkuMjEgdW0gMDU6MjYgc2NocmllYiBSYWxwaCBCb2VobWU6DQo+IGJvdGg6IHRo
ZXJlIGFyZSBpc3N1ZXMgd2l0aCB0aGUgcGF0Y2ggYW5kIEkgaGF2ZSBjaGFuZ2VzIG9uLXRv
cC4gOikgSXQgDQo+IGp1c3QgdGFrZXMgYSBiaXQgb2YgdGltZSBkdWUgdG8gb3RoZXIgc3R1
ZmYgZ29pbmcgb24gY3VycmVudGx5IGxpa2UgU0RDLg0KDQpmaW5hbGx5Li4uIDopDQoNClBs
ZWFzZSBjaGVjayBteSBicmFuY2ggDQo8aHR0cHM6Ly9naXRodWIuY29tL3Nsb3dmcmFua2xp
bi9zbWIzLWtlcm5lbC9jb21taXRzL2tzbWJkLWZvci1uZXh0LXBlbmRpbmc+DQoNCmZvciBh
ZGRlZCBjb21taXRzIGFuZCB0d28gU1FVQVNIZXMuIFJlbWFpbmluZyBjb21taXRzIHJldmll
d2VkLWJ5OiBtZS4NCg0KT2gsIGFuZCBJIGFsc28gc3BsaXQgb3V0IHRoZSBzZXRpbmZvIGJh
c2ljIGluZm9sZXZlbCBjaGFuZ2VzIGludG8gaXRzIA0Kb3duIGNvbW1pdC4NCg0KTGV0IG1l
IGtub3cgd2hhdCB5b3UgdGhpbmsgb2YgdGhlIGFkZGl0aW9uYWwgY2hlY2tzIEkndmUgYWRk
ZWQuDQoNCkNoZWVycyENCi1zbG93DQoNCi0tIA0KUmFscGggQm9laG1lLCBTYW1iYSBUZWFt
ICAgICAgICAgICAgICAgICBodHRwczovL3NhbWJhLm9yZy8NClNlck5ldCBTYW1iYSBUZWFt
IExlYWQgICAgICBodHRwczovL3Nlcm5ldC5kZS9lbi90ZWFtLXNhbWJhDQo=

--------------mmXirPYJdrT0AiM1KwdSzR0N--

--------------Xa81XfDFtFK7U5BS5HXuCNq0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFTG/wFAwAAAAAACgkQqh6bcSY5nkZi
chAAvnHnibMmff+pejtRj7lmy249/GyZ+zTeUUtrJXpEXY/unQBl/vYUD77uZ8OPFxTwEf/xMblp
1vElbuTtELg9sOcnquAYcd2TJ2A0Ie+hkyQL3qxpfqPqMTMkjMOdje3SfgprmTrl/d4FrvUiT9me
FCZdCnHUMfwl+5oPfPeS5yd2X5zM1eOtAK6IbM+AAsLkX/rGTcoZCwZkJpamzAUNb/pyosynUvAW
c3MfWRbiu9Z2h7OeGAvnLTVNsMoNqNGvYyMCfVsE3rOiUCglrXAnYmwGR/+sIn74c+aRnGw81wMb
XPsd5GvFS+W/PaOcbb3wQpV+iUb3uHbJ7jBJ/Mppc9fwX/jD0GTnWmg0chkeX8PoBR/DofHRLLkz
gxq9ALAax63iUpCqDl0m73+ju569dv5UQ0R+d3Ib6OQyTBHvEjbJTwB07VadrRmuadIh51xUaOVT
5nX+ByDBQe88NhSmjGNAjLYNsPMJu6tZN+b7Jtda7UOSbltAnZRXhiCQdKZMA5Q0EVBrOPWrTi4L
BbOj8szMFdQ1Ao+OKhXNCBFAA1QjZwBJsZMRQs+acQOfeE9nIhF6rJPMqxG6gE5rUzH4RmNr/dyi
Ek7LB9pFTUVtJEJZCCkAu0OfjpX4NRbNTOLsFImoYD7ETaVdTBnNI7CfjJwxKxWam8K112CeZWEJ
HKw=
=M1+f
-----END PGP SIGNATURE-----

--------------Xa81XfDFtFK7U5BS5HXuCNq0--
