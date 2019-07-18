Return-Path: <SRS0=TF3n=VP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07481C7618F
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 23:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1FBA21019
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 23:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="WqrRx47m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfGRXQp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Jul 2019 19:16:45 -0400
Received: from ozlabs.org ([203.11.71.1]:37857 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbfGRXQp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 18 Jul 2019 19:16:45 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45qVQ205FVz9s3Z;
        Fri, 19 Jul 2019 09:16:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1563491802;
        bh=JPWxfWsB7CzOeTPTMae8OANq/2KSKlaaeadTcXnadGE=;
        h=Date:From:To:Cc:Subject:From;
        b=WqrRx47mzEDrbtpaOWMikBta+0AakHP0VEjlRGxrCQtbNvP5EUpNXbxHEULNTGUDv
         9luBEAsA4xydi2S3UHWNJa4RAt3EUA+5qw/00C9HV9PwmxPRdP6gKZgs2t8dxWbkjB
         4oIq0g7CjhWt8J5ce4mxO3zS+EwhFcMj1MUjudHJ3SdXQfmTxBsF3+1FyX+MZFx9zd
         IjKGwOmNPoBEEgOnF1C5PXjlTGsmirHAfYEargClEIH7P7W3QDfvNg+S4pb2xLvme2
         X/Q0FsZ5t5Dn0m0d5D7TbffXwpDHV2elnqQLB1Cwxlx+EVX1diQCSu+g89YHVd4/a5
         SBXRKnQhNCLQg==
Date:   Fri, 19 Jul 2019 09:16:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: build warning after merge of the cifs tree
Message-ID: <20190719091635.4949cc70@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MQWht61GukQlabwtPbhOuEZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--Sig_/MQWht61GukQlabwtPbhOuEZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

fs/cifs/smb2ops.c: In function 'open_shroot':
fs/cifs/smb2ops.c:762:28: warning: passing argument 5 of 'smb2_parse_contex=
ts' makes pointer from integer without a cast [-Wint-conversion]
     oparms.fid->lease_key, oplock, NULL);
                            ^~~~~~
In file included from fs/cifs/smb2ops.c:16:
fs/cifs/smb2proto.h:234:11: note: expected '__u8 *' {aka 'unsigned char *'}=
 but argument is of type 'u8' {aka 'unsigned char'}
     __u8 *oplock, struct smb2_file_all_info *buf);
     ~~~~~~^~~~~~

Introduced by commit

  bf63aef07199 ("smb3: optimize open to not send query file internal info")

--=20
Cheers,
Stephen Rothwell

--Sig_/MQWht61GukQlabwtPbhOuEZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0w/dMACgkQAVBC80lX
0GyXPQf8DRN28rglREqtf/KlgCs3ikhaoXtXv292i70EF1lIYKiilLqoTTcDQSUa
rKmbLGn0faqR9X0izzwRK91EGBqsvhqsMAeTqnfi4i6TuIXHTgQW9Z4nbX9L6MlC
jfmWLBPbQBDKk23mTIlO85PZ35jqshi6UOD7mJsFxNMPLsg4y4gdkLAfx0jRQn4a
+73LTB4oKynW+Ai5QYibECP4SfVbaERvQz69QdZPtwZN4dbBgZhM0MaJn5GB8BZ0
KglAYoCbFJag0MaYdcO70GPgf9mcwSpgIPGXS5KubHLSCpJmUpyJK7AfqPyCJzpZ
CIssrkW0BLkH04KNIMsh7Aiz6lL05w==
=HNXA
-----END PGP SIGNATURE-----

--Sig_/MQWht61GukQlabwtPbhOuEZ--
