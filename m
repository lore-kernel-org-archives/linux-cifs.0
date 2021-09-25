Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEF4C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 09:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B974261250
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 09:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbhIYJRk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 05:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbhIYJRj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 25 Sep 2021 05:17:39 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69301C061570
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 02:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=FG5vWJZYYjP3dyztmyJtO08cLNONH4wCtkRs1tBYSJE=; b=RMBSXydejFQ4f3UiL2zDmT9+qT
        REjrMLRsGivbzWC+8/beCndBIczUM+hOMFp9dSGXa84Fls1+upo9qGZV6Xtl6BRSNP1i54NAcQvwa
        Hlfdfe/L4Ucsl4zR8N6A+j6zHeL699voEFiI6l40pKh0WjSiDAucDlP0z3knWyyoh36tfBo6+9fsb
        a/YqaPNMRvqDst+dUsmYF+WlMDQMEtTve4N92qbmU5xctwNTFoZunH2CqDhCEa4ESHRlkEce0qgRf
        2vZnSSNqLpKONyJEtWuzr8LZA+J+RGKa2qlH7zA23D6uLD+XC+Eb2V0C2niaWiSIa1Klzpb4OcHl6
        392Tvm0fSzUKtzP+xycLxOLj4C6/ILpkZqcOenDNBoRQWBz1M7FekCklxnfolUkDHim4COZCTy0Cw
        GeVnBkFoj3bm0qtpZ7KSO/1ztnUCwSVnwENuOI033B+bwTxSps1/xYAw3tRk8bslq9p6GtRxr1J8T
        47ypSGeIx+KP35Fz8Q7XhQG5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mU3mr-007obF-TU; Sat, 25 Sep 2021 09:16:02 +0000
To:     COMMON INTERNET FILE SYSTEM SERVER <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Subject: Building ksmbd as external module on kernel < 5.15
Message-ID: <040d44a6-5c7c-5053-6e03-8db045519c0a@samba.org>
Date:   Sat, 25 Sep 2021 11:15:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CyTq4jLJBomlnRRbLjvGkJ1R8Ui7P4DNO"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CyTq4jLJBomlnRRbLjvGkJ1R8Ui7P4DNO
Content-Type: multipart/mixed; boundary="4kJYd65CYdTVrqGf0ODLPv6qS0jTlMKFa";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: COMMON INTERNET FILE SYSTEM SERVER <linux-cifs@vger.kernel.org>
Cc: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Message-ID: <040d44a6-5c7c-5053-6e03-8db045519c0a@samba.org>
Subject: Building ksmbd as external module on kernel < 5.15

--4kJYd65CYdTVrqGf0ODLPv6qS0jTlMKFa
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi!

I noticed two problems building ksmbd as external module from=20
github.com:smfrench/smb3-kernel.git:

1. Need to manually export CONFIG_SMB_SERVER=3Dm even though .config=20
contains it.

2. Use of lookup_one() not present in kernels before 5.15.

See the following shell dump for the problems in action:

<https://cpaste.org/?cddf4595181c8c42#8HKBmcBcP8hE2RUhG3wi3QbsQmAXHDtVuMF=
YfeuYz7Lj>

Wrt 1: this was exported in Namjae's old git repo=20
https://github.com/namjaejeon/ksmbd but was lost in the Makefile rewrite.=


Wrt 2: it seems the patches included in=20
https://github.com/namjaejeon/ksmbd around=20
9caf6ed9f0b6c71b0bcc661b316e08172b7a6d55 are missing in=20
github.com:smfrench/smb3-kernel.git.

How shall we address this? Is building the module on older kernels (I'm=20
on 5.13.14-200.fc34.x86_64) actually supported?

Thanks!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--4kJYd65CYdTVrqGf0ODLPv6qS0jTlMKFa--

--CyTq4jLJBomlnRRbLjvGkJ1R8Ui7P4DNO
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFO6MsFAwAAAAAACgkQqh6bcSY5nkZV
bBAAnve3Omp3OGXBA/Ro4SdyTDZAvSOCWZSFYg05ECoUqjCBwcVbRtNRK4qi95Emxe6n9bRPGZSy
4/wtD2fY9oL8lYQCN2bJQI7Jca5xAevGOtHhpsIz2/W9XVZLjbtWXj+tUIY5UU7RLu/+2GewhqBQ
VNzMOtHa5L+PG8//7sY10Xq9LlDadzRLBi0hUSXJr9YmALuNYnL5+OjAwTNyKCAqslYguyvdLpco
p5flYOna/bY00Gq80peJTvOk0acz3qVupZWWoTNvpdgToMpnvmMleiFJQxng1JTik06W0J6vqo1v
MISyMv1Md/OR/hrZ9F2WU1j1vzv+pXesrqNGNSRG5C7wQbJ+uE7E3MinZdq0owD+FM55lLiEtf5m
h7W1IV3bF2TSyjjXdjXHbrAUuB312Ub6r+5uoaABhR6Pcwu3YU1Cb+6ShKMA7GNgSOPrrJ8nyUN/
/7j+CuA2+j8FwYDGwK4ADDG41S2X3JS1ims1M7oHSXUrhMzmhdLEiFZSXQ9agtcBmJEovtharq+j
PjYfsgh9zmBPcZ+92NnEW2x2derVnPepu2Ghbzjy1fyeMZ66zd5CZk7bOmZQdlneKZR9SIvihaVD
YZmYjVRjuYhX75PCaUj2vFY59YPXZsoSglGdc9FFPOaPappILeA4AgR8onHX5ZmBhlqY3AnOvDZG
PbQ=
=a9nu
-----END PGP SIGNATURE-----

--CyTq4jLJBomlnRRbLjvGkJ1R8Ui7P4DNO--
