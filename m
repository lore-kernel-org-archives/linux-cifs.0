Return-Path: <SRS0=Apod=SE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E9F2C4360F
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 20:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E096E2075E
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 20:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="NvhHKx2A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfDBUky (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Apr 2019 16:40:54 -0400
Received: from ozlabs.org ([203.11.71.1]:40243 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfDBUky (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 2 Apr 2019 16:40:54 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44Yh1b4Mrkz9sPc;
        Wed,  3 Apr 2019 07:40:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1554237651;
        bh=QpDVVsfM7UP5VM5vSGnvSnlsw5Lp+35vzClaAw9qfa8=;
        h=Date:From:To:Cc:Subject:From;
        b=NvhHKx2Akptc0yVYlVnTyEVwSfuLpiIK1IutvfX3XYtfF2AA2iqwUU6xCNQFadLuV
         M0zw+LVpYCop/fgyo+J8tO2vZNueFUromOq9Rf9VKe8cEIPfiB3/U9/xtk7MdM5eqs
         NKThtHAZnNLyb8Ji7k1woOH6ilQshMZr6KfCGlYy2Sh2R7KWfJE/T4aA8oItpe5Ftf
         J4nlyK71A9TUpaPBcwA+fGWrzu1csqIivklfbxdRkTyhAhsWiD2fnUzvO8ksuFM82x
         9CMjCetI0T20lMuqMW4K/oBBFUblcgvC+/TseND/IRNp/KlrYhBLKUOcv2o+w4kgGN
         XGbOYMUSM6AGQ==
Date:   Wed, 3 Apr 2019 07:40:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Kenneth D'souza <kdsouza@redhat.com>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Message-ID: <20190403074039.7c7af691@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8hnSVyUXSeuNUtvp.m5s/lV"; protocol="application/pgp-signature"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/8hnSVyUXSeuNUtvp.m5s/lV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  d0cb257cb7b0 ("Show locallease in /proc/mounts for cifs shares mounted wi=
th locallease feature.")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/8hnSVyUXSeuNUtvp.m5s/lV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyjyMcACgkQAVBC80lX
0Gwt/wf/fbeWIKFvLfaqVGUILxvjcd3F9qog6n45E3chwqQ9x/xot6NJ+Un76iJ+
Ov/yhVhkxxPO4q0DZn4yNi7ShALgYfvHwacSSe+PrinlgnbimKI7gYvQWgpzQz98
ppVy/QEp6V7AS2NQ9Wmsc5dY6F+IBXnRFzX4SrYJdN0fjHVUCEQbWUDcHCk4u4jK
DJDLv587fzp36WtGWgAVUsYQycH2RVQrsIfQIwkW9hIKge10VrBvu1ikZZkm8QG3
wIinqI5qeyxncCnGRlcdnpjHeUPpaHccOMZUHMjiBl12KuDlDncidEGHoUKO5rdP
1TYuJ4p0REfHrI2pl067eRbiuepB3w==
=VKnS
-----END PGP SIGNATURE-----

--Sig_/8hnSVyUXSeuNUtvp.m5s/lV--
