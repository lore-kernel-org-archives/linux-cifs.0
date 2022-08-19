Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC87BC25B0E
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 05:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346073AbiHSFsW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Aug 2022 01:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241528AbiHSFsQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Aug 2022 01:48:16 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A037DC3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 22:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=U5coVC/zGS6DWIvCheW2Ak7LyT3S
        RdDMZFsyY6wUQM0=; b=mOhiFL0HLxl0NhNx0gBTqq0IK4H4EArtu/PeGPM0jQgQ
        ZPsPLUMoQDvNTauOdt+9+GE5/+RYYfhjktxDp9Sm3PXn0Teal9vz+VqOoAi7FM2X
        OaMPWcFrnU6nqDhsEunTsOWOaDTwSgzXoDXBZyjCoxFmlO6iESQyTPBvAYOZcdg=
Received: (qmail 4113229 invoked from network); 19 Aug 2022 07:48:09 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 19 Aug 2022 07:48:09 +0200
X-UD-Smtp-Session: l3s3148p1@i/mVpJHm+L8ucrTL
Date:   Fri, 19 Aug 2022 07:48:09 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Steve French <smfrench@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH] cifs: move from strlcpy with unused retval to strscpy
Message-ID: <Yv8kGdt8e/VgLRxY@shikoro>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Steve French <smfrench@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
References: <20220818210142.7867-1-wsa+renesas@sang-engineering.com>
 <CAH2r5muBD8AV51ZQMapGoXyF=5Mk0GW2tYz2ng9XrhKRp_b96g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hqqaMmxIJ06FJ7g5"
Content-Disposition: inline
In-Reply-To: <CAH2r5muBD8AV51ZQMapGoXyF=5Mk0GW2tYz2ng9XrhKRp_b96g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--hqqaMmxIJ06FJ7g5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 19, 2022 at 12:00:34AM -0500, Steve French wrote:
> Looks fine.   Do you want this merged through my tree?

Yes, please.


--hqqaMmxIJ06FJ7g5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmL/JBkACgkQFA3kzBSg
KbbAbg//QVHmt/y7zDwyraqBCXaN7RgJoNT8iXiv2JmkGcmRDVQmzKYjfawD4uFA
ytO8JVkX56psgiPzb8JOMT5tfdDbGDq6rxJvByWiMcJ4x4FcVMiEvh0l2usCpWaR
zjvFYIeU+CpV/j7dOJ3JGa+KV/PcvKd+R9MVrcaV0ZxtE6pgIsLpVC6TAAxD/uRW
U2213dAc3QG0qcvIrZe86X0ZJOKGc9zl8bwjW2rqRQLEizAIAlKvjwCwHd7pMcDr
20wv/pVDEjQCYzUe+L0tV7S41oM7hr2GsrFS9D3UuyRLc7JhGCMMJYrAqDMb5fsA
x1s/SLqYH1AE6eziiSSelEpFoEyHtvDHnnN0j8lsTwn1BcP08h+EbU8xleT2XJAE
XU2J/UDXV6wU3lXN7coG4Tjb8EiKtCQ4Box9B6V0osvJwYYiKgbKmk8z/3UcNxyn
NMj1tGoSg6N9V+rnM5mENCLoQAPXR3ysHVkPqW+aKwQZLIDtsiISsM83VjQX/QTx
XIoqTlbrLAdWwM32XYkvFuxsBYU/bOmIY12SUPM0N8ZybcU1sTtwvCavX0Wkdgtl
GkLAFnSdl4Gg9o7Nr25G42IW8+m6zb/qP3o7VKegjQjG8EF3QQ9RJPLqVgJSBETF
7Fiq9UmD+SZBAczpaYa6IVZGDs6OOGIe3fcZU2+X8jlGV618Cpk=
=GNvn
-----END PGP SIGNATURE-----

--hqqaMmxIJ06FJ7g5--
