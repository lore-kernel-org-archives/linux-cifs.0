Return-Path: <SRS0=8TPy=V5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840D6C19759
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 21:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5406E2080C
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 21:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Zjzn8KFh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbfHAVy5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Aug 2019 17:54:57 -0400
Received: from ozlabs.org ([203.11.71.1]:34175 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730419AbfHAVy5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 1 Aug 2019 17:54:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4603xB6btMz9s3Z;
        Fri,  2 Aug 2019 07:54:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1564696495;
        bh=KPSAi5E+QrUSQRNI6r1fH4edAAA6UKpIr2v3WfOzsUM=;
        h=Date:From:To:Cc:Subject:From;
        b=Zjzn8KFhqkkNwUTuWoG0Xvc1yGBWR3A9ezgltqCmGPDn25E8O+0dQ8dECIltwbTiU
         Uq3zA0LUOldzWueWuZKRyqqTLvQxzyx5/WSnw2uaE1UCj9CqdCKbP849IOOCsea3Lp
         rpUOzcswmjphrkGjkvQB7QLaLrB38iISvWMeH0oWMI2oNt0NE5OOVSEZ2jqzdVhCX3
         bVzgX+PpXcqgxMHy+g1CiFa+BNq4BRd8ubiwSOWgeAaMT2dsupwoSaKX7X7Zl5HfVn
         wIUD1hxSXULnH84j6+v+yqWPA6Z6RtGX3jZBwfSR6mK2nnxoUQGvo2FVUttEQj7S6Q
         aLJXzvIGNqY+A==
Date:   Fri, 2 Aug 2019 07:54:53 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20190802075453.06066be1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Tvn2OBSDkwMEDVigN//YA/m";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/Tvn2OBSDkwMEDVigN//YA/m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  c3ab166ec798 ("SMB3: Kernel oops mounting a encryptData share with CONFIG=
_DEBUG_VIRTUAL")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/Tvn2OBSDkwMEDVigN//YA/m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1DX60ACgkQAVBC80lX
0GxHhgf+IB5SocUd0MMJ3udUo6oRImUgkO4C10Y5xlU9lvYlehoV4DT348vKYMYB
mGqvq4Og5JHUXg3CG4XR06uLQATcXJn7ao7zUqHixOL1a+idvNAFCZ2mjqL74QsS
9ZwqxwZFdGb5ELYWqoq1vxN2a6eTRpSmjRgf2XYinEzdNvR5BVkMDmXw7BkwLtN+
zcBIFefBRWYoocKqbV4QkJlw3usjjnDWvSL2pSyim5yJlP6Bqax9wkqYkOHr3cFf
jp43R8ytVZRH8Vnm8Wn2WAlUXCT8qlR+h2fIkVXttuRJYzh7kwT/TYZqLNEY/D4j
EZyenU+Bdy1TUg7hvSO9X3jIVpjfmA==
=Dju+
-----END PGP SIGNATURE-----

--Sig_/Tvn2OBSDkwMEDVigN//YA/m--
