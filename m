Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2D3ECAAD4
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Aug 2022 21:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbiH3VnG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 17:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiH3VnE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 17:43:04 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7567D1DF;
        Tue, 30 Aug 2022 14:42:57 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MHLQ03w2Wz4x3w;
        Wed, 31 Aug 2022 07:42:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661895768;
        bh=Q7IqJDKJCKu7T16GqnyVT1LzGNUcjF5DgByltIzNeZo=;
        h=Date:From:To:Cc:Subject:From;
        b=YMwHgrEVTFHvsL+jlbmN0AK4FrOaHgLMA5Nd/cfqcoFw/Ttkj1vFAsELRN2GcLJh/
         Y4sj66XoYXCF9NeRZV2hp+Yhm/C66DxnX1Ao5bQxRYT3dKwGdaOtDfiFVycs/j59Q4
         7y/l+kUeGRWRl9OTFInkAGVsbtanCGL6Kn5WC+uKa0KCHgqP4yvBxgR41DCITkty9y
         b69WgiyZ9J6xiuhUv7MmDeailfV6ka2BnLMAdd4YIvW1inl3T67iBkEjnrQCkJq7Mz
         A1AIwJCYNQJm1NVqNb3syLR6oSvOhjBJ1dSCM+3i00xYCuvsFMkurEjrFZQwXsfEsh
         RB5QRThJEnnDg==
Date:   Wed, 31 Aug 2022 07:42:47 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the cifs tree
Message-ID: <20220831074247.5ae119a3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JdUuOIdmn1salOT5REm8Aj.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/JdUuOIdmn1salOT5REm8Aj.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  ebcc8ccc13e0 ("smb3: use filemap_write_and_wait_range instead of filemap_=
write_and_wait")

Fixes tag

  Fixes: c3a72bb21320 ("Reviewed-by: David Howells <dhowells@redhat.com>")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

So,

Fixes: c3a72bb21320 ("smb3: Move the flush out of smb2_copychunk_range() in=
to its callers")

--=20
Cheers,
Stephen Rothwell

--Sig_/JdUuOIdmn1salOT5REm8Aj.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMOhFcACgkQAVBC80lX
0GykFgf+MDNlJKKmkjYNGKjErB2+QIzQzTWCXNR2NSi7GkPIgV/bK2jnihERXFM0
gXdgp13LTA66EcSZrTklRRzj7BB4mVZbeDt6qXZ5NXInbFJkjUVyycxQv69A38xU
+CZbMdDswJvGRhBPx/VRi2I6k+9vMg6jOko/J5R5Rzt4/ZMMg+dGCEU7iOojb3g9
OVdNBuBiBpzXFoPLSld/WMvs2iNdw6pfzWZwCfLOdqO7/zvB6G+ZmQsk+t6S0Su7
fpiT9yQXzgP25gZ1LBtNl5zVm0r1FVNucp2t53bNABPegzoz+gr9b9bM/Sfd5SeB
4MOdKo30b0BPwcN0nbmiNVp6vw+7mQ==
=XEr4
-----END PGP SIGNATURE-----

--Sig_/JdUuOIdmn1salOT5REm8Aj.--
