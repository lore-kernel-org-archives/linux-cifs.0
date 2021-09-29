Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFBAC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 16:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04A8261406
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 16:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345616AbhI2QkC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 12:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344376AbhI2QkB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 12:40:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64CAC06161C
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 09:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=j4ZbHmr6GTXCOF5fgpFlTMATwwQ7LPbnAicoGuQgtqw=; b=H4g5TNYtKdax03PBWA3Qjagc3o
        AFnq8kGGRJJ9P6POjaiBW9aQH9w3Vp93pqF7FZzdWXKCpJtX+sMywQVO1lBNE/Xe0o4eyC60hlqc2
        jAJzx92qRMSsZ4/Xar98fH0wuQzt90WOGC+mCD3OO1GnlVBoozOYBzHIKD8GdaGtb2ZliUOCRRBVq
        AfGVNqDndmac4NcpSJwBTpSL1vZT9KDirTpyLFohNJI8fPVFU6n60hOqveg3KGrJjQMIlR04KfoIt
        6v4xvIIvm6ukDeJ69PXfysVWko4lxrb21RQ5EW93pXGao96zRfSr31rzEtfrx1L/6yBB7nyMznmh7
        Xjmbz0J0n6Uo2imQcVLKomRVPRowinhjJFQCS6K8gS/wASGlyNH8H6ZVP2EMkmKfJqmNAEsZHiD/P
        8HSSaJSbEhf2Zl47p1Zeu+3sznQbQ4v1b+/yY48LlZdh2BmtbOX0qvfLmioTVl13lsnY3OMNlriVb
        tqtxKzrqWL/nRwK5yUZMQ+iI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVcb2-000jBw-F7; Wed, 29 Sep 2021 16:38:16 +0000
Message-ID: <ce52c130-74de-feaa-6995-6a0d947816a6@samba.org>
Date:   Wed, 29 Sep 2021 18:38:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
Content-Language: en-US
To:     Jeremy Allison <jra@samba.org>, Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
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
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <YVSJWPa8dalyzsl0@jeremy-acer>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------JQU73VJOk4tWyWG0XpSyGNh7"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------JQU73VJOk4tWyWG0XpSyGNh7
Content-Type: multipart/mixed; boundary="------------cY69AeZ7wTQfPNFoMscqg9bc";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Jeremy Allison <jra@samba.org>, Tom Talpey <tom@talpey.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <ce52c130-74de-feaa-6995-6a0d947816a6@samba.org>
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
In-Reply-To: <YVSJWPa8dalyzsl0@jeremy-acer>

--------------cY69AeZ7wTQfPNFoMscqg9bc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMjkuMDkuMjEgdW0gMTc6NDIgc2NocmllYiBKZXJlbXkgQWxsaXNvbjoNCj4gT24gV2Vk
LCBTZXAgMjksIDIwMjEgYXQgMTE6Mjg6MDlBTSAtMDQwMCwgVG9tIFRhbHBleSB3cm90ZToN
Cj4+DQo+PiBJIGNvbXBsZXRlbHkgYWdyZWUgdGhhdCBlbWFpbCBpcyBpbmVmZmljaWVudCwg
YnV0IGdpdCBpcyBhIHRlcnJpYmxlDQo+PiB3YXkgdG8gaGF2ZSBhIGRpc2N1c3Npb24uIFdl
IHNob3VsZCBhdHRlbXB0IHRvIGJlIHN1cmUgd2UgaGF2ZQ0KPj4gdGhvc2UsIGFuZCB0aGF0
IGV2ZXJ5Ym9keSBoYXMgYSBjaGFuY2UgdG8gc2VlIHRoZSBwcm9wb3NhbHMgd2l0aG91dA0K
Pj4gaGF2aW5nIHRvIGdvIHRvIHRoZSB3ZWIgZml2ZSB0aW1lcyBhIGRheS4NCj4+DQo+PiBQ
bGVhc2UgdGFrZSB0aGlzIGFzIGEgcmVxdWVzdCBmb3IgcmVndWxhciBnaXQtc2VuZC1lbWFp
bCB1cGRhdGVzIHRvDQo+PiB0aGlzIGxpc3QsIHNvIEkgY2FuIHNlZSB0aGVtIGlmIEknbSBu
b3Qgb25saW5lLiBNYXliZSBhZGQgYSBib2lsZXJwbGF0ZQ0KPj4gbGluZSB0byBkaXJlY3Qg
dG8gdGhlIGdpdCByZXBvIHdlYnVpLiBJJ20gc3VyZSBhIGZldyBvdGhlcnMgd2lsbA0KPj4g
YXBwcmVjaWF0ZSBpdCB0b28uDQo+IA0KPiBTYW1iYSBkb2VzIHdlbGwgd2l0aCB0aGUgd2Vi
LWJhc2VkIGRpc2N1c3Npb24gbWVjaGFuaXNtDQo+IGFyb3VuZCBtZXJnZS1yZXF1ZXN0cyAo
TVIncykgaW4gZ2l0bGFiLiBJIGFzc3VtZSBnaXRodWINCj4gaGFzIHNvbWV0aGluZyBzaW1p
bGFyLg0KPiANCj4gTWF5YmUgc2VuZCB0aGUgaW5pdGlhbCBwYXRjaCB0byB0aGUgbGlzdCB3
aXRoIGEgbGluaw0KPiB0byB0aGUgZ2l0aHViIE1SIHNvIHBlb3BsZSBpbnRlcmVzdGVkIGlu
IHJldmlld2luZy9kaXNjdXNzaW5nDQo+IGNhbiBmb2xsb3cgYWxvbmcgdGhlcmUgPw0KDQp3
ZWxsLCBpZiBJIGNvdWxkIGhhdmUgaXQgdGhlIHdheSBJIHdhbnRlZCwgdGhlbiB0aGlzIHdv
dWxkIGJlIGl0LiBCdXQgSSANCnVuZGVyc3RhbmQgdGhhdCBhZG9wdGluZyBuZXcgd29ya2Zs
b3dzIGlzIG5vdCBzb21ldGhpbmcgSSBjYW4gaW1wb3NlIC0tIA0KYXQgbGVhc3Qgbm90IHdp
dGhvdXQgcGF5aW5nIGZvciBhbiBpbnNhbmUgYW1vdW50IG9mIExha3JpdHotR2l0YXJyZW4g
DQp0aGF0IEkgdGVuZCB0byB1c2UgdG8gYnJpYmUgbWV0emUgaW50byBkb2luZyBzb21ldGhp
bmcgSSB3YW50IGhpbSB0byBkby4gOikNCg0KVGhlIHByb2JsZW0gaXMgbm90IHNvIG11Y2gg
ZG9pbmcgdGhlICpyZXZpZXcqIG9uIHBhdGNoZXMgc2VudCB0byB0aGUgDQpsaXN0LiBXaGls
ZSBTYW1iYSBoYXMgbW92ZWQgYXdheSBmcm9tIGRvaW5nIHJldmlldyBvbiBwYXRjaCBlbWFp
bHMsIGl0IA0KY2FuIGNlcnRhaW5seSBiZSBkb25lLg0KDQpUaGUgcG9pbnQgaXMsIG9uY2Ug
eW91IGdvIGJleW9uZCAicmV2aWV3IiBieSB0YWtpbmcgc29tZW9uZSBlbHNlJ3MgDQpwYXRj
aHNldCwgbW9kaWZ5aW5nIGl0IGRlZXBseSwgcmVvcmRlcmluZyBwYXRjaGVzLCBhZGRpbmcg
cGF0Y2hlcywgDQpyZXdyaXRpbmcgcGF0Y2hlcywgZHJvcHBpbmcgcGF0Y2hlcyBhbmQgc28g
b24sIHRoYXQncyB3aGVuIHRoZSANCnBhdGNoc2V0LWFzLWVtYWlsIHdvcmtmbG93IGV4cGxv
ZGVzIGFuZCBjb29yZGluYXRpb24gdmlhIGdpdCBpcyBuZWVkZWQuDQoNCk9uY2Ugc3VjaCBh
IGNvbGxhYm9yYXRpdmVseSB3b3JrZWQgb24gcGF0Y2hzZXQgc3RhYmlsaXplcywgaXQgY2Fu
IG9mIA0KY291cnNlIGFnYWluIGdvIHRvIHRoZSBtYWlsaW5nIGxpc3QuDQoNCi1zbG93DQoN
Ci0tIA0KUmFscGggQm9laG1lLCBTYW1iYSBUZWFtICAgICAgICAgICAgICAgICBodHRwczov
L3NhbWJhLm9yZy8NClNlck5ldCBTYW1iYSBUZWFtIExlYWQgICAgICBodHRwczovL3Nlcm5l
dC5kZS9lbi90ZWFtLXNhbWJhDQo=

--------------cY69AeZ7wTQfPNFoMscqg9bc--

--------------JQU73VJOk4tWyWG0XpSyGNh7
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFUlncFAwAAAAAACgkQqh6bcSY5nkbt
ohAAq+hhctifKIrZyUPVnjNq3xu9OF3rJJXSlyz713XLdY7Ee1LDG+LWpa/GbgvjQ9l3ZWemWb6y
kj92oR4uateB0rQGjXjDiuOJh/vOGurQP3t/lYRCMKuBQkdOqbnRJIH6HkLt+sFqybFd6pQIgVwt
p/4/mAw2n6mTujdaGLpHqCGJAZoxwp+fGCj8wZVHEtrU5enWjNJveGo/i6wiVoSyx4g4tCOA1wvg
g7z9sfhl8j//LCB4X+WsTWNTNOKrHlYnMrcdDojRmEl3BsBr21F2gtwz2dz4IOsmjtSoneJbTf4K
DZd3ByfirW8sGQ6QsAN8Zcd2wdPZ37f7QY1QJopAAAcijVmGGFOAbf5yaSEnfijbybM2n1bhAjiq
Q1gs6+6s6Zbkp3jM3mhY+Qw60EJTz6UJJ3BbrBBAa7D/dC+kWJDcS7IBC/Y7mil0SWY0MZf8pCMv
4xjMSICgcIa0Bf4SWF+7HZ4ayq9LZUcIabIoHHJ8hosjRrvZ23KD6ifM4f1LBjbVQZW/tG6z4INA
K3vuOjS8TinB2xLgQD3rEMLSmh+1sL4CS5JnLgsfzYpHwE+uaC5+TWqlWe97nxiA1ESUweGial3H
FNPGhpYEGs1iDF+iTAyC1tBEcWRgxnwZ7OXPvpZhUdKqB/F4daHThEYAI6q2PcmBtIkfp0/MPQDo
ilw=
=VzrQ
-----END PGP SIGNATURE-----

--------------JQU73VJOk4tWyWG0XpSyGNh7--
