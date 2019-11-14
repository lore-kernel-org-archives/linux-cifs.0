Return-Path: <SRS0=ILFa=ZG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9A8C432C3
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 20:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7D27206F0
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Nov 2019 20:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Pur0CUPW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfKNUKl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Nov 2019 15:10:41 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:56583 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfKNUKl (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Nov 2019 15:10:41 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47DXfQ6s8pz9s7T;
        Fri, 15 Nov 2019 07:10:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1573762239;
        bh=1UI8pVF3/7Jc7ZYq0SdaJrPmsc+5fz3YMy/9IQFEh3k=;
        h=Date:From:To:Cc:Subject:From;
        b=Pur0CUPWVZjUEVIjerYpMi35l4jBRB+OtJD57tcvkcs03GzfU+2hK2ynVA3wThIoK
         U52OwpR54QIvBFcNLQcrsDUeytPj8xKCKGJBCV7qdtovF9WV+6shdH6lZM4ROcd2JQ
         txUuALkG4Y9+vNGZ7n0WtOz/ShJM6TGys/9OerY7Ah5Hdq9QZqf0w7JAHxojdbYJEi
         ucxoz79USv/+8IIovKg0ttCKmPxKukuJE6th7KI/Iuqli/+ydOXHxo9sIO3Qs1Vp7V
         qesc8tiHh7zrhqblRt/9XQRNkILstWqh8mKzeMyb/rTYpt0zTtBbp0/P9YaJdvyTCw
         M7vODEKXmCMRw==
Date:   Fri, 15 Nov 2019 07:10:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20191115071038.7ac29202@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8tsmZZ1FY96BU+0_9hZTcMs";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/8tsmZZ1FY96BU+0_9hZTcMs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  6eb36a327ea3 ("smb3: add debug messages for closing unmatched open")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/8tsmZZ1FY96BU+0_9hZTcMs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3NtL4ACgkQAVBC80lX
0GwhWwf5AVPwtjL8YSVL2JPAPjOA+/i4mJ004ijHfieBD//w+6MSLD5qI1n7Nl+L
1dHL6RWMiT4vCRF/InGI+vKf/cOe+PUfLSXJq68hwP9xbH2C5DB0SutMPTbuNRnW
XzI4iMsCFUoYMneSJ/xeMe1BIExGuYjyRB7DLqiHxq+VnKls4X/lRechJCmM5s2s
gsWQNClHIT8lloTcx9G43o4Sz4o507/mCA52yLtkehRhvRKk+SegKIUmMFra1hh+
Zd3BWVzi/l4Eb8d0h8Rs86vdmTG/O8kGVrlMa+1demiqYiOWNwm6XN//hCQqph40
s52pVElFUz5FBf67Y80TJy7pVnOM1A==
=Lf5J
-----END PGP SIGNATURE-----

--Sig_/8tsmZZ1FY96BU+0_9hZTcMs--
