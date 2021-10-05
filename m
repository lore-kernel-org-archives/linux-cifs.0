Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD875C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 04:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84FB061216
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 04:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhJEEeP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhJEEeP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 00:34:15 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1F2C061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 21:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=t7dIU8L6lfYCE5X0CGDatiAzi/CEucdC2q6WfHkc48k=; b=NX1bUIfBNU/1KDv5J2OpjXLyek
        T6FYBifc+q2tLTeOAwTF4ukDuKSP83db4I1E2uDmjrzzgcUdsLZMur4xGjyQEj+6VoK5T/UiDdS/M
        Emy/MHmPYcX4zvoroy8HManvwoxLlbrTZHIrwy62ycH5AZN2zEIN/xrzKGoUyM9wwoADTyX21QTWH
        GogFXkZCQJ07oH/4I8jq3PpjFIHYzXFmvHYxX55VIpLsZBzGA0yJDKYZYeRnwnPNLYQeiQHpt2dsg
        Ms/n+P6Zl9v34QH6VAzrBabcs/S2mgIi6Jf8rGMASRwbIdNvSCd11/XNRD8gK0Y6NZqtdMU3X2ZbN
        DqRLd5N92flpYbviEyGB8qnUoefzZ+MiSYYBZNAmYztviO3fgIPIDiJoT1R/btyeTsD6XDBibRpAN
        dO7b0TmXb2pMA+gLYzEs99YPJoNV8fgQ/vQTjHx8sKzhpqEvjCnO7cAi2jpY9e4FLRpNRcSDsby13
        K/t6f8phts1UESV7bYuKra4l;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXc7q-001Yp3-ON; Tue, 05 Oct 2021 04:32:22 +0000
Message-ID: <37928509-d0e8-1a7c-a6f2-9e291fdb45f0@samba.org>
Date:   Tue, 5 Oct 2021 06:32:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v6 09/14] ksmbd: check PDU len is at least header plus
 body size in ksmbd_smb2_check_message()
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20211002131212.130629-1-slow@samba.org>
 <20211002131212.130629-10-slow@samba.org>
 <CAKYAXd-ZL6so9yBiUpY6MTa95s00M4=+H5RVLeAy5J-+q2FHVw@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd-ZL6so9yBiUpY6MTa95s00M4=+H5RVLeAy5J-+q2FHVw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------6NC3cYvVDlnpv1uJcWDAhQyZ"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------6NC3cYvVDlnpv1uJcWDAhQyZ
Content-Type: multipart/mixed; boundary="------------t9pbT0YuzDmLwg6N7ht3Tzmv";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>
Message-ID: <37928509-d0e8-1a7c-a6f2-9e291fdb45f0@samba.org>
Subject: Re: [PATCH v6 09/14] ksmbd: check PDU len is at least header plus
 body size in ksmbd_smb2_check_message()
References: <20211002131212.130629-1-slow@samba.org>
 <20211002131212.130629-10-slow@samba.org>
 <CAKYAXd-ZL6so9yBiUpY6MTa95s00M4=+H5RVLeAy5J-+q2FHVw@mail.gmail.com>
In-Reply-To: <CAKYAXd-ZL6so9yBiUpY6MTa95s00M4=+H5RVLeAy5J-+q2FHVw@mail.gmail.com>

--------------t9pbT0YuzDmLwg6N7ht3Tzmv
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDMuMTAuMjEgdW0gMDM6MTEgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0xMC0w
MiAyMjoxMiBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
Tm90ZTogd2UgYWxyZWFkeSBoYXZlIHRoZSBzYW1lIGNoZWNrIGluIGlzX2NoYWluZWRfc21i
Ml9tZXNzYWdlKCksIGJ1dCB0aGVyZQ0KPj4gaXQNCj4+IG9ubHkgYXBwbGllcyB0byBjb21w
b3VuZCByZXF1ZXN0cywgc28gd2UgaGF2ZSB0byByZXBlYXQgdGhlIGNoZWNrIGhlcmUgdG8N
Cj4+IGNvdmVyDQo+PiBib3RoIGNhc2VzLg0KPj4NCj4+IENjOiBOYW1qYWUgSmVvbiA8bGlu
a2luamVvbkBrZXJuZWwub3JnPg0KPj4gQ2M6IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29t
Pg0KPj4gQ2M6IFJvbm5pZSBTYWhsYmVyZyA8cm9ubmllc2FobGJlcmdAZ21haWwuY29tPg0K
Pj4gQ2M6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29tPg0KPj4gQ2M6IEh5dW5j
aHVsIExlZSA8aHljLmxlZUBnbWFpbC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBSYWxwaCBC
b2VobWUgPHNsb3dAc2FtYmEub3JnPg0KPj4gLS0tDQo+PiAgIGZzL2tzbWJkL3NtYjJtaXNj
LmMgfCAzICsrKw0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+Pg0K
Pj4gZGlmZiAtLWdpdCBhL2ZzL2tzbWJkL3NtYjJtaXNjLmMgYi9mcy9rc21iZC9zbWIybWlz
Yy5jDQo+PiBpbmRleCA3ZWQyNjZlYjZjNWUuLjU0MWIzOWI3YTg0YiAxMDA2NDQNCj4+IC0t
LSBhL2ZzL2tzbWJkL3NtYjJtaXNjLmMNCj4+ICsrKyBiL2ZzL2tzbWJkL3NtYjJtaXNjLmMN
Cj4+IEBAIC0zMzgsNiArMzM4LDkgQEAgaW50IGtzbWJkX3NtYjJfY2hlY2tfbWVzc2FnZShz
dHJ1Y3Qga3NtYmRfd29yayAqd29yaykNCj4+ICAgCWlmIChjaGVja19zbWIyX2hkcihoZHIp
KQ0KPj4gICAJCXJldHVybiAxOw0KPj4NCj4+ICsJaWYgKGxlbiA8IHNpemVvZihzdHJ1Y3Qg
c21iMl9wZHUpIC0gNCkNCj4+ICsJCXJldHVybiAxOw0KPiBUaGUgcG9pbnQgSSdtIHRhbGtp
bmcgYWJvdXQgaXMgYW4gaXNzdWUgY2F1c2VkIGJ5IHlvdSBtb3ZpbmcgdGhlDQo+IGhlYWRl
ciBidWZmZXIgc2l6ZSBoZXJlIGZpcnN0KCBhbmQgeW91IHJlbW92ZSBoZWFkZXIgYnVmZmVy
IHNpemUgY2hlY2sNCj4gaW4ga3NtYmRfY29ubl9oYW5kbGVyX2xvb3AoKS4pDQo+IFdoZW4g
SSBhcHBseSBwYXRjaCB0aWxsIDA5LzE0IG51bWJlciwgY2hlY2tfdXNlcl9zZXNzaW9uKCkg
YW5kDQo+IGdldF9rc21iZF90Y29uKCkgaXMgc3RpbGwgaGFzIHByb2JsZW0gdGhhdCBhY2Nl
c3MgaGVhZGVyIHdpdGhvdXQNCj4gaGVhZGVyIGJ1ZmZlciBzaXplIGNoZWNrLg0KPiANCj4g
QW5kIHRoZXJlIHN0aWxsIGFyZSBmdW5jdGlvbnMgdG8gYWNjZXNzIGhlYWRlciB3aXRob3V0
IGhlYWRlciBidWZmZXINCj4gc2l6ZSBjaGVjay4gUGxlYXNlIGNoZWNrIGFsbG9jYXRlX3Jz
cF9idWYoKSwgaXNfdHJhbnNmb3JtX2hkcigpIGFuZA0KPiBpbml0X3JzcF9oZHIoKSBpbiBf
X2hhbmRsZV9rc21iZF93b3JrKCkuDQoNCm9oLCB0aGF0J3MgYSBwcm9ibGVtLCBtaXNzZWQg
dGhhdCwgc29ycnkuIExvb2tzIGxpa2Ugd2UgaGF2ZSB0byBrZWVwIHRoZSANCnZhbGlkYXRp
b24gYXQgdGhpcyBsYXllci4gOigNCg0KLXNsb3cNCg0KLS0gDQpSYWxwaCBCb2VobWUsIFNh
bWJhIFRlYW0gICAgICAgICAgICAgICAgIGh0dHBzOi8vc2FtYmEub3JnLw0KU2VyTmV0IFNh
bWJhIFRlYW0gTGVhZCAgICAgIGh0dHBzOi8vc2VybmV0LmRlL2VuL3RlYW0tc2FtYmENCg==


--------------t9pbT0YuzDmLwg6N7ht3Tzmv--

--------------6NC3cYvVDlnpv1uJcWDAhQyZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFb1VQFAwAAAAAACgkQqh6bcSY5nkY+
txAAgRbLRIOL3uC4kPo3akBfEETJ52384PKg7zRmRcLYaqG7hvhwoqOhbVHsSXV+D6Yz7SzVEmTQ
vtCs0U141hd5lkdttUfwA506Vd1DRdvkip3vhPqXhuE5FuXs15PMdN6xB2wv2P92zzryNKht64j+
a5L3iykmkjqy/+WJ8mNmFFSehfAmkEnrha4YiRM+PAROvEBXeA5ikf28870BPrhinKqEeRYyeyO9
iNfabHkmj+/OLodOunFZ+RnZyF67nlAGNzlOlPHCAGvn0TqwZQZ7E5UolFu64o3ELi/nhPC5lnl8
iiRHJsXBvXRzUtuRTS1iEeMhXJixyZhqyUC9TwXjHyPhQjMJjtBp+6EXIcMQgs9iMJhgDQPo8Kml
dcBcCSmWpJnURder4C9oguuwuLiT3iVlqazcpx9b2JWvWycamgd05siUhEB3jfX/KckBg95tCpYk
Z+uOTa7/GzziEOywm4Yr2WfrUVoNLRIyUojReLKMjKoymioTf0KQXCsJ1BXUYCDQ/jfk1l2aTvmZ
Ufo7+rxqP/TirUvJ80Ro7HArNSQpv4HjsmV8sHXJdQ+0aRzJC5O5qjaHnJKqsHASBQgfO6mkEev7
FZGHsv48HXGlfPLpCkyCYNpULDuOThSPITmHxvvk9H8BXl0Q+OLpD0JBWFfFhO/tdf3ilbFftP6D
SEg=
=b4bN
-----END PGP SIGNATURE-----

--------------6NC3cYvVDlnpv1uJcWDAhQyZ--
