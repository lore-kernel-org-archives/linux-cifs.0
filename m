Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0587C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 07:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB04615A7
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 07:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348824AbhI3H6z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Sep 2021 03:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348701AbhI3H6z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Sep 2021 03:58:55 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB38C06161C
        for <linux-cifs@vger.kernel.org>; Thu, 30 Sep 2021 00:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=7kiPfL9DuIXwdIYMgfTgHmOAig5hfI/90LmfJAZQAcQ=; b=Qdmy3khzCPAIY+mxGc5sr36xZP
        0HktFsuec708qM592RCxY9gDYWVEDSCmEAW5botFSn8quTFoFP3SVMj+36bWPuSBorBWAa7tt0t4O
        oQnsNBdvuyq/yZgAAuz2NjBd+2UkCquYhnnVoRAfK42C1oyRZw1F30x0WdRw9KDFSjfYaeu4lynuI
        vzCA30AARsTrFy2hbEy+ECY6JqgSJq1sXoTj+nrwAHmWna080Q5yoUm9Y+Kiw9LN2BOkPD1IdxwOV
        3+cdUJ0ePjg5cgBwfIQFs8hmsdtFS0g/umNasCIAUlw8qmeR2+qBB1eUN43bY21F8Y+ADteS80fV5
        3/TWkxfNC4NQJq5NOlY73TgUtotJDWawwWmEIDd+Lg6dmyQC0m6HYtjcqfDIXEr+sJJWR7SH4wHlK
        eQCxDTsDRp1U+BCvq8GF+UB5UXsB5H5bLOg4TreaKaTecy6zNjUbK6Ai0/86n/9FMfbqUun3gczj2
        bssSKxpSfIuDvGjdSYPzfdlk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVqwH-000qWn-3i; Thu, 30 Sep 2021 07:57:09 +0000
Message-ID: <6253bf85-4410-7fad-2f3f-27a3548baf51@samba.org>
Date:   Thu, 30 Sep 2021 09:57:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Jeremy Allison <jra@samba.org>,
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
 <0132d0cb-5efd-f042-d8d6-720e7f3dc69b@samba.org>
 <CAKYAXd8R2OQ3=m8HjUffph5+hw_D2KaT60ZDsYmEtCqEFE3gQQ@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd8R2OQ3=m8HjUffph5+hw_D2KaT60ZDsYmEtCqEFE3gQQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lrYdt5BYoi0yFvMgIbaI7oiL"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lrYdt5BYoi0yFvMgIbaI7oiL
Content-Type: multipart/mixed; boundary="------------yaK2rbs6BQHotft9dsyINgmb";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Jeremy Allison <jra@samba.org>, CIFS <linux-cifs@vger.kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Hyunchul Lee
 <hyc.lee@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <6253bf85-4410-7fad-2f3f-27a3548baf51@samba.org>
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
 <0132d0cb-5efd-f042-d8d6-720e7f3dc69b@samba.org>
 <CAKYAXd8R2OQ3=m8HjUffph5+hw_D2KaT60ZDsYmEtCqEFE3gQQ@mail.gmail.com>
In-Reply-To: <CAKYAXd8R2OQ3=m8HjUffph5+hw_D2KaT60ZDsYmEtCqEFE3gQQ@mail.gmail.com>

--------------yaK2rbs6BQHotft9dsyINgmb
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMzAuMDkuMjEgdW0gMDI6MzIgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0wOS0z
MCAyOjE4IEdNVCswOTowMCwgUmFscGggQm9laG1lIDxzbG93QHNhbWJhLm9yZz46DQo+PiBh
cyBzYWlkIGJlZm9yZToganVzdCBkb24ndCBkbyB0aGUgbWVyZ2UgdGhlcmUsIGp1c3QgdGhl
IHJldmlldy4gVGhhdCdzDQo+PiB0aGUgd2F5IFNhbWJhIGhhcyBiZWVuIGRvaW5nIGl0IGZv
ciB5ZWFycy4gQXJlIHlvdSBhY3R1YWxseSBhd2FyZSBvZiB0aGUNCj4+IGN1cnJlbnQgU2Ft
YmEgd29ya2Zsb3c/DQo+IElzIGl0IGZyaWVuZGx5IHRvIG5ldyBkZXZlbG9wZXJzPw0KDQp5
ZXMuIEl0J3MganVzdCBhIGRpZmZlcmVudCB0b29saW5nIHlvdSBoYXZlIHRvIHdyYXAgeW91
ciBoZWFkIGFyb3VuZC4gSW4gDQp0aGUgY2FzZSBvZiBTYW1iYSBpdCBoYXMgdGhlIGFkZGVk
IGJlbmVmaXQsIHRoYXQgZXZlcnkgaW50ZXJlc3RlZCANCmNvbnRyaWJ1dG9yIGNhbiBtYWtl
IHVzZSBvZiB0aGUgZnVsbCBTYW1iYSBDSS4gVGhpcyB3b3JrcyBieSB1c2luZyBhIA0Kc2hh
cmVkIHJlcG8gb24gZ2l0bGFiIHdoZXJlIGV2ZXJ5IHJlZ2lzdGVyZWQgZGV2ZWxvcGVyIChz
byB5b3UgaGF2ZSB0byANCmFzayB0byBiZSBhZGRlZCwgYnV0IHRoaXMgaXMgZnJlZWx5IGdy
YW50ZWQpIHdoZXJlIHlvdSBwdXNoIHlvdXIgDQpwYXRjaHNldCB0byBhIGJyYW5jaCBuYW1l
IHByZWZpeGVkIHdpdGggeW91ciB1c2VybmFtZSAodG8gYXZvaWQgc3RlcHBpbmcgDQpvbiBz
b21lb25lIGVsc2UncyBicmFuY2gpLiBUaGF0IHRyaWdnZXJzIGFuIGF1dG9tYXRlZCAqZnVs
bCogQ0kgcnVuLCBzbyANCm5ldyBjb250cmlidXRvcnMgY2FuIGJlIHN1cmUgbm90IHRvIHdh
c3RlIHRpbWUgb2Ygb3RoZXIgZGV2ZWxvcGVycyANCmJlZm9yZSBhc2tpbmcgZm9yIHJldmll
dy4NCg0KPiBJIGtub3cgc2FtYmEgd29ya2Zsb3cgbm93IHRvby4gTmV3DQo+IGRldmVsb3Bl
cnMgY2FuIGRvIGV2ZXJ5dGhpbmcgZWFzaWx5IGJ5IHNpbXBseSBzdWJzY3JpYmluZyB0byB0
aGUNCj4gbWFpbGluZyBsaXN0LiANCg0KU3VyZSwgaW5zdGVhZCBvZiBwdXNoaW5nIHRoZSBy
ZXN1bHRpbmcgcGF0Y2hzZXQgZnJvbSB0aGUgcmV2aWV3IG9mIHlvdXIgDQpwYXRjaHNldCB0
byBhIGdpdGh1YiBicmFuY2gsIEkgY291bGQgc2VuZCBteSBwYXRjaHNldCB0byB0aGUgTUwu
DQoNCkhhdmluZyBub3cgdXNlZCBhIG1vcmUgYSBkaWZmZXJlbnQgd29ya2Zsb3cgZm9yIGEg
ZmV3IHllYXJzLCBJIA0KYXBwcmVjaWF0ZSBob3cgbXVjaCBtb3JlIG5hdHVyYWwgaXQgZmVl
bHMgdG8gc2hhcmUsIHdvcmsgb24gYW5kIHJldmlldyANCmNvZGUgd2l0aCBhIHRvb2xpbmcg
dGhhdCBpcyBtdWNoIG1vcmUgaW50ZXJncmF0ZWQgdG8gZ2l0Lg0KDQpTbyB3aGF0IEknZCBs
aWtlIHRvIHByb3Bvc2UgZm9yIG5vdyBpcyBsZXQncyBzdGljayB0byB0aGUgTUwgZm9yIG5v
dywgDQpuZXh0IHRpbWUgSSB3aWxsIHNlbmQgbXkgcGF0Y2hzZXQgdG8gdGhlIE1MIGluc3Rl
YWQsIGJ1dCBsZXQncyBhbHNvIA0KY29uc2lkZXIgYW5kIG1heWJlIHRlc3QgZGlmZmVyZW50
IHBvc3NpYmxlIHRvb2xpbmdzLg0KDQo+IEFuZCBkbyB3ZSByZXZpZXcgb25seSB0aGUgU01C
IHByb3RvY29sIG9uIGdpdGh1Yj8gSWYgd2UNCj4gcmV2aWV3IGFuZCBkaXNjdXNzIGtlcm5l
bCBjb21tb24gY29kZSB1c2FnZSBhbmQgdG91Y2hpbmcsIGl0IHNob3VsZCBiZQ0KPiB2aXNp
YmxlIHRvIHRoZSBjb21wb25lbnQga2VybmVsIG1haW50YWluZXJzIGFzIHdlbGwuDQo+IA0K
PiBBbmQgaXMgdGhlIHJldmlldyBoaXN0b3J5IGxpa2VseSB0byBiZSBkaXNjYXJkZWQgb24g
Z2l0aHViPw0KDQpJIGRvbid0IHRoaW5rIHNvLCBJJ20gbm90IDEwMCUgc3VyZSBvbiB0aGlz
IHRob3VnaC4gQnV0IGFzIGl0J3MgTk9UIA0KZGlzY2FyZGVkIG9uIGdpdGxhYiwgSSBndWVz
cyBnaXRodWIgd2lsbCBtYXRjaCBmZWF0dXJlIHdpc2UuDQoNCj4gRG9lc24ndCBpdA0KPiBn
ZXQgdGhyb3duIGF3YXkgdGhlIG1vbWVudCB5b3UgY2hhbmdlIG9yIHVwZGF0ZSBhIHBhdGNo
PyBBbHNvLCByZXZpZXcNCj4gZGlzY3Vzc2lvbnMgbGVmdCBvbiBlYWNoIGluZGl2aWR1YWwn
cyBnaXRodWIgY2Fubm90IGJlIGVhc2lseSBzZWFyY2hlZA0KPiBsaWtlIG1haWxpbmcgbGlz
dC4NCg0KWWVhaCwgYnV0IGRvZXMgdGhhdCByZWFsbHkgbWF0dGVyPyBTbyBmYXIgdGhpcyB3
YXMgbm90IG1pc3NlZCBpbiB0aGUgDQpTYW1iYSBnaXRsYWIgdG9vbGluZy4NCg0KLXNsb3cN
Cg0KLS0gDQpSYWxwaCBCb2VobWUsIFNhbWJhIFRlYW0gICAgICAgICAgICAgICAgIGh0dHBz
Oi8vc2FtYmEub3JnLw0KU2VyTmV0IFNhbWJhIFRlYW0gTGVhZCAgICAgIGh0dHBzOi8vc2Vy
bmV0LmRlL2VuL3RlYW0tc2FtYmENCg==

--------------yaK2rbs6BQHotft9dsyINgmb--

--------------lrYdt5BYoi0yFvMgIbaI7oiL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFVbdQFAwAAAAAACgkQqh6bcSY5nka4
7g//aqsucdU4qdhOoid/J8/kEDboR+zb2sqnNJrR3VbQPYDqwoh+VaHkdjM4OANO41aFpqGeM7Wn
CI8k9K0Rz+qyM+f9khG7zcGeb3swvYJa5qFL8Lv+2ED0WK5mawsOY8Z1yUch2q/wK0v+PpMsUGCB
UMkWZyyD0ClclVpXln5HfOyorfofs8/QWWJJ30GqnPQflLSW7daV4RTKSKd+lEFet2bzfrfgFy5F
n41yw33zYgGyMWcB6re1v9tgBJV5aFTFoBERa7y47SJDNAYHS+9/iZDAUSzn9S0+e9A4w4QLtp0U
59DRIf3MDgCkPM83xynGFm8F8DhyCcSXAiQII5sDyPeyEMvsn0t2mtpEXQ5C+mi1IcUFqA8tQPAM
drUH0pKX0ckLhPJM+3Zqxga9vLS2POEzbBZsoa67ZMApdW8DtKRl2UpWCPhF/v0TUHC9EFU/CHxl
wF8cCYaQs3d9rU0Qt2IjQphOvroBMdh19RRBWzARPI7Q0OFanKl4OK76yn1X3fblGcNKGnJXImaR
f58V4HTtS40+uXbAEL1qIwT0Wza41zQqJ+xOtqgL8NrFbFoLjvoqUSfcTPItDncwEzipb4+nJckW
9LjcAHnSY2N6XOOHg9uxYzUdhwudtP+C0MVMrMsrj4w6l14xxwZQFOwo++ujYXKFYT22+xV5wNCI
qdY=
=EJXh
-----END PGP SIGNATURE-----

--------------lrYdt5BYoi0yFvMgIbaI7oiL--
