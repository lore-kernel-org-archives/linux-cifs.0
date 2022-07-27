Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9F3C04A68
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jul 2022 06:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiG0G5B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jul 2022 02:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiG0G5A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jul 2022 02:57:00 -0400
X-Greylist: delayed 232 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Jul 2022 23:56:57 PDT
Received: from s1.jo-so.de (jo-so.de [IPv6:2a03:4000:8:213::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D5123BD9
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jul 2022 23:56:57 -0700 (PDT)
Received: from mail-relay (helo=jo-so.de)
        by s1.jo-so.de with local-bsmtp (Exim 4.94.2)
        (envelope-from <joerg@jo-so.de>)
        id 1oGayV-000u6a-Vx
        for linux-cifs@vger.kernel.org; Wed, 27 Jul 2022 08:56:55 +0200
Received: from joerg by zenbook.jo-so.de with local (Exim 4.96)
        (envelope-from <joerg@jo-so.de>)
        id 1oGayV-000eqR-1R
        for linux-cifs@vger.kernel.org;
        Wed, 27 Jul 2022 08:56:55 +0200
Date:   Wed, 27 Jul 2022 08:56:55 +0200
From:   =?utf-8?B?SsO2cmc=?= Sommer <joerg@jo-so.de>
To:     linux-cifs@vger.kernel.org
Subject: Re: Stale file handle with cat -- AVM Fritzbox
Message-ID: <20220727065655.zk3pvh4jynj6hbym@jo-so.de>
OpenPGP: id=7D2C9A23D1AEA375; url=https://jo-so.de/pgp-key.txt;
 preference=signencrypt
References: <20220727065301.afmn7ui3zzre7nem@jo-so.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g6whaureyuiszabd"
Content-Disposition: inline
In-Reply-To: <20220727065301.afmn7ui3zzre7nem@jo-so.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--g6whaureyuiszabd
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: Stale file handle with cat -- AVM Fritzbox
MIME-Version: 1.0

J=C3=B6rg Sommer schrieb am Wed 27. Jul, 08:53 (+0200):
> Hi,
>=20
> I'm trying to access a USB disk attached to a Fritzbox from AVM. The
> Fritzbox is a router, but can also export USB disks as NAS. With smbfs I
> can't access any files, but smbclient works.
>=20
>   # mount //192.168.178.1/fritzi /mnt/fritzi -o user=3Dpublic,password=3D=
=E2=80=A6
>   # cat /mnt/fritzi/WD_blau/Public/J=C3=B6rg-Backup/Archiv/keys/63b0d55eb=
795822facba850363d5148ce657db559552ef3a5cdf6623d110bb98 >/dev/null
>   cat: /mnt/fritzi/WD_blau/Public/J=C3=B6rg-Backup/Archiv/keys/63b0d55eb7=
95822facba850363d5148ce657db559552ef3a5cdf6623d110bb98: Stale file handle
>=20
> But smbclient works:
>=20
>   # smbclient -U public%=E2=80=A6 //192.168.178.1/fritzi -c 'get WD_blau\=
Public\J=C3=B6rg-Backup\Archiv\keys\63b0d55eb795822facba850363d5148ce657db5=
59552ef3a5cdf6623d110bb98'
>   # file WD_blau\\Public\\J=C3=B6rg-Backup\\Archiv\\keys\\63b0d55eb795822=
facba850363d5148ce657db559552ef3a5cdf6623d110bb98=20
>   WD_blau\Public\J=C3=B6rg-Backup\Archiv\keys\63b0d55eb795822facba850363d=
5148ce657db559552ef3a5cdf6623d110bb98: JSON data
>=20
> So, what does the Kernel do different? How can I debug this?

Oh, sorry. I missed the versions:

% uname -r
5.19.0-rc6-amd64

The kernel is from Debian. https://packages.debian.org/experimental/linux-i=
mage-5.19.0-rc6-amd64

% smbclient --version
Version 4.16.3-Debian




--=20
Viele Leute glauben, dass sie denken, wenn sie lediglich
ihre Vorurteile neu ordnen.

--g6whaureyuiszabd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJMEAREIADsWIQS1pYxd0T/67YejVyF9LJoj0a6jdQUCYuDhth0YaHR0cHM6Ly9q
by1zby5kZS9wZ3Ata2V5LnR4dAAKCRB9LJoj0a6jdfp5APwOxd0v4YHRI0GKVrW/
W7r3x/3zh5bgZXYgL09Z7iK0+AD9F+0Zud9e0TynNngE3XBty3BLNS6SHUKhkWnW
vGDuFD0=
=oY/I
-----END PGP SIGNATURE-----

--g6whaureyuiszabd--
