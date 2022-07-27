Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CFAC04A68
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jul 2022 07:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiG0HAf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jul 2022 03:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiG0HAd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jul 2022 03:00:33 -0400
Received: from s1.jo-so.de (jo-so.de [IPv6:2a03:4000:8:213::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD89AA18E
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jul 2022 00:00:32 -0700 (PDT)
Received: from mail-relay (helo=jo-so.de)
        by s1.jo-so.de with local-bsmtp (Exim 4.94.2)
        (envelope-from <joerg@jo-so.de>)
        id 1oGauk-000u5l-Ge
        for linux-cifs@vger.kernel.org; Wed, 27 Jul 2022 08:53:02 +0200
Received: from joerg by zenbook.jo-so.de with local (Exim 4.96)
        (envelope-from <joerg@jo-so.de>)
        id 1oGauj-000eag-3A
        for linux-cifs@vger.kernel.org;
        Wed, 27 Jul 2022 08:53:01 +0200
Date:   Wed, 27 Jul 2022 08:53:01 +0200
From:   =?utf-8?B?SsO2cmc=?= Sommer <joerg@jo-so.de>
To:     linux-cifs@vger.kernel.org
Subject: Stale file handle with cat -- AVM Fritzbox
Message-ID: <20220727065301.afmn7ui3zzre7nem@jo-so.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oavzske5ybes4fl7"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--oavzske5ybes4fl7
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Stale file handle with cat -- AVM Fritzbox
MIME-Version: 1.0

Hi,

I'm trying to access a USB disk attached to a Fritzbox from AVM. The
Fritzbox is a router, but can also export USB disks as NAS. With smbfs I
can't access any files, but smbclient works.

  # mount //192.168.178.1/fritzi /mnt/fritzi -o user=3Dpublic,password=3D=
=E2=80=A6
  # cat /mnt/fritzi/WD_blau/Public/J=C3=B6rg-Backup/Archiv/keys/63b0d55eb79=
5822facba850363d5148ce657db559552ef3a5cdf6623d110bb98 >/dev/null
  cat: /mnt/fritzi/WD_blau/Public/J=C3=B6rg-Backup/Archiv/keys/63b0d55eb795=
822facba850363d5148ce657db559552ef3a5cdf6623d110bb98: Stale file handle

But smbclient works:

  # smbclient -U public%=E2=80=A6 //192.168.178.1/fritzi -c 'get WD_blau\Pu=
blic\J=C3=B6rg-Backup\Archiv\keys\63b0d55eb795822facba850363d5148ce657db559=
552ef3a5cdf6623d110bb98'
  # file WD_blau\\Public\\J=C3=B6rg-Backup\\Archiv\\keys\\63b0d55eb795822fa=
cba850363d5148ce657db559552ef3a5cdf6623d110bb98=20
  WD_blau\Public\J=C3=B6rg-Backup\Archiv\keys\63b0d55eb795822facba850363d51=
48ce657db559552ef3a5cdf6623d110bb98: JSON data

So, what does the Kernel do different? How can I debug this?


Kind regards, J=C3=B6rg


--=20
Auch wenn man etwas oft wiederholt, wird es dadurch nicht richtig,
aber es setzt sich fest.

--oavzske5ybes4fl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJMEAREIADsWIQS1pYxd0T/67YejVyF9LJoj0a6jdQUCYuDgzB0YaHR0cHM6Ly9q
by1zby5kZS9wZ3Ata2V5LnR4dAAKCRB9LJoj0a6jdVmaAQCqhURM4IVEiSFqgZT1
4h+YYb2xgOZWJImNejzUJYug1QD/We6nMUJdeKe/kYYjvgkG+M9r4jZnDyNn45B3
Ti/gkcU=
=2uYs
-----END PGP SIGNATURE-----

--oavzske5ybes4fl7--
