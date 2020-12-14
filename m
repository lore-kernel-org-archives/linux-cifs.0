Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B37C7C2BB48
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 19:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 786E722509
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 19:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502479AbgLNTdb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 14:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502472AbgLNTd2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Dec 2020 14:33:28 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CFCC0613D3;
        Mon, 14 Dec 2020 11:32:47 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cvs3w1ZMTz9sSC;
        Tue, 15 Dec 2020 06:32:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607974364;
        bh=/jVB/V0DgR/mC21PqfU+xY2yhAVJaq1lmG28ELTV330=;
        h=Date:From:To:Cc:Subject:From;
        b=JQoJtLXE8iHGwL2WO5QoIl44ztwHSHpKNVD9oQ0guXpgxsGEP83zjvDeGdn9FKqqA
         glJRQ9Op7tlnQQRxxSMUFR/cVYieb/FCRgR6emOa+6YzW+EA00daLVe/6ypzVlu6rJ
         PAupWGVzQ+vIoxacEn//yfoqijwiOJZX+kzbH67goAHK43qIG+DxfWufDOB4tiuLp8
         fHYe5npSvw9QygZCghzHs4raa9kFXCLrbLA22EgH8Owe/ttUyKB/lYYTEs7+d2MuOy
         wQkieEkH5rYelltQPwOcvsHFV0Ynt0f2/YFp4EiFpY3Rb/LF6eCP6IDeeNULF/Dy99
         /0BfxrofzqlOw==
Date:   Tue, 15 Dec 2020 06:32:43 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20201215063243.236b2a60@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/bl5fLCs4uxLaiAfXUEzkEeX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/bl5fLCs4uxLaiAfXUEzkEeX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  425f40482491 ("cifs: fix uninitialized variable in smb3_fs_context_parse_=
param")
  8cc9a66ea70e ("cifs: update mnt_cifs_flags during reconfigure")

are missing a Signed-off-by from their committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/bl5fLCs4uxLaiAfXUEzkEeX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/XvdsACgkQAVBC80lX
0Gzyzwf/dEr9OkL4x7O3ckJFjVWs8Hwr9rHyhygVuWwhyXv3WDHHT4W9L1jrWuBx
Txsj9fvNB4hdJC2G0g3vmS7a9a3k+ZAOaJfGTA2RzMbYB0jnnj4jzmMCpHGS0v9U
nUOEmkuuMPaC1tkmZ+ub3YUt6UqKRkvBrr/HPMtKIKeze/bCLyKmjB5W36afgDl5
qcM4/jY0KnltKzZFBZPQWBllhM6QB+1lo5BEUkC0oVRLN7XEAhtNxtFdjbo7Uk1O
yRO3U1sJME232QmB+FFpSE/NO1iApqRj/OVE9JxMesJOEGktoPcGFtxnmjXF9oMu
61bhavUHB+V7Ynum0R+3RyoPr7JMug==
=iGUD
-----END PGP SIGNATURE-----

--Sig_/bl5fLCs4uxLaiAfXUEzkEeX--
