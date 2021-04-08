Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66633C433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 12:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40598610C7
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 12:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhDHMHZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 08:07:25 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43921 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhDHMHZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 8 Apr 2021 08:07:25 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FGKkm1fGBz9sWH;
        Thu,  8 Apr 2021 22:07:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617883632;
        bh=afB+tFvSVPpjZFZ2XPoyqVczHtcZ7+0K0bTZXcR5UVY=;
        h=Date:From:To:Cc:Subject:From;
        b=QT1D1UtyI+z+6GADlposgOWj0FIIcYcWgqzReRxWHGa3V2jrAw2AdnRVVIKAN1W4J
         nuD1pFhUfVhmbDSaPVLqsXz2/ukkyuY52yAMp1OyGU8a5q32WwBd9duey3a4v4CCKj
         YbR4cwkbTgU6ZbptIKAU0R3QAkoVSCw8TrF/wXQLY184lqJyyzCeCvz4F4UleXArdL
         tWPVFQOLLRBsX7Df6Xa5tDHg3QyjzYUJcaSMX10aApbwL7Pl8S0Sv1yqWV2BCijEus
         oM4qy/hUK1ci85eHDpZncVqmX9Ge48qqM3GzEcS7sC0YMshtkKJ4ZVyKQ5zAjTqSnJ
         WOW22ouahPUgg==
Date:   Thu, 8 Apr 2021 22:07:11 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20210408220711.5a39d4a0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7jEnSQe/RMO0Z32CLYq2aQD";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/7jEnSQe/RMO0Z32CLYq2aQD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  e67fcb31fb0e ("stuff")

is missing a Signed-off-by from its author and comitter.

--=20
Cheers,
Stephen Rothwell

--Sig_/7jEnSQe/RMO0Z32CLYq2aQD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBu8e8ACgkQAVBC80lX
0GxwZAf+NSMy7ed6NB5OayNLtLA0G7wLcgWk5J7nMb5LTg6ZB+96Q16lqgm6vldd
tqjSdc8r/WxDymJITqJaB6zZctCaO8Pcdrnbkvv/18KmlzK87kBZbb3LOvhPDOVx
GzXCEw0WpivzHtWaWdT3lbq6iaFlHfKe370poumVnnaJ4luwl6jMbcjEvCUSYl+2
SzqSKctq6txddE4Kth6mlV7/yfY+vZT0Uzcg0aaY27f1WXyFX3mNBx57TZ7m1THn
LYVuMMsKzNz/p8MOCrcqA2dxUJDSWSdBSgHX3DtWv5cwZnUr+TAodjz2W0KWM0eG
m6Iruj4cJ3GeWH8AOStx1u34es5ogA==
=Vg3O
-----END PGP SIGNATURE-----

--Sig_/7jEnSQe/RMO0Z32CLYq2aQD--
