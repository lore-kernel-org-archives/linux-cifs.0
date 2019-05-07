Return-Path: <SRS0=vQ6B=TH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A554C004C9
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 21:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B14E204FD
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 21:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="QeYpMKlY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfEGVcs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 May 2019 17:32:48 -0400
Received: from ozlabs.org ([203.11.71.1]:40839 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbfEGVcs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 7 May 2019 17:32:48 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44zCWJ5nyyz9s3q;
        Wed,  8 May 2019 07:32:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1557264765;
        bh=e6glGKSwvNIOSRSbolSuZpCB3rUX9saRiCu+3igiJxA=;
        h=Date:From:To:Cc:Subject:From;
        b=QeYpMKlYMw0lOIBu7pU0GpP2PohDEch6iMmi6VsmEujun0kJS6+0EcoUs3f0J6ZrJ
         LuE+b0U2n9BIdRubYQuIv6nw7Ct1K323k1Cnpo8J+Fb1K8bwqY1/L56LACsueIL6QT
         FRudEvpMvni3UBPJDnOoHKkpEFbxNYuEI/VPJ+1x8d9HrTlcr0phsXQSM0U5CqYFjW
         ubEf6tnPVhJbKtqpKSUd3w1iWARIcjJD2CcYejO1wJgVqdbqb5t7JnPxOUEUncCKtM
         sTwJlIzTdPdyTrPnxN6s/LPD0HUg55Xi3bfTu7Pwlx/Yk3RWU6OMyHVGDA9qdtmExx
         31pyLoBVNgFUw==
Date:   Wed, 8 May 2019 07:32:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Probst <kernel@probst.it>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20190508073238.6a5f4cd7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nV_z1UXHPRWrbHF1bVrzqUz"; protocol="application/pgp-signature"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/nV_z1UXHPRWrbHF1bVrzqUz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  b00c40f57bd5 ("cifs: fix strcat buffer overflow and reduce raciness in sm=
b21_set_oplock_level()")

is missing a Signed-off-by from its author.

Actually it looks like you were just tripped up by the mailing list's
DMARC workaround.  :-(

--=20
Cheers,
Stephen Rothwell

--Sig_/nV_z1UXHPRWrbHF1bVrzqUz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzR+XYACgkQAVBC80lX
0Gw6+wgAnPYqgMXjYLhWdeqyVk2mTpGiJyxOY7FqWKAHX5nhsBFolPphfLHcXe3b
vJnigEOtiB0S/opc0DAxQZAXXW404hF2aCsTWa9NoLlfkAUTsObsLv/l6oloK7SZ
6otfVHe2RX6hrPdqCAEt+wXtJUTbQN07PSxRNb0bSMPBhas6GNO9HW26ecFuHRY4
hAfsMY5CX/7bsSuhfgwSevxTOXFkB8VwSHjOJRoWwX3w7iXT6XVlr1AQ49oGQk6F
Gc2AiO8RMtNzQPPHyyy0QCWGZQV7ect7Z6yJOaEtSAicYNjYc00cxSINICSPUI6R
iqJxGj7zOE8Zru4GOx1kiX+wKV3e7A==
=rYQp
-----END PGP SIGNATURE-----

--Sig_/nV_z1UXHPRWrbHF1bVrzqUz--
