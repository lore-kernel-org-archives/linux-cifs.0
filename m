Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA47C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 06:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbiHXGjq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 02:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbiHXGjo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 02:39:44 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3400D85A9F;
        Tue, 23 Aug 2022 23:39:42 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MCGfd0TzQz4xV3;
        Wed, 24 Aug 2022 16:39:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661323177;
        bh=ygTl1pJvQIzdFVJN/ciTlCWRUmAOLnv2z9yb0eiXs9w=;
        h=Date:From:To:Cc:Subject:From;
        b=ucQsOpvFj10VuSDPeXa9gl2EIiouvaM3xr61tA3iHhhx7dZxphTBJnrjVVrESvECl
         7ieDF4K8vUXKMjfwHFtWLiQMQlWSELkzLYiZaNSfckDZ6pDhtcoN7DgladJt64/dok
         Zo8CNKq6Dz7w9SYmmQaCTUg4bf/nVw0AvLCHr5GsrU71+H/xixdZ4d/orlk7VSE9+j
         GhR9dkMf1UbAyytcO8+25flxJWUegaPS34BGXh9en8YgNWKCMT+gcWFZlw+vpbFVGP
         eLTla0ebFB2BeJ4LzdHFGosE6Z86r8VzbcgP8gV78ob5UM4qwqcA9LInUg1VJ6Teas
         AlAak4sSjH2Gg==
Date:   Wed, 24 Aug 2022 16:39:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20220824163936.58b58ad3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WMI/cBj40r1E_9qNYIN89FW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/WMI/cBj40r1E_9qNYIN89FW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  b044b4dd6048 ("smb3: fix temporary data corruption in insert range")

is missing a Signed-off-by from its author.

This is another case of a mailing list munging the From: header of
an email.

--=20
Cheers,
Stephen Rothwell

--Sig_/WMI/cBj40r1E_9qNYIN89FW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMFx6gACgkQAVBC80lX
0Gx/TAf/eXgGchlzOKnpGvV2eXjbK67Y/NbFfdIflwqP8TcgoVIrKydA7eTBXw7S
ZAHVzgMN1P874BMmLDxxo/cVzY7RAUy37Hbq2r85HvFuyZe6agEZFxYTVqm6HnT4
kfJpawdcKdzmkyjsM3TZQWGW4SI8t3AG0SCgsY34el3H/qofnTi/JkQIvCTsnNrZ
3fckQr7na1z8Ik6J8iDbAhswXyDW58xD2P4C5OkVLagp7l/QmzvcKKec3t3Shqjk
Uzmqgsu+vaMBnhN0oCX+OfRoh3uq3MDZ/SFG5vl2jUocQeFCNP2uEXreC/X1Dehe
6yGXlRCmW/eWsFzkNhp/i3pK0x2MWQ==
=4htj
-----END PGP SIGNATURE-----

--Sig_/WMI/cBj40r1E_9qNYIN89FW--
