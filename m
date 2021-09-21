Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578DEC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 07:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D488611C5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 07:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhIUHpf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 03:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhIUHpe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 03:45:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154F9C061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 00:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=7lHP7R4Ww0bkoO2cw08LmK09hF3kVYiFaYExNfQg+i4=; b=uC/zgR1Tz2cViHNolKcWHdvCuF
        UmvmA0d5Tv6s/tVnQ9dtCKbQX3JxxuBZWKBQCNDw9VTT+cGmAkdveVXQPpZOe/7VOz/5f2HKavL+z
        jJaah3JCvYakjEmVR+gUM9TlZvwirIGhKstpY424cUavXecvQEveiBkaehu/f9miFmnr+8RmlMnor
        /dqS3BkldharQMFpvN8Piol68O/ZFOapNHxMB6FiRjKqKyYI4GoIVIvRx3KzQ7iBz/cU+KTcPEgpv
        CUGJW9cCMKxvWXZCKVvqaifEKM8jnQZB9TVXL0pmYQNxYRvHYW2WOVd/n/dKY8SMn2Vg0zw1yQPU3
        jSh+iGfaz1HhuOEVzbJwmj3nK4V5NNhrSXtrfUjgBINteWt8dsqePEfRZ+ITJnihy5lR+up0j3TZ0
        xxtHJV8RVTOJNHbC3t4FCeBkYzz0J/ZBqHnY2tGZ4wrk3+zdzcIzASumdMobOIclKTYl6Z+nqvj+x
        C1Ollsnzv5ZPFGUx391GlqPJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSaRe-0077ec-MV; Tue, 21 Sep 2021 07:44:03 +0000
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210920065613.5506-1-linkinjeon@kernel.org>
 <6e8b6c79-3394-f39c-8e1b-06b3c2950a28@samba.org>
 <CAKYAXd9Re_iHpwKq4t4GUibKo8g_D3QB1rzBOYiTvv5dLhdvsw@mail.gmail.com>
 <5633aaea-84f3-ce70-ff14-aa2dc80a93b8@samba.org>
 <CAKYAXd91WHicHun_XBJnF3L9y9Of3gBaVe6NK8H8gmMxsXf-Tw@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <0eea3f58-8d68-5737-3a07-320fa085c5dc@samba.org>
Date:   Tue, 21 Sep 2021 09:44:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAKYAXd91WHicHun_XBJnF3L9y9Of3gBaVe6NK8H8gmMxsXf-Tw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bYBumKSZ3UV7N5vDTA8hBvxIH84lyCLDK"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bYBumKSZ3UV7N5vDTA8hBvxIH84lyCLDK
Content-Type: multipart/mixed; boundary="oDK0QcG5ydcoKqdE7D0JCjx3Qcsz2Gkmq";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <0eea3f58-8d68-5737-3a07-320fa085c5dc@samba.org>
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
References: <20210920065613.5506-1-linkinjeon@kernel.org>
 <6e8b6c79-3394-f39c-8e1b-06b3c2950a28@samba.org>
 <CAKYAXd9Re_iHpwKq4t4GUibKo8g_D3QB1rzBOYiTvv5dLhdvsw@mail.gmail.com>
 <5633aaea-84f3-ce70-ff14-aa2dc80a93b8@samba.org>
 <CAKYAXd91WHicHun_XBJnF3L9y9Of3gBaVe6NK8H8gmMxsXf-Tw@mail.gmail.com>
In-Reply-To: <CAKYAXd91WHicHun_XBJnF3L9y9Of3gBaVe6NK8H8gmMxsXf-Tw@mail.gmail.com>

--oDK0QcG5ydcoKqdE7D0JCjx3Qcsz2Gkmq
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 20.09.21 um 18:37 schrieb Namjae Jeon:
> 2021-09-21 1:28 GMT+09:00, Ralph Boehme <slow@samba.org>:
>> Am 20.09.21 um 17:57 schrieb Namjae Jeon:
>>> ksmbd_vfs_kern_path() doesn't return -ELOOP if last component is a
>>> symlink. So need to check it using d_is_symlink().
>>
>> Really? I missed that. Is that a behaviour of kern_path() when passing=

>> LOOKUP_NO_SYMLINKS?
> Yes.

d'oh! Got it. We're yet to make use of those flags in Samba, so I hadn't =

really wrapped my head fully around this to understand how it works in=20
detail, so I messed up the semantics a bit. :)

-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--oDK0QcG5ydcoKqdE7D0JCjx3Qcsz2Gkmq--

--bYBumKSZ3UV7N5vDTA8hBvxIH84lyCLDK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFJjUEFAwAAAAAACgkQqh6bcSY5nkYs
vg/9FuUIzhq46971DTdrnDV25PU9frT84CZuH3gvFgQkboVw9ow6lv3twiWe3m0n8ioLem3Ww9pK
FZ7KAXcg/odEKsPgi+X4mD9hyb2H9h97wPDKbBZIWJMcC8QeexS9+iYNdiEaZSwrEmAwNiuVBuyj
YNIq50x1yzoRjrXoijU+xjpJDTiG8jg7+UcIEngjnrre0tQy95uXBwxAUp9PuG9gPU64dUP/tAcp
LBQHWve5ln9eFqrXu5+v+LlbC5xjouIXGDovTKg+zV9LGAyT6GGMmIFf97PtN4261Wj6QPBtDFxo
59IOKgJud3Fc4yzK4rruqouuIH8lh8/ppQApade/SnKHmM0EkkDJaYszlRhG4LYWme+84FTxxfNi
D+HDTAH7kCP37bgNR0CliP5zFy4v94cJOwjEPJ5BKN9Z9m6cFxXHO0KjJXB4kbSz5Acaj/pO3s3P
0UErtS1QBDFeHAp99+EQ/mkUgD3qKNj9CkxhYdON7RH11MH/wvReGdbLz8h1kMjHDmR1fHSqkSoZ
NmRaT+XypotY2byUaU90bekJrEo4NbPZwcVdWzrzZNmujXgnGAxfkwMLYYQOyMfDZD/3Ry7BIo8m
Iv/VUyQwaFwNgOKefOc9hESIG3HaogpY2Now/cvzLf49FpVOkGX2yxfQZapASFWpIxwOKGC0BKHz
pWU=
=s6Ik
-----END PGP SIGNATURE-----

--bYBumKSZ3UV7N5vDTA8hBvxIH84lyCLDK--
