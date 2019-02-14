Return-Path: <SRS0=e9ua=QV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5801DC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 07:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 267F62229F
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 07:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="rGF0/+BT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437264AbfBNHiC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 02:38:02 -0500
Received: from ozlabs.org ([203.11.71.1]:60251 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfBNHiB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Feb 2019 02:38:01 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ozlabs.org (Postfix) with ESMTPSA id 440Ssy68TWz9sML;
        Thu, 14 Feb 2019 18:37:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1550129878;
        bh=mhSnKBbxtFBqhKsmuQxMGBbzf0loUXWxbGsgZMCPC/Y=;
        h=Date:From:To:Cc:Subject:From;
        b=rGF0/+BTCWD3C4NfXRFxeBn3gVIhXPbXMcgTG/NgDdNf8ArhsU0Sw5rXLfVZmGEo5
         shlSbFRT23P3ui5qK8NqSU2SEsTd3k36Kfd7okQP7xlYFkcugc0t1mZk7tSzVQfTOX
         drnL8/l9hQKGzhJmezOxnA28C+R5G3X+c9USG/EB7rbxsautPDMjvMFvXhSHNKf/2l
         +IiwZTH90p+y7UCHZZXoHbxu3Q619IHhCBHr4knWCak1X5HnSZQd78I3XColddkogA
         zul9aIQZFjx9rqqXjtytbw0k0Yw0Q8yYzR3Dxm2c4B7C9sJwLb8RM6ZJsrs/GcttPT
         5qesR66G/3NLA==
Date:   Thu, 14 Feb 2019 18:37:55 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20190214183755.71b8f1b4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sgSiSkvbPg_SznL/PXDkN3D"; protocol="application/pgp-signature"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/sgSiSkvbPg_SznL/PXDkN3D
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  375808983c63 ("smb3: request more credits on tree connect")

is missing a Signed-off-by from its author and committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/sgSiSkvbPg_SznL/PXDkN3D
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlxlGtMACgkQAVBC80lX
0Gws/Qf/aJHGk5hm9nMhBvPW03P4hdyJ/aDbHk8OffH7B07VO5Cmx2jAb8zd19nY
VQFaDcV0CTTlD5nJKXKkBFO9mZg8Xa5GorDvbe8EkU50brxcQ/yvG/z+fBsywol/
Up7Wr2TdJX1dHRfVMehw7bxY1lzwGoaA2d5m/Jb0lOVmxznwhxT/gSPcaxJGD5KN
4/bT5KZ4LyZIsUy14zL4KIS5vdjqdpzNHhBihyOhwGYYRYnMKhOLJY3A/oV7LRFU
RE4TTRRDTU5qgnN2qHFpUcz7NAvhAS69uKanlv0iV95CfWJb3RXv/0i93RZSXi6a
hacu0OkUkF3smHtm56aFoaZOYFIezQ==
=DS9N
-----END PGP SIGNATURE-----

--Sig_/sgSiSkvbPg_SznL/PXDkN3D--
