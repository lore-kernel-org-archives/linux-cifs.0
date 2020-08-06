Return-Path: <SRS0=f6oI=BQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6B0C433DF
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Aug 2020 22:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 373C2221E3
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Aug 2020 22:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Wgf24cwa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgHFWdq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Aug 2020 18:33:46 -0400
Received: from ozlabs.org ([203.11.71.1]:39085 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgHFWdq (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 6 Aug 2020 18:33:46 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BN3Dm29y5z9sPB;
        Fri,  7 Aug 2020 08:33:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596753224;
        bh=FsB5kYxkaUFGzjHKfdToVWaIcno3UIYxxqaOUIlfcCI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wgf24cwa57IK9UcVS8Z4TojTJzkry95gJ9mpg9gneW6Bk34ZuJuJVDcXbruV/3rA5
         uYiuxLSq0z0lMx0aq4Sz5wbkmJJmep+HZ80HTHJHUOuUNwxZyB2o3y1SJQ1fCq8qZf
         6jIV5JYa3alpxFJSOu1FzEG8aeHHphBh7LH4S1hdv/IWMK9yyi0yw8JiVBmbLaW3CU
         krCQtVvF6KTfC5C7q7hsiJVr3ZbiHmlF1t3w4+eKHV2FIbxktlplr/ZqWbfN/0POuB
         1HxhReCqusyiCzt/6Imwcr7Ircf3TyKvR5f18/QZUDWOjGuKJXRgm07ftci24UKXNC
         zswADLUmiXvLw==
Date:   Fri, 7 Aug 2020 08:33:42 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20200807083342.6977153b@canb.auug.org.au>
In-Reply-To: <CAH2r5mvGD3ftLDfwrpx61kaJQnPpspupdDHD8NOjnF-q-ByTfg@mail.gmail.com>
References: <20200806164505.0eada105@canb.auug.org.au>
        <CAH2r5mvGD3ftLDfwrpx61kaJQnPpspupdDHD8NOjnF-q-ByTfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gLZlApbWK/zRikX/hm+fGUR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/gLZlApbWK/zRikX/hm+fGUR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Steve,

Thanks for fixing this up.

On Thu, 6 Aug 2020 10:31:33 -0500 Steve French <smfrench@gmail.com> wrote:
>
> I just fixed the Author tag in this patch to match your email address
> but seems like the author email address gets mangled when sent through
> some mailing lists.  Any ideas how to avoid this.

You may need to ask people to add an explicit From: line at the start
of the body for patches sent via the samba.org mailing lists (since
they mangle addresses to get around DKIM checks, I assume).

--=20
Cheers,
Stephen Rothwell

--Sig_/gLZlApbWK/zRikX/hm+fGUR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8shUcACgkQAVBC80lX
0Gw1Gwf/XWj7q5tp9zlh9ivEzpmZpfatsr98aHls5d/vEsSZEnbEjunSiqYbMXL4
BKr6+Hl9yhN5RjiGFx7VdmZPnq2GxYKH1xCSGakENhJZBFV41vcUgzuxqXuulHYL
0eFuuESEDv1TpTz7ACCXcRCAo6LP7EyHvBUQLLzf+We0/43y4sttf58tMVgdVg4w
NXqghR54mkmAhI/8HPS1C6Q7s2bCbb78RrwZ8xMRZRglfFOEtmSdYDZhJYVwun33
LBB2R9DVIjhKEx0dFPGNeR5X1RmoNl+a8+r3TOHJXPNOc91mQ3Z8BhZnUP5feOtc
EZ+zLKtcXCk5AbcKA+NdIwsUpnRSmA==
=HyuJ
-----END PGP SIGNATURE-----

--Sig_/gLZlApbWK/zRikX/hm+fGUR--
