Return-Path: <SRS0=BTJv=7B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B95C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 06:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3069020758
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 06:57:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="d5cIqdxc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgESG5j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 02:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgESG5j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 May 2020 02:57:39 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42FFC061A0C;
        Mon, 18 May 2020 23:57:38 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49R6C35ks6z9sPK;
        Tue, 19 May 2020 16:57:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589871456;
        bh=IxBXL6U6L4IxYEayNUyM3xRdVe8j9U+f97iPpjKQK/Q=;
        h=Date:From:To:Cc:Subject:From;
        b=d5cIqdxc1kDoa8gfu4qUrgeKsHIKZ7nAcwAxtx5L/ut0atkhrw4iZAHUUW6uHKzUw
         jTqz829ph/vzH+av19uQwaE9QgbImS0Vh0KpG8gofVsEZSP64m72aD9PiuY2RXMeLM
         PERpwbcDUG6H/JwBTY3LDMDTxcsLPgCSmaHvX2uol7qmIr7njY0tR4R6oyMqjr0iDd
         KeTVIkeupmi4tPcYULkiOe/RNbXGkkIt/oyDU+x6fghWhyZrv3jCDiwZiyyczUpQ2s
         PsIpYKkKO2hDMV0Dt+Jqmcdwzq5TF9tNnz9XzFDE29X/VVFV2vWvn835i9UJYMJ0yZ
         /Y9qsYadJQMHw==
Date:   Tue, 19 May 2020 16:57:34 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: linux-next: build warning after merge of the tip tree
Message-ID: <20200519165734.79d0c3a3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NTxEosSAH2jF3h/=xPOfI7y";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/NTxEosSAH2jF3h/=xPOfI7y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

fs/cifs/smb2inode.c: In function 'smb2_compound_op':
fs/cifs/smb2inode.c:424:1: warning: the frame size of 2736 bytes is larger =
than 2048 bytes [-Wframe-larger-than=3D]
  424 | }
      | ^

I have no idea what caused this.

--=20
Cheers,
Stephen Rothwell

--Sig_/NTxEosSAH2jF3h/=xPOfI7y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7Dg14ACgkQAVBC80lX
0GznOwgAnCzYIEnj/kJJV5yqM8jXBNyygHuHGJpWPShzEv4hF0OV/qOgujVAS9wy
VfnOyHcFWmErwwmiNXdzk/ctbtJhrOkU31+hUJDzO8JH0poRBx0XeomKKdCae5D7
GWoz5jv1nEzcZ/bLdXPKJ7Q9LydfBd+hXbWAh0kp50p28HPKa0MFe8Oa5/s7wwbV
Gtykq9yOyneZXoOo6ouGW4a1FmUV89PyIntj+LtEp1S3ieF67WfZFi87M3yC0jlx
YUw5uR3VOZm7Kg02frhjHgXpBXlJ8eyYzO+OKI2mmqwog3EiD2MhiuClTyA5L9E2
+VvrxpxEaZfhvRi1zQKOVaZtKlZ4VQ==
=PKGY
-----END PGP SIGNATURE-----

--Sig_/NTxEosSAH2jF3h/=xPOfI7y--
