Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C00FC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 18:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4729361100
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 18:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240177AbhIRSLu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 14:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbhIRSLu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 18 Sep 2021 14:11:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761FCC061574
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 11:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=jgpjvHPWeHwoSf5UNIFsLegMs4zDN3muaKEJiMVy2l0=; b=IndubJLee/Ua90VmTINT6T7Eop
        r3KEMomObLZDZJhzDGmsRLK5MTd65PseSW0lPWTBrAsEGvOclngB0RPfS5dQoSGTN+zp6uope4M62
        UJn2G02A5jTWfnCvvGwiwxG8v0zUDav6gHL77xHn2vqj/+3NiQvrPp4Ry2mrn7iz4Apumie0v8M0U
        X1Skm1wgp41OghyeYWTzOHmHOthlL3MVfMyHX7gwaUeu9/mOpPM5SAgBBy7AFBmwrdd35okujzCls
        WzObsbHtvrjBcTDCDw/QlqkzIJ4vgfu/3+i549Y1blYYKQAr3kHNBRKh2vFS1g4oIH5U9AL0gn22v
        0anqAvmGGGJ6e+5eiqb1BJ2tFwXiCpVqd/PQGqhHiUsYvZ+JdWD/DSbofYeGG0fQxfsDlX1K1+dd2
        mBpUVCTTZbrBRQkZDzX70kSEjexWZ0j23F+qOgS9B1YNJaSrsrlZ6KMNUhENmvRk5tvtXrRY0J0qb
        cW0n+3IzRj0ik5T5CG8Cv8gf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mRen7-006lkW-P2; Sat, 18 Sep 2021 18:10:22 +0000
Subject: Re: [PATCH 3/4] ksmbd: add validatioin for FILE_FULL_EA_INFORMATION
 of smb2_get_info
To:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
References: <20210918094513.89480-1-linkinjeon@kernel.org>
 <20210918094513.89480-3-linkinjeon@kernel.org>
 <CAH2r5mumOAqEgkitSK4yrxithPUUF1d9GihTLQAOdrX8-kK2Eg@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <91bcb4eb-ae00-5f68-26ff-90410fcded8b@samba.org>
Date:   Sat, 18 Sep 2021 20:10:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5mumOAqEgkitSK4yrxithPUUF1d9GihTLQAOdrX8-kK2Eg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ImaY9M75oovF2yW8w4tthN6XhFy4n54sv"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ImaY9M75oovF2yW8w4tthN6XhFy4n54sv
Content-Type: multipart/mixed; boundary="msrb2u4GhJZ9Cmvg4np2jWoJEYakVs7OW";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>
Message-ID: <91bcb4eb-ae00-5f68-26ff-90410fcded8b@samba.org>
Subject: Re: [PATCH 3/4] ksmbd: add validatioin for FILE_FULL_EA_INFORMATION
 of smb2_get_info
References: <20210918094513.89480-1-linkinjeon@kernel.org>
 <20210918094513.89480-3-linkinjeon@kernel.org>
 <CAH2r5mumOAqEgkitSK4yrxithPUUF1d9GihTLQAOdrX8-kK2Eg@mail.gmail.com>
In-Reply-To: <CAH2r5mumOAqEgkitSK4yrxithPUUF1d9GihTLQAOdrX8-kK2Eg@mail.gmail.com>

--msrb2u4GhJZ9Cmvg4np2jWoJEYakVs7OW
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 18.09.21 um 17:55 schrieb Steve French:
> Merged into cifsd-for-next (smbd-for-next) after fixing typo in title.
> The other three look promising but want to look in more detail at
> those unless others have review feedback on those - those patches
> include some potentially very important checks.

I'm carefully looking at all four, it just takes a bit of time.

Cheers!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--msrb2u4GhJZ9Cmvg4np2jWoJEYakVs7OW--

--ImaY9M75oovF2yW8w4tthN6XhFy4n54sv
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFGK4sFAwAAAAAACgkQqh6bcSY5nkYj
5A//S0OZp7xfyo5glftz4VEiUV5xWUG9JalGjM72KmAMir/hf1hKdfoTUCaNT2MjRmfvfJwUVojK
FUkkyip0RhF4LUumKjQBNNhrk9dVCOnpY0kCp+/uIqY9a7NqyTaKI8NAWrnbrM69cY2cmfdYwb6u
98TZfguXLjpv6NBkzXZlggbnmuVQbP+NXrrHlD+glpCNBiKFTFnoWi4nzr1+H/ANNJ0R1KI1zrW0
R97+4gENXjz5wF3Xud42yn0P9CwQokTsP7nVAjyTJTsuzbth+s3lkAzdlG/XDJBHpgycSJ22AeXD
vV8cABhEvQ0fFse7pYMTZiBrUCVedIaXcx6rKSTZSG54oZJ11yLYkuH8FjIHuobUBKt4LRBfPNwA
zk8UlIQ+QczRxpwFKHr4Y678/60WNgy4L+lRiqX7CBTDwvyuKwMX9RhFT4l+H8lQlFnuJ7ErQmZf
dDraxUFHyLyhGSiZhFJuOW72lAjz/oN6wYPdqxMF2NCCLLkZQj9k5m1Wv8COJFkDisXZTtNOhdGm
NC3s6MxEbXjEBcSZrvFjwFE3DpwcMbmvLf3jJqyqy9e99EDj1Mj8MukpHPsS0vNyDYVSSKUHvlsh
XKzZMmLQeH9knScucu1KZtNsowCN1aavPGdpRxic95IBBWzReSr3N515OB8TPZx8W2vlg9xp9vX2
444=
=6r/c
-----END PGP SIGNATURE-----

--ImaY9M75oovF2yW8w4tthN6XhFy4n54sv--
