Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9075AC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 04:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D99661502
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 04:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhJEEaw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhJEEav (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 00:30:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF13C061745
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 21:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=myCc/ls9yH7Ps5rvJr5MRansuPRQ680tGXY42ywrmgg=; b=IKPk1O10f0qrvXSA+uHhbWxAr4
        rgO2qBR5C48AsytLVZOhttJb1e3kJfVPxAhvO8gfZ+C4MBx19pbnR7iqUc8ZKiX3gC/Wjoiy0UH83
        1h5HBsDvZAQE+XlBNBd97/0/G0bdmBzm9/x1y4rZ5n21SElfWP2C/btfNexusoL/xAd6Ov49GN/Pn
        3TiAFm8fjz2Yhk57Ada0Lv7/ttyzNqKl/OJAm2IV1t0XTDmnWFwcWbYKMquLq4/0g6yRzciferqpc
        CNj1p84c3XzRWbY/8Z+vR1Lbtyxh68tGfxgWHD+gzKREdX0LltrPjPWgGwERb/coo756tVDLItYAt
        Rk3iPWzxjdUYKtPTThdJuwWChoLs47wA1p/dwJdSFYq7C3KkwCe+fONnjYTfICEx+Lz2+lYmxch11
        d3e4yq39r2JqYWTz+jdp6StiLT6wWMb+w/IFNxPeFs6Nm/bRrGmTi5QjOyrBQ+vifON/ePRqWp9NX
        VVZAtzjxaUKdGOryQRN4lyEk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXc4Z-001YnD-Su; Tue, 05 Oct 2021 04:29:00 +0000
Message-ID: <84fca1c3-2ee2-2a13-d367-6878b56f200a@samba.org>
Date:   Tue, 5 Oct 2021 06:28:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v6 07/14] ksmbd: use ksmbd_req_buf_next() in
 ksmbd_smb2_check_message()
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20211002131212.130629-1-slow@samba.org>
 <20211002131212.130629-8-slow@samba.org>
 <CAKYAXd_jYHCnUbOoBGpsAPo_=H3wsbXcE8LOaAgvZT+dXzpPEA@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd_jYHCnUbOoBGpsAPo_=H3wsbXcE8LOaAgvZT+dXzpPEA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------jRt6cHWo5TwBvDqmJiycm9ps"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------jRt6cHWo5TwBvDqmJiycm9ps
Content-Type: multipart/mixed; boundary="------------GFx0mmkua6BLlgHba0oc57Bf";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>
Message-ID: <84fca1c3-2ee2-2a13-d367-6878b56f200a@samba.org>
Subject: Re: [PATCH v6 07/14] ksmbd: use ksmbd_req_buf_next() in
 ksmbd_smb2_check_message()
References: <20211002131212.130629-1-slow@samba.org>
 <20211002131212.130629-8-slow@samba.org>
 <CAKYAXd_jYHCnUbOoBGpsAPo_=H3wsbXcE8LOaAgvZT+dXzpPEA@mail.gmail.com>
In-Reply-To: <CAKYAXd_jYHCnUbOoBGpsAPo_=H3wsbXcE8LOaAgvZT+dXzpPEA@mail.gmail.com>

--------------GFx0mmkua6BLlgHba0oc57Bf
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDMuMTAuMjEgdW0gMDI6NTkgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0xMC0w
MiAyMjoxMiBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
Tm8gY2hhbmdlIGluIGJlaGF2aW91ci4NCj4gSXQgaXMgYmV0dGVyIHRvIGFkZCBwYXRjaCBz
dWJqZWN0IGhlcmUgaWYgdGhlcmUgaXMgbm90aGluZyB0byB3cml0ZQ0KPiBwYXRjaCBkZXNj
cmlwdGlvbi4NCj4gaS5lLiAiVXNlIGtzbWJkX3JlcV9idWZfbmV4dCgpIGluIGtzbWJkX3Nt
YjJfY2hlY2tfbWVzc2FnZSgpIg0KU2VlIHRoZSBtYWlsIHN1YmplY3QsIHRoYXQncyB0aGUg
cGF0Y2ggc3ViamVjdC4NCg0KSW4gU2FtYmEgd2Ugb2Z0ZW4gaGVscCByZXZpZXdlcnMgcmV2
aWV3aW5nIGxhcmdlIHBhdGNoc2V0cyB0aGF0IG1heSANCmluY2x1ZGUgYSBsb3Qgb2Ygc21h
bGwgcHJlcGFyYXRpb25hbC9jbGVhbnVwIHBhdGNoZXMgd2l0aCBhIHNlbnRlbmNlIA0KbGlr
ZSAiTm8gY2hhbmdlIGluIGJlaGF2aW91ciIgdG8gZ2l2ZSBhIGhpbnQgd2hpY2ggcGF0Y2hl
cyBhcmUgY3JpdGljYWwgDQphbmQgbmVlZCBleHRyYSBjYXJlIHdoZW4gcmV2aWV3aW5nIChp
ZSBhbGwgb3RoZXJzKSBhbmQgd2hpY2ggbWF5IG5vdCANCnJlcXVpcmUgdGhpcy4NCg0KLXNs
b3cNCg0KLS0gDQpSYWxwaCBCb2VobWUsIFNhbWJhIFRlYW0gICAgICAgICAgICAgICAgIGh0
dHBzOi8vc2FtYmEub3JnLw0KU2VyTmV0IFNhbWJhIFRlYW0gTGVhZCAgICAgIGh0dHBzOi8v
c2VybmV0LmRlL2VuL3RlYW0tc2FtYmENCg==

--------------GFx0mmkua6BLlgHba0oc57Bf--

--------------jRt6cHWo5TwBvDqmJiycm9ps
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFb1IkFAwAAAAAACgkQqh6bcSY5nkYj
ew/+InR37VzJRGeTEoUwfbPGuSRc6O8M79syFuMXadaubyLtv8GG+Y0P5sDBLTahuhsHK0GvLr+m
gZCg2m+44gAUuM42DOZJNALC7zh/o0oE2ptzW9ZEmTUYceZwmaQRWC7OkB2zAdgNjvEwmx+oGndv
Ef3/29J8MxyAnngVIBCHm48no7xUfqC5TJ3MN2iqjC5tXwC24UAUOhjNkOGyv2PMy07rLbhT4hk0
xt1l59zc6AfrPQXUrdeNMsSGJFzgT0IdcOsEVOwZv2hxjQ36CJlzwbuPwZ9OAvWh5xiiQbi7cGZn
m0jksZzMV9fiZ60nvZ0Il6eC9Ms6pGGgQixzzef0u2AsbMZ7Fy41PJmzNOkL84a/DBU2BxTvA3LH
R7KgREpQgG1t6F3VZEIYW3XyLwStAoerQr3sfRgAR6njES1aCLRliNu8KRNoKCZnNTy3BPH+JL+J
DTdE5dU4ZU3/sJK698tk+lu9Say/l+jZECoEbUOr1v3eOXrkAy+CLbFnH/uUf2Qw8bFue4DLrJcF
z0R/iZs2qDBSqLmWoWBfHUbE7InwZrOsxXMtyL2/zLSc+rsbCjTv0Husgz+4UdP1sidNnS58xunk
kA5HLMAbq8QtUFQ4Fz4hHCudI1p1SqSsJEFsXkDePyg00hVv15vYJVCjjgBULHqvvagE/n+fBreW
88k=
=BCLe
-----END PGP SIGNATURE-----

--------------jRt6cHWo5TwBvDqmJiycm9ps--
