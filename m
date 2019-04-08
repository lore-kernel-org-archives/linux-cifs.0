Return-Path: <SRS0=JvIj=SK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07833C10F13
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 21:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9B9120857
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 21:38:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="ckueTsRW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfDHVic (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:38:32 -0400
Received: from ozlabs.org ([203.11.71.1]:51593 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfDHVic (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 8 Apr 2019 17:38:32 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44dP1J6whwz9sQq;
        Tue,  9 Apr 2019 07:38:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1554759509;
        bh=5aCzkUiFxV7BE5TE4jDfYxi4wz3UG/eF/H6aCDROU4Y=;
        h=Date:From:To:Cc:Subject:From;
        b=ckueTsRWZ692u7uEo6Uy14un6Z+uXT3KsfHKqJlPgxGLStFbtqwVcjurUg1b3uYZ/
         s0SNs/5CUDwSZzB4LG8KoZkRrmxiVdPX2NZPw/ubhO6p0Yt/symws6tcjWqsvUNf+4
         TssJOg8YeCxDEsf/alOVIF0QGgx6r9spSWIjKwbgu+/qWJISIHP/6qZoc6Vw8ZGt34
         aWCM5/dwv8hXkeOt2cXVD69uGjPHUQm9JuzQ15E9PDrZWgTed/oSb65BlfaFAFxo4u
         QlQgWx1MJQLHbY00xPwhd0506MF9OPC71HHen5TEzLWJDz6/rhy9P5LIJMEPol1BvM
         1oo8yrD6xG8MQ==
Date:   Tue, 9 Apr 2019 07:38:27 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Subject: linux-next: Fixes tags need some work in the cifs tree
Message-ID: <20190409073827.0ac717ab@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+Cxg+ESuN=N.06zze4DXxV8"; protocol="application/pgp-signature"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/+Cxg+ESuN=N.06zze4DXxV8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  7d672725ba72 ("cifs: Fix lease buffer length error")

Fixes tags

  Fixes: 9764c02fcbad(SMB3: Add support for multidialect negotiate (SMB2.1 =
and later))
  Fixes: d5c7076b772a(smb3: add smb3.1.1 to default dialect list)

has these problem(s):

  - missing space between the SHA1 and the subject
  - missing quotes around the subject

In commit

  54492efdd6a2 ("cifs: Fix use-after-free in SMB2_read")

Fixes tag

  Fixes: eccb4422cf97(smb3: Add ftrace tracepoints for improved SMB3 debugg=
ing)

has these problem(s):

  - missing space between the SHA1 and the subject
  - missing quotes around the subject

In commit

  3cc71735cf9f ("cifs: Fix use-after-free in SMB2_write")

Fixes tag

  Fixes: eccb4422cf97(smb3: Add ftrace tracepoints for improved SMB3 debugg=
ing)

has these problem(s):

  - missing space between the SHA1 and the subject
  - missing quotes around the subject

--=20
Cheers,
Stephen Rothwell

--Sig_/+Cxg+ESuN=N.06zze4DXxV8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyrv1MACgkQAVBC80lX
0GxowAgAmWmMbbAKkYvsgWwAkJNtKonbxiRW3nk1aPjQXbQrLqDmc8SdjhMyKWVF
1jPLs6D1sm0wzpeY3Bc4SO69X0+EXWggFwDKbrYhBNSGdmR7iz5PWjWfg8cbrbYL
YL4tb6268WhFiyMvnPYdGPhbsI6bwTPyDecJQBc36p+oggsBzeXlb1UXbpAw4A7E
tf2lJheJqyh5yw59wGILvqiUK40hcOsCb2goJv1xsQR330IGQw/fd/YEcJ2S/O4o
Og5iB+Bs8oUmuLlf44ACX8U9rvGSvVPP9TearlnW2Tc9WL/yez+3UU8rdnC+EJtR
56qyY+xb/SkSloKbDOblt+WCYiIEjQ==
=gmhl
-----END PGP SIGNATURE-----

--Sig_/+Cxg+ESuN=N.06zze4DXxV8--
