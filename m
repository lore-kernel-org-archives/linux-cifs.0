Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A6EC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C5361019
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhITQbv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbhITQbv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 12:31:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4D5C061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 09:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=V0LA6pLKObUfz2Pv1TmzSpRrP2fBW1yhVEmk4/ofFo0=; b=OZxuYZ8aCCbAq4zdW7n0ALTqVp
        a6RVL6y4qsfFuf5WVzqgVl8TkwUJa5cX3IBNG9uswv1soDWyqVRScGWKD2TgCwzgNrpi4V4xJ1aT6
        aQQJb748shkqAYjNfsd6n67IvQ4s9BVssLqZDxjWTbwB+GCzfoAxjq55Q12eeezgMcpsOdK+0XyYW
        CTrCia8Bru3qkRH+hm10cXh5Ja1ARBn7LaSR/3PsPKp1Q+K1yJOKAiL8q+mE8/vpUkj4qtl1wzbJF
        UWnOT0rNLBZKDJohMcKiIGMmgBzE3XDfdROU59JBGdaFpJrVTKBDwFH8z6Q/0CO9w0Ly2nKTbuDtY
        fnN3cqRLUCErge/ehNRQFzQbtvcHNk9gUEWRt0bPOudZbxwjgFiTXR+daGfPjmX84LzF9Ou/vy1xz
        pagZlIGvoS37jy07Z5rvuLAPIeH47hOK4N2nJBokoBjzZ7PDLy2ffvHyDjX7UyvOes8zx69u6V8pP
        LKH8HrRtjMOT1UAA3UunQBMS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSMBS-00717b-5Y; Mon, 20 Sep 2021 16:30:22 +0000
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org>
 <27cdc659-cf4d-cc9e-e5c5-6a3d23987e72@samba.org>
 <CAH2r5mt8gxSS56kDvmtRTOi7Dm0fXwD6zL45WAP2hw2_TxDPow@mail.gmail.com>
 <97166b9e-b0e2-2cc2-5d53-c0f8687faf80@samba.org>
 <CAH2r5mtHCpy9n6LXDU+V2uJAEQqh4J80gRzinxbpiVs7HTh81g@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <8cf2eb1d-a236-5db2-19a9-4749c29aa807@samba.org>
Date:   Mon, 20 Sep 2021 18:30:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5mtHCpy9n6LXDU+V2uJAEQqh4J80gRzinxbpiVs7HTh81g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Mc50VP8HL2nzYxgOYfQjcyJvlPUMMlUsD"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Mc50VP8HL2nzYxgOYfQjcyJvlPUMMlUsD
Content-Type: multipart/mixed; boundary="pUO82kBUl8uA6VMortKqAc5deRJL3A8X2";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>
Message-ID: <8cf2eb1d-a236-5db2-19a9-4749c29aa807@samba.org>
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org>
 <27cdc659-cf4d-cc9e-e5c5-6a3d23987e72@samba.org>
 <CAH2r5mt8gxSS56kDvmtRTOi7Dm0fXwD6zL45WAP2hw2_TxDPow@mail.gmail.com>
 <97166b9e-b0e2-2cc2-5d53-c0f8687faf80@samba.org>
 <CAH2r5mtHCpy9n6LXDU+V2uJAEQqh4J80gRzinxbpiVs7HTh81g@mail.gmail.com>
In-Reply-To: <CAH2r5mtHCpy9n6LXDU+V2uJAEQqh4J80gRzinxbpiVs7HTh81g@mail.gmail.com>

--pUO82kBUl8uA6VMortKqAc5deRJL3A8X2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 20.09.21 um 18:20 schrieb Steve French:
> It is not too late to do review of any of these 8.  Given the
> importance of security, the more reviews the better.  Earliest we
> would send them (the larger set of 8) upstream would be in a few days.
>    I typically like to have them sit in for-next for 48 hours (although=

> in some cases make exceptions, e.g.  for important bug fixes I will
> shorten this if later in the week so they make it in time for the next
> rc)

which "for-next"?

git://git.samba.org/ksmbd.git/ksmbd-for-next ?

Thanks!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--pUO82kBUl8uA6VMortKqAc5deRJL3A8X2--

--Mc50VP8HL2nzYxgOYfQjcyJvlPUMMlUsD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFItx0FAwAAAAAACgkQqh6bcSY5nkbk
DQ/+IT3xFDw3jZGKCdYiVMDg4VHP4kJObDgM8NzvhGy+/0uL03jVIbLCQnicjyDHqpkCm0Kb6uaB
H3V2OXoTKoR0ZLeZ4v9SWckjCDvmIlz6BXTLgHiXH87CB+xKIMXkqYhGRrWCz6CK8Hqu/mHsQ+LZ
BfKmgC7AMtzSEFw6+cuIjn+T5gJAM5mo2foE2VQGNKe+OZaWSHo5QiOGczPAtEq4Qq9mZioWPkJ1
X92CskxbWdDEcqyNF3B7jV6OpYNf+iDPdnCpsdF+Aong9vDnSfO4MBYbUS5xA0my2n1/ptwL+GcV
B8GdpyXEQAVOnVi2+gaZl1cF/QqE+rx8VzVkFVwvqbzYvirO9k/yRg5T+1/VGqTJi9vrc7Fa6WKP
zjXncdpPpZ2avkSyRtL4fJOzF9/lfdJVHJVfWRyAzyBb4NM1KwxNkoW7RcB7meAoULqqWkdUE/j2
WMu3R3jDGqwsJjm8AEUI/iARRaUEgs1grtjaZEtaizahKY/klIqlx6tdYkenfNoKV4orVoi0Mvhx
peX0QyOb7MDLuMqzPk46GJd7V0AT62RWcfkyC++s6M6ZR8QcvGOKhgGA1JIi6uPLi8myQiWaR74p
EA+y4lENz7zTKvvBs5rnWu5TE2d6Vf4OepwihVNLdAwAvHDfBVWMJKbSLxmWRSxoTIPclwEK/w4W
fBY=
=Oz9a
-----END PGP SIGNATURE-----

--Mc50VP8HL2nzYxgOYfQjcyJvlPUMMlUsD--
