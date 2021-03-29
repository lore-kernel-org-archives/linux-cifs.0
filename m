Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C388C433C1
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Mar 2021 17:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4281561927
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Mar 2021 17:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhC2RSq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Mar 2021 13:18:46 -0400
Received: from smtp-out-03.rz.uni-jena.de ([141.35.104.45]:38490 "EHLO
        smtp-out-03.rz.uni-jena.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230220AbhC2RSk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 29 Mar 2021 13:18:40 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2021 13:18:39 EDT
Received: from smtp-in-03.rz.uni-jena.de (smtp-in-03.rz.uni-jena.de [IPv6:2001:638:1558:2368::22])
        by smtp-out-03.rz.uni-jena.de (Postfix) with ESMTPS id 4F8JvD0Y0vzDp0k;
        Mon, 29 Mar 2021 19:08:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-jena.de;
        s=opendkim-2020; t=1617037720;
        bh=QvAONq3WVEfjT2VDziO/QrHTdhjTno2diPtnqVfGKI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lc3x4fYf8FhMp+yDZU6RiQVy6KgEGP8Drw6RXw2r9VUEy3XWtW931rAvKK10+Kpxl
         BvowAAhPE79polohFiQ/RHx8CK2A2incTMHRpy3NL7mq7OkV8xKJV2PdMqfPI8KT0w
         RWG6CXnDu0GM42kI2iXmFNoNNGbZQNCvunx0GZLFgEWZu1gxAKf/LTCK345d8LGH8y
         32qahGlZEOZLBzmYEgna3qdGw0k+HMdByCBsgvXKSQyLsCFgVxsKnmE04qWDUEHrhr
         vXFphi7rJeJJa9gp5mK3N2zQ20jmGFawHvPdiIlo0p2NlkNO5kkWJEWnRz4l1TNvpU
         UzNjhA1/OWrZg==
Received: from localhost (x4db78f0b.dyn.telefonica.de [77.183.143.11])
        by smtp-in-03.rz.uni-jena.de (Postfix) with ESMTPSA id 4F8JvC2j7RzFnFF;
        Mon, 29 Mar 2021 19:08:38 +0200 (CEST)
Date:   Mon, 29 Mar 2021 19:08:49 +0200
From:   Frank Loeffler <frank.loeffler@uni-jena.de>
To:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: specifying password when using krb5
Message-ID: <20210329170849.GD21718@topf.wg>
References: <20210327113252.GC8814@topf.wg>
 <87o8f2orjm.fsf@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <87o8f2orjm.fsf@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 29, 2021 at 06:25:49PM +0200, Aur=C3=A9lien Aptel wrote:
>When you use a password you're actually not using krb5 (even in
>smbclient), you're using NTLMSSP authentication.

As far as I understand, you (can) use a password to obtain a krb5-token,=20
which is then used for sec=3Dkrb5. From a users point of view, you enter=20
username and password and get access. Whether this is using krb5 and a=20
token or some other mechanism is usually something a user doesn't even=20
want to know about. What they know is a username/password combination=20
and a share name on some remote machine.
If the mechanism happens to be krb5 (isn't that even the default on=20
Windows shares?), you might need a temporary token, but I wonder if =20
that "technicality" couldn't be made transparent to the user by default.=20
This would make mounting Windows shares a lot less 'messy' to users.

>> 4. Currently, trying sec=3Dkrb5 without token cache files results in=20
>> the
>> rather obscure error "mount error(2): No such file or directory". Could
>> this me changed into something that points users to the actual cause of
>> the error?
>
>Sadly we don't have much to work with. Mounting is done with a single
>system call mount() which can only return 1 error code from the list of er=
rno
>codes https://man7.org/linux/man-pages/man3/errno.3.html

That is unfortunate. However, not even verbose mounting gave me any=20
indication of what it was that is actually failing. Maybe, before=20
returning ENOENT, cifs you print something else, possibly at least with
high verbosity/debugging enabled.

>I think you are :) thanks for reporting.

Thanks for your time responding. :)

Frank


--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEDs94vEHD2WZGdOX+6TOmKn4jn2QFAmBiCZwACgkQ6TOmKn4j
n2SsYQ/7BGl6+0bBoN085Urd4bJc7+Lk8MQ6NGmCPSkQfkyepTAYrmAvsI2Cttp3
1QhN9uGntffgyWmegcow60E3IC1fpnDHzOhxEZTKYIXR+cr989+j03e/mZ3tjMrB
BFGSywk3eEjVs5w+/qz9mCtjIZ/bwLs19MQmU+j2a1vLWeTLqxha9xxxYy2w25Qu
liDJc2zGIrtoulfe0ZZH7SRSPrYFk2G0EW/NZeLkrRx3eO/FMXbKzAZ5BXcrxCdk
pnf2h6vlBmbWygOTyWENIJNYN6Y8ONrdKHcqn3OzwA7nA3ONbcqM6DJ14wv1g0b1
dJ0YSOigXM5B4++ztGZvjaZ74nW0pWrpHNLmwF9gPwZoH+3UD0Gj66yY4PbTXP4T
SbUe2pkt3HW295tzVru+WF84sNtlkgUeBYJyR0f6xPfWuq+BHCjA8sXU98LN8FUQ
xT4eBzNnKcvtXryiJao+iKkkjaIULq0L1a3xJS82GJ7gMpKWEGNMegp7E1JaDKen
WS4lAzQTpUlGPYIFKF4KgxCcTQKKZ4WTRcVbrXoetn86Hjx3O8MyHZnP55MuRBR9
6AW/ve+4KOceRzOYD0MV7jEJ7Z3gWp2ISMnIZqzazH4mmeegI0toOsghonzyseHQ
ShVdcHDqVvMkb3g0GPPGkDcQp3fraivoX4rdogNy8/sg+aCFR6M=
=nmoD
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
