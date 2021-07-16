Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A325C07E95
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Jul 2021 07:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B632613BB
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Jul 2021 07:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhGPHxX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Jul 2021 03:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbhGPHxW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Jul 2021 03:53:22 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9012C06175F
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jul 2021 00:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=eobKwl+ljYFI1ZjUtXTMn8EmXWya8DF0+qX7P22PHRo=; b=eEX3IOERfJaN4vyXjG4IVXBFCq
        sekoCnoWSfbUFKaLuW80naO3ZkUMq7+1bDddBfeQpQrfZhx+uxHnFkXSYwgVpB81sCczlrq1z9yNS
        Mjpiw/1SL/02BtUCA1rH/vFXLohERvOohgKkivGXLbZ8HMpnFseMiDX5uywtAxmDeQ+LH+mlAYufO
        q4E2NLVaamNvQBRwByMBU5VHeRvHQpumkTqH1WJ0qkNOKsu9gKEG8e2NjEZyKqwdrha6o3rJpRBkQ
        9rqZIORGeKYQdwKHWJEDDJbsVBcYv8l3GN+Wwzkig40g/lDaNgOicdGjqrQNBPsM05hCWmcYrRQ5/
        rSRFSFyy1tOj/0pJLry1vhnv4+yigvXwmCJSYLi30GSl5HrPmS4WCcZslf2QKbLHpIzQ8E/V2fML4
        hRSwPYeiixN9GYfZvl2i+meT9+xIcax1D24LFdXpS19WRhqK1zkUlCKuA3w+wXwWAfrqBRekGGKNG
        8fHOdvlgzOiNaPomEJTg0BRf;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1m4Ibx-00018Z-CC; Fri, 16 Jul 2021 07:50:18 +0000
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifsd-devel@lists.sourceforge.net,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
References: <CGME20210614085106epcas1p4143f68f380c480f5f8a504370b10a969@epcas1p4.samsung.com>
 <20210614084135.19753-1-namjae.jeon@samsung.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [Linux-cifsd-devel] [PATCH] ksmbd-tools: add support for SMB3
 multichannel
Message-ID: <d6d4e15b-95aa-38d1-40f7-14f99fe24260@samba.org>
Date:   Fri, 16 Jul 2021 09:50:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614084135.19753-1-namjae.jeon@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ajzbFN7wSXVxak6ELrSgOsgDKt7agayRu"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ajzbFN7wSXVxak6ELrSgOsgDKt7agayRu
Content-Type: multipart/mixed; boundary="YMqAzyy9RpxB06xItue9l71TsjWkedRYu";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Namjae Jeon <namjae.jeon@samsung.com>,
 linux-cifsd-devel@lists.sourceforge.net,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Message-ID: <d6d4e15b-95aa-38d1-40f7-14f99fe24260@samba.org>
Subject: Re: [Linux-cifsd-devel] [PATCH] ksmbd-tools: add support for SMB3
 multichannel
References: <CGME20210614085106epcas1p4143f68f380c480f5f8a504370b10a969@epcas1p4.samsung.com>
 <20210614084135.19753-1-namjae.jeon@samsung.com>
In-Reply-To: <20210614084135.19753-1-namjae.jeon@samsung.com>

--YMqAzyy9RpxB06xItue9l71TsjWkedRYu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


Hi Namjae,

> Add support for SMB3 multichannel.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> ---
>  Documentation/configuration.txt | 3 +++
>  include/linux/ksmbd_server.h    | 1 +
>  lib/config_parser.c             | 9 +++++++++
>  3 files changed, 13 insertions(+)
>=20
> diff --git a/Documentation/configuration.txt b/Documentation/configurat=
ion.txt
> index f38aceb..1289cbf 100644
> --- a/Documentation/configuration.txt
> +++ b/Documentation/configuration.txt
> @@ -109,6 +109,9 @@ Define ksmbd configuration parameters list.
>  		host where ksmbd runs. the format is "cifs/<FQDN>". if this
>  		option is not given, ksmbd sets "cifs" to the service name and
>  		try to get the host FQDN using getaddrinfo(3).
> +	- server multi channel support
> +		This boolean parameter controls whether ksmbd will support
> +		SMB3 multi-channel.

Did you actually implemented all replay related features?
- Create replay
- Lock replay
- Write/IOCtl/SetInfo replay
- Lease/OplockBreak replay

Otherwise you should mark this as experimental,
as it's likely to end with potential data coruption.
That's why Samba had this flagged as experimental up to now,
Samba 4.15 will be the first release with all required features
in order to enable multi channel.

metze


--YMqAzyy9RpxB06xItue9l71TsjWkedRYu--

--ajzbFN7wSXVxak6ELrSgOsgDKt7agayRu
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAmDxOi0ACgkQDbX1YShp
vVbeAw/9HNHh2acGzjGz7nfU01OxY92Sjj7gFjGMEG5beeRJKm8t/htNLHXkI+tO
2gh1E/GMEODqrLfmraRwCBoMYld/QXCrruLSFhsx30qse3d8nB4di+wzo6QobYHA
slATtdORSw39/rdGt3frwZqaGiGAeeudkO/NbDghE1+UR5VGQ0I911MPtWZ8swgU
3ozG7jNQxX3yRZO2fTe89fFvH5ane4/QXhFB4WlaxBOL3v/uez76YJEvLM3SBVds
jjViOGQlO9JFVAc2BRsmFwBdevnwdDRxiXfCQ4F/m75sxc/G7FEubTd279Lx4dId
2Oaqw46ZgHgf3Q/jZx9gKdxHna9dil9amW0lUBmTdKw6/KQa9hnrEau0DpMUkL+v
orw4Eu/DijUJLOIARI9/+uIP2ii0MWMtB7fTr2lcHlx0hEHrNOHxWwVh4JiaqRea
dm7spXYP5gcT/l5cNFPf2yNRkSjJGaHacvJJ9Y19QFzmeMKJ3vlYy0x11GeVMySb
HY260SxLr0IiMKruUEHPzKTZIbIJYRh4IpWgn10dIckGUx201GKGFk9KHvVhP0mm
KmxNOsIeZRslDJEKyGyxJpV1ORt3yabgCl+pPaVmPyjwLKS/Ejl/FOAHrSlUQLBt
wYTlGaCZAL4NetnWc5329fD/PXkrzWJ/12sp5TSz0PahWYWxYqU=
=prHF
-----END PGP SIGNATURE-----

--ajzbFN7wSXVxak6ELrSgOsgDKt7agayRu--
