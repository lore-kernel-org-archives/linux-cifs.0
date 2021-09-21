Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EA8C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 08:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5439661181
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 08:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhIUIJx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhIUIJv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 04:09:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31763C061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 01:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=RiJ9ThGUtIJeRWyFHTsNEWL4q4cx7+KmK+Xguolq8Ss=; b=20N9r2CRVUHsWJr7CiM+Y+jPss
        uUVdy3PPrTNYHxfYnoiH4Pa9FuqYeHP9gn3nNgU3I4/a5lnBj+bU7R1ZN5XUvaBXQL5GXVhHC8qei
        oEIHiScfRbAuTkibgV5e5XgcSnHAuuGRyD+r3XEbEyAedcZ8P76eOVTo5nsnnbWkenxIFYGQJ6M6H
        UhxG2y2elqwFTSdYtpL8Q7gp6lfIXpgx92E5zmWoK8fdxm0e+pTxICgAiDFCT99vd2n3aoQ+nwePV
        aW4xdcaJr6sMwA3iCQWeGdFqCgYHNRy+josHs65GPUqeFlfDEL2VwoZhvdw9rXZSd95PmtH3NRrAO
        S84C4d8LII+ex/PUgJNXAI5QiaK9wE+xQXhK8zFYHakWe0jUPbhSBb85JQgi86mbaZ4ZPWKtnQx1i
        y5LiOUEnreAw8HfarfogWl5Gvg32nTJt51RX4txEosg5YVfubyv4zxIvdG1l+iTtsvulIlsU1J+6K
        6NpGtAAXDxihWpgs/tRox8ES;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSapA-0077my-UD; Tue, 21 Sep 2021 08:08:21 +0000
Subject: Re: [PATCH v2 2/4] ksmbd: add validation in smb2_ioctl
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <20210919021315.642856-3-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <e053bc26-0170-0d48-3542-e3e8059735db@samba.org>
Date:   Tue, 21 Sep 2021 10:08:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210919021315.642856-3-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Saj7ftCcd6HeC6wQ6stayNwCImmsuGfS9"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Saj7ftCcd6HeC6wQ6stayNwCImmsuGfS9
Content-Type: multipart/mixed; boundary="k7XR7cFDhtFo9OyBqDa5pYI0v6qdVTwRV";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <e053bc26-0170-0d48-3542-e3e8059735db@samba.org>
Subject: Re: [PATCH v2 2/4] ksmbd: add validation in smb2_ioctl
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <20210919021315.642856-3-linkinjeon@kernel.org>
In-Reply-To: <20210919021315.642856-3-linkinjeon@kernel.org>

--k7XR7cFDhtFo9OyBqDa5pYI0v6qdVTwRV
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Namjae,


Am 19.09.21 um 04:13 schrieb Namjae Jeon:
> Add validation for request/response buffer size check in smb2_ioctl.
>=20
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

the check looks good. May I suggest to also pass the pointers to the=20
structs instead of the raw buffers consistently, same as we do for the=20
setinfo levels now?

We still pass the raw buffer to fsctl_query_iface_info_ioctl and=20
fsctl_copychunk().

-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--k7XR7cFDhtFo9OyBqDa5pYI0v6qdVTwRV--

--Saj7ftCcd6HeC6wQ6stayNwCImmsuGfS9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFJkvMFAwAAAAAACgkQqh6bcSY5nkYi
qRAAm3O2FNDH7jOtXshy5NS5A3Vzes6ZkVf9OMXukOi4/hDPXoLfTFFeb7pg5DtfbSLcgOUenSXI
E5eiNQ6mR6ZIfng1PmRz+enDyIVUGFNLPXyoDojMgthdrHBNIE3/TSrOWYhkLuX/gVLy6Oa1Ox+6
s0kXWXfM17QFKCrOR0vWFF0w8AeuyKMXWl2XL6Vl1b6YRGJn6i+bouZ0zqIA2/us80ZDMtiF0FaC
9TL4CoITplOUVSLh+Vi9GmC+IJKgSomzHCfyzIykk2k3jnBML183MA5107tPvfRfDFWuyO9UiHJ/
/olyWNEg5cMaQTl72XoN6B7KY2oliAjmdJtZjUwGshfCTJVHmHyeESbboaFDBAIukqRKvf08/oOE
TiL+nvntG2wops1APLIz+njNvOrqNp4pAmgLjisaUUDZlF7caMAwKx34uEvazrJEQ8a2rByrhGfv
ASijIJQ2UVWOVDM8qOCKfecs1FVnpDj9LuPwsZxKuA6NcUae1FYAOm97ZGLg+GzKR58M8HYvRFX9
9DzNqrWXKs/tDLFP1Emd3C66v1e7hAR1Y4Li8r0eYFugh+pPYnrDl9/3GkPCAs1Aiuwx/IAESRRO
GsqRi/1HGfsLeFR3/DrLLAJ+Eov7Xe+sVO3s/0tDugwqYlJrEhq5D73JGzTH3/77HVEYqZg06C8x
plw=
=P/Zt
-----END PGP SIGNATURE-----

--Saj7ftCcd6HeC6wQ6stayNwCImmsuGfS9--
