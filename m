Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526FBC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 22:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3574E61440
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 22:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347321AbhI2WsH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346734AbhI2WsH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 18:48:07 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008E3C061767
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 15:46:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HKWh019Lzz4xbP;
        Thu, 30 Sep 2021 08:46:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1632955584;
        bh=F1KSJW9tgExlSUhSWA21dJAYwChDnBlScLEOOuaLX5s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h6PrrLuCRM58SOS0jW3KbSrpbpIodog71ILNwSuKLP1nO2QDkrlwDaABV2m4VAghr
         GC4vYama75yerO77YxYeK6zTvFltmyWqn2LJpgPLVCBkRGhm17xXlBeEkn3R89h4OV
         Jj+AAztqyHRJSNHoD0mu9c3mNQdpGwvneWQeZpBPuYTTp5quv6Ke6Q6v1XchFB1dar
         ADpUSzFHaZpLX5+hP7+Vf4X7aSRNu1cz6lka985iJUtoVeuXqy1xnq42Mtm4CVzdqJ
         v0KN2XTY3HWjhCtFcF33ijvVu6zYSS80QmmJRahNeuS/1/0lnW4aeIGO4dY8BaNIIF
         F0mXiP8bG2uDQ==
Date:   Thu, 30 Sep 2021 08:46:23 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Use less confusing branch name for populating ksmbd changes in
 for-next
Message-ID: <20210930084623.3391092d@canb.auug.org.au>
In-Reply-To: <CAH2r5mt_cFskiqbVvMn_M44p=0L-zFdkKsJj2JNYC3QLriEAXg@mail.gmail.com>
References: <CAH2r5mt_cFskiqbVvMn_M44p=0L-zFdkKsJj2JNYC3QLriEAXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/AdcJnnwnE4shj.e4qR44R/5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/AdcJnnwnE4shj.e4qR44R/5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Wed, 29 Sep 2021 13:22:34 -0500 Steve French <smfrench@gmail.com> wrote:
>
> Can we switch from using "cifsd-for-next" branch to "ksmbd-for-next"
> when pulling changes
> automatically into linux-next (since the module is fs/ksmbd/ksmbd.ko
> using the branch name "ksmbd-for-next" is probably less confusing to
> some)
>=20
> ie from:
>   https://github.com/smfrench/smb3-kernel/commits/cifsd-for-next
> to
>  https://github.com/smfrench/smb3-kernel/commits/ksmbd-for-next

Done.  I also renamed the tree in linux-next from cifsd to ksmbd.

--=20
Cheers,
Stephen Rothwell

--Sig_/AdcJnnwnE4shj.e4qR44R/5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFU7L8ACgkQAVBC80lX
0GyknAgApX4RYFGQaCTagXY8fxEk0LC9ttQQZBgfGsvzqhYWHCJSFde2x9PHV9xZ
deVQ21gvcT1TuBSaZA6k0uU7iUNbEkzWZLQ1o9s38v0lgRVyUmINvGzFKHADmBvn
VSe7n8T50mTm+a/BbjHwpQ+biJBwgMgNToSqeJj+a5BAMJRm3nhU7W2Xvh2qHF4q
MO3DLzl1lGnllWAUzJNxXpY+CgwtJEzdwucp9V28zaajYTQCsoEPN3TFmjj2O+6n
iPqkavg1pnyh3Ui2gq7nxoOgpotofLKVjY8cfb0dy7CCZ5Wa6hSuyKgzb+PZ+WGU
FGBoX3QkiaH1hE4in3Fwcgj9v24luA==
=Y3nm
-----END PGP SIGNATURE-----

--Sig_/AdcJnnwnE4shj.e4qR44R/5--
