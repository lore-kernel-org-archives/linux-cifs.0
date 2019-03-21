Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A573C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 18:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35E5D218D8
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 18:47:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Tgqylfob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbfCUSrr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 14:47:47 -0400
Received: from ozlabs.org ([203.11.71.1]:58265 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728498AbfCUSrq (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 21 Mar 2019 14:47:46 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44QG4c1cx7z9sR9;
        Fri, 22 Mar 2019 05:47:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1553194064;
        bh=ALoByY0mcq4FMY9PtPluS6HDYhbNnwWfu8buEwlWV2M=;
        h=Date:From:To:Cc:Subject:From;
        b=TgqylfobvzZ9si8xrtNL7XBuf8Hmssk1VZztcbEcGNPJ0sdQwpOHxp873cSB0232U
         13yemyy+IYKEIcQWi6Zn3xUrdqOzCamEQYo/OYS0XAJwvmbIHcNMbw9yyguFgd9ZMK
         S8zBe+PTktU2DjGo6+IFKkUc+1VZ6lxH0Phe85s3q525u8z/R0o/M7AjG7FfrzKCAV
         wcufE8Z2jjo4NaVagxLOmiJkLFT4SCgGHal4qE5mvamdKeQTTDRtwS7EtUF0zj3qbV
         ZtNKW5Rh+2FTxjmv3m2vylbPIM3axBon6vASWskS3xejsj3c2xFxUxYezUHzjVJygt
         e0h72IY4zQhJA==
Date:   Fri, 22 Mar 2019 05:47:06 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20190322054706.3927b16a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/o5aiCENrLJUII0zYC4p/xDS"; protocol="application/pgp-signature"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/o5aiCENrLJUII0zYC4p/xDS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  828a8dfb7069 ("cifs: update internal module version number")

is missing a Signed-off-by from its author and committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/o5aiCENrLJUII0zYC4p/xDS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyT3CoACgkQAVBC80lX
0GyPYwf9FdAdq2bNOT6VtQ6FON5QJyWbNUu4DN29xAkMMnUxjNEy5Yk4rR2rKBA+
nV2BTOquTzWkXUifkMiZZmeXFIYWhIhhQhzmj3XDAeO0qFuUOVZfqGAQH+2wpoGu
YunCrSuuf45RltGrSlnDwZdOxcYVOTCxhspsjNym/hU4R1g6699NWomOKjAvj/tF
yvZEBcrOMaz/hKpOJ9+CSC+lfyrWTidCuvqpucEIyjdMOdMaqXjuyNTAoUeSNiZj
jPgTELvbgIjbINY/4+6tKbqTybPoeATchNXWXXnLI8Yxnbx90NyZgI/qD5Nu9428
qLbF8SSAcAPP/1YBpXe2TBE5JtE2xw==
=Achl
-----END PGP SIGNATURE-----

--Sig_/o5aiCENrLJUII0zYC4p/xDS--
