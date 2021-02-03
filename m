Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA3CC433DB
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Feb 2021 10:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBCB264F5C
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Feb 2021 10:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhBCK76 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Feb 2021 05:59:58 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:47611 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233575AbhBCK7y (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 3 Feb 2021 05:59:54 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DVzFp3q1Cz9tl5;
        Wed,  3 Feb 2021 21:59:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612349950;
        bh=lL0ZqYRnBF/nBTx0ONSa4yjnKXbiIM0pRBjh+q7JYUA=;
        h=Date:From:To:Cc:Subject:From;
        b=caVAH5i27DxQXuKrjuyHFbUc8knic9+nAAU/mW1mr1LAImnPsz7WGUeJISSb/8Fjg
         KD8A2OpvI2o47X7gZVvNZMWfeoa3VSHf5enT81mMpYs9ECnwUuPxvXco2fkFSaFS+E
         iUEQiMEIcOnyMp9ooHw9cJtLdbjPjVVaVByflS84H5SVzyo4NBe1Ihz5BhY/Ys3UlN
         umuczn5GiNdqp23r6grLT/6dUfMt3FLCbXbFTSBu+DOTQVBHi32nRiW2acMcOM51vn
         9VWyRkt5RXqEkL1qlVLc8Pe/Liyysf603cH/LBiigsdVnv9O5JcBvFlCxbY2yD38qU
         xec+AY0evsy+Q==
Date:   Wed, 3 Feb 2021 21:59:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20210203215909.5713dbe6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/g5f46r=fyf1WQL/csWOdZCe";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/g5f46r=fyf1WQL/csWOdZCe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  37595a5c8a51 ("smb3: fix crediting for compounding when only one request =
in flight")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/g5f46r=fyf1WQL/csWOdZCe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAagf0ACgkQAVBC80lX
0GzBtwf9FlpWVEdcCGMwGbXL1f7152S0ONqPQv6g8VW8pNsHcuG6JJNwNlAkl/O5
O2jldGe5j7InGjT/ZadLqFiexVi2IHyBfzG2atUkGpBUNWnWdjYyQLU7aE6xZuLG
oabtJ2fJRzeCCL9yn6q/N2Wq8KM5KxuNdaQOirDA5HQbuJtYbSXnbhapWGY6ulhP
a+JfiBktdboCqwREq5XZBIs5HvZHXhZNELvX/yP46tjeiIOS6XTbLP6yYuyC7Zhm
9KIYdDLvefgPSTAe+fLW3tIJkXkdfdE2ksaoNxO2a2Zkg5gpaRVUJEOQg8xBFLwB
rtz9gxTrCWOSRo7z2QR1QKY4sN5lrw==
=1dgi
-----END PGP SIGNATURE-----

--Sig_/g5f46r=fyf1WQL/csWOdZCe--
