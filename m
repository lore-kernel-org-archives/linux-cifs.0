Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653D4C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 14:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4707E61077
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 14:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbhITOqd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 10:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240693AbhITOqc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 10:46:32 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84542C061767
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 07:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=kTZ8l44nGuZW4gw+380T0svI6J+36TQZIQW0Hf6zlIM=; b=s7hSmLwUQiyICmIDHpFGVqw/zS
        cdMhPVl7FzXUVo64RU6nOEMgmMhEamUWRp+M9ny+1fvS7W9Rf/l5xX0ZloWtuu8xa3nnXIiIPBiHj
        j0Ji5pprt/m/81549NCR0aq1qTvp/J16evEkIayJvOfKzqiUOjGtUMjrMmJ6kkkt7T5PpIyKbNxL2
        adGygveoZlUKOJgq/AJasejMByeCQj3QcZIUMt22nS7PrdHz4cE5iJeKKuqIRYfqUSGzYPFeqGiNX
        FcrTtABYhLLoWydSrgOteP0+rBLcYvzs2jcJ2C/mPpd2yqNkl1jJNtISKFRkMuYdIdGtHxJVpMu+l
        hnW6PTQuWlEnSxRebEzQCTI54hPunpMABE2nUlckwWgJxRhUrLh/M0JtiG21lEVMkauMWYCoq4yhh
        +uzGgbgfv1DsjCn/evW+0mG20AmBqCXrbU86syvKmzDPpbglmHWtDMke5tii3xUCnd9s1aUtVEMxR
        GPAJsBLHEEEZbLMZKSRw+S8a;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSKXX-007085-Ne; Mon, 20 Sep 2021 14:45:03 +0000
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org>
Date:   Mon, 20 Sep 2021 16:45:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210919021315.642856-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2QXLyihWgsOmgPOWzUc0DSH438ns2qZoA"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2QXLyihWgsOmgPOWzUc0DSH438ns2qZoA
Content-Type: multipart/mixed; boundary="qrjV4ytrVQFt9lJtmVHRqSiUKlXa6tUZc";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org>
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
References: <20210919021315.642856-1-linkinjeon@kernel.org>
In-Reply-To: <20210919021315.642856-1-linkinjeon@kernel.org>

--qrjV4ytrVQFt9lJtmVHRqSiUKlXa6tUZc
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



--qrjV4ytrVQFt9lJtmVHRqSiUKlXa6tUZc--

--2QXLyihWgsOmgPOWzUc0DSH438ns2qZoA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFInm0FAwAAAAAACgkQqh6bcSY5nkb9
8Q/9HSlTD8qchv9+gmR+dGRacIPQiTND1b7o26eOxTvxwgscM6krCL7VJF619IiucCShNgDVZZlm
tftVrPAjmx6k0XW/vT7QLprYZMxHflpS0taMmYGaCHiYR42mw8rWll2FqAseOPl3DPbSJJ9nagsy
AAH0nhsgALz6Yo5a38vREzHLyuDYwQpNn8J9gOFEnnpa6k8QSB4uAu2a1hVWsO4XzrKHnVc2edvZ
ncTwefC7ed1GpyPyjewXdP6G0Cnok1QaR9XWI4T9QtLlONc3gVJpZ9fxEzPa9Gi4W9+1dq9BHxnH
FNbNd690/GKZaY9WlozUqWFXsXmziXp9kZazoUSSMYP+C17Wfv0ECxjhVEq6jqkvXcRx6bQYIq4I
WYuMoX4r+qJdPube4PdMCJe6xJQ1gGBbkKDcYMvUBFJVhF1xEcFLXE+/Y8yWcpgQspnbkkdHnnnZ
mIzBGXWXKitgehY0KJEdqy/zKDGlpIBvgYMejeD8n+Riz8W2B56VoDFqFc4nYvj43sQF/jqaS36Q
t3lVEpl2Bi3m+1JpTSu/dh/IRexoeRv1SdBi7zuWPXVF5GyGDGcZGuMtd5xh+Ic7sguk+E6EnuEI
NHmI/1Mv8Y5fLR2SfZ1/D6LIx68xqbgAlGWFa1g2bxdtu1TciQnZp0thayPoTmz4Gxhrd1uJeprx
+Vc=
=n9S7
-----END PGP SIGNATURE-----

--2QXLyihWgsOmgPOWzUc0DSH438ns2qZoA--
