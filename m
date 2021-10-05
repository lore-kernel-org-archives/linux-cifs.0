Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC75C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 04:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A2A761502
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 04:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhJEE0a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhJEE0a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 00:26:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25D3C061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 21:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=kRKATGOSLcS+DDK73tTSbQ+NF9+nVxeGri8Qb1u3SP0=; b=XGVf22lHJxRllUG6r8J0mvFCjW
        ePxe0Bs11BKO6DZozqUEkw+4lxx+0GK2djZ/GnJiXusMz8GXSt92bheIaq1e8CPndDZIVuOo41a7w
        EFIguHlFbT0o7V9M7EFZaRp5W1qWqopvSC0WRDQzWSWqK1tQwiSQaJKRSXaI1i8XxkYKh58G9C5Z3
        o2gQWhDrBLjthlpRfHzWYS1NCBq+k3jVfBG3Y+u/flkf9wQpGnEbNZkkBAaAllcLppzSd6T5IarsD
        AFDYo0bhcnjYm1I8gaJCTmQ6hsmvM5Yz+7s3AhT3sd4PLAMppzpMeVLryxplQUTvVhSjXp+t9FduG
        S7cvMbAnF6JTJW1cg3YBufMDrfID7zEQEPJJW4TYPwbyYrBw850hXTj9ArcSpXvFzroUa6fts0F7K
        mA5tgnpsqILEwF74tQNXTW5rYqpaZeesuDFbHM1HPhHVv7le9Xxw4oy5SIwIMB7bQ351e9LYoPysW
        QUciFln8m4ar4KhwH0kc6mFB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXc0K-001Ylq-LG; Tue, 05 Oct 2021 04:24:36 +0000
Message-ID: <65d4498e-e0c0-2390-a8d3-e3d82e1fe2ec@samba.org>
Date:   Tue, 5 Oct 2021 06:24:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v6 01/14] ksmbd: add the check to vaildate if stream
 protocol length exceeds maximum value
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20211002131212.130629-1-slow@samba.org>
 <20211002131212.130629-2-slow@samba.org>
 <CAKYAXd8X_8nAvLXxna8kAHfce1jxz4-TH1j1h6g3ufjc7WpYXw@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd8X_8nAvLXxna8kAHfce1jxz4-TH1j1h6g3ufjc7WpYXw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------JpAPYkCwwIPDwfV4TAgS07d9"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------JpAPYkCwwIPDwfV4TAgS07d9
Content-Type: multipart/mixed; boundary="------------ly1ZO4VIzhA1lI0CxESA6UyE";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>,
 Hyunchul Lee <hyc.lee@gmail.com>
Message-ID: <65d4498e-e0c0-2390-a8d3-e3d82e1fe2ec@samba.org>
Subject: Re: [PATCH v6 01/14] ksmbd: add the check to vaildate if stream
 protocol length exceeds maximum value
References: <20211002131212.130629-1-slow@samba.org>
 <20211002131212.130629-2-slow@samba.org>
 <CAKYAXd8X_8nAvLXxna8kAHfce1jxz4-TH1j1h6g3ufjc7WpYXw@mail.gmail.com>
In-Reply-To: <CAKYAXd8X_8nAvLXxna8kAHfce1jxz4-TH1j1h6g3ufjc7WpYXw@mail.gmail.com>

--------------ly1ZO4VIzhA1lI0CxESA6UyE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDMuMTAuMjEgdW0gMDM6MTggc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0xMC0w
MiAyMjoxMSBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
RnJvbTogTmFtamFlIEplb24gPGxpbmtpbmplb25Aa2VybmVsLm9yZz4NCj4+DQo+PiBUaGlz
IHBhdGNoIGFkZCBNQVhfU1RSRUFNX1BST1RfTEVOIG1hY3JvIGFuZCBjaGVjayBpZiBzdHJl
YW0gcHJvdG9jb2wNCj4+IGxlbmd0aCBleGNlZWRzIG1heGltdW0gdmFsdWUuIG9wZW5jb2Rl
IHBkdSBzaXplIGNoZWNrIGluDQo+PiBrc21iZF9wZHVfc2l6ZV9oYXNfcm9vbSgpLg0KPj4N
Cj4+IENjOiBUb20gVGFscGV5IDx0b21AdGFscGV5LmNvbT4NCj4+IENjOiBSb25uaWUgU2Fo
bGJlcmcgPHJvbm5pZXNhaGxiZXJnQGdtYWlsLmNvbT4NCj4+IENjOiBSYWxwaCBCw7ZobWUg
PHNsb3dAc2FtYmEub3JnPg0KPj4gQ2M6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwu
Y29tPg0KPj4gQ2M6IFNlcmdleSBTZW5vemhhdHNreSA8c2Vub3poYXRza3lAY2hyb21pdW0u
b3JnPg0KPj4gQWNrZWQtYnk6IEh5dW5jaHVsIExlZSA8aHljLmxlZUBnbWFpbC5jb20+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwub3JnPg0K
Pj4gLS0tDQo+PiAgIGZzL2tzbWJkL2Nvbm5lY3Rpb24uYyB8IDkgKysrKystLS0tDQo+PiAg
IGZzL2tzbWJkL3NtYl9jb21tb24uYyB8IDYgLS0tLS0tDQo+PiAgIGZzL2tzbWJkL3NtYl9j
b21tb24uaCB8IDQgKystLQ0KPj4gICAzIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygr
KSwgMTIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2ZzL2tzbWJkL2Nvbm5l
Y3Rpb24uYyBiL2ZzL2tzbWJkL2Nvbm5lY3Rpb24uYw0KPj4gaW5kZXggYWYwODZkMzUzOThh
Li5lNTAzNTNjNTA2NjEgMTAwNjQ0DQo+PiAtLS0gYS9mcy9rc21iZC9jb25uZWN0aW9uLmMN
Cj4+ICsrKyBiL2ZzL2tzbWJkL2Nvbm5lY3Rpb24uYw0KPj4gQEAgLTI5NiwxMCArMjk2LDEx
IEBAIGludCBrc21iZF9jb25uX2hhbmRsZXJfbG9vcCh2b2lkICpwKQ0KPj4gICAJCXBkdV9z
aXplID0gZ2V0X3JmYzEwMDJfbGVuKGhkcl9idWYpOw0KPj4gICAJCWtzbWJkX2RlYnVnKENP
Tk4sICJSRkMxMDAyIGhlYWRlciAldSBieXRlc1xuIiwgcGR1X3NpemUpOw0KPj4NCj4+IC0J
CS8qIG1ha2Ugc3VyZSB3ZSBoYXZlIGVub3VnaCB0byBnZXQgdG8gU01CIGhlYWRlciBlbmQg
Ki8NCj4+IC0JCWlmICgha3NtYmRfcGR1X3NpemVfaGFzX3Jvb20ocGR1X3NpemUpKSB7DQo+
PiAtCQkJa3NtYmRfZGVidWcoQ09OTiwgIlNNQiByZXF1ZXN0IHRvbyBzaG9ydCAoJXUgYnl0
ZXMpXG4iLA0KPj4gLQkJCQkgICAgcGR1X3NpemUpOw0KPj4gKwkJLyoNCj4+ICsJCSAqIENo
ZWNrIGlmIHBkdSBzaXplIGlzIHZhbGlkIChtaW4gOiBzbWIgaGVhZGVyIHNpemUsDQo+PiAr
CQkgKiBtYXggOiAweDAwRkZGRkZGKS4NCj4+ICsJCSAqLw0KPj4gKwkJaWYgKHBkdV9zaXpl
ID4gTUFYX1NUUkVBTV9QUk9UX0xFTikgew0KPiBZb3UgY2hhbmdlZCB0aGlzIHBhdGNoIG5v
dCB0byBjaGVjayBoZWFkZXIgc2l6ZSBjaGVjay4NCg0KeWVzLCBvbiBwdXJwb3NlLiBCZWNh
dXNlIEkgdGhvdWdoIHRoYXQgeW91ciBjaGFuZ2Ugd2FzIHdyb25nIGFuZCB0aGUgDQp3aG9s
ZSBsb2dpYyBzaG91bGQgYmUgZG9uZSBkaWZmZXJlbnRseS4gVW5mb3J0dW5hdGVseSBJIG1p
c3NlZCB0aGUgZmFjdCANCnRoYXQgdGhlcmUgYXJlIGEgYnVuY2ggb2Ygb3RoZXIgcGxhY2Vz
IHdoZXJlIGhlYWRlciBkYXRhIGlzIGFjY2Vzc2VkIA0KZWFybHksIGJlZm9yZSByZWFjaGlu
ZyBrc21iZF9zbWIyX2NoZWNrX21lc3NhZ2UoKSB3aGVyZSBJIHdhbnRlZCB0byANCmNvbnNv
bGlkYXRlIHRoZSBjaGVja3MuDQoNCj4gSSB0aGluayB0aGF0DQo+IHRoaXMgcGF0Y2ggc2hv
dWxkIGJlIGJhY2tlZCB0byBvcmlnaW5hbCBvbmUuDQo+IEJlY2F1c2UgeW91ciBwYXRjaGVz
IGFyZQ0KPiBjbGVhbi11cCBwYXRjaGVzLCBub3QgZml4ZXMuDQoNCnRoZXJlIGFyZSB0d28g
bW9yZSBpbnZhbGlkIHJlYWRzIHRoYXQgdGhlIHBhdGNoc2V0IGFkZHJlc3MuDQoNCkJ1dCBh
Z3JlZWQsIEkgd2lsbCBub3cgc2ltcGx5IHdvcmsgbXkgcGF0Y2hlcyBvbi10b3Agb2YgeW91
cnMuDQoNClRoYW5rcyENCi1zbG93DQoNCi0tIA0KUmFscGggQm9laG1lLCBTYW1iYSBUZWFt
ICAgICAgICAgICAgICAgICBodHRwczovL3NhbWJhLm9yZy8NClNlck5ldCBTYW1iYSBUZWFt
IExlYWQgICAgICBodHRwczovL3Nlcm5ldC5kZS9lbi90ZWFtLXNhbWJhDQo=

--------------ly1ZO4VIzhA1lI0CxESA6UyE--

--------------JpAPYkCwwIPDwfV4TAgS07d9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFb04IFAwAAAAAACgkQqh6bcSY5nka6
+Q/7BD67QVnTXuguQQXtT6soNhDEr0bL9QpcYIyj5GwAbq+lXFMLRelRUx2gVnrkzCPRpH1rjVUM
r/kI+S5lVjr+yk/pM22arPVRD1SvR90ESTwbKTEsV2Xf8NNd/T/cnroTQXfNzRS2ffVbukyG8l0H
Wt3LeKH++HWps2GQ1nOMm4tn4lAcgTmxGMY9YmQRDEmOWCGuHR9epoZ8LxQJORX5ORURr7M0E9bX
+eoXRo2yIYxFjPnbXLAHF0jp/natbpzYC8w99fyDdRl8LP0OpRJvheuNOlZDh2dzaO2bpzgtEVwa
vNYOZN+U1ic5pXa74nJOd7PzpAzg8ZLb6/dfUjrcoYecxb4z3L9raFkndS9AJPISUc0TznksPDzg
v12/boc3dZcbx/1PFG6iP4TGolbWmJxXaAnZeX49LOaE61E/9EAhA652X5EbyDl5x55b1zZ5USIV
EdRaTdjKGIYr47FD4F4qNK5JCSZluKGwT+/cHFcZyN0mgqFRyFf6/J0X5IG+Pe854Wbm130tF74r
Dd8StTk845HpIHQzlXWy2xdGj7VHdxfFS0jKvkM/f0PE9Yji56sZfQJ66mfDMsNBnl1ax14eAQWx
tCaLho56aFzA6nMpK0zZ2jeiUCyUa9HGrI7pZ/4rJmvggI4S1Jgd75RccuW6DS3K6aQbHzSsNGaN
2PE=
=ymtv
-----END PGP SIGNATURE-----

--------------JpAPYkCwwIPDwfV4TAgS07d9--
