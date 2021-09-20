Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29599C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3AF66115B
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhITQaA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbhITQ37 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 12:29:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6F4C061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 09:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=vKH5gmqSKd6AnVjuaYiVeBOkirqJ4ySDLctNRL6/7rQ=; b=iJQ4puivquojTH4x0FPb1OXNlR
        5sbUL+89dY9m4Z+QWZxu9rcnkuS7DXExAqqOQRfLfIZCsBvIHWN8nYyvN5nAq6Gr17o7PYkmxAGgK
        FXkC+PwRXpzk/KFZv7wBYUdrdnfy3aNzR3yZ5kLEzkaJ8/id0k97MT4BOpy/IrkOkhRrZbd7I7sB3
        8mtk/ze0fa0C85qMn8Wb8RpxIGhVB9z2jWdC09IJZFKzSnKjab1TBJXmCP1C5yeuXWDmscHEqNfI7
        5Z1Cf27hnyEI2mKGn0e3YFWnT7N2sABtWH447A1Or2ojnTcTqwDji04nZ7bZ06el9p5oKumnHh7H3
        7Y9D3nlQQMfdh1LbjHGWukoI/Q/YHbMmGEG/3JC/JhWl7EfiaYyovRMg5qqy4Dj04L/H1HsHBogpG
        mHIN0c9EZswoIFQgLI0oSe0+/Nb1E69kykwo5wiwLQLQ+zqH1PVStQk1jFL5TyXbFNUjdff6/2Kju
        FNPWh4FKXIxN6sVVLrPJCxpD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSM9e-00716U-T4; Mon, 20 Sep 2021 16:28:31 +0000
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210920065613.5506-1-linkinjeon@kernel.org>
 <6e8b6c79-3394-f39c-8e1b-06b3c2950a28@samba.org>
 <CAKYAXd9Re_iHpwKq4t4GUibKo8g_D3QB1rzBOYiTvv5dLhdvsw@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <5633aaea-84f3-ce70-ff14-aa2dc80a93b8@samba.org>
Date:   Mon, 20 Sep 2021 18:28:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAKYAXd9Re_iHpwKq4t4GUibKo8g_D3QB1rzBOYiTvv5dLhdvsw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="g1icO1bqwddcLxjSmGGtbpX7zdu2NnY55"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--g1icO1bqwddcLxjSmGGtbpX7zdu2NnY55
Content-Type: multipart/mixed; boundary="VWkYWP1JGfLnvuFPSgosM1P0XKCfCPqQM";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <5633aaea-84f3-ce70-ff14-aa2dc80a93b8@samba.org>
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
References: <20210920065613.5506-1-linkinjeon@kernel.org>
 <6e8b6c79-3394-f39c-8e1b-06b3c2950a28@samba.org>
 <CAKYAXd9Re_iHpwKq4t4GUibKo8g_D3QB1rzBOYiTvv5dLhdvsw@mail.gmail.com>
In-Reply-To: <CAKYAXd9Re_iHpwKq4t4GUibKo8g_D3QB1rzBOYiTvv5dLhdvsw@mail.gmail.com>

--VWkYWP1JGfLnvuFPSgosM1P0XKCfCPqQM
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 20.09.21 um 17:57 schrieb Namjae Jeon:
> ksmbd_vfs_kern_path() doesn't return -ELOOP if last component is a
> symlink. So need to check it using d_is_symlink().

Really? I missed that. Is that a behaviour of kern_path() when passing=20
LOOKUP_NO_SYMLINKS? I don't see the behaviour expressed inside=20
ksmbd_vfs_kern_path(), but maybe I'm looking at the wrong branch+patchset=
?

-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--VWkYWP1JGfLnvuFPSgosM1P0XKCfCPqQM--

--g1icO1bqwddcLxjSmGGtbpX7zdu2NnY55
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFItq4FAwAAAAAACgkQqh6bcSY5nkYR
+w/9FYaZyk1I7X82PB+zO9JfIDJo88GKGcm5HkCy8JTfXgcG+QH0lLqXJli4J+xrci6wLZlOaBLF
srZWWn0lsduVH24tRkL8VawX7odEA/8zyplLE6iljwKnfvSB+2AZ5jNslBiqizo7h1B+eHJBmLom
BqcmcFqDqkE4U37kLzosjeMZFyK4bwi+Gjv4/tXRWeQlfFaiRNVL9hqJRR1rVEDRG2BcCTfIu/A2
/MYZu7HX2f7oTm+ktOD8kaa8k8gkshcOT02WdcqVdfIQ9BsGkSpHXaE72Nm+GSaGtcH7dZX7KqiO
NrQ0bUinPzyzLAgSLbCi9ef5YYGmQ+/3xcd7STmLHdEdjK2ye/V7XI9WZTtVE6YfsqMlJYWqazC+
K6NNky2Rosvveu8QzZa3SL25fhMg8wvUZmY7BLWa1j/iRgoIIWvYPe4voFzysZl/a6tgQHQFqcIt
RE2+j85/HTdRbFOIkro7o8/QnYcBuqDBfmpgB7WJFT41QnmZ0objddlCLIKotrneMhruxPP0uUjf
/L8Mo/P51CwkQ5/4nAuXt75YaZG4UtL/uR3U8C1ah/y+y1YmblzpY2NRSmRFozByhNhTrAu+5WYK
Kx7b7Dzi5IOcEmvwki10iNQLP4KpaP5UR/2sf04nUlMTcT7j51ZtFsUwLOJtoWSsjh/6/g1Lp81p
ojw=
=2X4G
-----END PGP SIGNATURE-----

--g1icO1bqwddcLxjSmGGtbpX7zdu2NnY55--
