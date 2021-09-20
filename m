Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE3DC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 596C860F93
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241054AbhITPEh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 11:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241008AbhITPEd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 11:04:33 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC28BC061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 08:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:Cc:To:From;
        bh=tI6dollPgAnmuKv621RwNfSyKe54BBmxmd6y3tG+5LI=; b=QaCE52VWeibCr3FMvXNOA8ZA2H
        Js5XpDU7Sg45onNh42sRvBN+Ua4biEEMqcEG99o8o2TQKGG83svOR7TEX9eGbF+9jkB8rsLgkXgGo
        5cuZmq7tGTYOGssYHjqyBBm+oYVfYMl08xv+vF89/EzMXuXnoJiQxO8a9lzYYUKLwjDW7o8+BkU8m
        /Xs/I8mJn+/vOm1JD82vG7g49Tdjfl2B/4Cd/5W4l4IfaFkzqvNt15XvoeyYhTYG+MDtQwB95X/ig
        cwZFIuz6ZrLUMfFXJnO7hrw5BpGucr9dDY0ohGHhxV2HMdF4uJr+b+ItD/qfAw350yZYQnrMURkPM
        HRrw8Kuf+oJwmkaxE+s8KvfsUJcfifbba+sCrFSRouFNUchoi1yLdQI5NpGv59nOpb2gaVe3tPSWd
        jPlym1hs6jbqXIl9/+u0FVZYB+HNWOT/3ftKgdtLTHf01YJYWEOH64JfeYvuRA5pVVZy8pJMEbp0h
        jMS5pk2be7tISouDXo0j95KY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSKox-0070Gj-KR; Mon, 20 Sep 2021 15:03:03 +0000
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
From:   Ralph Boehme <slow@samba.org>
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org>
Message-ID: <27cdc659-cf4d-cc9e-e5c5-6a3d23987e72@samba.org>
Date:   Mon, 20 Sep 2021 17:03:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TAla8YIGcVM5G8iV2FBkhdJpsyjiVSsva"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TAla8YIGcVM5G8iV2FBkhdJpsyjiVSsva
Content-Type: multipart/mixed; boundary="skh1zjvFIt7ZWyzdHFpnU16GDMFYTyjkV";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <27cdc659-cf4d-cc9e-e5c5-6a3d23987e72@samba.org>
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org>
In-Reply-To: <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org>

--skh1zjvFIt7ZWyzdHFpnU16GDMFYTyjkV
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 20.09.21 um 16:45 schrieb Ralph Boehme:
> Am 19.09.21 um 04:13 schrieb Namjae Jeon:
>> Use=C2=A0 LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the
>> middle of symlink component lookup.
>=20
> maybe this patch should be squashed with the "ksmbd: remove follow
> symlinks support" patch?

also, I noticed that the patches are already included in ksmbd-for-next. =

Did I miss Steve's ack on the ML?

I wonder why the patches are already included in ksmbd-for-next without=20
a proper review, I just started to look at the patches and wanted to=20
raise several issues.

-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--skh1zjvFIt7ZWyzdHFpnU16GDMFYTyjkV--

--TAla8YIGcVM5G8iV2FBkhdJpsyjiVSsva
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFIoqYFAwAAAAAACgkQqh6bcSY5nkbo
3A//XMl8zKIYSxe+pj7HjlaEWKwjQ2+7IdlA5XYFHcExGncAsGP8jHtqNBdWOLoBkA3dJmWzlVur
zfIwpBQ0cmpuDGi8twALumOCZMD22psyYREnpgILsysOU7PEKHiIqCp7QtnjZk2vLNTyE9xtMV9i
KUeK4EWA1uGlsSC0haPey9QiqQscJYILwiMtV3Cq9/97rnYYPEQQB7TioqN/zBP1LPR4kuMl+bgR
FwBt9dxzaFgm43zILHLMPZJql5I8gIn7QSvrog4hfUKGCGQcKpxAyg9mL9kc8n0hVBgcDAwMCjQv
pd6JkDWWgf4I4JkC9/MDfYXJ2rvwsbED/Md2tb4pVIiqMr1zOy0DrBaHzcDZHAwXoCet/6qQ1VWs
Mmv7T1lnl+7RmLL+HqsOdPXSkhJW5cg+2oBpCC7E0klvUqvrYwcngsGOZHKZPiCDeSMm9HRygeQf
7v/RtIZWnYEsRu/yvzuNom+E1wjvGb6z2im3WVm/K4evwx5EYPSNLS/QKx8U56wABoCb6Vro5R7e
rwtWPQj3+onJkUpcaTEjDI/FFVqbzKOhQ1I5bogk46bMh3R162G0xm4ZY+kg4xtVJSrI3aK18ORi
0IH8z2xFIMubY6FRoYNSsBLbk8mshozV6qaRdVzW5nGPqcXwSfdNJ++y6wrua9G6urOu4gNg7v6V
8DA=
=q0vK
-----END PGP SIGNATURE-----

--TAla8YIGcVM5G8iV2FBkhdJpsyjiVSsva--
