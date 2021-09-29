Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1D5C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 17:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666BA61465
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 17:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245166AbhI2RUV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 13:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245080AbhI2RUV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 13:20:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF19C06161C
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 10:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=Z+EGTxWuBNsMSP6whDvtg2L3DCebmCVv3qx0sVlF9b4=; b=GUXVkYsgYcCt8oY/aVFYaiLt6S
        DtqWSfXXxRLCXVPbGW2mpr7xBZX1Z5rgP/WkxJVco3iftJvW0kfws/kLLm6jNzUEKyGtZeAZOXMiI
        ZgTEUbUjH46SSbHl0FFE3vr+gtobeVPqGYtTlII/V/jvXfODoixUtouND4FSTPwwAQuL0ZqTXyeTx
        R1BVBwWyUk2r45tVJStR+rrZ9xIX6lUm4jeC9rJG2K8zRYYMQEHW7boo24/XY0O4YE7TbqKpu7uK6
        gL0jVEAw6WPZk6WEDDJeGOIDieUpXHoygXT77gxbIAQUgOXgzr238ZH7s7uWuiWzfWeGe91McR0SY
        vJdpg8CZzHUKyoiJl4Di/gRqq7EESB39RLCVRsXJZV+Flpiv5opFbXMM4cmqNZwneG47Gv+TsRi0P
        fXo6IXkfMX2hZ9+QsTkBkl2TPYIJWyYMqfebpsCpdSjQfeoCKaPu1gPUv26HVmQGhqno1wV2i+gme
        WWXDuvlTVWSa5LinT8VGb9qy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVdE4-000jXs-Pp; Wed, 29 Sep 2021 17:18:36 +0000
Message-ID: <0132d0cb-5efd-f042-d8d6-720e7f3dc69b@samba.org>
Date:   Wed, 29 Sep 2021 19:18:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Cc:     Jeremy Allison <jra@samba.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
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
 <CAH2r5mvPy0UBJ2z=gSbyOSK9cMYMdB-Unr4Jk14Fve4W1XFTJQ@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAH2r5mvPy0UBJ2z=gSbyOSK9cMYMdB-Unr4Jk14Fve4W1XFTJQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------dD8IzALmUIKW8LQ10fCF1PmY"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------dD8IzALmUIKW8LQ10fCF1PmY
Content-Type: multipart/mixed; boundary="------------2y0TTTHWoxnTOYTnzx5WQwr0";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: Jeremy Allison <jra@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 CIFS <linux-cifs@vger.kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <0132d0cb-5efd-f042-d8d6-720e7f3dc69b@samba.org>
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
 <CAH2r5mvPy0UBJ2z=gSbyOSK9cMYMdB-Unr4Jk14Fve4W1XFTJQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvPy0UBJ2z=gSbyOSK9cMYMdB-Unr4Jk14Fve4W1XFTJQ@mail.gmail.com>

--------------2y0TTTHWoxnTOYTnzx5WQwr0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMjkuMDkuMjEgdW0gMTk6MTEgc2NocmllYiBTdGV2ZSBGcmVuY2g6DQo+IGdpdG51YiBp
cyBmaW5lIGZvciBtYW55IHRoaW5ncywgYW5kIHdlIGNhbiBhdXRvbWF0ZWQgImtlcm5lbA0K
PiBkZXZlbG9wbWVudCBwcm9jZXNzIg0KPiB0aGluZ3MgcHJlc3VtYWJseSB3aXRoIGdpdGh1
YiBlYXNpZXIgdGhhbiBhbHRlcm5hdGl2ZXM6DQo+IC0gcnVubmluZyAic2NyaXB0cy9jaGVj
a3BhdGNoIg0KPiAtIG1ha2Ugd2l0aCBDPTEgYW5kICJfQ0hFQ0tfRU5ESUFOIiBzdXBwb3J0
IHR1cm5lZCBvbg0KPiAtIGtpY2sgb2ZmIHNtYnRvcnR1cmUgdGVzdHMgKGFzIE5hbWphZSBh
bHJlYWR5IGRvZXMgaW4gaGlzIGJyYW5jaGVzIGluIGdpdGh1YikNCg0KeW91IGNhbiBhbHNv
IGFkZCAiZG9pbmcgcmV2aWV3Ii4gOikNCg0KQXMgZm9yIHJ1bm5pbmcgdGVzdHM6IEkgd2Fu
dCB0aGF0IGFzIHdlbGwhIDopIEhvdyBjYW4gSSBnZXQgdGhhdD8gTWF5YmUgDQpvdGhlciB3
YW50IHRvIHJ1biBDSSBvbiB0aGVpciBwYXRjaGVzIHRvbyBiZWZvcmUgcG9zdGluZyB0aGVt
Lg0KDQo+IEJVVCAuLi4gd2UgaGF2ZSB0byBlbnN1cmUgYSBjb3VwbGUgdGhpbmdzLg0KPiAt
IHdlIGRvbid0IGFubm95IExpbnVzIChhbmQgbGludXgtbmV4dCBhbmQgc3RhYmxlIG1haW50
YWluZXJzKSBieSBkb2luZyB0aGluZ3MNCj4gbGlrZSB3ZWIgbWVyZ2VzIGluIGdpdGh1YiAo
aGUgY29tcGxhaW5lZCBhYm91dCB0aGUgbWVhbmluZ2xlc3MvZGlzdHJhY3RpbmcNCj4gZ2l0
aHViIHdlYiB1aSBlbXB0eSBtZXJnZSBtZXNzYWdlcykNCg0KYXMgc2FpZCBiZWZvcmU6IGp1
c3QgZG9uJ3QgZG8gdGhlIG1lcmdlIHRoZXJlLCBqdXN0IHRoZSByZXZpZXcuIFRoYXQncyAN
CnRoZSB3YXkgU2FtYmEgaGFzIGJlZW4gZG9pbmcgaXQgZm9yIHllYXJzLiBBcmUgeW91IGFj
dHVhbGx5IGF3YXJlIG9mIHRoZSANCmN1cnJlbnQgU2FtYmEgd29ya2Zsb3c/DQoNCi1zbG93
DQoNCi0tIA0KUmFscGggQm9laG1lLCBTYW1iYSBUZWFtICAgICAgICAgICAgICAgICBodHRw
czovL3NhbWJhLm9yZy8NClNlck5ldCBTYW1iYSBUZWFtIExlYWQgICAgICBodHRwczovL3Nl
cm5ldC5kZS9lbi90ZWFtLXNhbWJhDQo=

--------------2y0TTTHWoxnTOYTnzx5WQwr0--

--------------dD8IzALmUIKW8LQ10fCF1PmY
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFUn+sFAwAAAAAACgkQqh6bcSY5nkYD
4w/+O1mbClyqwjgAHxBwUEvP5HFqCywW2OvdonjJ7oaj8rMz9yhuaBuKQu8zodn/3k1J70dB1XcA
5x+DXIWsn9mMufteW2/g1lRUnVIe4VgW5/E91FyjZqgiIxc5Y10+TTS48vb1yvTLfR6iz8dc06K+
82URuGFlTZVjmCdi1QD5gy5bTqhARdNriEfyZ3f7Nc8M/tsOfpyk46Yt1x+U2rgMvJb0CCtI4rQj
eVMgiQG1U+kbBBAyJ45BVbshU3W+qgNhflhf9jngMDWs+EmOTfzlRvjgTOr3zKNxtiDfwie1WIA/
155AoXZgiNIcQ0Z3mYSGVPZvjM1tYKhdcxN2iOtpknU8ymxvgJoyoNWVXe35NI0jtgfT3uXRpQbf
DJbIg8CWP6rQjMbRGqhy8puLVAofRheMyDxAZgTGvFuByHdBucAWkb9xXEy0c2MBLhoOecriT8eE
TNDlM1/UvInj1k8Jqr++ANkYRcVtHSXFbKjZ+Pm/62et2DvSbAcOI1j3nbxkrzDd6heubYg/vN6v
CE2c8BmNZ/hVGN5gCTkCFw/qIymv8+FbVwQOmYDEK7pXScgEqxaJy80QxHiN7gHdCVouXF4fFEGT
VubKwGmfonVeCLlN0GfSERhdWtJqDAd1ZA3z7ienVqkcYtEy5Su+x2sPZE4eydkjzJZu5nUy7Jfq
q/4=
=l4V0
-----END PGP SIGNATURE-----

--------------dD8IzALmUIKW8LQ10fCF1PmY--
