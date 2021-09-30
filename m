Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A487CC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 13:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D86361528
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 13:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350359AbhI3Neu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Sep 2021 09:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349882AbhI3Nes (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Sep 2021 09:34:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB202C06176D
        for <linux-cifs@vger.kernel.org>; Thu, 30 Sep 2021 06:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=nynpTQ+byzx0qrQ+lHZBF84uj2iDqxH7DbXZPGBbgSU=; b=bXBTOC62jvcGdQ9PbgS1xqc8rH
        zIANziw6pI8VURvfgHElM10sz20pRxFnFGpgvT/F8/bnV8LT9TwocIMUgfW8tKE7HX7GRHOHayyTt
        I7RVfYvVn6QBFPkDGkRmR35CQ+62t8QmQ2NKRMWSeLkfVJvCVKm9FjQhmq+303WGZiwGQL9Zyh8+f
        zeqB626CFTa9RabJFubO/VH9MeviizCmAWHNYGDL33BTXIf5PkLVFJ/9ErGMAVu5dfofCFkRKUBgM
        i8WABywugxlMqIguv0Mg49N+B1U4cLe8zpU8AYg19ge/ANDHL3XcQTFEHVXOaUCh+cyoqHXu2pjpN
        O3ODC2VsujRfZRBZJEsYaOCICaTUDWKm+JmwECHrackUBvWVKp2iQsjYeKpY7gbiqym0dxpglN/sK
        9cI7sb9XktDSx3IvU9UZ7e3sJuOocNwk6JGFDv1Wy/i+BYsJoshZbEgENsTnMdJy5YDhTMs1b5YIy
        u2t2qXZE7fQ6VoQwYav7izT9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVwBK-000tP8-Pl; Thu, 30 Sep 2021 13:33:02 +0000
Message-ID: <40575524-51ff-0c78-98d9-23878e8390fb@samba.org>
Date:   Thu, 30 Sep 2021 15:33:01 +0200
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
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd87aCAMZ56Ch68-NRjCH41MDdYYHUOSo3mfiMAOq_+QFA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------yJEstxI05exTAG68o85g4CfL"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------yJEstxI05exTAG68o85g4CfL
Content-Type: multipart/mixed; boundary="------------GIZaulBWsaRRQxcCbzQYflYK";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <40575524-51ff-0c78-98d9-23878e8390fb@samba.org>
Subject: Re: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
References: <20210929084501.94846-1-linkinjeon@kernel.org>
 <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
 <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com>
 <2b536a89-cba6-88a0-b7d8-c5435d183679@samba.org>
 <CAKYAXd87aCAMZ56Ch68-NRjCH41MDdYYHUOSo3mfiMAOq_+QFA@mail.gmail.com>
In-Reply-To: <CAKYAXd87aCAMZ56Ch68-NRjCH41MDdYYHUOSo3mfiMAOq_+QFA@mail.gmail.com>

--------------GIZaulBWsaRRQxcCbzQYflYK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMzAuMDkuMjEgdW0gMTU6MTcgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0wOS0z
MCAyMTo1MyBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
eWVzLCB0aGlzIHdhcyBuZXh0IG9uIG15IGxpc3QsIHNvcnJ5IGZvcmdvdCB0byBtZW50aW9u
IHRoaXMuIEFmYWljdCBpbg0KPj4gdGhlIGN1cnJlbnQgY29kZSB0aGUgc2Vzc2lvbiBhbmQg
dGNvbiBjaGVja3MgYXJlIG9ubHkgZG9uZSBvbmNlIG9uIHRoZQ0KPj4gZmlyc3QgU01CMiBQ
RFUgZm9yIGEgc2VyaWVzIG9mIGNvbXBvdW5kIG5vbi1yZWxhdGVkIFBEVXMsIHdoaWxlIGZv
cg0KPj4gbm9uLXJlbGF0ZWQgUERVcyB0aGUgY2FsbHMgdG8gY2hlY2tfdXNlcl9zZXNzaW9u
KCkgYW5kDQo+PiBzbWIyX2dldF9rc21iZF90Y29uKCkgc2hvdWxkIGJlIHByb2JhYmx5IGJl
IGRvbmUgaW5zaWRlDQo+PiBfX3Byb2Nlc3NfcmVxdWVzdCgpLCBvciBldmVudHVhbGx5IGp1
c3QgaW5zaWRlIGtzbWJkX3NtYjJfY2hlY2tfbWVzc2FnZSgpLg0KPiBjaGVja191c2VyX3Nl
c3Npb24gYW5kIGdldF9rc21iZF90Y29uIHNob3VsZCBub3QgYmUgbW92ZWQgaW5zaWRlDQo+
IF9fcHJvY2Vzc19yZXF1ZXN0KCkNCj4gYmVjYXVzZSBzZXNzaW9uIGlkIGFuZCB0cmVlIGlk
IG9mIHJlbGF0ZWQgcGR1IGlzIDB4RkZGRkZGRkZGRkZGRkZGRg0KPiBhbmQgMHhGRkZGRkZG
Ri4NCg0Kb2YgY291cnNlLCBidXQgdGhhdCBtdXN0IGp1c3QgYmUgaGFuZGxlZCBieSB0aG9z
ZSBmdW5jdGlvbnMuIEknbSANCmN1cnJlbnRseSB3b3JraW5nIG9uIHRlbnRhdGl2ZSBmaXgg
Zm9yIHRoaXMuDQoNCj4gDQo+Pg0KPj4+IGlzX2NoYWluZWRfc21iMl9tZXNzYWdlIGlzDQo+
Pj4gY2hlY2tpbmcgbmV4dCBjb21tYW5kIGhlYWRlciBzaXplLg0KPj4+Pg0KPj4+PiBZb3Ug
YWxzbyBkcm9wcGVkIHRoZSBmaXggZm9yIHRoZSBwb3NzaWJsZSBpbnZhbGlkIHJlYWQgaW4N
Cj4+Pj4ga3NtYmRfdmVyaWZ5X3NtYl9tZXNzYWdlKCkgb2YgdGhlIHByb3RvY29sX2lkIGZp
ZWxkLg0KPj4+IFdoZXJlID8gWW91IGFyZSBzYXlpbmcgeW91ciBwYXRjaCBpbiBnaXRodWIg
PyBJZiBpdCBpcyByaWdodCwgSSBkaWRuJ3QNCj4+PiBkcm9wLg0KPj4NCj4+IHRoaXMgb25l
Og0KPj4NCj4+IDxodHRwczovL2dpdGh1Yi5jb20vc21mcmVuY2gvc21iMy1rZXJuZWwvY29t
bWl0L2ZmYzQxMGYxZDE5YTBmMDZhOTUyYzdmMjhlOWJjYTRmYTRiZDRhNzQ+DQo+IEFoLi4g
WW91IHB1c2hlZCB0aGlzIHBhdGNoIHRvIGtzbWJkLWZvci1uZXh0LXBlbmRpbmcgPw0KPiBT
b3JyeSBmb3IgdGhhdCwgbXkgbWlzdGFrZSwgSSB3aWxsIGNoZWNrIGJyYW5jaCBiZWZvcmUg
YXBwbHlpbmcgbXkgcGF0Y2guDQoNClllYWgsIHRoZSB3aG9sZSBwYXRjaHNldCBpcyBpbiB0
aGUgYnJhbmNoIGtzbWJkLWZvci1uZXh0LXBlbmRpbmcgd2hpY2ggDQppcyBhY3R1YWxseSB0
aGUgb25lIHlvdSBjb3JyZWN0bHkgdXNlZCBmb3IgdGhlIGNvbW1lbnRzIG9uIGdpdGh1Yi4g
OikNCg0KQ2hlZXJzIQ0KLXNsb3cNCg0KLS0gDQpSYWxwaCBCb2VobWUsIFNhbWJhIFRlYW0g
ICAgICAgICAgICAgICAgIGh0dHBzOi8vc2FtYmEub3JnLw0KU2VyTmV0IFNhbWJhIFRlYW0g
TGVhZCAgICAgIGh0dHBzOi8vc2VybmV0LmRlL2VuL3RlYW0tc2FtYmENCg==

--------------GIZaulBWsaRRQxcCbzQYflYK--

--------------yJEstxI05exTAG68o85g4CfL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFVvI0FAwAAAAAACgkQqh6bcSY5nkaQ
+g//clQ99B/68xY+7AwDGROHloVl+mTPsXckm/SlD4YF6J80NrWhacgbE15jXQ06dAig+X8j4Z8K
W+WkRdfWYST7gjteLSj3VkJLbGJsMjf9pHr7uR+F/P7lsfQzpW5eok6fLeZ2YmtOpRbWRRZk3gp5
mRpX5qvDS9A6cNKbPzYcgbpvCm99q8YlsrgrH8gTxKRQ6DYn+gmySzqw9+GjEy2yS8bmToIxW7fx
XRFuXCUZBFZ7ekUtQEKVZNCFtjjN6REK1rcwNHW9wscxS3mWOpgW+mCTExkkU1FKn7IkDSIHa6o3
O5X4n8STN7BzJ6I1fKZ6TFGYkzzHHWkgDpFW2EpHpTKvq0R64jSL06HCo5ZNcbDRt42y566Pl56y
Kz9aDQqoMr8e7nGSl1DVflG0WicUNtrXMW2T/Nf48JQoPPk0dHwwOyHw5yAfQBxs/PMuM2sMLg4c
tFYTEgB8VeWHaxx8i3cjESF9UTQeVW2KPhLuAEa9rbiCFUkYn334j83nztDo/baKJCmNjcpHYNgw
47oEtH9ZplegjD5+cNeWWEsqeuUWh6Gn0FE3kRx7ky3uUKf/67UjWAioe8nJ5XVfrM5hhjALxLHV
I/77/eMka0nY31BRAhPQH+XLGY7MsyZ4hdeCzfyAXpnj9eOtVH+HvrLDQyPj1zifStWFoR4lhVZ8
rxA=
=oxi3
-----END PGP SIGNATURE-----

--------------yJEstxI05exTAG68o85g4CfL--
