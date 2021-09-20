Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29162C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04BB860FE6
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbhITP5b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 11:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238611AbhITP5a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 11:57:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148C6C061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 08:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=h6pPNVw9qGFj/VTc8YEVMwA3WtAEBlQ6t+RUyrxfFL4=; b=YR/+x1Vy7sEQXDZ9lJFPopo3kn
        exo+cLFEeSrgbK96a2ssSCfcVPWDLUidWWVog6IPk2hUt1+AWX0RssctxWBpcloVpCeRIx4slG2vp
        fqKFMf2vm0WF7Icq7N0c3RnnizZOtYk5PeyTO+iUqOUuRvrVWVuSM4Co5ucn17gbl/wZWtTvVxWV7
        5JYWD9fsO3DKrUTxcyb4lfpTzLCgQiGcga+yoFf5mMziIse2lvZV+q+gUm7WBZcy27jLELG8XYuIt
        05YeFHS7aYqcThPoGCLudp/mwyA38ALUz4dXPrPe3lLdwTtCnm/nHExIt0i3VIqiwFI1RHrZMTAKh
        04qACL1E5AuXqVX9ISQehBQAOE/17kT6oeGB9TDU3qyXVvRQHWgA9XhjXeuNCK1ZuQCLvMICJTHMy
        WQ9wmUYwda8GPQnjeCUTEbM+yCp8k2g3kL6z6T4wJ3xqZfPzrBEwRGV4NpjTzUMBVezKK7k0NOWq6
        eFoYhx/sHOzilhpXJgNzQDIm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSLeC-0070ei-QV; Mon, 20 Sep 2021 15:56:00 +0000
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
References: <20210920065613.5506-1-linkinjeon@kernel.org>
 <d42feeb6-51e6-e897-27ae-f66e8543556a@samba.org>
 <CAH2r5mtT2b_9HGP1_Yii8tVu6vmwyDu6y_9pj_Y8haqQtvqnRw@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <cca5b3e4-02c5-cfe3-f6c7-00135cd2eed2@samba.org>
Date:   Mon, 20 Sep 2021 17:55:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5mtT2b_9HGP1_Yii8tVu6vmwyDu6y_9pj_Y8haqQtvqnRw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qxNa5hNuphubXFw4DQFcpF3ohVF0QyI3h"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qxNa5hNuphubXFw4DQFcpF3ohVF0QyI3h
Content-Type: multipart/mixed; boundary="4iVEu5N0gyNX24ZC74Xf8GtVxCcjnBw2K";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>
Message-ID: <cca5b3e4-02c5-cfe3-f6c7-00135cd2eed2@samba.org>
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
References: <20210920065613.5506-1-linkinjeon@kernel.org>
 <d42feeb6-51e6-e897-27ae-f66e8543556a@samba.org>
 <CAH2r5mtT2b_9HGP1_Yii8tVu6vmwyDu6y_9pj_Y8haqQtvqnRw@mail.gmail.com>
In-Reply-To: <CAH2r5mtT2b_9HGP1_Yii8tVu6vmwyDu6y_9pj_Y8haqQtvqnRw@mail.gmail.com>

--4iVEu5N0gyNX24ZC74Xf8GtVxCcjnBw2K
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 20.09.21 um 17:19 schrieb Steve French:
> On Mon, Sep 20, 2021 at 9:44 AM Ralph Boehme <slow@samba.org> wrote:
>>=20
>> Am 19.09.21 um 04:13 schrieb Namjae Jeon:
>>> Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the=20
>>> middle of symlink component lookup.
>>=20
>> maybe this patch should be squashed with the "ksmbd: remove follow=20
>> symlinks support" patch?
>=20
> These two could be merged if it makes review easier or less likely
> to cause merge conflicts later (in this case that may be true since
> they both touch smb2_open),

from a high level perspective having both patches in the history is at
least confusing and should be avoided.

The first patch changes the semantics of "follow symlinks" and the
second one then changes it again by basically removing the option,
enforcing "never follow symlinks" behaviour.

> but that assumes that removing ability to follow all symlinks is
> agreed upon.

Well, as discussed you could use LOOKUP_BENEATH. The only downside would
be that symlinks with absolute paths are not allowed.

Note that with the current WIP patches we either

a) don't support symlink at all ("follow symlinks =3D yes")

b) have no protection against follow symlinks outside of a configured
share ("follow symlinks =3D no")

-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--4iVEu5N0gyNX24ZC74Xf8GtVxCcjnBw2K--

--qxNa5hNuphubXFw4DQFcpF3ohVF0QyI3h
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFIrw8FAwAAAAAACgkQqh6bcSY5nkZW
kA//R1HxzO7uOl756ULo2YiaO8FaVvxSFoiKpeGdaOKLnFF0UJqob00MxZ7M8YOx1hSz0WwJg6jB
3k6HWg7BbZt6gFLB28f+NqaiUxl2DdOubVFofDkobUiHqZG66pS4c5i0TIwOlo5P3vuiBjTUJE1j
WGukxXH+FgVnN2RbFpo/zdma2xeJlEdQPHAPTq44Ty9ka01K2NB78g+sbcBYozp9R4jHq/EzHvOb
Ke1ZbGip9iZdlvaruw1FoqIp+qQQ2SnkEVrznQ+b+M+iRzQLF7VaZldmBcSrLamtoqEEuSo2+TsP
3PqIUWkypAtdP0CbFpN+NU8kYOt+Zxm0dwitKhskGYGVdpGS3VXGpD10H/62GV9jBh4mJWP5U4wl
Acyxq6fqzI9x0v2J2B0uSHIQjkY4ANc0PBWnKy9aiXAt38sch2k0xtaXNN3MmtRNMQQab2P9bnDp
GRWpdCkUZ3fjKeyOvyOmtMLJApGGsyfnEJY2p6h7QF8oBOpChIZ52OGFAe0dslbjONw2dcpinrwl
N/b1pohZdpan9C0arVl1l5PFnjhlin8IfesGW0HHpU/MzDkWWmH7cmcKjHdm4ESCt9KG3MX9VV3r
6OedUGZfd0rBMrag4w8ZPBs4Puo8oRcsvs1opJv6UpE5vCGlu7D6jXKCC8k8+QepNYngmmr3aPD4
m1M=
=uQvs
-----END PGP SIGNATURE-----

--qxNa5hNuphubXFw4DQFcpF3ohVF0QyI3h--
