Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B121C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 14:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0AA060F6B
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 14:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbhITOqF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 10:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbhITOqE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 10:46:04 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AB2C061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 07:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=blDlCYV1wG7RhN981IRu4jk6LOj/KbF8AGb+9zbpEFU=; b=3TgLoGzUYtDd7wmSxJopyOSfg6
        F92645ke9uHkg6mT+pZST8IYU/xoFz+WPs/JKnE4Bd9attK3hyfbffpP+Q8S8gxEe8gtgRGT6DhmS
        MSPFB1IHO8IIUOEcpV3e+FJjj8yJ/VTcGG/z6mkuUv8uNcDgsj8Q/DH6iTx7DFdsMie3+rB2X0Snw
        2QPRWB5pkPvITsgOue9EBA1k40Br5J5cyDLER9v29BvzhHhDpbYeyJ+qx9a7r6noJE4FOCDfshUjU
        4McfP3c5c1tEnV/+FLByT4UXPgnRLvOF2M747QNQqIvK8V6crDJC9RbK3zUz2zK632xNHI8Yujs6e
        WNUfW0LBzTi3fyCSerdakcgBjuz5RPTG58oD9w7JmIHUclOPknmGpEO7moJMrghxHinQYlMEfbqXr
        ukyvtNXCyp/nhKgY8RxJ0RLr4iwD9QDZlLc7ujRO0dV625I3eHdgwForm+b/LUgXSJ5Z39wOkYgps
        zqdFQDyNf1SGRkxnRu4MKNxs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSKX4-00707i-2S; Mon, 20 Sep 2021 14:44:34 +0000
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210920065613.5506-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <d42feeb6-51e6-e897-27ae-f66e8543556a@samba.org>
Date:   Mon, 20 Sep 2021 16:44:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920065613.5506-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vhAJ2t8jIo9Nh4iC9RyWwIQguQYgkZ3rE"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vhAJ2t8jIo9Nh4iC9RyWwIQguQYgkZ3rE
Content-Type: multipart/mixed; boundary="dGdR7XSBiIhGheKdytYBdYQH4yHJZxNiP";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <d42feeb6-51e6-e897-27ae-f66e8543556a@samba.org>
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
References: <20210920065613.5506-1-linkinjeon@kernel.org>
In-Reply-To: <20210920065613.5506-1-linkinjeon@kernel.org>

--dGdR7XSBiIhGheKdytYBdYQH4yHJZxNiP
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 19.09.21 um 04:13 schrieb Namjae Jeon:
> Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the
> middle of symlink component lookup.

maybe this patch should be squashed with the "ksmbd: remove follow
symlinks support" patch?

-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--dGdR7XSBiIhGheKdytYBdYQH4yHJZxNiP--

--vhAJ2t8jIo9Nh4iC9RyWwIQguQYgkZ3rE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFInlEFAwAAAAAACgkQqh6bcSY5nkbC
6g//bjLiIjnLRVVX6rcnfPk1B6b1R3VKYuvScjlhSTARwX9HBGsFzeGsrzgnG6DOV7HOJI8OCEfx
+A7ucJvEez9HaAnrn1NHKQgDf+md1vzvqAhQRUrG3nacsIxqPWi+6gnA547nmSKB7RNCNCrMjef/
7Gi/SxPYqNhgoRSAZlokc/i9sMhjvSo4v5OJhmk4J+fbXxljx+l0zXaqEsU9t2igYWVYgoUsKwmp
fIYPoX2P/Ac4hVELC2ccPrTPLjvLUVuyY6UdJef++zqUmifQlBNT3EEP5/3qBRCx95hEhL8+4ryJ
0xNjCUJ/GVkEschNkWlJImGIvViQ76xdRnC46snvba+J4Kh/t01+ov42PqaEMhX7nEShjPX/zBe9
QYwfH/ZAxHTjeC9T+Gw9VXTxYMikqWyi2qyycMGWt6msicqpqYEdQQ7uvvUR1SQmQNQ7xQgOE/Iw
OFN4YesduClVkt1v8bAbKwnb/Xm1UcFrXKaKzr69hTQz03q3nw6xKCu9XrKbMq3Y88JImvPQCVXK
Ed3dUTs1BNkBIOUceJmyshThTeeWayOLcimVhOMoo35k4s9G+Jv5u2Tx3Whynvwhm1M+nTDphpiC
lgF6zvyNzulF8/FEyTig2yovmwEdbskjUNPb/D1q13s8e2pIHShh/vrTN7EuxZ2fUi7KSx1R5mA7
FSs=
=Bx5L
-----END PGP SIGNATURE-----

--vhAJ2t8jIo9Nh4iC9RyWwIQguQYgkZ3rE--
