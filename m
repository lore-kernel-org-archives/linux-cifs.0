Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FCDC433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 09:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CAE360F70
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 09:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236190AbhIYJwm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 05:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbhIYJwl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 05:52:41 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAED3C061570
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 02:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:Cc:To:From;
        bh=+pEd05JYcEvoB1lN00fgIR3R0MTA649eG9GxPWEO09o=; b=YLyYkwmo3y1XzILvgVx2nsmcfy
        grvYdgzF73bHFbayjtJ/P7HgO2b4otAuuHIjXKZc3SVKIb/0SImq+q6lbGj2f2OYnFSnEjen56oWL
        XdeAfBqRdA2jsx3YqKfmibtf6SAxEVJK+92hGuVM0k+K1QGlx33dPzMrr7xMqtlMTqhbybRPBQwB+
        Bx40stIcuWR/JaMccj62VtcsTES3JRS8Aj5R+0e0T6p3jc5EXQrQIiVvsEx5LjKN7ds+va+TQZilb
        PRWshcYFqkHdxgOvoKzswiy0aan85L2Hid1tjJbZvyYi/wjhBU644Nz9Ba6o4hLuOh/sjL+3lEIYm
        SFMNeRVoydjjVfzWKg6ad2iujMvr8e+Rm3CzDHeYfZXyekxzasw2SAP8GvzBSFZ2hlsORHG38FpKx
        YXtPzm6drTgdSrxN+vFjAMK7laAxBWGIKBEGcCFqL4Wz0olIb/C19x/n+NZdUxCpx0CKhMC5b6sph
        zkriBk/+9+uQM+FmQep94DOj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mU4Km-007ojW-KB; Sat, 25 Sep 2021 09:51:04 +0000
Subject: Re: Building ksmbd as external module on kernel < 5.15
From:   Ralph Boehme <slow@samba.org>
To:     COMMON INTERNET FILE SYSTEM SERVER <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
References: <040d44a6-5c7c-5053-6e03-8db045519c0a@samba.org>
Message-ID: <408a97fe-19dc-54dd-eb15-284043ddee69@samba.org>
Date:   Sat, 25 Sep 2021 11:51:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <040d44a6-5c7c-5053-6e03-8db045519c0a@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WnQvrqhuZ2nrBobghHql160LOllREDUm3"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WnQvrqhuZ2nrBobghHql160LOllREDUm3
Content-Type: multipart/mixed; boundary="fGQ5h86SuXewGCY9SYGyS7b7wmjk1ouzD";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: COMMON INTERNET FILE SYSTEM SERVER <linux-cifs@vger.kernel.org>
Cc: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Message-ID: <408a97fe-19dc-54dd-eb15-284043ddee69@samba.org>
Subject: Re: Building ksmbd as external module on kernel < 5.15
References: <040d44a6-5c7c-5053-6e03-8db045519c0a@samba.org>
In-Reply-To: <040d44a6-5c7c-5053-6e03-8db045519c0a@samba.org>

--fGQ5h86SuXewGCY9SYGyS7b7wmjk1ouzD
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 25.09.21 um 11:15 schrieb Ralph Boehme:
> Is building the module on older kernels (I'm=20
> on 5.13.14-200.fc34.x86_64) actually supported?

as checkpatch.pl warns about using LINUX_VERSION_CODE, I guess the=20
building on older kernels is not supported anymore.

Is there any other way to just compile the module against a running=20
distro kernel? Or do I have to bite the bullit and build and install the =

full kernel?

-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--fGQ5h86SuXewGCY9SYGyS7b7wmjk1ouzD--

--WnQvrqhuZ2nrBobghHql160LOllREDUm3
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFO8QYFAwAAAAAACgkQqh6bcSY5nkYV
5BAAmFbCYMihFDG/ArX9W2SqElf9Ul2IvdXOVF7QB3LOQp4meIKHphEjeqx+OBH75Sveo0aCU1xA
p30zj1NiYFq0GjeiXYPWNb1Dsp6YRO2PBf9Lyhx4Ae0bkkxFsSm6tPRVgdBZFh85Ntr+zjiutzKN
NBUejJT5G8wuRCzQTHlBCr7Qw4BDbdmgOGoP80DmptZCQPyMlMtQrD03+jQp7zzuW1f83KbM6rTy
TAIXP4XbPDNfebHt+wbaLbtDpCD1HKIqTFnDAeo8h9OjDj/2MU2Ulx4WqOTqe4DOo1eGJ9m7zixc
qscHO22mq01BkbY0E7K/JQ7v0UQ6uwDbE1AbyRCG8jGdhhc2Thkwa8R4jg7/GoZLFexKAOKZl5h2
xH+LhU7b295bq2CODrkCuEvSEdGe3mM6kwf+d1M0slGBwZqC/ss0YWId+AdW5vLiM1zNgaNam/bS
Td15775N6ljmVwSoQvcRQO1oShICXvmOBjGF56XlDzE52If2i94Eux6UHooJxY6xRmMo5q0RT9r9
sPsDYFH68gLdgzTYAm8v0j+chsbkkenzFhDhb7jRbcsDkHGQCrb6FXeQarEkE6e9dw87+HX7voL2
JhmanzDHAl6rlSWkMuFoFqqc4uuoVpZHQ6McKIpMjy6CotphsZs7O5U6c2p3YVQiTlHZjTv+SjQJ
iWg=
=3XHF
-----END PGP SIGNATURE-----

--WnQvrqhuZ2nrBobghHql160LOllREDUm3--
