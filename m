Return-Path: <SRS0=6r7N=3F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E663AC33CB1
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 08:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD224207E0
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 08:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="lmoeG/px"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgAPIOB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 03:14:01 -0500
Received: from ozlabs.org ([203.11.71.1]:56785 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgAPIOB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 16 Jan 2020 03:14:01 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47yxmP1NLkz9sP3;
        Thu, 16 Jan 2020 19:13:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1579162438;
        bh=YaNdal+dN5QtrmHxhWGaupnkNhgoh2PLOWXV49ePTok=;
        h=Date:From:To:Cc:Subject:From;
        b=lmoeG/pxjJl7GUuHKLqUn+qD9v/WtmyCFvbyetCkOU2KhVxCy5Up7eFZlxqVEFhik
         YqnF5/QWOcd7y05WoYfi4qsJAGGX2qmXzGxjlSXK+cUVM3VyqtQaMC4ee2jguEF7Yi
         ZfMjf44jpN1cd7EynJwyeaCoPnXG64UzdVUPLsKo13vn8jpft8fSogwcAAaUa7gh36
         BMPHoYbNoZLx6DrVjAitz4x24st+/1Yw+abyyWYOd/99/KrVTz7u3mi2pbpIQ+U2w2
         4HHEfDAd8vkYizCVCt2h8bD/jk2M7Z4xWi06jQEZJasCf2xn4LioUkKhIGutW+Lbm6
         oqUaSWPAXDIHg==
Date:   Thu, 16 Jan 2020 19:13:52 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: linux-next: manual merge of the akpm tree with the cifs tree
Message-ID: <20200116191352.64fd4030@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7WUCLXXBwbjPauelIBabN7_";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/7WUCLXXBwbjPauelIBabN7_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm tree got a conflict in:

  fs/cifs/dfs_cache.c

between commit:

  03535b72873b ("cifs: Avoid doing network I/O while holding cache lock")

from the cifs tree and patch:

  "proc: convert everything to "struct proc_ops""

from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc fs/cifs/dfs_cache.c
index 76ffe12d64f5,6aad6a2bf8f0..000000000000
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@@ -5,6 -5,9 +5,7 @@@
   * Copyright (c) 2018-2019 Paulo Alcantara <palcantara@suse.de>
   */
 =20
+ #include <linux/proc_fs.h>
 -#include <linux/rcupdate.h>
 -#include <linux/rculist.h>
  #include <linux/jhash.h>
  #include <linux/ktime.h>
  #include <linux/slab.h>

--Sig_/7WUCLXXBwbjPauelIBabN7_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4gG0AACgkQAVBC80lX
0Gxm+QgAguwoc/IfgDUQTCD1b5rTP9nohTxAMFpPEsT3Vho54cpnpRlZO9inVK+d
Tu+AiiOTQ0HzV5Ddzjhk1fiEqNlmSOHaNPaZ+uoBp3J6fwvVXrwN3Q0TjPXeRN2D
DykB4e+tIPCGpFhZbVqIeA8HT9TOXOJPSGdSgLUqI9WLDk5Liff7oeB7Wa5TeP5v
VyRs7P0+f8mib5Z2bmxlyY/R2H9pvlOT9+1gR05sZGkbj98AY8IF0EVwRLfu7pBG
dOfBykQ0j14xTVsFrdLQSuwjJ6HaG0TMQehjg9b7Oc892sTsf6EUsAxVfrcpDdNE
wTofp1oOzorBe5IFkA7/gZXmT0PZNQ==
=tyCt
-----END PGP SIGNATURE-----

--Sig_/7WUCLXXBwbjPauelIBabN7_--
