Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B443C2B9F4
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Jun 2021 16:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2936E61C75
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Jun 2021 16:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhF1QI3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Jun 2021 12:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbhF1QI2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Jun 2021 12:08:28 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FCFC061574
        for <linux-cifs@vger.kernel.org>; Mon, 28 Jun 2021 09:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=vllJIejJhrmeZARGU3bg88i1VfOiRHYnGqKctRzOnIE=; b=wpqeRGP1uGA3MbC7nbGoYywggg
        IPXGK94nAe8xqfV4mYj6IHdJbjpiZtcGRLgGa4uVMYsy5ds7lLhFnYpR6abqkeO9k6UMYKndM79Lu
        iwcoJv6ABCkUztKNwYEe62u4kJkb7N+JJeZmMJJas0zXN5ZjUor+b0QP2ytAqobs7tFM0x6vlr97T
        IcYxBvhhZBHDgD3spyPGnuRzrmONJkQVjrhE1FZDxA47+IR5trWrTof9JRaHiZ/0sUaWkiwQMRBWa
        +YRLNOMhGERDLYmcWZYewAqR+j7OlwObiOMYcA75SaojF5Ispk4uoOxMMSM+B4f/iG7GG5wMDbcam
        whsX1cyF8XUng7Hb5ZbOiDQxCM7thqoaA4ZlPMydDgZOQfbPqhHLqx6Ql4k29mYX4sAUQgQ1cBZdH
        Wa79wFxoh7z4tpKFDFP32yBGvnsm8fWVZ5F0Cq/ErsTnSlu7yhq9mssbEAhcLitQ9W1/lu06SVaQ7
        QAZRp2IMF4kl8GPUcOTD1FM+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lxtln-0003y5-Rr; Mon, 28 Jun 2021 16:05:59 +0000
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
References: <CAH2r5mubZZjJcSxLvkAZNU-AFWe6+w51m5KQ5xjNAE4_xG2Xow@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH][SMB3.1.1] client support for signing negotiate context
Message-ID: <1e313824-28a3-c2de-8281-2a3ee0d0cfa9@samba.org>
Date:   Mon, 28 Jun 2021 18:05:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5mubZZjJcSxLvkAZNU-AFWe6+w51m5KQ5xjNAE4_xG2Xow@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3JxbtoexIzANVyj86cVLguNyDQIVToRPF"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3JxbtoexIzANVyj86cVLguNyDQIVToRPF
Content-Type: multipart/mixed; boundary="DyEWaKQZtzgSMTcy7Z7EOYK2yUfiEQ149";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 COMMON INTERNET FILE SYSTEM SERVER <linux-cifsd-devel@lists.sourceforge.net>
Message-ID: <1e313824-28a3-c2de-8281-2a3ee0d0cfa9@samba.org>
Subject: Re: [PATCH][SMB3.1.1] client support for signing negotiate context
References: <CAH2r5mubZZjJcSxLvkAZNU-AFWe6+w51m5KQ5xjNAE4_xG2Xow@mail.gmail.com>
In-Reply-To: <CAH2r5mubZZjJcSxLvkAZNU-AFWe6+w51m5KQ5xjNAE4_xG2Xow@mail.gmail.com>

--DyEWaKQZtzgSMTcy7Z7EOYK2yUfiEQ149
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


Am 27.06.21 um 23:03 schrieb Steve French via samba-technical:
> Here is a WIP patch for negotiating optional signing negotiate context
> (which will allow negotiating faster GMAC packet signing if server
> supports it).  This patch handles enabling requesting it during
> negotiate protocol  (set module parm "enable_GMAC_signing" to 1) and
> parsing the negotiate protocol response.

Please drop the GMAC part and negotiate CMAC and HMAC-SHA256 for now.

The GMAC signing has a bug with Cancel PDUs in Windows 2022
(client and server use a different nonce, the client uses the MID of the =
original request, while sending a MID=3D0 on the wire,
then server uses MID=3D0 for the nonce and returns ACCESS_DENIED).

metze


--DyEWaKQZtzgSMTcy7Z7EOYK2yUfiEQ149--

--3JxbtoexIzANVyj86cVLguNyDQIVToRPF
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAmDZ82EACgkQDbX1YShp
vVY9AQ/+KfdeTJSm8e0LJLgwkp3tPUPzUJKYvfy3BhQFsa5XCZbIh+QGYCJ/3AZ+
vgCMOhnb01TdVFX6xgpoWwhxHYb/dGykq506HV8/sWVNKLFJnjtmlFVZtB8DqQ5u
xGEfBNwxTU4v414ttwb55ZtUgftnn06Uf2dzf0nlGks9oh8pV2x2JlD/mWpjoQl+
e2DN9P3RQLQ8JvfUcfKeTnc/VdxuC6mz1HRcCOSQ9Ah0DEXVt/Nf+jRvpjwr9ZxJ
HBvj9etzpxg0ZHK6sOedkAEnn1tj8q9VETfrNmwq6ApngKEW/vmdT/WfDni2XFtC
i0McN6VY4W6yAuFTFyT9QgY6pgG6T5SKufM+hzrixg+daLpaYRUcxjBx91GO3DKG
fP2cZ5pW4dcBNRbxqTVqFMBL31y1cHSbjhv2SLGlk4ofyckFm/p+8aTfG+AstHmU
a6X5xUvVVxfDAtMeWq5EVa5AJC2kCinqyEgMhfH++ZIf1gWIFN2Plh3NxJd6sqCK
LsIet0TXJJkkMxPOF0OlELrT7kDuroZvrIMxYz/LGy9Uck8wjBU4xMTXblwxlp75
bJh8gBcbfW0jaKTvmQKmAmRxK7qz/WEz6lqykPS4k3NirP+bFC49kb42dqzx0MFd
k815cyldLK9I2B6c+8arS/jOPJ1ARi6+AWUJfWWmlnu51RdtKkM=
=6cl7
-----END PGP SIGNATURE-----

--3JxbtoexIzANVyj86cVLguNyDQIVToRPF--
