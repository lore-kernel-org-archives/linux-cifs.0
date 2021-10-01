Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D9AC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 11:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9217761A82
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 11:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354193AbhJAMBP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354196AbhJAMBN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Oct 2021 08:01:13 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57BEC06177D
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 04:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=hwwXDBLWPtfg2XJWUiNJ6wJB9ABUzO0rPMx/JSZb888=; b=CuGIHc4+aSYYBhI0I5Ev2WfwCf
        iblDRqH92J8jrcQRUnNZYUM0xTyq7BzNpJIYSdo07kaSd5rAzYDnqOzrZjdx/CwhSBedpYrP81a4p
        m2GYuMTtZpuDCfMJehM7EIjv4WIN8UgtacJnzFDAoYFdMLlsjRAiWbOS7Q2dv8rC5HRL0NICA1Nwb
        qNlx7DNHPto5xjyfHFoRTcDmrOAbLscTKLdwxfXaBw0yn8I8mXA6peJ6LkXtFVau9yKKcl7O7gXbL
        gAiP00sagR8ccGlZE81rEXj0vGebx8/hTi9F4hSILElMvn+Fr8q8dtXnfepOyRW+rqPCmVloXX92A
        HV9RaeImvHYSKIinuU3WqK9uKAX2F/sxyiyixDEEeNIztgJh/pnJuuYUHL60Oc/gVgqcNBv4C4XUg
        yY8gbY8/Ap3MNH4S1KSCmAP1sVe1bEJBAfaRZ3lD23EQVWZq7lVp2u2LtidbtaS6U5iB0r1qu8DoP
        IvfFsGhEEoj68Wz+hhxIxPf3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWHCI-0013W7-5n; Fri, 01 Oct 2021 11:59:26 +0000
Message-ID: <db055e2c-b5c5-8def-e2dd-066f84b29e36@samba.org>
Date:   Fri, 1 Oct 2021 13:59:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org>
 <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
 <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com>
 <2b536a89-cba6-88a0-b7d8-c5435d183679@samba.org>
 <CAKYAXd87aCAMZ56Ch68-NRjCH41MDdYYHUOSo3mfiMAOq_+QFA@mail.gmail.com>
 <40575524-51ff-0c78-98d9-23878e8390fb@samba.org>
 <CAKYAXd8uU=4U1+_rXNeNtu1sAztshzXVi2SGVjcuSSmVtTc+8A@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd8uU=4U1+_rXNeNtu1sAztshzXVi2SGVjcuSSmVtTc+8A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------kNC0S2chUQ0Z0CUsbIMdOEdw"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------kNC0S2chUQ0Z0CUsbIMdOEdw
Content-Type: multipart/mixed; boundary="------------gZi6XFdK4KDaz0L4h7b5t3c5";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <db055e2c-b5c5-8def-e2dd-066f84b29e36@samba.org>
Subject: Re: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
References: <20210929084501.94846-1-linkinjeon@kernel.org>
 <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
 <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com>
 <2b536a89-cba6-88a0-b7d8-c5435d183679@samba.org>
 <CAKYAXd87aCAMZ56Ch68-NRjCH41MDdYYHUOSo3mfiMAOq_+QFA@mail.gmail.com>
 <40575524-51ff-0c78-98d9-23878e8390fb@samba.org>
 <CAKYAXd8uU=4U1+_rXNeNtu1sAztshzXVi2SGVjcuSSmVtTc+8A@mail.gmail.com>
In-Reply-To: <CAKYAXd8uU=4U1+_rXNeNtu1sAztshzXVi2SGVjcuSSmVtTc+8A@mail.gmail.com>

--------------gZi6XFdK4KDaz0L4h7b5t3c5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDEuMTAuMjEgdW0gMDM6MTAgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMS4gWW91IG5l
ZWQgdG8gY2hlY2sgaGVhZGVyIHNpemUgb2YgcmVsYXRlZCBwZHUgb2YgY29tcG91bmQgcmVx
dWVzdCBpcw0KPiBhbHJlYWR5IGNoZWNrZWQgaW4gdGhlIGlzX2NoYWluZWRfc21iMl9tZXNz
YWdlIGZ1bmN0aW9uLg0KPiANCj4gaXNfY2hhaW5lZF9zbWIyX21lc3NhZ2UoKQ0KPiAuLi4N
Cj4gICAgICAgICAgaWYgKG5leHRfY21kID4gMCkgew0KPiAgICAgICAgICAgICAgICAgIGlm
ICgodTY0KXdvcmstPm5leHRfc21iMl9yY3ZfaGRyX29mZiArIG5leHRfY21kICsNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgIF9fU01CMl9IRUFERVJfU1RSVUNUVVJFX1NJWkUgPg0K
PiAgICAgICAgICAgICAgICAgICAgICBnZXRfcmZjMTAwMl9sZW4od29yay0+cmVxdWVzdF9i
dWYpKSB7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICBwcl9lcnIoIm5leHQgY29tbWFu
ZCgldSkgb2Zmc2V0IGV4Y2VlZHMgc21iIG1zZyBzaXplXG4iLA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIG5leHRfY21kKTsNCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgIHJldHVybiBmYWxzZTsNCj4gICAgICAgICAgICAgICAgICB9DQoNCnllYWgsIEkgYWxy
ZWFkeSBtZW50aW9uZWQgdGhhdCBpbiB0aGUgY29tbWl0IG1lc3NhZ2UgaWlyYy4gVGhlIHBy
b2JsZW0gDQp3aXRoIHRoaXMgaXMgdGhhdCB0aGlzIGxvZ2ljIGlzIHRvbyBicml0dGxlIGFu
ZCBoYXJkIHRvIHVuZGVyc3RhbmQuIFRoZSANCmNvZGUgc2hvdWxkIGJlIHJvYnVzdCBhbmQg
ZWFzeSB0byB1bmRlcnN0YW5kLCB0aGF0J3Mgd2h5IEkgc3Ryb25nbHkgDQpzdWdnZXN0IHRv
IGFkZCB0aGUgY2hlY2sgdG8ga3NtYmRfc21iMl9jaGVja19tZXNzYWdlKCkuDQoNCj4gMi4g
c2Vzc2lvbiBpZCBhbmQgdHJlZSBpZCBvbmx5IG5lZWRzIHRvIGJlIGNoZWNrZWQgaW4gdGhl
IGhlYWRlciBvZg0KPiB0aGUgZmlyc3QgcGR1IHJlZ2FyZGxlc3Mgb2YgY29tcG91bmQgYW5k
IHNpbmdsZSBvbmUuDQoNClVubGVzcyBJJ20gY29tcGxldGVseSBvZmYgKHdoaWNoIEkgc29t
ZXRpbWVzIGFyZSwgc28gSSdtIHByZXBhcmVkIHRvIGJlIA0KcHJvdmVuIGZhbHNlIDopICks
IHRoaXMgaXMgbm90IGNvcnJlY3QuIENmIE1TLVNNQjIgMy4zLjUuMi43LiBGb3IgDQpub24t
cmVsYXRlZCBjb21wb3VuZCByZXF1ZXN0cyBzZXNzaW9uLWlkIGFuZCB0cmVlLWlkIGFyZSB0
byBiZSB0YWtlbiANCmZyb20gZWFjaCBQRFUuDQoNCkNmIGFsc28gdGhlIFNhbWJhIGNvZGUg
aW4gc21iZF9zbWIyX3JlcXVlc3RfZGlzcGF0Y2goKSB3aGljaCBjYWxscyANCnNtYmRfc21i
Ml9yZXF1ZXN0X2NoZWNrX3Nlc3Npb24oKSBhbmQgc21iZF9zbWIyX3JlcXVlc3RfY2hlY2tf
dGNvbigpIHRvIA0KaW1wbGVtZW50IHRoZSByZWxldmFudCBsb2dpYy4NCg0KSSdsbCBzZW5k
IHdoYXQgSSBoYXZlIGluIGEgc2Vjb25kLg0KDQotc2xvdw0KDQotLSANClJhbHBoIEJvZWht
ZSwgU2FtYmEgVGVhbSAgICAgICAgICAgICAgICAgaHR0cHM6Ly9zYW1iYS5vcmcvDQpTZXJO
ZXQgU2FtYmEgVGVhbSBMZWFkICAgICAgaHR0cHM6Ly9zZXJuZXQuZGUvZW4vdGVhbS1zYW1i
YQ0K

--------------gZi6XFdK4KDaz0L4h7b5t3c5--

--------------kNC0S2chUQ0Z0CUsbIMdOEdw
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFW+B0FAwAAAAAACgkQqh6bcSY5nkay
yBAAhb5eVarGD1XqMC9aCMIjuFyO4u84ix2/TRWPDzEQN76A+EVscpscNB+I4TThD+B2BISzQeUi
GcKpr4oDnPeaZPufYqHd1jbDQQ8LMeMXwAxHeLsYK4NSQ5u4PvCnt/Vz7noXqLzVny/y4CP4WYoa
C02aDXptgL/7XJFdOt62a0F0OMTgYBwFhiWe3I9JR4D+bWXQXuib8hZVt8DOVFRCyyYxrdTbdWDt
hn1wjnCNVJmYOmCYE1q2Vb6DKumndGETcwrPooeROchF7WaD1CFne0DtuSGTqmzRY6pjJ9HaK6Is
HiQ0vJlmDLv3bOirogTtIHYpPsJEUf2Qh4KMvckFmsdTZKtCj0OsO4iWykL0R8h8SX3kl69IGweJ
JlOsofKoAN8pzENpHmKZJCHL8YwXmKOpa+zoX/CMcgKcBXb0UlG2iHc4MUnm28wgMle08Lb8ZI3L
jOSQ6g8NapYnqdUEerffKNFFUCS5UFTejhrnZlQvntDwLTkaH/O612sk2A7jbC06EbUq/fDR41gI
Ep9NhWUw3dX72hJQ/1gIsgRGZ7ZkPir3mcxV4Ecvtg/SjkGng0EeMgVkES0PCaSvgp3J+3tbHn68
+GKzXcODIgj1DyfMkN1pdChOIbN7YfvYiWGJ+GwVtvsHCs+mUX94ZQApPr2fpHR/lPa+nmH0cWNv
RWY=
=Yxi0
-----END PGP SIGNATURE-----

--------------kNC0S2chUQ0Z0CUsbIMdOEdw--
