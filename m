Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0C5C61DA4
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Feb 2023 17:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjBIRWF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Feb 2023 12:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBIRWD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Feb 2023 12:22:03 -0500
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E243D1117A
        for <linux-cifs@vger.kernel.org>; Thu,  9 Feb 2023 09:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=Content-Type:MIME-Version:Reply-To:Message-ID:Subject:To:
        From:Date:Sender:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bwWOupcFO78skUGN0OfYiP2NVYXa/FxzYCLX9gf+z80=; b=fxUzbyL5k+thIJEdbH8owvoG8Q
        cKJEMEcX08EmqW1KM/PjJBVeZuuO2tFgFso06D8XABPdxxECXafHyrnoqP+AzPq8Ocd+W5jTCIePk
        8bNKLoZfJau7BHOyJxX9H6gqCgQCab+W2XOdvj66Rw/qjcsShmkO0PR5wYuJGdFvcr+41YSyAvJbB
        LZ/LRkmiNO6cf/1UdcqlJPNwXqhYC6vzlAGPuf+42PhfZZMmgBtUH38KikNY+aIN8fcslWlSSbdIM
        Qj8fH3UBJeeGiufOv2lDiHNI425kQBdiY1BdxQX4Epy5yqi/cDlVMcB/dEkZ6qJ/325vsHYrwfGKU
        qKYIPqxw==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=Content-Type:MIME-Version:Reply-To:
        Message-ID:Subject:To:From:Date:Sender:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bwWOupcFO78skUGN0OfYiP2NVYXa/FxzYCLX9gf+z80=; b=5tFuy8ifxPLHdV/dT76g1hDJuJ
        TxS+xq58mGv1Vs0iPdn430nusF629hlZDzmVpIRs7SeO+mKKXN3kHOpGduBQ==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        for linux-cifs@vger.kernel.org
        id 1pQAcR-00Ga9Q-Hf; Thu, 09 Feb 2023 18:21:59 +0100
Received: by intern.sernet.de
        id 1pQAcR-009dxa-6i; Thu, 09 Feb 2023 18:21:59 +0100
Date:   Thu, 9 Feb 2023 18:21:50 +0100
From:   Volker Lendecke <Volker.Lendecke@sernet.de>
To:     linux-cifs@vger.kernel.org
Subject: Fix an uninitialized read in smb3_qfs_tcon()
Message-ID: <Y+UrrjvGrOT6Bcmy@sernet.de>
Reply-To: Volker.Lendecke@sernet.de
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YyXJtAxXLcRazTbB"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--YyXJtAxXLcRazTbB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

Attached find a patch that fixes another case where oparms.mode is
uninitialized. This patch fixes it with a struct assignment, relying
on the implicit initialization of unmentioned fields. Please note that
the assignment does not explicitly mention "reconnect" anymore,
relying on the implicit "false" value.

Is this kernel-style? Shall we just go through all of the oparms
initializations, there are quite a few other cases that might have the
mode uninitialized.

Regards,

Volker

--YyXJtAxXLcRazTbB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch.txt"
Content-Transfer-Encoding: quoted-printable

=46rom 848e2d42a731ed0612a5c5de188659b98734edce Mon Sep 17 00:00:00 2001
=46rom: Volker Lendecke <vl@samba.org>
Date: Wed, 11 Jan 2023 12:37:58 +0100
Subject: [PATCH] cifs: Fix uninitialized memory read in smb3_qfs_tcon()

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2ops.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e6bcd2baf446..34c2ff0247db 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -729,12 +729,13 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tco=
n *tcon,
 	struct cifs_fid fid;
 	struct cached_fid *cfid =3D NULL;
=20
-	oparms.tcon =3D tcon;
-	oparms.desired_access =3D FILE_READ_ATTRIBUTES;
-	oparms.disposition =3D FILE_OPEN;
-	oparms.create_options =3D cifs_create_options(cifs_sb, 0);
-	oparms.fid =3D &fid;
-	oparms.reconnect =3D false;
+	oparms =3D (struct cifs_open_parms) {
+		.tcon =3D tcon,
+		.desired_access =3D FILE_READ_ATTRIBUTES,
+		.disposition =3D FILE_OPEN,
+		.create_options =3D cifs_create_options(cifs_sb, 0),
+		.fid =3D &fid,
+	};
=20
 	rc =3D open_cached_dir(xid, tcon, "", cifs_sb, false, &cfid);
 	if (rc =3D=3D 0)
--=20
2.30.2


--YyXJtAxXLcRazTbB--
